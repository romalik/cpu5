#pragma once
#include "devices.hpp"
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <math.h>
#include <vector>
#include <iostream>
#include <signal.h>
#include <atomic>
#include <thread>
#include <vector>
#include <mutex>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>
#include <string.h>
#include <termios.h>
#include <unistd.h>
#include <fcntl.h>
#include <queue>
#include <functional>



extern "C" {
char verilator_mem_read (int addr, int mem_idx);
void verilator_mem_write(int addr, char data, int mem_idx);
void verilator_mem_init(std::string fw_bin_path);
}



void read_file(const char *filename, std::vector<uint8_t> & data);


struct IDevice {
    virtual ~IDevice() = default;

    virtual void write(uint16_t addr, uint8_t data) = 0;
    virtual uint8_t read(uint16_t addr) = 0;

    virtual void set_irq_callback(std::function<void(void)> fn) = 0;
};
class Console : public IDevice {
public:
    Console();
    int pop();
    int has_data();
    void stop();

    void write(uint16_t addr, uint8_t data) override;
    uint8_t read(uint16_t addr) override;
    void set_irq_callback(std::function<void(void)> fn) { irq_cb = fn; };

private:
    std::function<void(void)> irq_cb;
    int kbhit();
    int getch();
    struct termios initial_settings, new_settings;
    int peek_character;
    std::thread thr;
    void runner();
    bool running;
    std::queue<int> q;
    size_t max_q{64};
    std::mutex mtx;
    std::atomic<bool> has_data_atomic{false};

};
    

class SimpleStorage : public IDevice {
public:
    SimpleStorage();
    void load(std::string path);

    void init(size_t sz);

    void set_high_addr(uint8_t addr);
    void set_mid_addr(uint8_t addr);
    void set_low_addr(uint8_t addr);
    uint8_t read_l();
    void write_l(uint8_t d);

    void write(uint16_t addr, uint8_t data) override;
    uint8_t read(uint16_t addr) override;
    void set_irq_callback(std::function<void(void)> fn) override { (void)fn; }

private:
    size_t full_addr();
    std::vector<uint8_t> data;
    uint8_t c_high{0};
    uint8_t c_mid{0};
    uint8_t c_low{0};
    uint8_t c_idx{0};
};

struct RamDevice : public IDevice {
    bool readonly;
    std::vector<uint8_t> mem{};

public:
    RamDevice(size_t size, bool ro);
    void write(uint16_t addr, uint8_t data) override;
    uint8_t read(uint16_t addr) override;
    void set_irq_callback(std::function<void(void)> fn) { (void)fn; };
    void load(const std::string & filename);
};

class DummyDevice : public IDevice {
public:
    DummyDevice() {};
    void write(uint16_t addr, uint8_t data) override {/*printf("DummyDevice write @ 0x%04x\n", addr);*/}
    uint8_t read(uint16_t addr) override {/*printf("DummyDevice read @ 0x%04x\n", addr);*/ return 0;}
    void set_irq_callback(std::function<void(void)> fn) { (void)fn; };
};


struct Args {
    std::string rom;
    std::string hdd;
    std::string fw{"."};
    double mhz{0.0};
};

Args parse_args(int argc, char* argv[]);