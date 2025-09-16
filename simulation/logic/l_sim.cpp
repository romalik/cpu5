#include <stdio.h>
#include <stdint.h>
#include <memory>
#include "devices.hpp"

#include "l_sim.hpp"

#include <exception>
#include <string>
#include <stdexcept>

std::atomic<bool> running{true};



Register::Register(CPU* c) :c(c) {}
void Register::set_l(uint8_t val) {
    data = (data & 0xff00) | (val & 0x00ff); 
}
void Register::set_h(uint16_t val) {
    data = (static_cast<uint16_t>(val) << 8) | (data & 0x00ff); 
}
uint8_t Register::get_l() {
    return data & 0x00ff;
}
uint8_t Register::get_h() {
    return (data & 0xff00) >> 8;
}
uint16_t Register::get16() {
    return data;
}
void Register::reset() {
    data = 0;
}
void Register::inc() {
    data++;
}
void Register::dec() {
    data--;
}
void Register::il() {
    data = (data & 0xff00) | (c->dbus & 0x00ff); 
}
void Register::ih() {
    data = (static_cast<uint16_t>(c->dbus) << 8) | (data & 0x00ff); 
}
void Register::ol() {
    c->dbus = data & 0x00ff;
}
void Register::oh() {
    c->dbus = (data & 0xff00) >> 8;
}
void Register::a() {
    c->abus = data;
}


class CPUFault : public std::exception {
    std::string msg;
public:
    explicit CPUFault(std::string m) : msg(std::move(m)) {}

    const char* what() const noexcept override {
        return msg.c_str();
    }
};


void print_reg(const char * name, std::shared_ptr<Register> r) {
    printf("%s: 0x%04X\n", name, r->get16());
}

