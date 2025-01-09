// Created with Corsair vgit-latest
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

#define SPI_REGS_BASE_ADDR 0x0

// RESET - Software reset register
#define SPI_REGS_RESET_ADDR 0x0
#define SPI_REGS_RESET_RESET 0x0
typedef struct {
    uint32_t RESET : 1; // Reset the SPI core. Write 1 to reset.
    uint32_t : 31; // reserved
} spi_regs_reset_t;

// RESET.RESET - Reset the SPI core. Write 1 to reset.
#define SPI_REGS_RESET_RESET_WIDTH 1
#define SPI_REGS_RESET_RESET_LSB 0
#define SPI_REGS_RESET_RESET_MASK 0x1
#define SPI_REGS_RESET_RESET_RESET 0x0

// CONTROL - SPI Control register
#define SPI_REGS_CONTROL_ADDR 0x4
#define SPI_REGS_CONTROL_RESET 0x500
typedef struct {
    uint32_t : 3; // reserved
    uint32_t CPOL : 1; // Clock Polarity. Set to 0 for low when idle. Set to 1 for high when idle.
    uint32_t CPHA : 1; // Clock Phase. Set to 0 for first edge capture. Set to 1 for second edge capture.
    uint32_t : 3; // reserved
    uint32_t TRANS_INHIBIT : 1; // Inhibit data transfer. Set to 0 to start a data transfer.
    uint32_t LSB_FIRST : 1; // LSB First -> 0 = MSB first transfer format. 1 = LSB first transfer format.
    uint32_t XFER_COUNT : 4; // Number of 8bit transfers to perform. Set to 1 to transfer 1 byte.
    uint32_t AUTOMATIC_MODE : 1; // Automatic Mode. Set to 1 to enable automatic spi transfers.
    uint32_t : 17; // reserved
} spi_regs_control_t;

// CONTROL.CPOL - Clock Polarity. Set to 0 for low when idle. Set to 1 for high when idle.
#define SPI_REGS_CONTROL_CPOL_WIDTH 1
#define SPI_REGS_CONTROL_CPOL_LSB 3
#define SPI_REGS_CONTROL_CPOL_MASK 0x8
#define SPI_REGS_CONTROL_CPOL_RESET 0x0

// CONTROL.CPHA - Clock Phase. Set to 0 for first edge capture. Set to 1 for second edge capture.
#define SPI_REGS_CONTROL_CPHA_WIDTH 1
#define SPI_REGS_CONTROL_CPHA_LSB 4
#define SPI_REGS_CONTROL_CPHA_MASK 0x10
#define SPI_REGS_CONTROL_CPHA_RESET 0x0

// CONTROL.TRANS_INHIBIT - Inhibit data transfer. Set to 0 to start a data transfer.
#define SPI_REGS_CONTROL_TRANS_INHIBIT_WIDTH 1
#define SPI_REGS_CONTROL_TRANS_INHIBIT_LSB 8
#define SPI_REGS_CONTROL_TRANS_INHIBIT_MASK 0x100
#define SPI_REGS_CONTROL_TRANS_INHIBIT_RESET 0x1

// CONTROL.LSB_FIRST - LSB First -> 0 = MSB first transfer format. 1 = LSB first transfer format.
#define SPI_REGS_CONTROL_LSB_FIRST_WIDTH 1
#define SPI_REGS_CONTROL_LSB_FIRST_LSB 9
#define SPI_REGS_CONTROL_LSB_FIRST_MASK 0x200
#define SPI_REGS_CONTROL_LSB_FIRST_RESET 0x0

// CONTROL.XFER_COUNT - Number of 8bit transfers to perform. Set to 1 to transfer 1 byte.
#define SPI_REGS_CONTROL_XFER_COUNT_WIDTH 4
#define SPI_REGS_CONTROL_XFER_COUNT_LSB 10
#define SPI_REGS_CONTROL_XFER_COUNT_MASK 0x3c00
#define SPI_REGS_CONTROL_XFER_COUNT_RESET 0x1

