


-- Created with Corsair v1.0.4.dev0+14dc5d40
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity spi_regs is
generic(
    ADDR_W : integer := 10;
    DATA_W : integer := 32;
    STRB_W : integer := 4
);
port(
    clk    : in std_logic;
    rst    : in std_logic;
    -- RESET.RESET
    csr_reset_reset_out : out std_logic;

    -- CONTROL.CPOL
    csr_control_cpol_out : out std_logic;
    -- CONTROL.CPHA
    csr_control_cpha_out : out std_logic;
    -- CONTROL.TRANS_INHIBIT
    csr_control_trans_inhibit_out : out std_logic;
    -- CONTROL.LSB_FIRST
    csr_control_lsb_first_out : out std_logic;
    -- CONTROL.XFER_COUNT
    csr_control_xfer_count_out : out std_logic_vector(3 downto 0);
    -- CONTROL.AUTOMATIC_MODE
    csr_control_automatic_mode_out : out std_logic;

    -- STATUS.TX_FULL
    csr_status_tx_full_in : in std_logic;
    -- STATUS.TX_EMPTY
    csr_status_tx_empty_in : in std_logic;
    -- STATUS.RX_FULL
    csr_status_rx_full_in : in std_logic;
    -- STATUS.RX_EMPTY
    csr_status_rx_empty_in : in std_logic;
    -- STATUS.AXIS_XFER_ERROR
    csr_status_axis_xfer_error_in : in std_logic;

    -- CLK_DIV.DIV
    csr_clk_div_div_out : out std_logic_vector(15 downto 0);

    -- TX_DATA.DATA
    csr_tx_data_data_out : out std_logic_vector(31 downto 0);

    -- SLAVE_SELECT.SS
    csr_slave_select_ss_out : out std_logic_vector(31 downto 0);

    -- WAIT_CYCLES.CYCLES
    csr_wait_cycles_cycles_out : out std_logic_vector(31 downto 0);

    -- AXI-Lite
    axil_awaddr   : in  std_logic_vector(ADDR_W-1 downto 0);
    axil_awprot   : in  std_logic_vector(2 downto 0);
    axil_awvalid  : in  std_logic;
    axil_awready  : out std_logic;
    axil_wdata    : in  std_logic_vector(DATA_W-1 downto 0);
    axil_wstrb    : in  std_logic_vector(STRB_W-1 downto 0);
    axil_wvalid   : in  std_logic;
    axil_wready   : out std_logic;
    axil_bresp    : out std_logic_vector(1 downto 0);
    axil_bvalid   : out std_logic;
    axil_bready   : in  std_logic;
    axil_araddr   : in  std_logic_vector(ADDR_W-1 downto 0);
    axil_arprot   : in  std_logic_vector(2 downto 0);
    axil_arvalid  : in  std_logic;
    axil_arready  : out std_logic;
    axil_rdata    : out std_logic_vector(DATA_W-1 downto 0);
    axil_rresp    : out std_logic_vector(1 downto 0);
    axil_rvalid   : out std_logic;
    axil_rready   : in  std_logic

);
end entity;

architecture rtl of spi_regs is

signal wready : std_logic;
signal waddr  : std_logic_vector(ADDR_W-1 downto 0);
signal wdata  : std_logic_vector(DATA_W-1 downto 0);
signal wen    : std_logic;
signal wstrb  : std_logic_vector(STRB_W-1 downto 0);
signal rdata  : std_logic_vector(DATA_W-1 downto 0);
signal rvalid : std_logic;
signal raddr  : std_logic_vector(ADDR_W-1 downto 0);
signal ren    : std_logic;
signal waddr_int       : std_logic_vector(ADDR_W-1 downto 0);
signal raddr_int       : std_logic_vector(ADDR_W-1 downto 0);
signal wdata_int       : std_logic_vector(DATA_W-1 downto 0);
signal strb_int        : std_logic_vector(STRB_W-1 downto 0);
signal awflag          : std_logic;
signal wflag           : std_logic;
signal arflag          : std_logic;
signal rflag           : std_logic;
signal wen_int         : std_logic;
signal ren_int         : std_logic;
signal axil_bvalid_int : std_logic;
signal axil_rdata_int  : std_logic_vector(DATA_W-1 downto 0);
signal axil_rvalid_int : std_logic;