void print_state(CPU * c) {
    print_reg("PC", c->PC);
    print_reg("S ", c->S);
    print_reg("X ", c->X);
    print_reg("A ", c->A);
    print_reg("B ", c->B);
    printf("TLB idx 0x%02x\n", c->vmem->get_tlb_index());
    printf("Paging %s\n", c->vmem->get_paging_enabled() ? "ON":"OFF");
    
}
std::map<ICode, std::vector<std::function<void(CPU*)>>> microcode = {

    { ICode::hlt, {
        [](CPU* c) -> void { 
            print_state(c);
            while(running.load()) {}
        }
    } },
    { ICode::di, {
        [](CPU* c) -> void { c->iv_o(); },
        [](CPU* c) -> void { c->pp(); }
    } },
    { ICode::ei, {
        [](CPU* c) -> void { c->ei(); },
        [](CPU* c) -> void { c->pp(); }
    } },
    { ICode::nop, {
        [](CPU* c) -> void { c->pp(); }
    } },
    { ICode::cpy, {
        [](CPU* c) -> void { c->X->a(); c->mr(); c->A->il(); },
        [](CPU* c) -> void { c->mfa();  c->A->ol(); c->mw(); },
        [](CPU* c) -> void { c->pp(); }        
    } },
    { ICode::swp, {
        [](CPU* c) -> void { c->not_impl(); }
    } },
    { ICode::xpp, {
        [](CPU* c) -> void { c->toggle_pc(); },
        [](CPU* c) -> void { c->pp(); },
        [](CPU* c) -> void { c->toggle_pc(); },
        [](CPU* c) -> void { c->pp(); }
    } },
    { ICode::iret, {
        [](CPU* c) -> void { c->toggle_pc(); },
        [](CPU* c) -> void { c->S->inc(); },
        [](CPU* c) -> void { c->S->a(); c->mr(); c->A->il(); },
        [](CPU* c) -> void { c->A->ol(); c->X->il(); },

        [](CPU* c) -> void { c->S->inc(); },
        [](CPU* c) -> void { c->S->a(); c->mr(); c->A->il(); },
        [](CPU* c) -> void { c->A->ol(); c->X->ih(); },

        [](CPU* c) -> void { c->sela(); c->abus=0xffbf; c->mr(); c->A->il(); 
                                c->S->reset(); },
        [](CPU* c) -> void { c->sela(); c->abus=0xffbd; c->mr(); c->S->ih(); },
        [](CPU* c) -> void { c->sela(); c->abus=0xffbe; c->mr(); c->S->il(); },
        [](CPU* c) -> void { c->toggle_pc(); },
        [](CPU* c) -> void { c->ei(); },


    } },
    { ICode::scall, {
        [](CPU* c) -> void { c->toggle_pc(); },
        [](CPU* c) -> void { c->sela(); c->abus=0xffbe; c->S->ol(); c->mw(); },
        [](CPU* c) -> void { c->sela(); c->abus=0xffbd; c->S->oh(); c->mw(); },
        [](CPU* c) -> void { c->sela(); c->abus=0xffbf; c->A->ol(); c->mw(); 
                                c->S->reset(); },
        [](CPU* c) -> void { c->S->dec(); },
        [](CPU* c) -> void { c->X->oh(); c->A->il(); },
        [](CPU* c) -> void { c->S->a(); c->A->ol(); c->mw(); },
        [](CPU* c) -> void { c->X->ol(); c->A->il(); },
        [](CPU* c) -> void { c->S->dec(); },
        [](CPU* c) -> void { c->S->a(); c->A->ol(); c->mw(); },
        [](CPU* c) -> void { c->iv_o(); c->X->il(); },
        [](CPU* c) -> void { c->S->oh(); c->A->il(); },
        [](CPU* c) -> void { c->A->ol(); c->X->ih(); },
        [](CPU* c) -> void { c->S->dec(); },
        [](CPU* c) -> void { c->toggle_pc(); }
    } },
    { ICode::iretf, {
        [](CPU* c) -> void { printf("microcode: IRETF\n"); c->toggle_pc(); },
        [](CPU* c) -> void { c->S->inc(); },
        [](CPU* c) -> void { c->S->a(); c->mr(); c->A->il(); },
        [](CPU* c) -> void { c->A->ol(); c->X->il(); },

        [](CPU* c) -> void { c->S->inc(); },
        [](CPU* c) -> void { c->S->a(); c->mr(); c->A->il(); },
        [](CPU* c) -> void { c->A->ol(); c->X->ih(); },

        [](CPU* c) -> void { c->sela(); c->abus=0xffbf; c->mr(); c->A->il(); 
                                c->S->reset(); },
        [](CPU* c) -> void { c->sela(); c->abus=0xffbd; c->mr(); c->S->ih(); },
        [](CPU* c) -> void { c->sela(); c->abus=0xffbe; c->mr(); c->S->il(); },
        [](CPU* c) -> void { c->toggle_pc(); },

        [](CPU* c) -> void { /*load fault*/ c->Off->set_l(c->fault_bk.Off->get_l()); },

        [](CPU* c) -> void { c->ei(); },

        [](CPU* c) -> void { /*load fault*/ c->IR->set_l(c->fault_bk.IR->get_l()); 
                                c->is_fault_recovery = true; },

    } },
    { ICode::jump, {
        [](CPU* c) -> void { c->pp(); },
        [](CPU* c) -> void { c->toggle_pc(); }        
    } },
    { ICode::talu, {
        [](CPU* c) -> void { c->pp(); },
        [](CPU* c) -> void { c->PC->a(); c->mr(); c->Off->il(); },
        [](CPU* c) -> void { c->mfa(); c->mr(); c->A->il(); },
        [](CPU* c) -> void { c->pp(); },
        [](CPU* c) -> void { c->PC->a(); c->mr(); c->Off->il(); },
        [](CPU* c) -> void { c->mfa(); c->mr(); c->B->il(); },
        [](CPU* c) -> void { c->pp(); },
        [](CPU* c) -> void { c->alul(); },
        [](CPU* c) -> void { c->PC->a(); c->mr(); c->Off->il(); },
        [](CPU* c) -> void { c->alud(); c->A->il(); },
        [](CPU* c) -> void { c->alufd(); c->F->il(); },
        [](CPU* c) -> void { c->mfa(); c->A->ol(); c->mw(); },
        [](CPU* c) -> void { c->pp(); }
        
    } },
    { ICode::alu, {
        [](CPU* c) -> void { c->alud(); c->A->il(); },
        [](CPU* c) -> void { c->alufd(); c->F->il(); },
        [](CPU* c) -> void { c->pp(); }        
    } },
    { ICode::mov_b_a, {
        [](CPU* c) -> void { c->A->ol(); c->B->il(); },
        [](CPU* c) -> void { c->pp(); }
    } },
    { ICode::mov_sl_a, {
        [](CPU* c) -> void { c->A->ol(); c->S->il(); },
        [](CPU* c) -> void { c->pp(); }
    } },
    { ICode::mov_sh_a, {
        [](CPU* c) -> void { c->A->ol(); c->S->ih(); },
        [](CPU* c) -> void { c->pp(); }
    } },
    { ICode::mov_ml_a, {
        [](CPU* c) -> void { c->A->ol(); c->M->il(); },
        [](CPU* c) -> void { c->pp(); }
    } },
    { ICode::mov_mh_a, {
        [](CPU* c) -> void { c->A->ol(); c->M->ih(); },
        [](CPU* c) -> void { c->pp(); }
    } },
    { ICode::mov_mf_a, {
        [](CPU* c) -> void { c->pp(); },
        [](CPU* c) -> void { c->PC->a(); c->mr(); c->Off->il(); },
        [](CPU* c) -> void { c->mfa(); c->A->ol(); c->mw(); },
        [](CPU* c) -> void { c->pp(); }

    } },
    { ICode::mov_xl_a, {
        [](CPU* c) -> void { c->A->ol(); c->X->il(); },
        [](CPU* c) -> void { c->pp(); }
    } },
    { ICode::mov_xh_a, {
        [](CPU* c) -> void { c->A->ol(); c->X->ih(); },
        [](CPU* c) -> void { c->pp(); }
    } },
    { ICode::push_a, {
        [](CPU* c) -> void { c->S->a(); c->A->ol(); c->mw(); },
        [](CPU* c) -> void { c->S->dec(); },
        [](CPU* c) -> void { c->pp(); }
    } },
    { ICode::mov_f_a, {
        [](CPU* c) -> void { c->A->ol(); c->F->il(); },
        [](CPU* c) -> void { c->pp(); }
    } },
    { ICode::mov_x_a, {
        [](CPU* c) -> void { c->X->a(); c->A->ol(); c->mw(); },
        [](CPU* c) -> void { c->pp(); }        
    } },
    { ICode::ldd_s, {
        [](CPU* c) -> void { c->PC->inc(); },
        [](CPU* c) -> void { c->PC->a(); c->mr(); c->A->il(); },
        [](CPU* c) -> void { c->A->ol(); c->S->il(); },
        [](CPU* c) -> void { c->pp(); },
        [](CPU* c) -> void { c->PC->a(); c->mr(); c->A->il(); },
        [](CPU* c) -> void { c->A->ol(); c->S->ih(); },
        [](CPU* c) -> void { c->PC->inc(); }
    } },
    { ICode::ldd_m, {
        [](CPU* c) -> void { c->PC->inc(); },
        [](CPU* c) -> void { c->PC->a(); c->mr(); c->A->il(); },
        [](CPU* c) -> void { c->A->ol(); c->M->il(); },
        [](CPU* c) -> void { c->pp(); },
        [](CPU* c) -> void { c->PC->a(); c->mr(); c->A->il(); },
        [](CPU* c) -> void { c->A->ol(); c->M->ih(); },
        [](CPU* c) -> void { c->PC->inc(); }
    } },
    { ICode::ldd_x, {
        [](CPU* c) -> void { c->PC->inc(); },
        [](CPU* c) -> void { c->PC->a(); c->mr(); c->A->il(); },
        [](CPU* c) -> void { c->A->ol(); c->X->il(); },
        [](CPU* c) -> void { c->pp(); },
        [](CPU* c) -> void { c->PC->a(); c->mr(); c->A->il(); },
        [](CPU* c) -> void { c->A->ol(); c->X->ih(); },
        [](CPU* c) -> void { c->PC->inc(); }
    } },
    { ICode::ldd_r_i, {
        [](CPU* c) -> void { c->PC->inc(); },
        [](CPU* c) -> void { c->PC->a(); c->mr(); c->Off->il(); },
        [](CPU* c) -> void { c->PC->inc(); },
        [](CPU* c) -> void { c->PC->a(); c->mr(); c->A->il(); },
        [](CPU* c) -> void { c->mfa(); c->A->ol(); c->mw(); },
        [](CPU* c) -> void { c->pp(); }        
    } },
    { ICode::mov_a_b, {
        [](CPU* c) -> void { c->B->ol(); c->A->il(); },
        [](CPU* c) -> void { c->pp(); }        
    } },
    { ICode::mov_a_sl, {
        [](CPU* c) -> void { c->S->ol(); c->A->il(); },
        [](CPU* c) -> void { c->pp(); }        
    } },
    { ICode::mov_a_sh, {
        [](CPU* c) -> void { c->S->oh(); c->A->il(); },
        [](CPU* c) -> void { c->pp(); }        
    } },
    { ICode::mov_a_ml, {
        [](CPU* c) -> void { c->M->ol(); c->A->il(); },
        [](CPU* c) -> void { c->pp(); }        
    } },
    { ICode::mov_a_mh, {
        [](CPU* c) -> void { c->M->oh(); c->A->il(); },
        [](CPU* c) -> void { c->pp(); }        
    } },
    { ICode::mov_a_mf, {
        [](CPU* c) -> void { c->pp(); },
        [](CPU* c) -> void { c->PC->a(); c->mr(); c->Off->il(); },
        [](CPU* c) -> void { c->mfa(); c->mr(); c->A->il(); },
        [](CPU* c) -> void { c->pp(); }
    } },
    { ICode::mov_a_xl, {
        [](CPU* c) -> void { c->X->ol(); c->A->il(); },
        [](CPU* c) -> void { c->pp(); }
    } },
    { ICode::mov_a_xh, {
        [](CPU* c) -> void { c->X->oh(); c->A->il(); },
        [](CPU* c) -> void { c->pp(); }
    } },
    { ICode::pop_a, {
        [](CPU* c) -> void { c->S->inc(); },
        [](CPU* c) -> void { c->S->a(); c->mr(); c->A->il(); },
        [](CPU* c) -> void { c->pp(); }
    } },
    { ICode::mov_a_f, {
        [](CPU* c) -> void { c->F->ol(); c->A->il(); },
        [](CPU* c) -> void { c->pp(); }
    } },
    { ICode::mov_a_x, {
        [](CPU* c) -> void { c->X->a(); c->mr(); c->A->il(); },
        [](CPU* c) -> void { c->pp(); }
    } },
    { ICode::ld_a, {
        [](CPU* c) -> void { c->pp(); },
        [](CPU* c) -> void { c->PC->a(); c->mr(); c->A->il(); },
        [](CPU* c) -> void { c->pp(); }
    } },
    { ICode::movsm, {
        [](CPU* c) -> void { c->M->ol(); c->A->il(); },
        [](CPU* c) -> void { c->A->ol(); c->S->il(); },
        [](CPU* c) -> void { c->M->oh(); c->A->il(); },
        [](CPU* c) -> void { c->A->ol(); c->S->ih(); },
        [](CPU* c) -> void { c->pp(); }        
    } },
    { ICode::movms, {
        [](CPU* c) -> void { c->S->ol(); c->A->il(); },
        [](CPU* c) -> void { c->A->ol(); c->M->il(); },
        [](CPU* c) -> void { c->S->oh(); c->A->il(); },
        [](CPU* c) -> void { c->A->ol(); c->M->ih(); },
        [](CPU* c) -> void { c->pp(); }        
    } },
    { ICode::push_xm, {
        [](CPU* c) -> void { c->X->ol(); c->A->il(); },
        [](CPU* c) -> void { c->S->a(); c->A->ol(); c->mw(); },
        [](CPU* c) -> void { c->S->dec(); },
        [](CPU* c) -> void { c->X->oh(); c->A->il(); },
        [](CPU* c) -> void { c->S->a(); c->A->ol(); c->mw(); },
        [](CPU* c) -> void { c->S->dec(); },

        [](CPU* c) -> void { c->M->ol(); c->A->il(); },
        [](CPU* c) -> void { c->S->a(); c->A->ol(); c->mw(); },
        [](CPU* c) -> void { c->S->dec(); },
        [](CPU* c) -> void { c->M->oh(); c->A->il(); },
        [](CPU* c) -> void { c->S->a(); c->A->ol(); c->mw(); },
        [](CPU* c) -> void { c->S->dec(); },

        [](CPU* c) -> void { c->pp(); }


    } },
    { ICode::pop_mx, {
        [](CPU* c) -> void { c->S->inc(); },
        [](CPU* c) -> void { c->S->a(); c->mr(); c->A->il(); },
        [](CPU* c) -> void { c->A->ol(); c->M->ih(); },
        [](CPU* c) -> void { c->S->inc(); },
        [](CPU* c) -> void { c->S->a(); c->mr(); c->A->il(); },
        [](CPU* c) -> void { c->A->ol(); c->M->il(); },
        
        [](CPU* c) -> void { c->S->inc(); },
        [](CPU* c) -> void { c->S->a(); c->mr(); c->A->il(); },
        [](CPU* c) -> void { c->A->ol(); c->X->ih(); },
        [](CPU* c) -> void { c->S->inc(); },
        [](CPU* c) -> void { c->S->a(); c->mr(); c->A->il(); },
        [](CPU* c) -> void { c->A->ol(); c->X->il(); },

        [](CPU* c) -> void { c->pp(); }
        
    } },
    { ICode::sp_p_2, {
        [](CPU* c) -> void { c->S->inc(); },
        [](CPU* c) -> void { c->S->inc(); },
        [](CPU* c) -> void { c->pp(); }
    } },
    { ICode::sp_p_8, {
        [](CPU* c) -> void { c->S->inc(); },
        [](CPU* c) -> void { c->S->inc(); },
        [](CPU* c) -> void { c->S->inc(); },
        [](CPU* c) -> void { c->S->inc(); },
        [](CPU* c) -> void { c->S->inc(); },
        [](CPU* c) -> void { c->S->inc(); },
        [](CPU* c) -> void { c->S->inc(); },
        [](CPU* c) -> void { c->S->inc(); },
        [](CPU* c) -> void { c->pp(); }
    } },
    { ICode::sp_m_2, {
        [](CPU* c) -> void { c->S->dec(); },
        [](CPU* c) -> void { c->S->dec(); },
        [](CPU* c) -> void { c->pp(); }
    } },
    { ICode::sp_m_8, {
        [](CPU* c) -> void { c->S->dec(); },
        [](CPU* c) -> void { c->S->dec(); },
        [](CPU* c) -> void { c->S->dec(); },
        [](CPU* c) -> void { c->S->dec(); },
        [](CPU* c) -> void { c->S->dec(); },
        [](CPU* c) -> void { c->S->dec(); },
        [](CPU* c) -> void { c->S->dec(); },
        [](CPU* c) -> void { c->S->dec(); },
        [](CPU* c) -> void { c->pp(); }
    } },
    { ICode::push_m, {
        [](CPU* c) -> void { c->pp(); },
        [](CPU* c) -> void { c->PC->a(); c->mr(); c->Off->il(); },
        [](CPU* c) -> void { c->mfa(); c->mr(); c->A->il(); },
        [](CPU* c) -> void { c->S->a(); c->A->ol(); c->mw(); },
        [](CPU* c) -> void { c->S->dec(); },
        [](CPU* c) -> void { c->pp(); }
    } },
    { ICode::pop_m, {
        [](CPU* c) -> void { c->S->inc(); },
        [](CPU* c) -> void { c->S->a(); c->mr(); c->A->il(); },
        [](CPU* c) -> void { c->pp(); },
        [](CPU* c) -> void { c->PC->a(); c->mr(); c->Off->il(); },
        [](CPU* c) -> void { c->mfa(); c->A->ol(); c->mw(); },
        [](CPU* c) -> void { c->pp(); }
    } },
    { ICode::pushw_m, {
        [](CPU* c) -> void { c->pp(); },
        [](CPU* c) -> void { c->PC->a(); c->mr(); c->Off->il(); },
        [](CPU* c) -> void { c->mfa(); c->abus|=1; c->mr(); c->A->il(); },
        [](CPU* c) -> void { c->S->a(); c->A->ol(); c->mw(); },
        [](CPU* c) -> void { c->S->dec(); },

        [](CPU* c) -> void { c->PC->a(); c->mr(); c->Off->il(); },
        [](CPU* c) -> void { c->mfa(); c->mr(); c->A->il(); },
        [](CPU* c) -> void { c->S->a(); c->A->ol(); c->mw(); },
        [](CPU* c) -> void { c->S->dec(); },

        [](CPU* c) -> void { c->pp(); }
    } },
    { ICode::popw_m, {
        [](CPU* c) -> void { c->S->inc(); },
        [](CPU* c) -> void { c->S->a(); c->mr(); c->A->il(); },
        [](CPU* c) -> void { c->pp(); },
        [](CPU* c) -> void { c->PC->a(); c->mr(); c->Off->il(); },
        [](CPU* c) -> void { c->mfa(); c->A->ol(); c->mw(); },

        [](CPU* c) -> void { c->S->inc(); },
        [](CPU* c) -> void { c->S->a(); c->mr(); c->A->il(); },
        [](CPU* c) -> void { c->PC->a(); c->mr(); c->Off->il(); },
        [](CPU* c) -> void { c->mfa(); c->abus|=1; c->A->ol(); c->mw(); },

        [](CPU* c) -> void { c->pp(); }
    } },
    { ICode::mov_mm, {
        [](CPU* c) -> void { c->pp(); },
        [](CPU* c) -> void { c->PC->a(); c->mr(); c->Off->il(); },
        [](CPU* c) -> void { c->mfa(); c->mr(); c->A->il(); },
        [](CPU* c) -> void { c->pp(); },
        [](CPU* c) -> void { c->PC->a(); c->mr(); c->Off->il(); },
        [](CPU* c) -> void { c->mfa(); c->A->ol(); c->mw(); },
        [](CPU* c) -> void { c->pp(); }
    } },
    { ICode::mov_xm, {
        [](CPU* c) -> void { c->pp(); },
        [](CPU* c) -> void { c->PC->a(); c->mr(); c->Off->il(); },
        [](CPU* c) -> void { c->mfa(); c->mr(); c->A->il(); },
        [](CPU* c) -> void { c->A->ol(); c->X->il(); },

        [](CPU* c) -> void { c->mfa(); c->abus|=1; c->mr(); c->A->il(); },
        [](CPU* c) -> void { c->A->ol(); c->X->ih(); },
        [](CPU* c) -> void { c->pp(); }
    } },
    { ICode::INT, {
        [](CPU* c) -> void { c->toggle_pc(); },
        [](CPU* c) -> void { c->sela(); c->abus=0xffbe; c->S->ol(); c->mw(); },
        [](CPU* c) -> void { c->sela(); c->abus=0xffbd; c->S->oh(); c->mw(); },
        [](CPU* c) -> void { c->sela(); c->abus=0xffbf; c->A->ol(); c->mw(); 
                                c->S->reset(); },
        [](CPU* c) -> void { c->S->dec(); },
        [](CPU* c) -> void { c->X->oh(); c->A->il(); },
        [](CPU* c) -> void { c->S->a(); c->A->ol(); c->mw(); },
        [](CPU* c) -> void { c->X->ol(); c->A->il(); },
        [](CPU* c) -> void { c->S->dec(); },
        [](CPU* c) -> void { c->S->a(); c->A->ol(); c->mw(); },
        [](CPU* c) -> void { c->iv_o(); c->X->il(); },
        [](CPU* c) -> void { c->S->oh(); c->A->il(); },
        [](CPU* c) -> void { c->A->ol(); c->X->ih(); },
        [](CPU* c) -> void { c->S->dec(); },
        [](CPU* c) -> void { c->toggle_pc(); }
    } }
};

