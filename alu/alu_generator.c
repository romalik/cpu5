#include <stdio.h>
#include <stdint.h>


void decode_address(uint16_t addr, uint8_t * A, uint8_t * B, uint8_t * cmd, uint8_t * carry_in) {
    *A          = (addr & 0b0000000001111);
    *B          = (addr & 0b0000011110000) >> 4;
    *cmd        = (addr & 0b0111100000000) >> 8;
    *carry_in   = (addr & 0b1000000000000) >> 12;
}

uint16_t encode_address(uint8_t A, uint8_t B, uint8_t cmd, uint8_t carry_in) {
  uint16_t result = (A                & 0b0000000001111) |  
                    ((B << 4)         & 0b0000011110000) |  
                    ((cmd << 8)       & 0b0111100000000) |  
                    ((carry_in << 12) & 0b1000000000000);
  return result;    
}

enum {
    c_add = 0,
    c_sub,
    c_neg,
    c_shl,
    c_shlc,
    c_inc,
    c_adc,
    c_sbc,
    /////
    c_not,
    c_and,
    c_or,
    c_xor,
    c_zero,
    c_test,
    c_shr,
    c_shrc
};

char * cmd_names[16] = {
    "c_add",
    "c_sub",
    "c_neg",
    "c_shl",
    "c_shlc",
    "c_inc",
    "c_adc",
    "c_sbc",
    "c_not",
    "c_and",
    "c_or",
    "c_xor",
    "c_zero",
    "c_test",
    "c_shr",
    "c_shrc"
};

