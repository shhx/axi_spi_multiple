LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY spi_top IS
    GENERIC (
        ADDR_W           : INTEGER := 10;
        DATA_W           : INTEGER := 32;
        STRB_W           : INTEGER := 4;
        N_SENSORS        : INTEGER := 10;
        N_CHIP_SELECTS   : INTEGER := 1;
        CS_WAIT_CYCLES   : INTEGER := 5; -- Number of clock cycles to wait after CS is asserted
        MAX_NUMBER_READS : INTEGER := 4; -- Width of the read data
        STREAM_WIDTH     : INTEGER := 32
    );
    PORT (
        spi_clk : IN STD_LOGIC;
        rst     : IN STD_LOGIC;

        -- SPI Core Ports
        sck  : OUT STD_LOGIC;
        cs   : OUT STD_LOGIC_VECTOR(N_CHIP_SELECTS - 1 DOWNTO 0);
        mosi : OUT STD_LOGIC;
        miso : IN STD_LOGIC_VECTOR(N_SENSORS - 1 DOWNTO 0);

        -- SPI Core AXI Stream Ports
        s_axis_out_tdata   : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        s_axis_out_tkeep   : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        s_axis_out_tvalid  : OUT STD_LOGIC;
        s_axis_out_tready  : IN STD_LOGIC;
        s_axis_out_tlast   : OUT STD_LOGIC;
        s_axis_out_aclk    : IN STD_LOGIC;
        s_axis_out_aresetn : IN STD_LOGIC;

        -- AXI-Lite Ports
        s_axi_lite_aclk    : IN STD_LOGIC;
        s_axi_lite_aresetn : IN STD_LOGIC;
        s_axi_lite_awaddr  : IN STD_LOGIC_VECTOR(ADDR_W - 1 DOWNTO 0);
        s_axi_lite_awprot  : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        s_axi_lite_awvalid : IN STD_LOGIC;
        s_axi_lite_awready : OUT STD_LOGIC;
        s_axi_lite_wdata   : IN STD_LOGIC_VECTOR(DATA_W - 1 DOWNTO 0);
        s_axi_lite_wstrb   : IN STD_LOGIC_VECTOR(STRB_W - 1 DOWNTO 0);
        s_axi_lite_wvalid  : IN STD_LOGIC;
        s_axi_lite_wready  : OUT STD_LOGIC;
        s_axi_lite_bresp   : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        s_axi_lite_bvalid  : OUT STD_LOGIC;
        s_axi_lite_bready  : IN STD_LOGIC;
        s_axi_lite_araddr  : IN STD_LOGIC_VECTOR(ADDR_W - 1 DOWNTO 0);
        s_axi_lite_arprot  : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        s_axi_lite_arvalid : IN STD_LOGIC;
        s_axi_lite_arready : OUT STD_LOGIC;
        s_axi_lite_rdata   : OUT STD_LOGIC_VECTOR(DATA_W - 1 DOWNTO 0);
        s_axi_lite_rresp   : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        s_axi_lite_rvalid  : OUT STD_LOGIC;
        s_axi_lite_rready  : IN STD_LOGIC
    );
END ENTITY;

ARCHITECTURE rtl OF spi_top IS

    SIGNAL csr_reset_reset_out : STD_LOGIC;
    SIGNAL csr_control_cpol_out : STD_LOGIC;
    SIGNAL csr_control_cpha_out : STD_LOGIC;
    SIGNAL csr_control_trans_inhibit_out : STD_LOGIC;
    SIGNAL csr_control_lsb_first_out : STD_LOGIC;
    SIGNAL csr_control_xfer_count_out : STD_LOGIC_VECTOR(4 - 1 DOWNTO 0);

    SIGNAL csr_status_tx_full_in : STD_LOGIC;
    SIGNAL csr_status_tx_empty_in : STD_LOGIC;
    SIGNAL csr_status_rx_full_in : STD_LOGIC;
    SIGNAL csr_status_rx_empty_in : STD_LOGIC;
    SIGNAL csr_clk_div_div_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL csr_tx_data_data_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL csr_rx_data_data_in : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL csr_slave_select_ss_out : STD_LOGIC_VECTOR(31 DOWNTO 0);