void fetch(CPU* c) {
    if((c->int_ctl->irq_pending()) && c->int_en) {
        c->IR->set_l(0xff);
    } else {
        c->PC->a();
        //printf("Fetch from 0x%04x\n", c->abus);
        c->mr();
        c->IR->il();
        //printf("IR 0x%02x\n", c->IR->get_l());
    }
}

void CPU::mr() {
    dbus = vmem->read(abus);
}

void CPU::mw() {
    vmem->write(abus, dbus);
}

void CPU::iv_o() {
    int_en = false;
    dbus = int_ctl->get_iv();
    int_ctl->reset();
}

void CPU::sela() {
    vmem->disable_pg();
}

void CPU::ei() {
    int_en = true;
    vmem->enable_pg();
}

std::string toBin(uint8_t v) {
    std::string res;
    for(int i = 7; i>=0; i--) {
        if(v & (1<<i)) {
            res = res + "1";
        } else {
            res = res + "0";
        }
    }
    return res;
}

bool CPU::condition() {

    uint8_t decoded_ir_con = ~(1U << (IR->get_l() & 0x07));

    uint8_t f = F->get_l();
    uint8_t FC = (f & (1<<0))? 1:0;
    uint8_t FZ = (f & (1<<1))? 1:0;
    uint8_t FS = (f & (1<<2))? 1:0;
    uint8_t FO = (f & (1<<3))? 1:0;
    

    uint8_t decoded_flags = (FZ << 0) | (FC << 1) | ((FZ | (FS^FO)) << 2) | ((FZ | FC) << 3) | ((FS ^ FO) << 4);
    
    if(IR->get_l() & (1 << 3)) {
        decoded_flags = ~decoded_flags;
    }
    
    // 0x1f = b 0001 1111
    uint8_t ored_flags = ((decoded_flags | decoded_ir_con) & 0x1f) | (decoded_ir_con & 0x80);
/*
    printf("VVVVV cmp VVVVV\n");
    printf("IR   %s\n", toBin(IR->get_l()).c_str());
    printf("F    %s\n", toBin(F->get_l()).c_str());
    printf("DIC  %s\n", toBin(decoded_ir_con).c_str());
    printf("DF   %s\n", toBin(decoded_flags).c_str());
    printf("ORF  %s\n", toBin(ored_flags).c_str());
*/
    // b1001 1111 = 0x9f
    bool cmp = false;
    if( (ored_flags & 0x9f) != 0x9f) {
        cmp = true;
    } else {
        cmp = false;
    }
/*
    printf("RES %s\n", cmp?"TRUE":"FALSE");
    printf("^^^^^ cmp ^^^^^\n");
*/
    return cmp;

}

