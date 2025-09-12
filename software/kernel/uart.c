#include "uart.h"
#include "interrupts.h"

unsigned char uart_buffer[256];
unsigned char uart_buffer_size;
unsigned char uart_buffer_rd_pos;
unsigned char uart_buffer_wr_pos;

void init_uart() {
    puts(" + init uart... ");
    uart_buffer_size = 0;
    uart_buffer_rd_pos = 0;
    uart_buffer_wr_pos = 0;
    puts("ok\n");
}

void __interrupt uart_isr() {
    ISR_PROLOG
    if(uart_buffer_size < 0xffU) {
        uart_buffer[uart_buffer_wr_pos] = *(unsigned char *)(0x4803);
        uart_buffer_wr_pos++;
        uart_buffer_size++;
    } else {
        char dummy = *(unsigned char *)(0x4803);
    }
    ISR_EPILOG
}

