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

// CONFIG - SPI Configuration register
#define CSR_CONFIG_ADDR 0x4
#define CSR_CONFIG_RESET 0x0
typedef struct {
    uint32_t CPOL : 1; // Clock Polarity
    uint32_t CPHA : 1; // Clock Phase
    uint32_t : 30; // reserved
} csr_config_t;

// CONFIG.CPOL - Clock Polarity
#define CSR_CONFIG_CPOL_WIDTH 1
#define CSR_CONFIG_CPOL_LSB 0
#define CSR_CONFIG_CPOL_MASK 0x1
#define CSR_CONFIG_CPOL_RESET 0x0

// CONFIG.CPHA - Clock Phase
#define CSR_CONFIG_CPHA_WIDTH 1
#define CSR_CONFIG_CPHA_LSB 1
#define CSR_CONFIG_CPHA_MASK 0x2
#define CSR_CONFIG_CPHA_RESET 0x0

// CLK_DIV - Clock Divider register
#define CSR_CLK_DIV_ADDR 0x8
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
#define CSR_TX_DATA_ADDR 0xc
#define CSR_TX_DATA_RESET 0x0
typedef struct {
    uint32_t DATA : 32; // Data to be transmitted
} csr_tx_data_t;

// TX_DATA.DATA - Data to be transmitted
#define CSR_TX_DATA_DATA_WIDTH 32
#define CSR_TX_DATA_DATA_LSB 0
#define CSR_TX_DATA_DATA_MASK 0xffffffff
#define CSR_TX_DATA_DATA_RESET 0x0

// RX_DATA - Data Receive Register
#define CSR_RX_DATA_ADDR 0x10
#define CSR_RX_DATA_RESET 0x0
typedef struct {
    uint32_t DATA : 32; // Data received
} csr_rx_data_t;

// RX_DATA.DATA - Data received
#define CSR_RX_DATA_DATA_WIDTH 32
#define CSR_RX_DATA_DATA_LSB 0
#define CSR_RX_DATA_DATA_MASK 0xffffffff
#define CSR_RX_DATA_DATA_RESET 0x0


// Register map structure
typedef struct {
    union {
        __IO uint32_t RESET; // Software reset register
        __IO csr_reset_t RESET_bf; // Bit access for RESET register
    };
    union {
        __IO uint32_t CONFIG; // SPI Configuration register
        __IO csr_config_t CONFIG_bf; // Bit access for CONFIG register
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
        __I uint32_t RX_DATA; // Data Receive Register
        __I csr_rx_data_t RX_DATA_bf; // Bit access for RX_DATA register
    };
} csr_t;

#define CSR ((csr_t*)(CSR_BASE_ADDR))

#ifdef __cplusplus
}
#endif

#endif /* __SPI_REGS_H */