void CPU::pp() {
    PC->inc();
}
void CPU::mfa() {
    abus = calc_mf_addr();
}
void CPU::alul() {
    aluA = A->get_l();
    aluB = B->get_l();
}


enum {
/*0000*/  c_add  = 0,
/*0001*/  c_adc  = 1,
/*0010*/  c_sub  = 2,
/*0011*/  c_sbc  = 3,
/*0100*/  c_or   = 4,
/*0101*/  c_orc  = 5,
/*0110*/  c_xor  = 6,
/*0111*/  c_xorc = 7,
/*1000*/  c_and  = 8,
/*1001*/  c_andc = 9,
/*1010*/  c_neg  = 10,
/*1011*/  c_not  = 11,
/*1100*/  c_shl  = 12,
/*1101*/  c_shlc = 13,
/*1110*/  c_shr  = 14,
/*1111*/  c_shrc = 15
};

void evaluate_alu(uint8_t cmd, uint8_t carry_in, uint8_t A, uint8_t B, uint8_t &R8, uint8_t &F) {
    uint8_t CF = 0;
    uint8_t ZF = 0;
    uint8_t SF = 0;
    uint8_t OF = 0;

    uint16_t R = 0;


    uint16_t A16 = A;
    uint16_t B16 = B;

    uint8_t ignore_carry = 1;
    uint8_t tmp = 0;

    switch(cmd) {
        case c_adc:
            ignore_carry = 0;
            //fallthrough
        case c_add:
            R = A + B;
            if(!ignore_carry) R += carry_in;

            if( (A & 0x80U) == (B & 0x80U) ) {
                if( (A & 0x80U) != (R & 0x80U) ) {
                    OF = 1;
                }
            }

        break;
        case c_sbc:
            ignore_carry = 0;
            //fallthrough
        case c_sub:
            B16 = ~B16;
            if(ignore_carry) {
                B16 = B16 + 1u;
            } else {
                B16 = B16 + 1u - carry_in;                
            }


            R = A16 + B16;

            if( (A16 & 0x80U) == (B16 & 0x80U) ) {
                if( (A16 & 0x80U) != (R & 0x80U) ) {
                    OF = 1;
                }
            }

        break;
        case c_neg:
            R = ~A;
            if(ignore_carry) {
                R = R + 1;
            } else {
                R = R + carry_in;                
            }
            // flip bit 8 (borrow-carry)
            R ^= (1<<8);
        break;
        /*
        case c_inc:
            if(ignore_carry) {
                R = A + 1;
            } else {
                R = A + carry_in;
            }
            if( (A & 0x80) == 0 ) {
                if( (R & 0x80) != 0 ) {
                    OF = 1;
                }
            }
        break;
        */
        case c_not:
            R = ~A;
        break;
        case c_and:
        case c_andc:
            R = A & B;
        break;
        case c_or:
        case c_orc:
            R = A | B;
        break;
        case c_xor:
        case c_xorc:
            R = A ^ B;
        break;

        case c_shlc:
            ignore_carry = 0;
        case c_shl:
            R = A<<1;
            if(ignore_carry) {
            } else {
                R|=carry_in;
            }
        break;

        case c_shrc:
            ignore_carry = 0;
        case c_shr:

            if(A&0x01U) {
                tmp = 1;
            }
            R = A>>1;
            if(ignore_carry) {
            } else {
                R|=carry_in << 7;
            }
            if(tmp) {
                R|=0x100;
            }
        break;

/*
        case c_test:
            if(!low) {
                if(A || carry_in) {
                    R = 1;
                } else {
                    R = 0;
                }
            } else { 
                if(A) {
                    R = 0x10;
                } else {
                    R = 0;
                }
            }
        break;
*/
        default:
            return;

    }
//CF ZF SF OF


    //TEMP HACK
    //OF = 0;

    //printf("R: 0x%04x\n", R);

    if((R&0xffU) == 0) ZF = 1;
    
    if((R&0x100U) != 0) CF = 1;

    SF = (R & 0x80U) ? 1 : 0;

    F = ((CF << 0) | (ZF << 1) | (SF << 2) | (OF << 3));

    R8 = R&0xffU;
}




