#!/usr/bin/env python3
# -*- coding: utf-8 -*-

""" Created with Corsair vgit-latest

Control/status register map.
"""


class _RegReset:
    def __init__(self, rmap):
        self._rmap = rmap

    @property
    def reset(self):
        """Reset the SPI"""
        rdata = self._rmap._if.read(self._rmap.RESET_ADDR)
        return (rdata >> self._rmap.RESET_RESET_POS) & self._rmap.RESET_RESET_MSK

    @reset.setter
    def reset(self, val):
        rdata = self._rmap._if.read(self._rmap.RESET_ADDR)
        rdata = rdata & (~(self._rmap.RESET_RESET_MSK << self._rmap.RESET_RESET_POS))
        rdata = rdata | (val << self._rmap.RESET_RESET_POS)
        self._rmap._if.write(self._rmap.RESET_ADDR, rdata)


class _RegControl:
    def __init__(self, rmap):
        self._rmap = rmap

    @property
    def cpol(self):
        """Clock Polarity"""
        rdata = self._rmap._if.read(self._rmap.CONTROL_ADDR)
        return (rdata >> self._rmap.CONTROL_CPOL_POS) & self._rmap.CONTROL_CPOL_MSK

    @cpol.setter
    def cpol(self, val):
        rdata = self._rmap._if.read(self._rmap.CONTROL_ADDR)
        rdata = rdata & (~(self._rmap.CONTROL_CPOL_MSK << self._rmap.CONTROL_CPOL_POS))
        rdata = rdata | (val << self._rmap.CONTROL_CPOL_POS)
        self._rmap._if.write(self._rmap.CONTROL_ADDR, rdata)

    @property
    def cpha(self):
        """Clock Phase"""
        rdata = self._rmap._if.read(self._rmap.CONTROL_ADDR)
        return (rdata >> self._rmap.CONTROL_CPHA_POS) & self._rmap.CONTROL_CPHA_MSK

    @cpha.setter
    def cpha(self, val):
        rdata = self._rmap._if.read(self._rmap.CONTROL_ADDR)
        rdata = rdata & (~(self._rmap.CONTROL_CPHA_MSK << self._rmap.CONTROL_CPHA_POS))
        rdata = rdata | (val << self._rmap.CONTROL_CPHA_POS)
        self._rmap._if.write(self._rmap.CONTROL_ADDR, rdata)

    @property
    def trans_inhibit(self):
        """Inhibit data transfer. Set to 0 to start a data transfer."""
        rdata = self._rmap._if.read(self._rmap.CONTROL_ADDR)
        return (rdata >> self._rmap.CONTROL_TRANS_INHIBIT_POS) & self._rmap.CONTROL_TRANS_INHIBIT_MSK

    @trans_inhibit.setter
    def trans_inhibit(self, val):
        rdata = self._rmap._if.read(self._rmap.CONTROL_ADDR)
        rdata = rdata & (~(self._rmap.CONTROL_TRANS_INHIBIT_MSK << self._rmap.CONTROL_TRANS_INHIBIT_POS))
        rdata = rdata | (val << self._rmap.CONTROL_TRANS_INHIBIT_POS)
        self._rmap._if.write(self._rmap.CONTROL_ADDR, rdata)

    @property
    def lsb_first(self):
        """LSB First -> 0 = MSB first transfer format. 1 = LSB first transfer format."""
        rdata = self._rmap._if.read(self._rmap.CONTROL_ADDR)
        return (rdata >> self._rmap.CONTROL_LSB_FIRST_POS) & self._rmap.CONTROL_LSB_FIRST_MSK

    @lsb_first.setter
    def lsb_first(self, val):
        rdata = self._rmap._if.read(self._rmap.CONTROL_ADDR)
        rdata = rdata & (~(self._rmap.CONTROL_LSB_FIRST_MSK << self._rmap.CONTROL_LSB_FIRST_POS))
        rdata = rdata | (val << self._rmap.CONTROL_LSB_FIRST_POS)
        self._rmap._if.write(self._rmap.CONTROL_ADDR, rdata)

    @property
    def xfer_count(self):
        """Number of 8bit transfers to perform. Set to 1 to transfer 1 byte."""
        rdata = self._rmap._if.read(self._rmap.CONTROL_ADDR)
        return (rdata >> self._rmap.CONTROL_XFER_COUNT_POS) & self._rmap.CONTROL_XFER_COUNT_MSK

    @xfer_count.setter
    def xfer_count(self, val):
        rdata = self._rmap._if.read(self._rmap.CONTROL_ADDR)
        rdata = rdata & (~(self._rmap.CONTROL_XFER_COUNT_MSK << self._rmap.CONTROL_XFER_COUNT_POS))
        rdata = rdata | (val << self._rmap.CONTROL_XFER_COUNT_POS)
        self._rmap._if.write(self._rmap.CONTROL_ADDR, rdata)

    @property
    def automatic_mode(self):
        """Automatic Mode. Set to 1 to enable automatic spi transfers."""
        rdata = self._rmap._if.read(self._rmap.CONTROL_ADDR)
        return (rdata >> self._rmap.CONTROL_AUTOMATIC_MODE_POS) & self._rmap.CONTROL_AUTOMATIC_MODE_MSK

    @automatic_mode.setter
    def automatic_mode(self, val):
        rdata = self._rmap._if.read(self._rmap.CONTROL_ADDR)
        rdata = rdata & (~(self._rmap.CONTROL_AUTOMATIC_MODE_MSK << self._rmap.CONTROL_AUTOMATIC_MODE_POS))
        rdata = rdata | (val << self._rmap.CONTROL_AUTOMATIC_MODE_POS)
        self._rmap._if.write(self._rmap.CONTROL_ADDR, rdata)