// CONTROL.AUTOMATIC_MODE - Automatic Mode. Set to 1 to enable automatic spi transfers.
#define SPI_REGS_CONTROL_AUTOMATIC_MODE_WIDTH 1
#define SPI_REGS_CONTROL_AUTOMATIC_MODE_LSB 14
#define SPI_REGS_CONTROL_AUTOMATIC_MODE_MASK 0x4000
#define SPI_REGS_CONTROL_AUTOMATIC_MODE_RESET 0x0

// STATUS - SPI Status register
#define SPI_REGS_STATUS_ADDR 0x8
#define SPI_REGS_STATUS_RESET 0xa
typedef struct {
    uint32_t TX_FULL : 1; // Transmit FIFO Full
    uint32_t TX_EMPTY : 1; // Transmit FIFO Empty
    uint32_t RX_FULL : 1; // Receive FIFO Full
    uint32_t RX_EMPTY : 1; // Receive FIFO Empty
    uint32_t AXIS_XFER_ERROR : 1; // Write to clear. Set when the data from an spi transfer was not read by the AXI stream before the next transfer started.
    uint32_t : 27; // reserved
} spi_regs_status_t;

// STATUS.TX_FULL - Transmit FIFO Full
#define SPI_REGS_STATUS_TX_FULL_WIDTH 1
#define SPI_REGS_STATUS_TX_FULL_LSB 0
#define SPI_REGS_STATUS_TX_FULL_MASK 0x1
#define SPI_REGS_STATUS_TX_FULL_RESET 0x0

// STATUS.TX_EMPTY - Transmit FIFO Empty
#define SPI_REGS_STATUS_TX_EMPTY_WIDTH 1
#define SPI_REGS_STATUS_TX_EMPTY_LSB 1
#define SPI_REGS_STATUS_TX_EMPTY_MASK 0x2
#define SPI_REGS_STATUS_TX_EMPTY_RESET 0x1

// STATUS.RX_FULL - Receive FIFO Full
#define SPI_REGS_STATUS_RX_FULL_WIDTH 1
#define SPI_REGS_STATUS_RX_FULL_LSB 2
#define SPI_REGS_STATUS_RX_FULL_MASK 0x4
#define SPI_REGS_STATUS_RX_FULL_RESET 0x0

// STATUS.RX_EMPTY - Receive FIFO Empty
#define SPI_REGS_STATUS_RX_EMPTY_WIDTH 1
#define SPI_REGS_STATUS_RX_EMPTY_LSB 3
#define SPI_REGS_STATUS_RX_EMPTY_MASK 0x8
#define SPI_REGS_STATUS_RX_EMPTY_RESET 0x1

// STATUS.AXIS_XFER_ERROR - Write to clear. Set when the data from an spi transfer was not read by the AXI stream before the next transfer started.
#define SPI_REGS_STATUS_AXIS_XFER_ERROR_WIDTH 1
#define SPI_REGS_STATUS_AXIS_XFER_ERROR_LSB 4
#define SPI_REGS_STATUS_AXIS_XFER_ERROR_MASK 0x10
#define SPI_REGS_STATUS_AXIS_XFER_ERROR_RESET 0x0

// CLK_DIV - Clock Divider register
#define SPI_REGS_CLK_DIV_ADDR 0xc
#define SPI_REGS_CLK_DIV_RESET 0x0
typedef struct {
    uint32_t DIV : 16; // Clock Divider
    uint32_t : 16; // reserved
} spi_regs_clk_div_t;

// CLK_DIV.DIV - Clock Divider
#define SPI_REGS_CLK_DIV_DIV_WIDTH 16
#define SPI_REGS_CLK_DIV_DIV_LSB 0
#define SPI_REGS_CLK_DIV_DIV_MASK 0xffff
#define SPI_REGS_CLK_DIV_DIV_RESET 0x0