signal csr_reset_rdata : std_logic_vector(31 downto 0);
signal csr_reset_wen : std_logic;
signal csr_reset_ren : std_logic;
signal csr_reset_ren_ff : std_logic;
signal csr_reset_reset_ff : std_logic;

signal csr_control_rdata : std_logic_vector(31 downto 0);
signal csr_control_wen : std_logic;
signal csr_control_ren : std_logic;
signal csr_control_ren_ff : std_logic;
signal csr_control_cpol_ff : std_logic;
signal csr_control_cpha_ff : std_logic;
signal csr_control_trans_inhibit_ff : std_logic;
signal csr_control_lsb_first_ff : std_logic;
signal csr_control_xfer_count_ff : std_logic_vector(3 downto 0);
signal csr_control_automatic_mode_ff : std_logic;

signal csr_status_rdata : std_logic_vector(31 downto 0);
signal csr_status_wen : std_logic;
signal csr_status_ren : std_logic;
signal csr_status_ren_ff : std_logic;
signal csr_status_tx_full_ff : std_logic;
signal csr_status_tx_empty_ff : std_logic;
signal csr_status_rx_full_ff : std_logic;
signal csr_status_rx_empty_ff : std_logic;
signal csr_status_axis_xfer_error_ff : std_logic;

signal csr_clk_div_rdata : std_logic_vector(31 downto 0);
signal csr_clk_div_wen : std_logic;
signal csr_clk_div_ren : std_logic;
signal csr_clk_div_ren_ff : std_logic;
signal csr_clk_div_div_ff : std_logic_vector(15 downto 0);

signal csr_tx_data_rdata : std_logic_vector(31 downto 0);
signal csr_tx_data_wen : std_logic;
signal csr_tx_data_ren : std_logic;
signal csr_tx_data_ren_ff : std_logic;
signal csr_tx_data_data_ff : std_logic_vector(31 downto 0);

signal csr_slave_select_rdata : std_logic_vector(31 downto 0);
signal csr_slave_select_wen : std_logic;
signal csr_slave_select_ren : std_logic;
signal csr_slave_select_ren_ff : std_logic;
signal csr_slave_select_ss_ff : std_logic_vector(31 downto 0);

signal csr_wait_cycles_rdata : std_logic_vector(31 downto 0);
signal csr_wait_cycles_wen : std_logic;
signal csr_wait_cycles_ren : std_logic;
signal csr_wait_cycles_ren_ff : std_logic;
signal csr_wait_cycles_cycles_ff : std_logic_vector(31 downto 0);

signal rdata_ff : std_logic_vector(31 downto 0);
signal rvalid_ff : std_logic;
begin

axil_awready <= not awflag;
axil_wready  <= not wflag;
axil_bvalid  <= axil_bvalid_int;
waddr        <= waddr_int;
wdata        <= wdata_int;
wstrb        <= strb_int;
wen_int      <= awflag and wflag;
wen          <= wen_int;
axil_bresp   <= b"00";

process (clk) begin
if rising_edge(clk) then
if (rst = '0') then
    waddr_int <= (others => '0');
    wdata_int <= (others => '0');
    strb_int <= (others => '0');
    awflag <= '0';
    wflag <= '0';
    axil_bvalid_int <= '0';
else
    if (axil_awvalid = '1' and awflag = '0') then
        awflag    <= '1';
        waddr_int <= axil_awaddr;
    elsif (wen_int = '1' and wready = '1') then
        awflag    <= '0';
    end if;
    if (axil_wvalid = '1' and wflag = '0') then
        wflag     <= '1';
        wdata_int <= axil_wdata;
        strb_int  <= axil_wstrb;
    elsif (wen_int = '1' and wready = '1') then
        wflag     <= '0';
    end if;
    if (axil_bvalid_int = '1' and axil_bready = '1') then
        axil_bvalid_int <= '0';
    elsif ((axil_wvalid = '1' and awflag = '1') or (axil_awvalid = '1' and wflag = '1') or (wflag = '1' and awflag = '1')) then
        axil_bvalid_int <= wready;
    end if;
end if;
end if;
end process;


