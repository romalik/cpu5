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


extern "C" {
char verilator_mem_read (int addr, int mem_idx);
void verilator_mem_write(int addr, char data, int mem_idx);
void verilator_mem_init(std::string fw_bin_path);
}



void read_file(const char *filename, std::vector<uint8_t> & data);



class keyboard{
    public:
        keyboard();
        ~keyboard();
        int pop();
        int has_data();
    private:
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
    

class SimpleStorage {
public:
    SimpleStorage();
    void load(std::string path);

    void init(size_t sz);

    void set_high_addr(uint8_t addr);
    void set_mid_addr(uint8_t addr);
    void set_low_addr(uint8_t addr);
    uint8_t read();
    void write(uint8_t d);

private:
    size_t full_addr();
    std::vector<uint8_t> data;
    uint8_t c_high{0};
    uint8_t c_mid{0};
    uint8_t c_low{0};
    uint8_t c_idx{0};
};