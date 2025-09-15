#pragma once

#include <stdio.h>
#include <stdint.h>
#include <memory>
#include "devices.hpp"
#include <map>

class CPU;
class Register;
class Register {
    uint16_t data;
    CPU *c;
public:
    Register(CPU* c);
    void set_l(uint8_t val);
    void set_h(uint16_t val);
    uint8_t get_l();
    uint8_t get_h();
    uint16_t get16();
    void reset();
    void inc();
    void dec();
    void il();
    void ih();
    void ol();
    void oh();
    void a();

};


struct VMemEntry {
    VMemEntry(uint32_t first, uint32_t last, uint32_t mask, std::shared_ptr<IDevice> device) :
        first(first),
        last(last),
        mask(mask),
        device(device)
    {}

    uint32_t first;
    uint32_t last;
    uint32_t mask;
    std::shared_ptr<IDevice> device;
};


class VMem;
class TLBCtl : public IDevice {
    std::shared_ptr<VMem> vmem;
public:
    TLBCtl(std::shared_ptr<VMem> vmem) : vmem(vmem) {};
    void write(uint16_t addr, uint8_t data) override;
    uint8_t read(uint16_t addr) override;
    void set_irq_callback(std::function<void(void)> fn);
};


class VMem {
    std::shared_ptr<DummyDevice> dummy;
    std::vector<VMemEntry> decode_table;

    std::shared_ptr<RamDevice> tlb_memory;
    std::shared_ptr<TLBCtl> tlb_ctl;

    std::pair<std::shared_ptr<IDevice>, uint32_t> decode(uint32_t addr) {
        for(const auto & d : decode_table) {
            if(addr >= d.first && addr <= d.last) {
                return std::make_pair(d.device, d.mask);
            }
        }
        return std::make_pair(dummy, 0xffff);
    }

    bool paging_enable{false};
    uint8_t tlb_index{0};

    uint8_t fault_idx{0};
    uint8_t fault_page_cause{0};

public:
    VMem() {
        dummy = std::make_shared<DummyDevice>();
    }

    void set_tlb_memory(std::shared_ptr<RamDevice> t) {
        tlb_memory = t;
    }

    void set_tlb_ctl(std::shared_ptr<TLBCtl> t) {
        tlb_ctl = t;
    }

    std::shared_ptr<TLBCtl> get_tlb_ctl() {
        return tlb_ctl;
    }

    std::shared_ptr<RamDevice> get_tlb_memory() {
        return tlb_memory;
    }

    void enable_pg() {
        paging_enable = true;
    }

    void disable_pg() {
        paging_enable = false;
    }

    void set_tlb_index(uint8_t idx) {
        tlb_index = idx;
    }

    uint8_t get_fault_idx() {
        return fault_idx;
    }

    uint8_t get_fault_page_cause() {
        return fault_page_cause;
    }

    std::pair<uint32_t, uint8_t> get_eaddr_flags(uint16_t addr);

    uint8_t read(uint16_t addr);
    void write(uint16_t addr, uint8_t data);

    void add_vmem_entry(VMemEntry en);

};

enum ICode {
    hlt = 0,
    di,
    ei,
    nop,
    cpy,
    swp,
    xpp,
    iret,
    scall,
    iretf,
    jump,
    talu,
    alu,
    mov_b_a,
    mov_sl_a,
    mov_sh_a,
    mov_ml_a,
    mov_mh_a,
    mov_mf_a,
    mov_xl_a,
    mov_xh_a,
    push_a,
    mov_f_a,
    mov_x_a,
    ldd_s,
    ldd_m,
    ldd_x,
    ldd_r_i,
    mov_a_b,
    mov_a_sl,
    mov_a_sh,
    mov_a_ml,
    mov_a_mh,
    mov_a_mf,
    mov_a_xl,
    mov_a_xh,
    pop_a,
    mov_a_f,
    mov_a_x,
    ld_a,
    movsm,
    movms,
    push_xm,
    pop_mx,
    sp_p_2,
    sp_p_8,
    sp_m_2,
    sp_m_8,
    push_m,
    pop_m,
    pushw_m,
    popw_m,
    mov_mm,
    mov_xm,
    INT
};



struct Instruction {
    Instruction(uint8_t code, uint8_t mask, int delay, ICode icode) :
        code(code),
        mask(mask),
        delay(delay),
        icode(icode) {}

    uint8_t code;
    uint8_t mask;
    int delay{0};
    ICode icode;
};



class IntCtl {
    std::vector<bool> irqs;
public:
    IntCtl();

    void set_int(int irqn);
    bool irq_pending();
    uint8_t get_iv();
    void reset();

};
class CPU {
public:
    std::shared_ptr<Register> A;
    std::shared_ptr<Register> B;
    std::shared_ptr<Register> PA;
    std::shared_ptr<Register> PB;
    std::shared_ptr<Register> M;
    std::shared_ptr<Register> S;
    std::shared_ptr<Register> F;
    std::shared_ptr<Register> IR;
    std::shared_ptr<Register> Off;

    std::shared_ptr<Register> PC;
    std::shared_ptr<Register> X;


    struct {
        std::shared_ptr<Register> Off;
        std::shared_ptr<Register> IR;
        size_t mpc{0};        
    } fault_bk;

    std::shared_ptr<VMem> vmem;
    std::shared_ptr<IntCtl> int_ctl;

    size_t tick_n{0};

    size_t cycle_delay_ns{100};   

    uint8_t aluA{0};
    uint8_t aluB{0};

    uint8_t dbus{0};
    uint16_t abus{0};

    bool FAULT{false};
    bool IRQ{false};
    
    bool is_fault_recovery{false};

    bool int_en{false};

    std::vector<Instruction> instructions;

    void toggle_pc();

    void delay(int n_cycles);

    uint16_t calc_mf_addr();

    void not_impl();

    void exec_instruction(size_t mpc);

    void mr();
    void mw();

    bool condition();
    void pp();
    void mfa();

    void alul();
    void alud();
    void alufd();

    void iv_o();
    void sela();    
    void ei();

    CPU();

    void init_decode();

    void reset();
    void fault();

    int cycle();

    void set_vmem(std::shared_ptr<VMem> v);
    void set_int_ctl(std::shared_ptr<IntCtl> ic);

    void set_calib_cycle_delay_ns(size_t ns);
    size_t get_calib_cycle_delay_ns();
};



