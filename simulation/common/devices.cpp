#include "devices.hpp"



void read_file(const char *filename, std::vector<uint8_t> & data) {
    FILE *f = fopen(filename, "rb");
    if (!f) {
        printf("read_file(%s)\n", filename);
        perror("fopen");
    }

    if (fseek(f, 0, SEEK_END) != 0) {
        perror("fseek");
        fclose(f);
    }

    long size = ftell(f);
    if (size < 0) {
        perror("ftell");
        fclose(f);
    }
    rewind(f);

    data.resize(size);

    unsigned char *buffer = data.data();


    size_t read = fread(buffer, 1, size, f);
    if (read != (size_t)size) {
        fprintf(stderr, "fread failed (read %zu of %ld)\n", read, size);
        fclose(f);
    }

    fclose(f);
}


extern "C" {
static std::vector<std::vector<uint8_t>> MEMs(1<<19);

char verilator_mem_read (int addr, int mem_idx) {
    return MEMs[mem_idx][addr];
}
void verilator_mem_write(int addr, char data, int mem_idx) {
    MEMs[mem_idx][addr] = data;
}

void verilator_mem_init(std::string fw_bin_path) {
    MEMs.resize(20);
    std::vector<std::string> files = {
        fw_bin_path + "/microcode_0.bin",
        fw_bin_path + "/microcode_1.bin",
        fw_bin_path + "/alu_low.bin",
        fw_bin_path + "/alu_high.bin",
        fw_bin_path + "/rom.bin"
    };

    for(auto & mem : MEMs) {
        mem.resize(1000000);
    }

    for(size_t i = 0; i<files.size(); i++) {
        read_file(files[i].c_str(), MEMs[i]);
    }
}

}

    
int Console::pop() {
    std::lock_guard<std::mutex> lock(mtx);
    if(!q.empty()) {
        int c = q.front();
        q.pop();
        if(q.empty()) {
            has_data_atomic.store(false);
        }
        return c;
    }
    return 0;
}
int Console::has_data() {
    return has_data_atomic.load();
}
        
Console::Console(){
    tcgetattr(0,&initial_settings);
    new_settings = initial_settings;
    new_settings.c_lflag &= ~ICANON;
    new_settings.c_lflag &= ~ECHO;
    new_settings.c_cc[VMIN] = 1;
    new_settings.c_cc[VTIME] = 0;
    tcsetattr(0, TCSANOW, &new_settings);
    peek_character=-1;
    running = true;
    thr = std::thread(&Console::runner, this);
}

void Console::stop() {
    tcsetattr(0, TCSANOW, &initial_settings);
    running = false;
    thr.join();
}

void Console::runner() {
    while(running) {
        if(kbhit()) {

            int c = getch();
            if(q.size() < max_q) {
                std::lock_guard<std::mutex> lock(mtx);
                q.push(c);
                has_data_atomic.store(true);
                if(irq_cb) {
                    irq_cb();
                }
            }
        }
        usleep(5*1000);
    }
}

int Console::kbhit(){
    unsigned char ch;
    int nread;
    if (peek_character != -1) return 1;
    new_settings.c_cc[VMIN]=0;
    tcsetattr(0, TCSANOW, &new_settings);
    nread = ::read(0,&ch,1);
    new_settings.c_cc[VMIN]=1;
    tcsetattr(0, TCSANOW, &new_settings);

    if (nread == 1){
        peek_character = ch;
        return 1;
    }
    return 0;
}
    
int Console::getch(){
    char ch;

    if (peek_character != -1){
        ch = peek_character;
        peek_character = -1;
    }
    else ::read(0,&ch,1);
    return ch;
}

void Console::write(uint16_t addr, uint8_t data) {
    (void)addr;
    printf("%c", data);
    fflush(stdout);
};
uint8_t Console::read(uint16_t addr) {
    (void)addr;
    if(has_data()) {
        return pop();
    } else {
        return 0;
    }

};



SimpleStorage::SimpleStorage() {};

void SimpleStorage::load(std::string path) {
    printf("Loading HDD %s...\n", path.c_str());
    read_file(path.c_str(), data);
    printf("Loaded HDD %s of size %zu\n", path.c_str(), data.size());
}

void SimpleStorage::init(size_t sz) {
    data.clear();
    data.resize(sz);
}

void SimpleStorage::set_high_addr(uint8_t addr) {
    c_high = addr;        
    c_idx = 0;
}
void SimpleStorage::set_mid_addr(uint8_t addr) {
    c_mid = addr;
    c_idx = 0;
}
void SimpleStorage::set_low_addr(uint8_t addr) {
    c_low = addr;
    c_idx = 0;
}
uint8_t SimpleStorage::read_l() {
    uint8_t d = data[full_addr()];
    c_idx++;
    return d;
}

void SimpleStorage::write_l(uint8_t d) {
    data[full_addr()] = d;
    c_idx++;
}

size_t SimpleStorage::full_addr() {
    return c_idx | (c_mid << 8) | (c_high << 16);
}

void SimpleStorage::write(uint16_t addr, uint8_t data) {
    if(addr == 0x00) {
        set_low_addr(data);
    } else if(addr == 0x01) {
        set_mid_addr(data);
    } else if(addr == 0x02) {
        set_high_addr(data);
    } else if(addr == 0x04) {
        write_l(data);
    }
}

uint8_t SimpleStorage::read(uint16_t addr) {
    if(addr == 0x04) {
        return read_l();
    }
}


RamDevice::RamDevice(size_t size, bool ro) {
    mem.resize(size);
    readonly = ro;
}

void RamDevice::write(uint16_t addr, uint8_t data) {
    if (addr < mem.size() && !readonly) {
        mem[addr] = data;
    }
}

uint8_t RamDevice::read(uint16_t addr) {
    if (addr < mem.size()) return mem[addr];
    return 0xFF;
}

void RamDevice::load(const std::string & filename) {
    read_file(filename.c_str(), mem);
}

Args parse_args(int argc, char* argv[]) {
    Args args;
    for (int i = 1; i < argc; ++i) {
        std::string key = argv[i];
        if ((key == "--rom") && i + 1 < argc) {
            args.rom = argv[++i]; // eat next arg
        } else if ((key == "--hdd") && i + 1 < argc) {
            args.hdd = argv[++i];
        } else if ((key == "--fw") && i + 1 < argc) {
            args.fw = argv[++i];
        } else if ((key == "--mhz") && i + 1 < argc) {
            args.mhz = strtod(argv[++i], NULL);
        } else if(key == "--trace") {
            args.trace = true;
        }
    }
    return args;
}