axil_arready <= not arflag;
axil_rdata   <= axil_rdata_int;
axil_rvalid  <= axil_rvalid_int;
raddr        <= raddr_int;
ren_int      <= arflag and (not rflag);
ren          <= ren_int;
axil_rresp   <= b"00";

process (clk) begin
if rising_edge(clk) then
if (rst = '0') then
    raddr_int <= (others => '0');
    arflag <= '0';
    rflag <= '0';
    axil_rdata_int <= (others => '0');
    axil_rvalid_int <= '0';
else
    if (axil_arvalid = '1' and arflag = '0') then
        arflag    <= '1';
        raddr_int <= axil_araddr;
    elsif (axil_rvalid_int = '1' and axil_rready = '1') then
        arflag    <= '0';
    end if;
    if (rvalid = '1' and ren_int = '1' and rflag = '0') then
        rflag <= '1';
    elsif (axil_rvalid_int = '1' and axil_rready = '1') then
        rflag <= '0';
    end if;
    if (rvalid = '1' and axil_rvalid_int = '0') then
        axil_rdata_int  <= rdata;
        axil_rvalid_int <= '1';
    elsif (axil_rvalid_int = '1' and axil_rready = '1') then
        axil_rvalid_int <= '0';
    end if;
end if;
end if;
end process;


--------------------------------------------------------------------------------
-- CSR:
-- [0x0] - RESET - Software reset register
--------------------------------------------------------------------------------
csr_reset_rdata(31 downto 1) <= (others => '0');

csr_reset_wen <= wen when (waddr = std_logic_vector(to_unsigned(0, ADDR_W))) else '0'; -- 0x0

csr_reset_ren <= ren when (raddr = std_logic_vector(to_unsigned(0, ADDR_W))) else '0'; -- 0x0
process (clk) begin
if rising_edge(clk) then
if (rst = '0') then
    csr_reset_ren_ff <= '0'; -- 0x0
else
        csr_reset_ren_ff <= csr_reset_ren;
end if;
end if;
end process;

-----------------------
-- Bit field:
-- RESET(0) - RESET - Reset the SPI
-- access: rw1s, hardware: o
-----------------------

csr_reset_rdata(0) <= csr_reset_reset_ff;

csr_reset_reset_out <= csr_reset_reset_ff;

process (clk) begin
if rising_edge(clk) then
if (rst = '0') then
    csr_reset_reset_ff <= '0'; -- 0x0
else
        if (csr_reset_wen = '1') then
            if ((wstrb(0) = '1') and (wdata(0) = '1')) then
                csr_reset_reset_ff <= '1';
            end if;
        else
            csr_reset_reset_ff <= csr_reset_reset_ff;
        end if;
end if;
end if;
end process;



--------------------------------------------------------------------------------
-- CSR:
-- [0x4] - CONTROL - SPI Control register
--------------------------------------------------------------------------------
csr_control_rdata(7 downto 2) <= (others => '0');
csr_control_rdata(31 downto 15) <= (others => '0');

csr_control_wen <= wen when (waddr = std_logic_vector(to_unsigned(4, ADDR_W))) else '0'; -- 0x4

csr_control_ren <= ren when (raddr = std_logic_vector(to_unsigned(4, ADDR_W))) else '0'; -- 0x4
process (clk) begin
if rising_edge(clk) then
if (rst = '0') then
    csr_control_ren_ff <= '0'; -- 0x0
else
        csr_control_ren_ff <= csr_control_ren;
end if;
end if;
end process;

-----------------------
-- Bit field:
-- CONTROL(0) - CPOL - Clock Polarity
-- access: rw, hardware: o
-----------------------

csr_control_rdata(0) <= csr_control_cpol_ff;

csr_control_cpol_out <= csr_control_cpol_ff;

process (clk) begin
if rising_edge(clk) then
if (rst = '0') then
    csr_control_cpol_ff <= '0'; -- 0x0
else
        if (csr_control_wen = '1') then
            if (wstrb(0) = '1') then
                csr_control_cpol_ff <= wdata(0);
            end if;
        else
            csr_control_cpol_ff <= csr_control_cpol_ff;
        end if;
end if;
end if;
end process;



-----------------------
-- Bit field:
-- CONTROL(1) - CPHA - Clock Phase
-- access: rw, hardware: o
-----------------------