void CPU::alud() {
    uint8_t cmd = IR->get_l() & 0x0fu;
    uint8_t carry_in = F->get_l() &0x01u;
    uint8_t res;
    uint8_t f;
    evaluate_alu(cmd, carry_in, aluA, aluB, res, f);
    
    //printf("alud:  %d %d -> %d 0x%02x(cmd 0x%02x)\n", aluA, aluB, res, f, cmd);
    dbus = res;
}
void CPU::alufd() {
    uint8_t cmd = IR->get_l() & 0x0fu;
    uint8_t carry_in = F->get_l() &0x01u;
    uint8_t res;
    uint8_t f;
    evaluate_alu(cmd, carry_in, aluA, aluB, res, f);


    uint8_t curr_FZ = (f & 0x02u) ? 1:0;
    uint8_t prev_FZ = ( F->get_l() & 0x02u ) ? 1:0;
    
    uint8_t FZ = curr_FZ;
    if(cmd & 0x01u) {
        FZ = curr_FZ & prev_FZ;
    }

    f &= ~(0x02u);
    f |= FZ << 1;
    
    //printf("alufd: %d %d -> %d 0x%02x(cmd 0x%02x)\n", aluA, aluB, res, f, cmd);

    dbus = f;
}

void CPU::toggle_pc() {
    if(condition()) {
        std::swap(PC,X);
    }
}