BEGIN

    -- Instantiate SPI Core
    spi_core_inst : ENTITY work.spi_core
        GENERIC MAP(
            N_SENSORS        => N_SENSORS,
            N_CHIP_SELECTS   => N_CHIP_SELECTS,
            MAX_NUMBER_READS => MAX_NUMBER_READS,
            CS_WAIT_CYCLES   => CS_WAIT_CYCLES,
            STREAM_WIDTH     => STREAM_WIDTH
        )
        PORT MAP(
            clk              => spi_clk,
            rst              => rst,
            sck              => sck,
            cs               => cs,
            mosi             => mosi,
            miso             => miso,
            cpha             => csr_control_cpha_out,
            cpol             => csr_control_cpol_out,
            clk_div          => csr_clk_div_div_out,
            lsb_first        => csr_control_lsb_first_out,
            selected_cs      => csr_slave_select_ss_out(N_CHIP_SELECTS - 1 DOWNTO 0),
            transfer_inhibit => csr_control_trans_inhibit_out,
            xfer_count       => csr_control_xfer_count_out,

            data_tx  => csr_tx_data_data_out,
            tx_full  => csr_status_tx_full_in,
            tx_empty => csr_status_tx_empty_in,
            rx_full  => csr_status_rx_full_in,
            rx_empty => csr_status_rx_empty_in,

            s_axis_out_tdata   => s_axis_out_tdata,
            s_axis_out_tkeep   => s_axis_out_tkeep,
            s_axis_out_tvalid  => s_axis_out_tvalid,
            s_axis_out_tready  => s_axis_out_tready,
            s_axis_out_tlast   => s_axis_out_tlast,
            s_axis_out_aclk    => s_axis_out_aclk,
            s_axis_out_aresetn => s_axis_out_aresetn
        );

    -- Instantiate SPI Registers
    spi_regs_inst : ENTITY work.spi_regs
        GENERIC MAP(
            ADDR_W => ADDR_W,
            DATA_W => DATA_W,
            STRB_W => STRB_W
        )
        PORT MAP(
            clk => s_axi_lite_aclk,
            rst => s_axi_lite_aresetn,

            -- SPI Core Ports
            csr_reset_reset_out           => csr_reset_reset_out,
            csr_control_cpol_out          => csr_control_cpol_out,
            csr_control_cpha_out          => csr_control_cpha_out,
            csr_control_trans_inhibit_out => csr_control_trans_inhibit_out,
            csr_control_lsb_first_out     => csr_control_lsb_first_out,
            csr_control_xfer_count_out    => csr_control_xfer_count_out,

            csr_status_tx_full_in   => csr_status_tx_full_in,
            csr_status_tx_empty_in  => csr_status_tx_empty_in,
            csr_status_rx_full_in   => csr_status_rx_full_in,
            csr_status_rx_empty_in  => csr_status_rx_empty_in,
            csr_clk_div_div_out     => csr_clk_div_div_out,
            csr_tx_data_data_out    => csr_tx_data_data_out,
            csr_slave_select_ss_out => csr_slave_select_ss_out,

            -- AXI-Lite Ports
            axil_awaddr  => s_axi_lite_awaddr,
            axil_awprot  => s_axi_lite_awprot,
            axil_awvalid => s_axi_lite_awvalid,
            axil_awready => s_axi_lite_awready,
            axil_wdata   => s_axi_lite_wdata,
            axil_wstrb   => s_axi_lite_wstrb,
            axil_wvalid  => s_axi_lite_wvalid,
            axil_wready  => s_axi_lite_wready,
            axil_bresp   => s_axi_lite_bresp,
            axil_bvalid  => s_axi_lite_bvalid,
            axil_bready  => s_axi_lite_bready,
            axil_araddr  => s_axi_lite_araddr,
            axil_arprot  => s_axi_lite_arprot,
            axil_arvalid => s_axi_lite_arvalid,
            axil_arready => s_axi_lite_arready,
            axil_rdata   => s_axi_lite_rdata,
            axil_rresp   => s_axi_lite_rresp,
            axil_rvalid  => s_axi_lite_rvalid,
            axil_rready  => s_axi_lite_rready
        );

END ARCHITECTURE;