csr_control_rdata(1) <= csr_control_cpha_ff;

csr_control_cpha_out <= csr_control_cpha_ff;

process (clk) begin
if rising_edge(clk) then
if (rst = '0') then
    csr_control_cpha_ff <= '0'; -- 0x0
else
        if (csr_control_wen = '1') then
            if (wstrb(0) = '1') then
                csr_control_cpha_ff <= wdata(1);
            end if;
        else
            csr_control_cpha_ff <= csr_control_cpha_ff;
        end if;
end if;
end if;
end process;



-----------------------
-- Bit field:
-- CONTROL(8) - TRANS_INHIBIT - Inhibit data transfer
-- access: rw, hardware: o
-----------------------

csr_control_rdata(8) <= csr_control_trans_inhibit_ff;

csr_control_trans_inhibit_out <= csr_control_trans_inhibit_ff;

process (clk) begin
if rising_edge(clk) then
if (rst = '0') then
    csr_control_trans_inhibit_ff <= '1'; -- 0x1
else
        if (csr_control_wen = '1') then
            if (wstrb(1) = '1') then
                csr_control_trans_inhibit_ff <= wdata(8);
            end if;
        else
            csr_control_trans_inhibit_ff <= csr_control_trans_inhibit_ff;
        end if;
end if;
end if;
end process;



-----------------------
-- Bit field:
-- CONTROL(9) - LSB_FIRST - LSB First -> 0 = MSB first transfer format. 1 = LSB first transfer format.
-- access: rw, hardware: o
-----------------------

csr_control_rdata(9) <= csr_control_lsb_first_ff;

csr_control_lsb_first_out <= csr_control_lsb_first_ff;

process (clk) begin
if rising_edge(clk) then
if (rst = '0') then
    csr_control_lsb_first_ff <= '0'; -- 0x0
else
        if (csr_control_wen = '1') then
            if (wstrb(1) = '1') then
                csr_control_lsb_first_ff <= wdata(9);
            end if;
        else
            csr_control_lsb_first_ff <= csr_control_lsb_first_ff;
        end if;
end if;
end if;
end process;



-----------------------
-- Bit field:
-- CONTROL(13 downto 10) - XFER_COUNT - Transfer Count
-- access: rw, hardware: o
-----------------------

csr_control_rdata(13 downto 10) <= csr_control_xfer_count_ff;

csr_control_xfer_count_out <= csr_control_xfer_count_ff;

process (clk) begin
if rising_edge(clk) then
if (rst = '0') then
    csr_control_xfer_count_ff <= "0001"; -- 0x1
else
        if (csr_control_wen = '1') then
            if (wstrb(1) = '1') then
                csr_control_xfer_count_ff(3 downto 0) <= wdata(13 downto 10);
            end if;
        else
            csr_control_xfer_count_ff <= csr_control_xfer_count_ff;
        end if;
end if;
end if;
end process;



-----------------------
-- Bit field:
-- CONTROL(14) - AUTOMATIC_MODE - Automatic Mode
-- access: rw, hardware: o
-----------------------

csr_control_rdata(14) <= csr_control_automatic_mode_ff;

csr_control_automatic_mode_out <= csr_control_automatic_mode_ff;

process (clk) begin
if rising_edge(clk) then
if (rst = '0') then
    csr_control_automatic_mode_ff <= '0'; -- 0x0
else
        if (csr_control_wen = '1') then
            if (wstrb(1) = '1') then
                csr_control_automatic_mode_ff <= wdata(14);
            end if;
        else
            csr_control_automatic_mode_ff <= csr_control_automatic_mode_ff;
        end if;
end if;
end if;
end process;



--------------------------------------------------------------------------------
-- CSR:
-- [0x8] - STATUS - SPI Status register
--------------------------------------------------------------------------------
csr_status_rdata(31 downto 5) <= (others => '0');

csr_status_wen <= wen when (waddr = std_logic_vector(to_unsigned(8, ADDR_W))) else '0'; -- 0x8

csr_status_ren <= ren when (raddr = std_logic_vector(to_unsigned(8, ADDR_W))) else '0'; -- 0x8
process (clk) begin
if rising_edge(clk) then
if (rst = '0') then
    csr_status_ren_ff <= '0'; -- 0x0