void delay_ns(long long ns) {
    using clock = std::chrono::steady_clock; // monotonic, not wall time
    const auto start = clock::now();
    const auto end   = start + std::chrono::nanoseconds(ns);

    // Optional: compiler barrier to stop clever reordering across the loop body
    do {
        std::atomic_signal_fence(std::memory_order_seq_cst);
    } while (clock::now() < end);
}

void CPU::delay(int n_cycles) {
    delay_ns(cycle_delay_ns);
}

void CPU::set_calib_cycle_delay_ns(size_t ns) {
    cycle_delay_ns = ns;
}

size_t CPU::get_calib_cycle_delay_ns() {
    return cycle_delay_ns;
}

uint16_t CPU::calc_mf_addr() {
    uint16_t addr = M->get16();
    uint8_t off = Off->get_l();
    uint16_t off16 = ((((uint16_t)off & 0x80u) ? 0xffu : 0x00u) << 8) | (uint16_t)off;
    return addr + off16;
}

void CPU::not_impl() {
    printf("Not implemented! IR 0x%02x\n", IR->get_l());
    running.store(false);
}

static size_t __mpc = 0;
static size_t __backup_cycle = 0;

void CPU::exec_instruction(size_t mpc) {
    if(mpc == 0) {


                if(  vmem->get_paging_enabled() 
                     && !int_ctl->fault_pending()
                     && IR->get_l() != 0x2f) { //no record when fault_load in IRET
                    fault_bk.mpc = mpc;
                    fault_bk.IR->set_l(IR->get_l());
                    fault_bk.Off->set_l(Off->get_l());
                    __backup_cycle = tick_n;
                }     


        fetch(this);
        tick_n++;
        mpc++;
    }
    uint8_t code = IR->get_l();
    for(const auto & in : instructions) {
        if(in.code == (code & in.mask)) {
            const auto & mc_routine = microcode[in.icode];
            for(; mpc < mc_routine.size()+1; mpc++) {
                __mpc = mpc;

                if(  vmem->get_paging_enabled() 
                     && !int_ctl->fault_pending()
                     && IR->get_l() != 0x2f) { //no record when fault_load in IRET
                    fault_bk.mpc = mpc;
                    fault_bk.IR->set_l(IR->get_l());
                    fault_bk.Off->set_l(Off->get_l());
                    __backup_cycle = tick_n;
                }                
                mc_routine[mpc-1](this);
                tick_n++;
                delay(1);
            }
            return;
        }
    }
    printf("Unknown instruction 0x%02x\n", code);
}


CPU::CPU() {

    A   = std::make_shared<Register>(this);
    B   = std::make_shared<Register>(this);
    PA  = std::make_shared<Register>(this);
    PB  = std::make_shared<Register>(this);
    M   = std::make_shared<Register>(this);
    S   = std::make_shared<Register>(this);
    F   = std::make_shared<Register>(this);
    IR  = std::make_shared<Register>(this);
    Off = std::make_shared<Register>(this);

    fault_bk.mpc = 0;
    fault_bk.Off = std::make_shared<Register>(this);
    fault_bk.IR = std::make_shared<Register>(this);

    PC = PA;
    X = PB;
    init_decode();
}

void CPU::init_decode() {
    instructions.push_back({0x00, 0xff,  2, ICode::hlt         });
    instructions.push_back({0x01, 0xff,  3, ICode::di          });
    instructions.push_back({0x02, 0xff,  3, ICode::ei          });
    instructions.push_back({0x03, 0xff,  2, ICode::nop         });
    instructions.push_back({0x04, 0xff,  4, ICode::cpy         });
    instructions.push_back({0x05, 0xff,  2, ICode::swp         });
    instructions.push_back({0x07, 0xff,  5, ICode::xpp         });
    instructions.push_back({0x0f, 0xff, 14, ICode::iret        });
    instructions.push_back({0x1f, 0xff, 16, ICode::scall       });
    instructions.push_back({0x2f, 0xff, 15, ICode::iretf       });
    instructions.push_back({0xa0, 0xf0,  3, ICode::jump        });
    instructions.push_back({0xb0, 0xf0, 14, ICode::talu        });
    instructions.push_back({0xc0, 0xf0,  4, ICode::alu         });
    instructions.push_back({0xd0, 0xff,  3, ICode::mov_b_a     });
    instructions.push_back({0xd1, 0xff,  3, ICode::mov_sl_a    });
    instructions.push_back({0xd2, 0xff,  3, ICode::mov_sh_a    });
    instructions.push_back({0xd3, 0xff,  3, ICode::mov_ml_a    });
    instructions.push_back({0xd4, 0xff,  3, ICode::mov_mh_a    });
    instructions.push_back({0xd5, 0xff,  5, ICode::mov_mf_a    });
    instructions.push_back({0xd6, 0xff,  3, ICode::mov_xl_a    });
    instructions.push_back({0xd7, 0xff,  3, ICode::mov_xh_a    });
    instructions.push_back({0xd9, 0xff,  4, ICode::push_a      });
    instructions.push_back({0xda, 0xff,  3, ICode::mov_f_a     });
    instructions.push_back({0xdb, 0xff,  3, ICode::mov_x_a     });
    instructions.push_back({0xdc, 0xff,  8, ICode::ldd_s       });
    instructions.push_back({0xdd, 0xff,  8, ICode::ldd_m       });
    instructions.push_back({0xde, 0xff,  8, ICode::ldd_x       });
    instructions.push_back({0xdf, 0xff,  8, ICode::ldd_r_i     });
    instructions.push_back({0xe0, 0xff,  3, ICode::mov_a_b     });
    instructions.push_back({0xe1, 0xff,  3, ICode::mov_a_sl    });
    instructions.push_back({0xe2, 0xff,  3, ICode::mov_a_sh    });
    instructions.push_back({0xe3, 0xff,  3, ICode::mov_a_ml    });
    instructions.push_back({0xe4, 0xff,  3, ICode::mov_a_mh    });
    instructions.push_back({0xe5, 0xff,  5, ICode::mov_a_mf    });
    instructions.push_back({0xe6, 0xff,  3, ICode::mov_a_xl    });
    instructions.push_back({0xe7, 0xff,  3, ICode::mov_a_xh    });
    instructions.push_back({0xe9, 0xff,  4, ICode::pop_a       });
    instructions.push_back({0xea, 0xff,  3, ICode::mov_a_f     });
    instructions.push_back({0xeb, 0xff,  3, ICode::mov_a_x     });
    instructions.push_back({0xec, 0xff,  4, ICode::ld_a        });
    instructions.push_back({0xee, 0xff,  6, ICode::movsm       });
    instructions.push_back({0xef, 0xff,  6, ICode::movms       });
    instructions.push_back({0xf0, 0xff, 14, ICode::push_xm     });
    instructions.push_back({0xf1, 0xff, 14, ICode::pop_mx      });
    instructions.push_back({0xf2, 0xff,  4, ICode::sp_p_2      });
    instructions.push_back({0xf3, 0xff, 10, ICode::sp_p_8      });
    instructions.push_back({0xf4, 0xff,  4, ICode::sp_m_2      });
    instructions.push_back({0xf5, 0xff, 10, ICode::sp_m_8      });
    instructions.push_back({0xf6, 0xff,  7, ICode::push_m      });
    instructions.push_back({0xf7, 0xff,  7, ICode::pop_m       });
    instructions.push_back({0xf8, 0xff, 11, ICode::pushw_m     });
    instructions.push_back({0xf9, 0xff, 11, ICode::popw_m      });
    instructions.push_back({0xfa, 0xff,  8, ICode::mov_mm      });
    instructions.push_back({0xfe, 0xff,  8, ICode::mov_xm      });
    instructions.push_back({0xff, 0xff,  8, ICode::INT         });


}