class _RegStatus:
    def __init__(self, rmap):
        self._rmap = rmap

    @property
    def tx_full(self):
        """Transmit FIFO Full"""
        rdata = self._rmap._if.read(self._rmap.STATUS_ADDR)
        return (rdata >> self._rmap.STATUS_TX_FULL_POS) & self._rmap.STATUS_TX_FULL_MSK

    @property
    def tx_empty(self):
        """Transmit FIFO Empty"""
        rdata = self._rmap._if.read(self._rmap.STATUS_ADDR)
        return (rdata >> self._rmap.STATUS_TX_EMPTY_POS) & self._rmap.STATUS_TX_EMPTY_MSK

    @property
    def rx_full(self):
        """Receive FIFO Full"""
        rdata = self._rmap._if.read(self._rmap.STATUS_ADDR)
        return (rdata >> self._rmap.STATUS_RX_FULL_POS) & self._rmap.STATUS_RX_FULL_MSK

    @property
    def rx_empty(self):
        """Receive FIFO Empty"""
        rdata = self._rmap._if.read(self._rmap.STATUS_ADDR)
        return (rdata >> self._rmap.STATUS_RX_EMPTY_POS) & self._rmap.STATUS_RX_EMPTY_MSK

    @property
    def axis_xfer_error(self):
        """Write to clear. Set when the data from an spi transfer was not read by the AXI stream before the next transfer started."""
        rdata = self._rmap._if.read(self._rmap.STATUS_ADDR)
        return (rdata >> self._rmap.STATUS_AXIS_XFER_ERROR_POS) & self._rmap.STATUS_AXIS_XFER_ERROR_MSK

    @axis_xfer_error.setter
    def axis_xfer_error(self, val):
        rdata = self._rmap._if.read(self._rmap.STATUS_ADDR)
        rdata = rdata & (~(self._rmap.STATUS_AXIS_XFER_ERROR_MSK << self._rmap.STATUS_AXIS_XFER_ERROR_POS))
        rdata = rdata | (val << self._rmap.STATUS_AXIS_XFER_ERROR_POS)
        self._rmap._if.write(self._rmap.STATUS_ADDR, rdata)


