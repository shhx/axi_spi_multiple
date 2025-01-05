LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY spi_core_tb IS
    -- Testbench does not have ports
END spi_core_tb;

ARCHITECTURE Behavioral OF spi_core_tb IS

    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT spi_core IS
        GENERIC (
            N_SENSORS        : INTEGER := 10;  -- Number of sensors
            N_CHIP_SELECTS   : INTEGER := 2;  -- Number of chip selects
            STREAM_WIDTH     : INTEGER := 32; -- Width of the axi stream output
            CS_WAIT_CYCLES   : INTEGER := 5;  -- Number of clock cycles to wait after CS is asserted
            MAX_NUMBER_READS : INTEGER := 1   -- Width of the read data
        );
        PORT (
            -- Configuration
            cpha             : IN STD_LOGIC;
            cpol             : IN STD_LOGIC;
            clk_div          : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            lsb_first        : IN STD_LOGIC;
            selected_cs      : IN STD_LOGIC_VECTOR(N_CHIP_SELECTS - 1 DOWNTO 0);
            transfer_inhibit : IN STD_LOGIC;
            xfer_count       : IN STD_LOGIC_VECTOR(4 - 1 DOWNTO 0); -- Number of 8 bit transfers
            xfer_error       : OUT STD_LOGIC;

            long_wait_cycles    : IN STD_LOGIC_VECTOR(31 DOWNTO 0); -- Number of clock cycles to wait after CS is de-asserted
            automatic_transfers : IN STD_LOGIC;

            -- Rx/Tx Data
            data_tx  : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            tx_full  : OUT STD_LOGIC;
            tx_empty : OUT STD_LOGIC;
            rx_full  : OUT STD_LOGIC;
            rx_empty : OUT STD_LOGIC;

            clk : IN STD_LOGIC;
            rst : IN STD_LOGIC;

            -- Harware Signals
            sck  : OUT STD_LOGIC;
            cs   : OUT STD_LOGIC_VECTOR(N_CHIP_SELECTS - 1 DOWNTO 0);
            miso : IN STD_LOGIC_VECTOR(N_SENSORS - 1 DOWNTO 0);
            mosi : OUT STD_LOGIC;

            -- Axi stream output
            s_axis_out_tdata   : OUT STD_LOGIC_VECTOR(STREAM_WIDTH - 1 DOWNTO 0);
            s_axis_out_tkeep   : OUT STD_LOGIC_VECTOR((STREAM_WIDTH/8) - 1 DOWNTO 0);
            s_axis_out_tvalid  : OUT STD_LOGIC;
            s_axis_out_tready  : IN STD_LOGIC;
            s_axis_out_tlast   : OUT STD_LOGIC;
            s_axis_out_aclk    : IN STD_LOGIC;
            s_axis_out_aresetn : IN STD_LOGIC
        );
    END COMPONENT;

    -- Signals to connect to the UUT
    CONSTANT MAX_NUMBER_READS : INTEGER := 4;
    CONSTANT N_SENSORS : INTEGER := 10;
    CONSTANT N_CHIP_SELECTS : INTEGER := 2;
    CONSTANT STREAM_WIDTH : INTEGER := 32;
    CONSTANT CLK_DIVIDER : INTEGER := 10;
    SIGNAL cpha : STD_LOGIC := '0';
    SIGNAL cpol : STD_LOGIC := '0';
    SIGNAL clk_div : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL lsb_first : STD_LOGIC := '0';

    SIGNAL long_wait_cycles : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL automatic_transfers : STD_LOGIC := '0';

    SIGNAL data_tx : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL tx_full : STD_LOGIC;
    SIGNAL tx_empty : STD_LOGIC;
    SIGNAL rx_full : STD_LOGIC;
    SIGNAL rx_empty : STD_LOGIC;
    SIGNAL selected_cs : STD_LOGIC_VECTOR(N_CHIP_SELECTS - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL transfer_inhibit : STD_LOGIC := '0';
    SIGNAL xfer_count : STD_LOGIC_VECTOR(4 - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL xfer_error : STD_LOGIC;

    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL rst : STD_LOGIC := '1';

    SIGNAL sck : STD_LOGIC;
    SIGNAL cs : STD_LOGIC_VECTOR(N_CHIP_SELECTS - 1 DOWNTO 0) := (OTHERS => '1');
    SIGNAL miso : STD_LOGIC_VECTOR(N_SENSORS - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL mosi : STD_LOGIC;

    SIGNAL s_axis_out_tdata : STD_LOGIC_VECTOR(STREAM_WIDTH - 1 DOWNTO 0);
    SIGNAL s_axis_out_tkeep : STD_LOGIC_VECTOR(STREAM_WIDTH/8 - 1 DOWNTO 0);
    SIGNAL s_axis_out_tvalid : STD_LOGIC;
    SIGNAL s_axis_out_tready : STD_LOGIC := '0';
    SIGNAL s_axis_out_tlast : STD_LOGIC;
    SIGNAL s_axis_aclk : STD_LOGIC := '0';
    SIGNAL s_axis_aresetn : STD_LOGIC := '1';

    CONSTANT CLK_PERIOD : TIME := 10 ns;

BEGIN
    -- Instantiate the Unit Under Test (UUT)
    UUT : spi_core
    GENERIC MAP(
        N_SENSORS        => N_SENSORS,
        STREAM_WIDTH     => STREAM_WIDTH,
        MAX_NUMBER_READS => MAX_NUMBER_READS
    )
    PORT MAP(
        cpha             => cpha,
        cpol             => cpol,
        clk_div          => clk_div,
        lsb_first        => lsb_first,
        selected_cs      => selected_cs,
        transfer_inhibit => transfer_inhibit,
        xfer_count       => xfer_count,
        xfer_error       => xfer_error,

        long_wait_cycles    => long_wait_cycles,
        automatic_transfers => automatic_transfers,

        data_tx  => data_tx,
        tx_full  => tx_full,
        tx_empty => tx_empty,
        rx_full  => rx_full,
        rx_empty => rx_empty,

        clk => clk,
        rst => rst,

        sck  => sck,
        cs   => cs,
        miso => miso,
        mosi => mosi,

        s_axis_out_tdata   => s_axis_out_tdata,
        s_axis_out_tkeep   => s_axis_out_tkeep,
        s_axis_out_tvalid  => s_axis_out_tvalid,
        s_axis_out_tready  => s_axis_out_tready,
        s_axis_out_tlast   => s_axis_out_tlast,
        s_axis_out_aclk    => s_axis_aclk,
        s_axis_out_aresetn => s_axis_aresetn
    );

    -- Clock generation
    clk_process : PROCESS
    BEGIN
        clk <= '0';
        WAIT FOR CLK_PERIOD / 2;
        clk <= '1';
        WAIT FOR CLK_PERIOD / 2;
    END PROCESS;

    -- AXI Stream clock generation
    s_axis_aclk_process : PROCESS
    BEGIN
        s_axis_aclk <= '0';
        WAIT FOR CLK_PERIOD / 2;
        s_axis_aclk <= '1';
        WAIT FOR CLK_PERIOD / 2;
    END PROCESS;

    -- Stimulus process
    stim_proc : PROCESS
    BEGIN

        -- Configure SPI parameters
        clk_div <= STD_LOGIC_VECTOR(to_unsigned(CLK_DIVIDER, clk_div'length)); -- Set clock divider
        cpha <= '0'; -- Set CPHA
        cpol <= '0'; -- Set CPOL
        lsb_first <= '0'; -- MSB first
        selected_cs <= B"10"; -- Select CS0
        transfer_inhibit <= '1'; -- Allow transfer
        xfer_count <= STD_LOGIC_VECTOR(to_unsigned(1, xfer_count'length)); -- Set number of transfers
        long_wait_cycles <= X"0000_0100"; -- Set long wait cycles
        automatic_transfers <= '0'; -- Disable automatic transfers

        -- Reset UUT
        rst <= '0';
        s_axis_out_tready <= '0';
        s_axis_aresetn <= '0';
        WAIT FOR CLK_PERIOD * 5;
        rst <= '1';
        s_axis_aresetn <= '1';

        -- Provide input data
        data_tx <= X"0000_00AA";
        miso <= (OTHERS => '1');
        WAIT FOR CLK_PERIOD * 5;
        transfer_inhibit <= '0'; -- Allow transfer
        wait for 165 ns;
        WAIT FOR CLK_PERIOD * CLK_DIVIDER;
        miso <= (OTHERS => '1');
        WAIT FOR CLK_PERIOD * CLK_DIVIDER * 2;
        miso <= (OTHERS => '0');
        WAIT FOR CLK_PERIOD * CLK_DIVIDER * 2;
        miso <= (OTHERS => '1');
        WAIT FOR CLK_PERIOD * CLK_DIVIDER * 2;
        miso <= (OTHERS => '0');
        WAIT FOR CLK_PERIOD * CLK_DIVIDER * 2;
        miso <= (OTHERS => '1');


        WAIT FOR CLK_PERIOD * 400;

        -- s_axis_out_tready <= '0';
        -- WAIT FOR CLK_PERIOD * 500;
        -- s_axis_out_tready <= '1';
        -- wait for CLK_PERIOD * 2;
        -- s_axis_out_tready <= '0';
        -- WAIT FOR CLK_PERIOD * 50;
        -- s_axis_out_tready <= '1';

        cpha <= '1'; -- Set CPHA
        transfer_inhibit <= '1'; -- Inhibit transfer
        WAIT FOR CLK_PERIOD * 10;
        transfer_inhibit <= '0'; -- Allow transfer
        wait for 165 ns;
        miso <= (OTHERS => '1');
        WAIT FOR CLK_PERIOD * CLK_DIVIDER * 2;
        miso <= (OTHERS => '0');
        WAIT FOR CLK_PERIOD * CLK_DIVIDER * 2;
        miso <= (OTHERS => '1');
        WAIT FOR CLK_PERIOD * CLK_DIVIDER * 2;
        miso <= (OTHERS => '0');
        WAIT FOR CLK_PERIOD * CLK_DIVIDER * 2;
        miso <= (OTHERS => '1');

        WAIT FOR CLK_PERIOD * 400;
        automatic_transfers <= '1'; -- Disable automatic transfers
        wait for CLK_PERIOD * 1000;

        -- End simulation
        WAIT;
    END PROCESS;

END Behavioral;