// TX_DATA - Data Transmit Register
#define SPI_REGS_TX_DATA_ADDR 0x10
#define SPI_REGS_TX_DATA_RESET 0x0
typedef struct {
    uint32_t DATA : 32; // Data to be transmitted
} spi_regs_tx_data_t;

// TX_DATA.DATA - Data to be transmitted
#define SPI_REGS_TX_DATA_DATA_WIDTH 32
#define SPI_REGS_TX_DATA_DATA_LSB 0
#define SPI_REGS_TX_DATA_DATA_MASK 0xffffffff
#define SPI_REGS_TX_DATA_DATA_RESET 0x0

// SLAVE_SELECT - Slave Select Register
#define SPI_REGS_SLAVE_SELECT_ADDR 0x14
#define SPI_REGS_SLAVE_SELECT_RESET 0x0
typedef struct {
    uint32_t SS : 32; // Slave Select. Write 0 on the bit index to select that slave.
} spi_regs_slave_select_t;

// SLAVE_SELECT.SS - Slave Select. Write 0 on the bit index to select that slave.
#define SPI_REGS_SLAVE_SELECT_SS_WIDTH 32
#define SPI_REGS_SLAVE_SELECT_SS_LSB 0
#define SPI_REGS_SLAVE_SELECT_SS_MASK 0xffffffff
#define SPI_REGS_SLAVE_SELECT_SS_RESET 0x0

// WAIT_CYCLES - Number of clock cycles to wait between transfers when using automatic mode.
#define SPI_REGS_WAIT_CYCLES_ADDR 0x18
#define SPI_REGS_WAIT_CYCLES_RESET 0x0
typedef struct {
    uint32_t CYCLES : 32; // Number of clock cycles to wait between transfers.
} spi_regs_wait_cycles_t;

// WAIT_CYCLES.CYCLES - Number of clock cycles to wait between transfers.
#define SPI_REGS_WAIT_CYCLES_CYCLES_WIDTH 32
#define SPI_REGS_WAIT_CYCLES_CYCLES_LSB 0
#define SPI_REGS_WAIT_CYCLES_CYCLES_MASK 0xffffffff
#define SPI_REGS_WAIT_CYCLES_CYCLES_RESET 0x0


// Register map structure
typedef struct {
    union {
        __IO uint32_t RESET; // Software reset register
        __IO spi_regs_reset_t RESET_bf; // Bit access for RESET register
    };
    union {
        __IO uint32_t CONTROL; // SPI Control register
        __IO spi_regs_control_t CONTROL_bf; // Bit access for CONTROL register
    };
    union {
        __IO uint32_t STATUS; // SPI Status register
        __IO spi_regs_status_t STATUS_bf; // Bit access for STATUS register
    };
    union {
        __IO uint32_t CLK_DIV; // Clock Divider register
        __IO spi_regs_clk_div_t CLK_DIV_bf; // Bit access for CLK_DIV register
    };
    union {
        __IO uint32_t TX_DATA; // Data Transmit Register
        __IO spi_regs_tx_data_t TX_DATA_bf; // Bit access for TX_DATA register
    };
    union {
        __IO uint32_t SLAVE_SELECT; // Slave Select Register
        __IO spi_regs_slave_select_t SLAVE_SELECT_bf; // Bit access for SLAVE_SELECT register
    };
    union {
        __IO uint32_t WAIT_CYCLES; // Number of clock cycles to wait between transfers when using automatic mode.
        __IO spi_regs_wait_cycles_t WAIT_CYCLES_bf; // Bit access for WAIT_CYCLES register
    };
} spi_regs_t;

#define SPI_REGS ((spi_regs_t*)(SPI_REGS_BASE_ADDR))

#ifdef __cplusplus
}
#endif

#endif /* __SPI_REGS_H */