else
        csr_status_ren_ff <= csr_status_ren;
end if;
end if;
end process;

-----------------------
-- Bit field:
-- STATUS(0) - TX_FULL - Transmit FIFO Full
-- access: ro, hardware: i
-----------------------

csr_status_rdata(0) <= csr_status_tx_full_ff;


process (clk) begin
if rising_edge(clk) then
if (rst = '0') then
    csr_status_tx_full_ff <= '0'; -- 0x0
else
            csr_status_tx_full_ff <= csr_status_tx_full_in;
end if;
end if;
end process;



-----------------------
-- Bit field:
-- STATUS(1) - TX_EMPTY - Transmit FIFO Empty
-- access: ro, hardware: i
-----------------------

csr_status_rdata(1) <= csr_status_tx_empty_ff;


process (clk) begin
if rising_edge(clk) then
if (rst = '0') then
    csr_status_tx_empty_ff <= '1'; -- 0x1
else
            csr_status_tx_empty_ff <= csr_status_tx_empty_in;
end if;
end if;
end process;



-----------------------
-- Bit field:
-- STATUS(2) - RX_FULL - Receive FIFO Full
-- access: ro, hardware: i
-----------------------

csr_status_rdata(2) <= csr_status_rx_full_ff;


process (clk) begin
if rising_edge(clk) then
if (rst = '0') then
    csr_status_rx_full_ff <= '0'; -- 0x0
else
            csr_status_rx_full_ff <= csr_status_rx_full_in;
end if;
end if;
end process;



-----------------------
-- Bit field:
-- STATUS(3) - RX_EMPTY - Receive FIFO Empty
-- access: ro, hardware: i
-----------------------

csr_status_rdata(3) <= csr_status_rx_empty_ff;


process (clk) begin
if rising_edge(clk) then
if (rst = '0') then
    csr_status_rx_empty_ff <= '1'; -- 0x1
else
            csr_status_rx_empty_ff <= csr_status_rx_empty_in;
end if;
end if;
end process;



-----------------------
-- Bit field:
-- STATUS(4) - AXIS_XFER_ERROR - AXI Stream Transfer Error
-- access: rolh, hardware: i
-----------------------

csr_status_rdata(4) <= csr_status_axis_xfer_error_ff;


process (clk) begin
if rising_edge(clk) then
if (rst = '0') then
    csr_status_axis_xfer_error_ff <= '0'; -- 0x0
else
        if (csr_status_ren = '1' and csr_status_ren_ff = '0' and csr_status_axis_xfer_error_ff = '1') then
            csr_status_axis_xfer_error_ff <= '0';
         elsif (csr_status_axis_xfer_error_in = '1') then
            csr_status_axis_xfer_error_ff <= csr_status_axis_xfer_error_in;
        end if;
end if;
end if;
end process;



--------------------------------------------------------------------------------
-- CSR:
-- [0xc] - CLK_DIV - Clock Divider register
--------------------------------------------------------------------------------
csr_clk_div_rdata(31 downto 16) <= (others => '0');

csr_clk_div_wen <= wen when (waddr = std_logic_vector(to_unsigned(12, ADDR_W))) else '0'; -- 0xc

csr_clk_div_ren <= ren when (raddr = std_logic_vector(to_unsigned(12, ADDR_W))) else '0'; -- 0xc
process (clk) begin
if rising_edge(clk) then
if (rst = '0') then
    csr_clk_div_ren_ff <= '0'; -- 0x0
else
        csr_clk_div_ren_ff <= csr_clk_div_ren;
end if;
end if;
end process;

-----------------------
-- Bit field:
-- CLK_DIV(15 downto 0) - DIV - Clock Divider
-- access: rw, hardware: o
-----------------------

csr_clk_div_rdata(15 downto 0) <= csr_clk_div_div_ff;

csr_clk_div_div_out <= csr_clk_div_div_ff;

process (clk) begin
if rising_edge(clk) then
if (rst = '0') then
    csr_clk_div_div_ff <= "0000000000000000"; -- 0x0