class _RegClk_div:
    def __init__(self, rmap):
        self._rmap = rmap

    @property
    def div(self):
        """Clock Divider"""
        rdata = self._rmap._if.read(self._rmap.CLK_DIV_ADDR)
        return (rdata >> self._rmap.CLK_DIV_DIV_POS) & self._rmap.CLK_DIV_DIV_MSK

    @div.setter
    def div(self, val):
        rdata = self._rmap._if.read(self._rmap.CLK_DIV_ADDR)
        rdata = rdata & (~(self._rmap.CLK_DIV_DIV_MSK << self._rmap.CLK_DIV_DIV_POS))
        rdata = rdata | (val << self._rmap.CLK_DIV_DIV_POS)
        self._rmap._if.write(self._rmap.CLK_DIV_ADDR, rdata)


class _RegTx_data:
    def __init__(self, rmap):
        self._rmap = rmap

    @property
    def data(self):
        """Data to be transmitted"""
        rdata = self._rmap._if.read(self._rmap.TX_DATA_ADDR)
        return (rdata >> self._rmap.TX_DATA_DATA_POS) & self._rmap.TX_DATA_DATA_MSK

    @data.setter
    def data(self, val):
        rdata = self._rmap._if.read(self._rmap.TX_DATA_ADDR)
        rdata = rdata & (~(self._rmap.TX_DATA_DATA_MSK << self._rmap.TX_DATA_DATA_POS))
        rdata = rdata | (val << self._rmap.TX_DATA_DATA_POS)
        self._rmap._if.write(self._rmap.TX_DATA_ADDR, rdata)


class _RegSlave_select:
    def __init__(self, rmap):
        self._rmap = rmap

    @property
    def ss(self):
        """Slave Select. Write 0 on the bit index to select that slave."""
        rdata = self._rmap._if.read(self._rmap.SLAVE_SELECT_ADDR)
        return (rdata >> self._rmap.SLAVE_SELECT_SS_POS) & self._rmap.SLAVE_SELECT_SS_MSK

    @ss.setter
    def ss(self, val):
        rdata = self._rmap._if.read(self._rmap.SLAVE_SELECT_ADDR)
        rdata = rdata & (~(self._rmap.SLAVE_SELECT_SS_MSK << self._rmap.SLAVE_SELECT_SS_POS))
        rdata = rdata | (val << self._rmap.SLAVE_SELECT_SS_POS)
        self._rmap._if.write(self._rmap.SLAVE_SELECT_ADDR, rdata)


class _RegWait_cycles:
    def __init__(self, rmap):
        self._rmap = rmap

    @property
    def cycles(self):
        """Number of clock cycles to wait between transfers."""
        rdata = self._rmap._if.read(self._rmap.WAIT_CYCLES_ADDR)
        return (rdata >> self._rmap.WAIT_CYCLES_CYCLES_POS) & self._rmap.WAIT_CYCLES_CYCLES_MSK

    @cycles.setter
    def cycles(self, val):
        rdata = self._rmap._if.read(self._rmap.WAIT_CYCLES_ADDR)
        rdata = rdata & (~(self._rmap.WAIT_CYCLES_CYCLES_MSK << self._rmap.WAIT_CYCLES_CYCLES_POS))
        rdata = rdata | (val << self._rmap.WAIT_CYCLES_CYCLES_POS)
        self._rmap._if.write(self._rmap.WAIT_CYCLES_ADDR, rdata)