void CPU::reset() {
    PA->reset();
    PB->reset();
}

void CPU::fault() {

}

int CPU::cycle() {

    //execute
    try {
        uint8_t mpc = 0;
        if(is_fault_recovery) {
            mpc = fault_bk.mpc;
            IR->set_l(fault_bk.IR->get_l());
            Off->set_l(fault_bk.Off->get_l());

            printf("Recovery with mpc = 0x%02x, IR = 0x%02x\n", mpc, IR->get_l());
            is_fault_recovery = false;
        }
        alul();
        exec_instruction(mpc);
    } catch (const CPUFault &e) {
        printf("Fault! %s\n", e.what());
        printf("fault_bk.IR = 0x%02x\n", fault_bk.IR->get_l());
        printf("IR = 0x%02x\n", IR->get_l());
        printf("fault_bk.mpc = 0x%02x\n", fault_bk.mpc);
        printf("mpc = 0x%02x\n", __mpc);
        printf("current_cycle = %zu\n", tick_n);
        printf("backup_cycle = %zu\n", __backup_cycle);
        
        
        int_ctl->set_int(0);
        vmem->disable_pg();

    }
    return 0;
}

void CPU::set_vmem(std::shared_ptr<VMem> v) {
    vmem = v;
}

void CPU::set_int_ctl(std::shared_ptr<IntCtl> ic) {
    int_ctl = ic;
}



void sigint_handler(int signum) {
    if (signum == SIGINT) {
        running.store(false, std::memory_order_relaxed);
    }
}


IntCtl::IntCtl() { irqs.resize(4, false); };

void IntCtl::set_int(int irqn) {
    if(irqn < irqs.size()) {
        irqs[irqn] = true;
    } else {
        throw std::runtime_error("IRQ too big");
    }
}

bool IntCtl::irq_pending() {
    for(size_t i = 0; i<irqs.size(); i++) {
        if(irqs[i]) {
            return true;
        }
    }
    return false;
}


void IntCtl::reset() {
    for(size_t i = 0; i<irqs.size(); i++) {
        irqs[i] = false;
    }    
}


uint8_t IntCtl::get_iv() {
    for(size_t i = 0; i<irqs.size(); i++) {
        if(irqs[i]) {
            uint8_t vec = (uint8_t)(i * 0x10);
            irqs[i] = false;
            return vec;
        }
    }
    return 0x40;
}
    


void test_alu(CPU & c) {

    for(uint16_t a = 0x15; a < 0xffff; a++) {
        for(uint16_t b = 0x13; b < 0xffff; b++) {
            uint16_t r = 0;
            uint8_t iflag = 0;
            c.A->set_l(a&0xff);
            c.B->set_l(b&0xff);
            c.alul();
            c.IR->set_l(0xc2); //sub
            c.alud();
            r = c.dbus;
            c.alufd();
            c.F->set_l(c.dbus);
            iflag = c.dbus;
            c.A->set_l((((uint16_t)a)&0xff00) >> 8);
            c.B->set_l((((uint16_t)b)&0xff00) >> 8);
            c.alul();
            c.IR->set_l(0xc3); //sbc
            c.alud();

            r |= (((uint16_t)c.dbus) << 8);

            if((uint16_t)(a - b) != r) {
                printf("error! 0x%04X - 0x%04X = 0x%04X (exp 0x%04X)\n", a,b,r,(uint16_t)(a-b));
                printf("iflag 0x%02X\n", iflag);
                exit(1);
            }

        }
    }

}




void TLBCtl::write(uint16_t addr, uint8_t data) {
    if(addr == 0x0000) { //RESET PAGING
        
        vmem->disable_pg();
    } else if(addr == 0x0001) { //SET_PAGING
        
        vmem->enable_pg();
    } else if(addr == 0x0002) { //TLB INDEX
        //printf("Set tlb index 0x%02x\n", data);
        vmem->set_tlb_index(data);
    }
}
uint8_t TLBCtl::read(uint16_t addr) { 
    if(addr == 0x0005) { //MMU_FAULT_IDX
        return vmem->get_fault_idx();
    } else if(addr == 0x0006) { //MMU_FAULT_PAGE_CAUSE
        return vmem->get_fault_page_cause();
    } else {
        printf("Illegal TLB read (0x%04x)\n", addr);
        return 0;
    }
}
void TLBCtl::set_irq_callback(std::function<void(void)> fn) {}



