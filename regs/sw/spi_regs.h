// Created with Corsair v1.0.4.dev0+14dc5d40
#ifndef __SPI_REGS_H
#define __SPI_REGS_H

#define __I  volatile const // 'read only' permissions
#define __O  volatile       // 'write only' permissions
#define __IO volatile       // 'read / write' permissions


#ifdef __cplusplus
#include <cstdint>
extern "C" {
#else
#include <stdint.h>
#endif

#define CSR_BASE_ADDR 0x0

// RESET - Software reset register
#define CSR_RESET_ADDR 0x0
#define CSR_RESET_RESET 0x0
typedef struct {
    uint32_t RESET : 1; // Reset the SPI
    uint32_t : 31; // reserved
} csr_reset_t;

// RESET.RESET - Reset the SPI
#define CSR_RESET_RESET_WIDTH 1
#define CSR_RESET_RESET_LSB 0
#define CSR_RESET_RESET_MASK 0x1
#define CSR_RESET_RESET_RESET 0x0

// CONTROL - SPI Control register
#define CSR_CONTROL_ADDR 0x4
#define CSR_CONTROL_RESET 0x500
typedef struct {
    uint32_t CPOL : 1; // Clock Polarity
    uint32_t CPHA : 1; // Clock Phase
    uint32_t : 6; // reserved
    uint32_t TRANS_INHIBIT : 1; // Inhibit data transfer
    uint32_t LSB_FIRST : 1; // LSB First -> 0 = MSB first transfer format. 1 = LSB first transfer format.
    uint32_t XFER_COUNT : 4; // Transfer Count
    uint32_t AUTOMATIC_MODE : 1; // Automatic Mode
    uint32_t : 17; // reserved
} csr_control_t;

// CONTROL.CPOL - Clock Polarity
#define CSR_CONTROL_CPOL_WIDTH 1
#define CSR_CONTROL_CPOL_LSB 0
#define CSR_CONTROL_CPOL_MASK 0x1
#define CSR_CONTROL_CPOL_RESET 0x0

// CONTROL.CPHA - Clock Phase
#define CSR_CONTROL_CPHA_WIDTH 1
#define CSR_CONTROL_CPHA_LSB 1
#define CSR_CONTROL_CPHA_MASK 0x2
#define CSR_CONTROL_CPHA_RESET 0x0

// CONTROL.TRANS_INHIBIT - Inhibit data transfer
#define CSR_CONTROL_TRANS_INHIBIT_WIDTH 1
#define CSR_CONTROL_TRANS_INHIBIT_LSB 8
#define CSR_CONTROL_TRANS_INHIBIT_MASK 0x100
#define CSR_CONTROL_TRANS_INHIBIT_RESET 0x1

// CONTROL.LSB_FIRST - LSB First -> 0 = MSB first transfer format. 1 = LSB first transfer format.
#define CSR_CONTROL_LSB_FIRST_WIDTH 1
#define CSR_CONTROL_LSB_FIRST_LSB 9
#define CSR_CONTROL_LSB_FIRST_MASK 0x200
#define CSR_CONTROL_LSB_FIRST_RESET 0x0

// CONTROL.XFER_COUNT - Transfer Count
#define CSR_CONTROL_XFER_COUNT_WIDTH 4
#define CSR_CONTROL_XFER_COUNT_LSB 10
#define CSR_CONTROL_XFER_COUNT_MASK 0x3c00
#define CSR_CONTROL_XFER_COUNT_RESET 0x1

// CONTROL.AUTOMATIC_MODE - Automatic Mode
#define CSR_CONTROL_AUTOMATIC_MODE_WIDTH 1
#define CSR_CONTROL_AUTOMATIC_MODE_LSB 14
#define CSR_CONTROL_AUTOMATIC_MODE_MASK 0x4000
#define CSR_CONTROL_AUTOMATIC_MODE_RESET 0x0

// STATUS - SPI Status register
#define CSR_STATUS_ADDR 0x8
#define CSR_STATUS_RESET 0xa
typedef struct {
    uint32_t TX_FULL : 1; // Transmit FIFO Full
    uint32_t TX_EMPTY : 1; // Transmit FIFO Empty
    uint32_t RX_FULL : 1; // Receive FIFO Full
    uint32_t RX_EMPTY : 1; // Receive FIFO Empty
    uint32_t : 28; // reserved
} csr_status_t;

// STATUS.TX_FULL - Transmit FIFO Full
#define CSR_STATUS_TX_FULL_WIDTH 1
#define CSR_STATUS_TX_FULL_LSB 0
#define CSR_STATUS_TX_FULL_MASK 0x1
#define CSR_STATUS_TX_FULL_RESET 0x0

// STATUS.TX_EMPTY - Transmit FIFO Empty
#define CSR_STATUS_TX_EMPTY_WIDTH 1
#define CSR_STATUS_TX_EMPTY_LSB 1
#define CSR_STATUS_TX_EMPTY_MASK 0x2
#define CSR_STATUS_TX_EMPTY_RESET 0x1

// STATUS.RX_FULL - Receive FIFO Full
#define CSR_STATUS_RX_FULL_WIDTH 1
#define CSR_STATUS_RX_FULL_LSB 2
#define CSR_STATUS_RX_FULL_MASK 0x4
#define CSR_STATUS_RX_FULL_RESET 0x0

// STATUS.RX_EMPTY - Receive FIFO Empty
#define CSR_STATUS_RX_EMPTY_WIDTH 1
#define CSR_STATUS_RX_EMPTY_LSB 3
#define CSR_STATUS_RX_EMPTY_MASK 0x8
#define CSR_STATUS_RX_EMPTY_RESET 0x1

// CLK_DIV - Clock Divider register
#define CSR_CLK_DIV_ADDR 0xc
#define CSR_CLK_DIV_RESET 0x0
typedef struct {
    uint32_t DIV : 16; // Clock Divider
    uint32_t : 16; // reserved
} csr_clk_div_t;

// CLK_DIV.DIV - Clock Divider
#define CSR_CLK_DIV_DIV_WIDTH 16
#define CSR_CLK_DIV_DIV_LSB 0
#define CSR_CLK_DIV_DIV_MASK 0xffff
#define CSR_CLK_DIV_DIV_RESET 0x0

// TX_DATA - Data Transmit Register
#define CSR_TX_DATA_ADDR 0x10
#define CSR_TX_DATA_RESET 0x0
typedef struct {
    uint32_t DATA : 32; // Data to be transmitted
} csr_tx_data_t;

// TX_DATA.DATA - Data to be transmitted
#define CSR_TX_DATA_DATA_WIDTH 32
#define CSR_TX_DATA_DATA_LSB 0
#define CSR_TX_DATA_DATA_MASK 0xffffffff
#define CSR_TX_DATA_DATA_RESET 0x0

// SLAVE_SELECT - Slave Select Register
#define CSR_SLAVE_SELECT_ADDR 0x14
#define CSR_SLAVE_SELECT_RESET 0x0
typedef struct {
    uint32_t SS : 32; // Slave Select
} csr_slave_select_t;

// SLAVE_SELECT.SS - Slave Select
#define CSR_SLAVE_SELECT_SS_WIDTH 32
#define CSR_SLAVE_SELECT_SS_LSB 0
#define CSR_SLAVE_SELECT_SS_MASK 0xffffffff
#define CSR_SLAVE_SELECT_SS_RESET 0x0

// WAIT_CYCLES - Wait Cycles Register
#define CSR_WAIT_CYCLES_ADDR 0x18
#define CSR_WAIT_CYCLES_RESET 0x0
typedef struct {
    uint32_t CYCLES : 32; // Number of cycles to wait
} csr_wait_cycles_t;

// WAIT_CYCLES.CYCLES - Number of cycles to wait
#define CSR_WAIT_CYCLES_CYCLES_WIDTH 32
#define CSR_WAIT_CYCLES_CYCLES_LSB 0
#define CSR_WAIT_CYCLES_CYCLES_MASK 0xffffffff
#define CSR_WAIT_CYCLES_CYCLES_RESET 0x0


// Register map structure
typedef struct {
    union {
        __IO uint32_t RESET; // Software reset register
        __IO csr_reset_t RESET_bf; // Bit access for RESET register
    };
    union {
        __IO uint32_t CONTROL; // SPI Control register
        __IO csr_control_t CONTROL_bf; // Bit access for CONTROL register
    };
    union {
        __I uint32_t STATUS; // SPI Status register
        __I csr_status_t STATUS_bf; // Bit access for STATUS register
    };
    union {
        __IO uint32_t CLK_DIV; // Clock Divider register
        __IO csr_clk_div_t CLK_DIV_bf; // Bit access for CLK_DIV register
    };
    union {
        __IO uint32_t TX_DATA; // Data Transmit Register
        __IO csr_tx_data_t TX_DATA_bf; // Bit access for TX_DATA register
    };
    union {
        __IO uint32_t SLAVE_SELECT; // Slave Select Register
        __IO csr_slave_select_t SLAVE_SELECT_bf; // Bit access for SLAVE_SELECT register
    };
    union {
        __IO uint32_t WAIT_CYCLES; // Wait Cycles Register
        __IO csr_wait_cycles_t WAIT_CYCLES_bf; // Bit access for WAIT_CYCLES register
    };
} csr_t;

#define CSR ((csr_t*)(CSR_BASE_ADDR))

#ifdef __cplusplus
}
#endif

#endif /* __SPI_REGS_H */