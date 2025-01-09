# Register map

Created with [Corsair](https://github.com/esynr3z/corsair) vgit-latest.

## Conventions

| Access mode | Description               |
| :---------- | :------------------------ |
| rw          | Read and Write            |
| rw1c        | Read and Write 1 to Clear |
| rw1s        | Read and Write 1 to Set   |
| ro          | Read Only                 |
| roc         | Read Only to Clear        |
| roll        | Read Only / Latch Low     |
| rolh        | Read Only / Latch High    |
| wo          | Write only                |
| wosc        | Write Only / Self Clear   |

## Register map summary

Base address: 0x00000000

| Name                     | Address    | Description |
| :---                     | :---       | :---        |
| [RESET](#reset)          | 0x00       | Software reset register |
| [CONTROL](#control)      | 0x04       | SPI Control register |
| [STATUS](#status)        | 0x08       | SPI Status register |
| [CLK_DIV](#clk_div)      | 0x0c       | Clock Divider register |
| [TX_DATA](#tx_data)      | 0x10       | Data Transmit Register |
| [SLAVE_SELECT](#slave_select) | 0x14       | Slave Select Register |
| [WAIT_CYCLES](#wait_cycles) | 0x18       | Number of clock cycles to wait between transfers when using automatic mode. |

## RESET

Software reset register

Address offset: 0x00

Reset value: 0x00000000

![reset](doc_img/reset.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:1   | -               | 0x0000000  | Reserved |
| RESET            | 0      | rw              | 0x0        | Reset the SPI |

Back to [Register map](#register-map-summary).

## CONTROL

SPI Control register

Address offset: 0x04

Reset value: 0x00000500

![control](doc_img/control.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:15  | -               | 0x0000     | Reserved |
| AUTOMATIC_MODE   | 14     | rw              | 0x0        | Automatic Mode. Set to 1 to enable automatic spi transfers. |
| XFER_COUNT       | 13:10  | rw              | 0x1        | Number of 8bit transfers to perform. Set to 1 to transfer 1 byte. |
| LSB_FIRST        | 9      | rw              | 0x0        | LSB First -> 0 = MSB first transfer format. 1 = LSB first transfer format. |
| TRANS_INHIBIT    | 8      | rw              | 0x1        | Inhibit data transfer. Set to 0 to start a data transfer. |
| -                | 7:2    | -               | 0x0        | Reserved |
| CPHA             | 1      | rw              | 0x0        | Clock Phase |
| CPOL             | 0      | rw              | 0x0        | Clock Polarity |

Back to [Register map](#register-map-summary).

## STATUS

SPI Status register

Address offset: 0x08

Reset value: 0x0000000a

![status](doc_img/status.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:5   | -               | 0x000000   | Reserved |
| AXIS_XFER_ERROR  | 4      | rwlh            | 0x0        | Write to clear. Set when the data from an spi transfer was not read by the AXI stream before the next transfer started. |
| RX_EMPTY         | 3      | ro              | 0x1        | Receive FIFO Empty |
| RX_FULL          | 2      | ro              | 0x0        | Receive FIFO Full |
| TX_EMPTY         | 1      | ro              | 0x1        | Transmit FIFO Empty |
| TX_FULL          | 0      | ro              | 0x0        | Transmit FIFO Full |

Back to [Register map](#register-map-summary).

## CLK_DIV

Clock Divider register

Address offset: 0x0c

Reset value: 0x00000000

![clk_div](doc_img/clk_div.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:16  | -               | 0x0000     | Reserved |
| DIV              | 15:0   | rw              | 0x0000     | Clock Divider |

Back to [Register map](#register-map-summary).

## TX_DATA

Data Transmit Register

Address offset: 0x10

Reset value: 0x00000000

![tx_data](doc_img/tx_data.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| DATA             | 31:0   | rw              | 0x00000000 | Data to be transmitted |

Back to [Register map](#register-map-summary).

## SLAVE_SELECT

Slave Select Register

Address offset: 0x14

Reset value: 0x00000000

![slave_select](doc_img/slave_select.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| SS               | 31:0   | rw              | 0x00000000 | Slave Select. Write 0 on the bit index to select that slave. |

Back to [Register map](#register-map-summary).

## WAIT_CYCLES

Number of clock cycles to wait between transfers when using automatic mode.

Address offset: 0x18

Reset value: 0x00000000

![wait_cycles](doc_img/wait_cycles.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| CYCLES           | 31:0   | rw              | 0x00000000 | Number of clock cycles to wait between transfers. |

Back to [Register map](#register-map-summary).