else
        if (csr_clk_div_wen = '1') then
            if (wstrb(0) = '1') then
                csr_clk_div_div_ff(7 downto 0) <= wdata(7 downto 0);
            end if;
            if (wstrb(1) = '1') then
                csr_clk_div_div_ff(15 downto 8) <= wdata(15 downto 8);
            end if;
        else
            csr_clk_div_div_ff <= csr_clk_div_div_ff;
        end if;
end if;
end if;
end process;



--------------------------------------------------------------------------------
-- CSR:
-- [0x10] - TX_DATA - Data Transmit Register
--------------------------------------------------------------------------------

csr_tx_data_wen <= wen when (waddr = std_logic_vector(to_unsigned(16, ADDR_W))) else '0'; -- 0x10

csr_tx_data_ren <= ren when (raddr = std_logic_vector(to_unsigned(16, ADDR_W))) else '0'; -- 0x10
process (clk) begin
if rising_edge(clk) then
if (rst = '0') then
    csr_tx_data_ren_ff <= '0'; -- 0x0
else
        csr_tx_data_ren_ff <= csr_tx_data_ren;
end if;
end if;
end process;

-----------------------
-- Bit field:
-- TX_DATA(31 downto 0) - DATA - Data to be transmitted
-- access: rw, hardware: o
-----------------------

csr_tx_data_rdata(31 downto 0) <= csr_tx_data_data_ff;

csr_tx_data_data_out <= csr_tx_data_data_ff;

process (clk) begin
if rising_edge(clk) then
if (rst = '0') then
    csr_tx_data_data_ff <= "00000000000000000000000000000000"; -- 0x0
else
        if (csr_tx_data_wen = '1') then
            if (wstrb(0) = '1') then
                csr_tx_data_data_ff(7 downto 0) <= wdata(7 downto 0);
            end if;
            if (wstrb(1) = '1') then
                csr_tx_data_data_ff(15 downto 8) <= wdata(15 downto 8);
            end if;
            if (wstrb(2) = '1') then
                csr_tx_data_data_ff(23 downto 16) <= wdata(23 downto 16);
            end if;
            if (wstrb(3) = '1') then
                csr_tx_data_data_ff(31 downto 24) <= wdata(31 downto 24);
            end if;
        else
            csr_tx_data_data_ff <= csr_tx_data_data_ff;
        end if;
end if;
end if;
end process;



--------------------------------------------------------------------------------
-- CSR:
-- [0x14] - SLAVE_SELECT - Slave Select Register
--------------------------------------------------------------------------------

csr_slave_select_wen <= wen when (waddr = std_logic_vector(to_unsigned(20, ADDR_W))) else '0'; -- 0x14

csr_slave_select_ren <= ren when (raddr = std_logic_vector(to_unsigned(20, ADDR_W))) else '0'; -- 0x14
process (clk) begin
if rising_edge(clk) then
if (rst = '0') then
    csr_slave_select_ren_ff <= '0'; -- 0x0
else
        csr_slave_select_ren_ff <= csr_slave_select_ren;
end if;
end if;
end process;

-----------------------
-- Bit field:
-- SLAVE_SELECT(31 downto 0) - SS - Slave Select
-- access: rw, hardware: o
-----------------------

csr_slave_select_rdata(31 downto 0) <= csr_slave_select_ss_ff;

csr_slave_select_ss_out <= csr_slave_select_ss_ff;

process (clk) begin
if rising_edge(clk) then
if (rst = '0') then
    csr_slave_select_ss_ff <= "00000000000000000000000000000000"; -- 0x0
else
        if (csr_slave_select_wen = '1') then
            if (wstrb(0) = '1') then
                csr_slave_select_ss_ff(7 downto 0) <= wdata(7 downto 0);
            end if;
            if (wstrb(1) = '1') then
                csr_slave_select_ss_ff(15 downto 8) <= wdata(15 downto 8);
            end if;
            if (wstrb(2) = '1') then
                csr_slave_select_ss_ff(23 downto 16) <= wdata(23 downto 16);
            end if;
            if (wstrb(3) = '1') then
                csr_slave_select_ss_ff(31 downto 24) <= wdata(31 downto 24);
            end if;
        else
            csr_slave_select_ss_ff <= csr_slave_select_ss_ff;
        end if;
end if;
end if;
end process;