std::pair<uint32_t, uint8_t> VMem::get_eaddr_flags(uint16_t addr) {
    std::pair<uint32_t, uint8_t> res;

    uint16_t tlb_addr = ((addr & 0xF000) >> 12) | (((uint16_t)tlb_index) << 4);
    uint8_t tlb_data = tlb_memory->read(tlb_addr);
    uint8_t tlbf_data = tlb_memory->read((1u << 12) | tlb_addr);        

    res.first =((uint32_t)(addr & 0x0fff)) | (((uint32_t)tlb_data) << 12);
    res.second = tlbf_data;

    return res;
}

uint8_t VMem::read(uint16_t addr) {
    uint32_t eaddr = addr;
    if(paging_enable) {
        auto tlb_res = get_eaddr_flags(addr);
        eaddr = tlb_res.first;
        uint8_t flags = tlb_res.second;
        if((flags & 0x01) == 0) {
            fault_idx = tlb_index;
            fault_page_cause = (addr >> 12) | (1 << 4);
            throw CPUFault("Read violation!");
        }

/*
        if(eaddr & 0x10000) {
                printf("read from 0x10000\n");
                printf("EAddr 0x%06X\n", eaddr);
                printf("TLBFlags: 0x%02x\n", flags);

                uint16_t tlb_addr = ((addr & 0xF000) >> 12) | (((uint16_t)tlb_index) << 4);
                printf("TLB addr: 0x%04x\n", tlb_addr);
                printf("TLBF addr: 0x%04x\n", (1u << 12) | tlb_addr);
                running.store(false);

        }
        */
        //if(tlb_index == 1) {
            //printf("Read with tlb_index == 0x%02x\naddr = 0x%04x\neaddr = 0x%04x\n", tlb_index, addr, eaddr);
        //}

    }

    // TLB here
    //printf("Read 0x%04x\n", addr);
    //if(eaddr & 0x1ffff) {
    //    printf("Read from eaddr %0x06X\n", eaddr);
    //}
    auto d = decode(eaddr);
    uint8_t data = d.first->read(eaddr & d.second);
    return data;
}
void VMem::write(uint16_t addr, uint8_t data) {
    uint32_t eaddr = addr;
    if(paging_enable) {
        auto tlb_res = get_eaddr_flags(addr);
        eaddr = tlb_res.first;
        uint8_t flags = tlb_res.second;
        if((flags & 0x02) == 0) {
            fault_idx = tlb_index;
            fault_page_cause = (addr >> 12) | (1 << 5);
            throw CPUFault("Write violation!");
        }
    }
    auto d = decode(eaddr);
    d.first->write(eaddr & d.second, data);
}

void VMem::add_vmem_entry(VMemEntry en) {
    decode_table.push_back(en);
}




int main(int argc, char ** argv) {
    signal(SIGINT, sigint_handler);
    Args args = parse_args(argc,argv);

    size_t target_cycle_time_ns = (size_t)(  (32.0 * 1.0 / (1000000.0 * args.mhz)) * 1000000000.0  );

    CPU cpu;

    std::shared_ptr<IntCtl> int_ctl = std::make_shared<IntCtl>();


    std::shared_ptr<RamDevice> rom = std::make_shared<RamDevice>(1024 * 16, true);
    rom->load(args.rom);

    std::shared_ptr<RamDevice> low_ram = std::make_shared<RamDevice>(1024 * 32, false);

    std::shared_ptr<RamDevice> high_ram = std::make_shared<RamDevice>(1024 * 1024, false);

    std::shared_ptr<Console> console  = std::make_shared<Console>();
    console->set_irq_callback([&]() -> void { int_ctl->set_int(3); });

    std::shared_ptr<SimpleStorage> storage = std::make_shared<SimpleStorage>();
    storage->load(args.hdd);

    std::shared_ptr<VMem> vmem = std::make_shared<VMem>();

    std::shared_ptr<RamDevice> tlb_memory = std::make_shared<RamDevice>(0x2000, false);
    std::shared_ptr<TLBCtl> tlb_ctl = std::make_shared<TLBCtl>(vmem);

    vmem->set_tlb_ctl(tlb_ctl);
    vmem->set_tlb_memory(tlb_memory);


    vmem->add_vmem_entry(VMemEntry(0x00000, 0x03fff, 0x03fff, rom));
    vmem->add_vmem_entry(VMemEntry(0x08000, 0x0ffff, 0x07fff, low_ram));
    vmem->add_vmem_entry(VMemEntry(0x10000, 0xfffff, 0xfffff, high_ram));
    vmem->add_vmem_entry(VMemEntry(0x04000, 0x04003, 0x00003, storage));
    vmem->add_vmem_entry(VMemEntry(0x04004, 0x04004, 0x00000, console));
    vmem->add_vmem_entry(VMemEntry(0x06000, 0x07fff, 0x01fff, vmem->get_tlb_memory()));
    vmem->add_vmem_entry(VMemEntry(0x04800, 0x04806, 0x00007, vmem->get_tlb_ctl()));

    cpu.set_vmem(vmem);
    cpu.set_int_ctl(int_ctl);

    cpu.reset();


    auto calib_time_start = std::chrono::steady_clock::now();
    size_t calib_start_tick = 0;

    size_t last_timer_tick_n = 0;

    while(running.load()) {
        cpu.cycle();

        if(cpu.tick_n - last_timer_tick_n > 0x10000) {
            int_ctl->set_int(1);
            last_timer_tick_n = cpu.tick_n;
        }

        if((cpu.tick_n - calib_start_tick > 10000)) {
            auto calib_time_end = std::chrono::steady_clock::now();
            std::chrono::duration<double> diff = calib_time_end - calib_time_start;
            size_t cycle_time_ns = (diff.count() / (static_cast<double>(cpu.tick_n - calib_start_tick))) * 1000000000.0;

            size_t calib_delay = 0;
            if(target_cycle_time_ns > cycle_time_ns) {
                calib_delay = target_cycle_time_ns - cycle_time_ns;
            }
            cpu.set_calib_cycle_delay_ns(target_cycle_time_ns - (cycle_time_ns - cpu.get_calib_cycle_delay_ns()));


            double clock_estimation_mhz = (static_cast<double>((cpu.tick_n - calib_start_tick) * 32) / diff.count()) / 1000000.0;
            //printf("\n\nCycle time %zu ns, target %zu. Requested main clock freq %f. Main clock freq %f MHz\n", cycle_time_ns, target_cycle_time_ns, args.mhz, clock_estimation_mhz);
            calib_time_start = calib_time_end;
            calib_start_tick = cpu.tick_n;
        }

    }

    console->stop();
    
    printf("Exiting sim.\n");
    return 0;
}