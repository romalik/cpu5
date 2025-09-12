#include "devices.hpp"



void read_file(const char *filename, std::vector<uint8_t> & data) {
    printf("read_file(%s)\n", filename);
    FILE *f = fopen(filename, "rb");
    if (!f) {
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

    
int keyboard::pop() {
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
int keyboard::has_data() {
    return has_data_atomic.load();
}
        
keyboard::keyboard(){
    tcgetattr(0,&initial_settings);
    new_settings = initial_settings;
    new_settings.c_lflag &= ~ICANON;
    new_settings.c_lflag &= ~ECHO;
    new_settings.c_cc[VMIN] = 1;
    new_settings.c_cc[VTIME] = 0;
    tcsetattr(0, TCSANOW, &new_settings);
    peek_character=-1;
    running = true;
    thr = std::thread(&keyboard::runner, this);
}
    
keyboard::~keyboard(){
    tcsetattr(0, TCSANOW, &initial_settings);
    running = false;
    thr.join();
}

void keyboard::runner() {
    while(running) {
        if(kbhit()) {
            int c = getch();
            if(q.size() < max_q) {
                std::lock_guard<std::mutex> lock(mtx);
                q.push(c);
                has_data_atomic.store(true);
            }
        }
        usleep(5*1000);
    }
}

int keyboard::kbhit(){
    unsigned char ch;
    int nread;
    if (peek_character != -1) return 1;
    new_settings.c_cc[VMIN]=0;
    tcsetattr(0, TCSANOW, &new_settings);
    nread = read(0,&ch,1);
    new_settings.c_cc[VMIN]=1;
    tcsetattr(0, TCSANOW, &new_settings);

    if (nread == 1){
        peek_character = ch;
        return 1;
    }
    return 0;
}
    
int keyboard::getch(){
    char ch;

    if (peek_character != -1){
        ch = peek_character;
        peek_character = -1;
    }
    else read(0,&ch,1);
    return ch;
}



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
uint8_t SimpleStorage::read() {
    uint8_t d = data[full_addr()];
    c_idx++;
    return d;
}

void SimpleStorage::write(uint8_t d) {
    data[full_addr()] = d;
    c_idx++;
}

size_t SimpleStorage::full_addr() {
    return c_idx | (c_mid << 8) | (c_high << 16);
}