--------------------------------------------------------------------------------
-- CSR:
-- [0x18] - WAIT_CYCLES - Wait Cycles Register
--------------------------------------------------------------------------------

csr_wait_cycles_wen <= wen when (waddr = std_logic_vector(to_unsigned(24, ADDR_W))) else '0'; -- 0x18

csr_wait_cycles_ren <= ren when (raddr = std_logic_vector(to_unsigned(24, ADDR_W))) else '0'; -- 0x18
process (clk) begin
if rising_edge(clk) then
if (rst = '0') then
    csr_wait_cycles_ren_ff <= '0'; -- 0x0
else
        csr_wait_cycles_ren_ff <= csr_wait_cycles_ren;
end if;
end if;
end process;

-----------------------
-- Bit field:
-- WAIT_CYCLES(31 downto 0) - CYCLES - Number of cycles to wait
-- access: rw, hardware: o
-----------------------

csr_wait_cycles_rdata(31 downto 0) <= csr_wait_cycles_cycles_ff;

csr_wait_cycles_cycles_out <= csr_wait_cycles_cycles_ff;

process (clk) begin
if rising_edge(clk) then
if (rst = '0') then
    csr_wait_cycles_cycles_ff <= "00000000000000000000000000000000"; -- 0x0
else
        if (csr_wait_cycles_wen = '1') then
            if (wstrb(0) = '1') then
                csr_wait_cycles_cycles_ff(7 downto 0) <= wdata(7 downto 0);
            end if;
            if (wstrb(1) = '1') then
                csr_wait_cycles_cycles_ff(15 downto 8) <= wdata(15 downto 8);
            end if;
            if (wstrb(2) = '1') then
                csr_wait_cycles_cycles_ff(23 downto 16) <= wdata(23 downto 16);
            end if;
            if (wstrb(3) = '1') then
                csr_wait_cycles_cycles_ff(31 downto 24) <= wdata(31 downto 24);
            end if;
        else
            csr_wait_cycles_cycles_ff <= csr_wait_cycles_cycles_ff;
        end if;
end if;
end if;
end process;



--------------------------------------------------------------------------------
-- Write ready
--------------------------------------------------------------------------------
wready <= '1';

--------------------------------------------------------------------------------
-- Read address decoder
--------------------------------------------------------------------------------
process (clk) begin
if rising_edge(clk) then
if (rst = '0') then
    rdata_ff <= "00000000000000000000000000000000"; -- 0x0
else
    if (ren = '1') then
        if raddr = std_logic_vector(to_unsigned(0, ADDR_W)) then -- 0x0
            rdata_ff <= csr_reset_rdata;
        elsif raddr = std_logic_vector(to_unsigned(4, ADDR_W)) then -- 0x4
            rdata_ff <= csr_control_rdata;
        elsif raddr = std_logic_vector(to_unsigned(8, ADDR_W)) then -- 0x8
            rdata_ff <= csr_status_rdata;
        elsif raddr = std_logic_vector(to_unsigned(12, ADDR_W)) then -- 0xc
            rdata_ff <= csr_clk_div_rdata;
        elsif raddr = std_logic_vector(to_unsigned(16, ADDR_W)) then -- 0x10
            rdata_ff <= csr_tx_data_rdata;
        elsif raddr = std_logic_vector(to_unsigned(20, ADDR_W)) then -- 0x14
            rdata_ff <= csr_slave_select_rdata;
        elsif raddr = std_logic_vector(to_unsigned(24, ADDR_W)) then -- 0x18
            rdata_ff <= csr_wait_cycles_rdata;
        else 
            rdata_ff <= "00000000000000000000000000000000"; -- 0x0
        end if;
    else
        rdata_ff <= "00000000000000000000000000000000"; -- 0x0
    end if;
end if;
end if;
end process;

rdata <= rdata_ff;

--------------------------------------------------------------------------------
-- Read data valid
--------------------------------------------------------------------------------
process (clk) begin
if rising_edge(clk) then
if (rst = '0') then
    rvalid_ff <= '0'; -- 0x0
else
    if ((ren = '1') and (rvalid = '1')) then
        rvalid_ff <= '0';
    elsif (ren = '1') then
        rvalid_ff <= '1';
    end if;
end if;
end if;
end process;


rvalid <= rvalid_ff;

end architecture;