#include <stdio.h>
#include <stdint.h>
#include <memory>
#include "devices.hpp"

#include "l_sim.hpp"

#include <exception>
#include <string>


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
uint8_t Register::ol() {
    c->dbus = data & 0x00ff;
}
uint8_t Register::oh() {
    c->dbus = (data & 0xff00) >> 8;
}
uint16_t Register::a() {
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

std::map<ICode, std::vector<std::function<void(CPU*)>>> microcode = {

    { ICode::hlt, {
        [](CPU* c) -> void { printf("HLT!\n"); }
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
    { ICode::ldd_r_r, {
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
    } }
};

int fetch(CPU* c) {
    if(c->FAULT || c->IRQ) {
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
    // XXXX
}

void CPU::sela() {
    // XXXX
}

void CPU::ei() {
    // XXXX
}

bool CPU::condition() {
    // XXXX
    return true;
}

void CPU::pp() {
    PC->inc();
}
void CPU::mfa() {
    abus = calc_mf_addr();
}
void CPU::alul() {
    // XXXX
}
void CPU::alud() {
    // XXXX
}
void CPU::alufd() {
    // XXXX
}

void CPU::toggle_pc() {
    if(condition()) {
        std::swap(PC,X);
    }
}

void CPU::delay(int n_cycles) {
    // XXXX
}

uint16_t CPU::calc_mf_addr() {
    uint16_t addr = M->get16();
    uint8_t off = Off->get_l();
    uint16_t off16 = (((off & 0x80) ? 0xff : 0x00) << 8) | (uint16_t)off;
    return off16;
}

void CPU::not_impl() {
    printf("Not implemented! IR 0x%02x\n", IR->get_l());
    exit(1);
}

void CPU::exec_instruction(size_t mpc) {
    if(mpc == 0) {
        fetch(this);
        mpc++;
    }
    uint8_t code = IR->get_l();
    for(const auto & in : instructions) {
        if(in.code == (code & in.mask)) {
            const auto & mc_routine = microcode[in.icode];
            for(; mpc < mc_routine.size()+1; mpc++) {
                //backup registers for fault
                mc_routine[mpc-1](this);
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
    instructions.push_back({0xdf, 0xff,  8, ICode::ldd_r_r     });
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
    uint8_t bus;
    //check IRQ
    
    //execute
    try {
        exec_instruction(0);
    } catch (const CPUFault &e) {

    }

}

void CPU::set_vmem(std::shared_ptr<VMem> v) {
    vmem = v;
}


std::atomic<bool> running{true};
void sigint_handler(int signum) {
    if (signum == SIGINT) {
        running.store(false, std::memory_order_relaxed);
    }
}

int main(int argc, char ** argv) {
    signal(SIGINT, sigint_handler);
    Args args = parse_args(argc,argv);

    CPU cpu;
    
    std::shared_ptr<RamDevice> rom = std::make_shared<RamDevice>(1024 * 16, true);
    rom->load(args.rom);

    std::shared_ptr<RamDevice> low_ram = std::make_shared<RamDevice>(1024 * 32, false);

    std::shared_ptr<Console> console  = std::make_shared<Console>();

    std::shared_ptr<SimpleStorage> storage = std::make_shared<SimpleStorage>();
    storage->load(args.hdd);


    std::shared_ptr<VMem> vmem = std::make_shared<VMem>();

    vmem->add_vmem_entry(VMemEntry(0x00000, 0x03fff, 0x03fff, rom));
    vmem->add_vmem_entry(VMemEntry(0x08000, 0x0ffff, 0x07fff, low_ram));
    vmem->add_vmem_entry(VMemEntry(0x04000, 0x04003, 0x00003, storage));
    vmem->add_vmem_entry(VMemEntry(0x04004, 0x04004, 0x00000, console));

    cpu.set_vmem(vmem);
    cpu.reset();

    while(running.load()) {
        cpu.cycle();
    }

    printf("Exiting sim.\n");
    return 0;
}