//The overflow flag is thus set when the most significant bit (here considered the sign bit) 
//is changed by adding two numbers with the same sign 
//(or subtracting two numbers with opposite signs)
uint8_t gen(uint16_t addr, uint8_t low, int dprint) {
    uint8_t ret = 0;
    uint8_t R = 0;
    uint8_t CF = 0;
    uint8_t ZF = 0;
    uint8_t SF = 0;
    uint8_t OF = 0;

    uint8_t A;
    uint8_t B;
    uint8_t cmd;
    uint8_t carry_in;

    uint8_t ignore_carry = 0;
    decode_address(addr, &A, &B, &cmd, &carry_in);


    ignore_carry = low;

    switch(cmd) {
        case c_adc:
            ignore_carry = 0;
            //fallthrough
        case c_add:
            R = A + B;
            if(!ignore_carry) R += carry_in;

            if( (A & 0x80) == (B & 0x80) ) {
                if( (A & 0x80) != (R & 0x80) ) {
                    OF = 1;
                }
            }

        break;
        case c_sbc:
            ignore_carry = 0;
            //fallthrough
        case c_sub:
            B = ~B;
            if(ignore_carry) {
                B = B + 1;
            } else {
                B = B + 1 - carry_in;                
            }


            R = A + B;

            if( (A & 0x80) == (B & 0x80) ) {
                if( (A & 0x80) != (R & 0x80) ) {
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
            // flip bit 4 (borrow-carry)
            R ^= (1<<4);
        break;
        case c_shlc:
            ignore_carry = 0;
            //fallthrough
        case c_shl:
            R  = A << 1;
            if(!ignore_carry) R |= carry_in;            
        break;
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
        case c_not:
            R = ~A;
        break;
        case c_and:
            R = A & B;
        break;
        case c_or:
            R = A | B;
        break;
        case c_xor:
            R = A ^ B;
        break;
        case c_zero:
            R = 0;
        break;
        case c_test:
        //we are in upper half, accept carry on low chip, generate carry on high chip
        //lower equals 1 if not zero or if carry
        //higher always zero, sets carry if A not zero
            if(low) {
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
        case c_shr:
            R = A >> 1;
            R = R | ((A&0x01) << 4); //set carry from bit0
            if(low) R = R | (carry_in<<3); //assign bit 3 to carry_in if lower chip
        break;
        case c_shrc:
            R = A >> 1;
            R = R | ((A&0x01) << 4); //set carry from bit0
            R = R | (carry_in<<3); //assign bit 3 to carry_in for both chips
        break;
        default:
            printf("Bad cmd\n");
            return 0;

    }
//CF ZF SF OF

    if((R&0x0f) == 0) ZF = 1;
    
    if((R&0x10) != 0) CF = 1;

    SF = (R & 0x08) >> 3;

    ret = ((R&0x0f) | (CF << 4) | (ZF << 5) | (SF << 6) | (OF << 7));

    if(dprint) printf("A 0x%02x B 0x%02x cmd %s(0x%02x) carry_in %d R 0x%02x CF %d ZF %d SF %d OF %d -> 0x%02x\n", A, B, cmd_names[cmd], cmd, carry_in, R, CF, ZF, SF, OF, ret);
    return ret;
}

#define IMAGE_SIZE 8*1024

uint8_t chip_low[IMAGE_SIZE];
uint8_t chip_high[IMAGE_SIZE];

uint16_t test_gen_output(uint8_t A, uint8_t B, uint8_t cmd, uint8_t carry_in, int dprint) {
    uint16_t result;
    uint8_t * chip_l = chip_low;
    uint8_t * chip_h = chip_high;
    uint16_t addr_low, addr_high;
    uint8_t res_low, res_high;
    uint8_t internal_carry;

    if((cmd & 0x08) == 0) {
        addr_low = encode_address((A&0x0f), (B&0x0f), cmd, carry_in);
        res_low  = chip_l[addr_low];

        internal_carry = (res_low & 0x10) >> 4;

        addr_high = encode_address((A&0xf0)>>4, (B&0xf0)>>4, cmd, internal_carry);
        res_high = chip_h[addr_high];
    } else {
        addr_high = encode_address((A&0xf0)>>4, (B&0xf0)>>4, cmd, carry_in);
        res_high = chip_h[addr_high];
        
        internal_carry = (res_high & 0x10) >> 4;

        addr_low = encode_address((A&0x0f), (B&0x0f), cmd, internal_carry);
        res_low  = chip_l[addr_low];
    }

    result = (res_low&0x0f) | (res_high << 4);

    if(dprint) {
        printf("\n");
        printf("carry_in: %d\n", carry_in);
        printf("addr_low: 0x%04x\n", addr_low);
        printf("res_low: 0x%02x\n", res_low);
        printf("Gen low:\n");
        gen(addr_low, 1, dprint);
        printf("\n");
        printf("internal_carry: %d\n", internal_carry);
        printf("addr_high: 0x%04x\n", addr_high);
        printf("res_high: 0x%02x\n", res_high);
        printf("Gen high:\n");
        gen(addr_high, 0, dprint);
        printf("\n");
    }


    return result;
}
int total_tests = 0;
int test_one(int a, int b, int cmd, int carry, int expect) {
    int success;
    uint16_t r = test_gen_output(a&0xff, b&0xff, cmd, carry, 0);
    uint8_t f = (r & 0xff00) >> 8;
    r = r & 0xff;
    expect = expect & 0xff;
    success = ((r&0xff) == (expect&0xff));
    if(!success) {
        printf("%s for %d(0x%02x) %s(%d) %d(0x%02x) CF %d = %d(0x%02x) (should be %d(0x%02x))\n", success?"Pass":"Fail", a, a, cmd_names[cmd], cmd, b, b, carry, r, r, expect, expect);
        test_gen_output(a&0xff, b&0xff, cmd, carry, 1);
        return 1;
    }
    total_tests++;
    return 0;
}

int test() {
    int a;
    int b;
    int r;
    int cmd= 0;
    int expect;
    int f = 0;
    int success = 0;
    for(a = -128; a<256; a++) {
        for(b = -128; b<256; b++) {


            // c_add
            if(test_one(a,b,c_add,0,a+b)) return 1;
            if(test_one(a,b,c_add,1,a+b)) return 1;
            // c_sub
            if(test_one(a,b,c_sub,0,a-b)) return 1;
            if(test_one(a,b,c_sub,1,a-b)) return 1;
            // c_neg
            if(test_one(a,b,c_neg,0,-a)) return 1;
            if(test_one(a,b,c_neg,1,-a)) return 1;
            // c_shl
            if(test_one(a,b,c_shl,0,a<<1)) return 1;
            if(test_one(a,b,c_shl,1,a<<1)) return 1;
            // c_shlc
            if(test_one(a,b,c_shlc,0,a<<1)) return 1;
            if(test_one(a,b,c_shlc,1,(a<<1)|1)) return 1;
            // c_inc
            if(test_one(a,b,c_inc,0,a+1)) return 1;
            if(test_one(a,b,c_inc,1,a+1)) return 1;
            // c_adc
            if(test_one(a,b,c_adc,0,a+b)) return 1;
            if(test_one(a,b,c_adc,1,a+b+1)) return 1;
            // c_sbc
            if(test_one(a,b,c_sbc,0,a-b)) return 1;
            if(test_one(a,b,c_sbc,1,a-b-1)) return 1;
            // c_not
            if(test_one(a,b,c_not,0,~a)) return 1;
            if(test_one(a,b,c_not,1,~a)) return 1;
            // c_and
            if(test_one(a,b,c_and,0,a&b)) return 1;
            if(test_one(a,b,c_and,1,a&b)) return 1;
            // c_or
            if(test_one(a,b,c_or,0,a|b)) return 1;
            if(test_one(a,b,c_or,1,a|b)) return 1;
            // c_xor
            if(test_one(a,b,c_xor,0,a^b)) return 1;
            if(test_one(a,b,c_xor,1,a^b)) return 1;
            // c_zero
            if(test_one(a,b,c_zero,0,0)) return 1;
            if(test_one(a,b,c_zero,1,0)) return 1;
            // c_test
            if(test_one(a,b,c_test,0,(a&0xff)?1:0)) return 1;
            if(test_one(a,b,c_test,1,(a&0xff)?1:0)) return 1;
            // c_shr
            if(test_one(a,b,c_shr,0,(a&0xff)>>1)) return 1;
            if(test_one(a,b,c_shr,1,(a&0xff)>>1)) return 1;
            // c_shrc
            //if(test_one(a,b,c_shrc,0,(a&0xff)>>1)) return 1;
            //if(test_one(a,b,c_shrc,1,((a&0xff)>>1)|0x80)) return 1;

        }
    }
    return 0;
}


int main() {
    uint16_t i;

    for(i = 0; i<IMAGE_SIZE; i++) {
        chip_low[i]  = gen(i, 1, 0);
        chip_high[i] = gen(i, 0, 0);
    }

    if(test()) {
        printf("Test failed\n");
        return 1;
    }

    printf("All tests passed: %d\n", total_tests);
    printf("Writing binary images..\n");

    FILE * alu_low = fopen("alu_low.bin", "w");
    FILE * alu_high = fopen("alu_high.bin", "w");
    fwrite(chip_low, 1, IMAGE_SIZE, alu_low);
    fwrite(chip_high, 1, IMAGE_SIZE, alu_high);
    fclose(alu_low);
    fclose(alu_high);

    return 0;
}