class RegMap:
    """Control/Status register map"""

    # RESET - Software reset register
    RESET_ADDR = 0x00
    RESET_RESET_POS = 0
    RESET_RESET_MSK = 0x1

    # CONTROL - SPI Control register
    CONTROL_ADDR = 0x04
    CONTROL_CPOL_POS = 0
    CONTROL_CPOL_MSK = 0x1
    CONTROL_CPHA_POS = 1
    CONTROL_CPHA_MSK = 0x1
    CONTROL_TRANS_INHIBIT_POS = 8
    CONTROL_TRANS_INHIBIT_MSK = 0x1
    CONTROL_LSB_FIRST_POS = 9
    CONTROL_LSB_FIRST_MSK = 0x1
    CONTROL_XFER_COUNT_POS = 10
    CONTROL_XFER_COUNT_MSK = 0xf
    CONTROL_AUTOMATIC_MODE_POS = 14
    CONTROL_AUTOMATIC_MODE_MSK = 0x1

    # STATUS - SPI Status register
    STATUS_ADDR = 0x08
    STATUS_TX_FULL_POS = 0
    STATUS_TX_FULL_MSK = 0x1
    STATUS_TX_EMPTY_POS = 1
    STATUS_TX_EMPTY_MSK = 0x1
    STATUS_RX_FULL_POS = 2
    STATUS_RX_FULL_MSK = 0x1
    STATUS_RX_EMPTY_POS = 3
    STATUS_RX_EMPTY_MSK = 0x1
    STATUS_AXIS_XFER_ERROR_POS = 4
    STATUS_AXIS_XFER_ERROR_MSK = 0x1

    # CLK_DIV - Clock Divider register
    CLK_DIV_ADDR = 0x0c
    CLK_DIV_DIV_POS = 0
    CLK_DIV_DIV_MSK = 0xffff

    # TX_DATA - Data Transmit Register
    TX_DATA_ADDR = 0x10
    TX_DATA_DATA_POS = 0
    TX_DATA_DATA_MSK = 0xffffffff

    # SLAVE_SELECT - Slave Select Register
    SLAVE_SELECT_ADDR = 0x14
    SLAVE_SELECT_SS_POS = 0
    SLAVE_SELECT_SS_MSK = 0xffffffff

    # WAIT_CYCLES - Number of clock cycles to wait between transfers when using automatic mode.
    WAIT_CYCLES_ADDR = 0x18
    WAIT_CYCLES_CYCLES_POS = 0
    WAIT_CYCLES_CYCLES_MSK = 0xffffffff

    def __init__(self, interface):
        self._if = interface

    @property
    def reset(self):
        """Software reset register"""
        return self._if.read(self.RESET_ADDR)

    @reset.setter
    def reset(self, val):
        self._if.write(self.RESET_ADDR, val)

    @property
    def reset_bf(self):
        return _RegReset(self)

    @property
    def control(self):
        """SPI Control register"""
        return self._if.read(self.CONTROL_ADDR)

    @control.setter
    def control(self, val):
        self._if.write(self.CONTROL_ADDR, val)

    @property
    def control_bf(self):
        return _RegControl(self)

    @property
    def status(self):
        """SPI Status register"""
        return self._if.read(self.STATUS_ADDR)

    @status.setter
    def status(self, val):
        self._if.write(self.STATUS_ADDR, val)

    @property
    def status_bf(self):
        return _RegStatus(self)

    @property
    def clk_div(self):
        """Clock Divider register"""
        return self._if.read(self.CLK_DIV_ADDR)

    @clk_div.setter
    def clk_div(self, val):
        self._if.write(self.CLK_DIV_ADDR, val)

    @property
    def clk_div_bf(self):
        return _RegClk_div(self)

    @property
    def tx_data(self):
        """Data Transmit Register"""
        return self._if.read(self.TX_DATA_ADDR)

    @tx_data.setter
    def tx_data(self, val):
        self._if.write(self.TX_DATA_ADDR, val)

    @property
    def tx_data_bf(self):
        return _RegTx_data(self)

    @property
    def slave_select(self):
        """Slave Select Register"""
        return self._if.read(self.SLAVE_SELECT_ADDR)

    @slave_select.setter
    def slave_select(self, val):
        self._if.write(self.SLAVE_SELECT_ADDR, val)

    @property
    def slave_select_bf(self):
        return _RegSlave_select(self)

    @property
    def wait_cycles(self):
        """Number of clock cycles to wait between transfers when using automatic mode."""
        return self._if.read(self.WAIT_CYCLES_ADDR)

    @wait_cycles.setter
    def wait_cycles(self, val):
        self._if.write(self.WAIT_CYCLES_ADDR, val)

    @property
    def wait_cycles_bf(self):
        return _RegWait_cycles(self)
