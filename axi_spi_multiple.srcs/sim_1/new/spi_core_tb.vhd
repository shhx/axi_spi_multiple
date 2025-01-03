LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY spi_core_tb IS
-- Testbench does not have ports
END spi_core_tb;

ARCHITECTURE Behavioral OF spi_core_tb IS

    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT spi_core
        GENERIC (
            N_SENSORS    : INTEGER := 8;
            STREAM_WIDTH : INTEGER := 32;
            TRANSFER_WIDTH   : INTEGER := 24
        );
        PORT (
            cpha      : IN STD_LOGIC;
            cpol      : IN STD_LOGIC;
            clk_div   : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            lsb_first : IN STD_LOGIC;

            data_tx  : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            data_rx : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            tx_full  : OUT STD_LOGIC;
            tx_empty : OUT STD_LOGIC;
            rx_full  : OUT STD_LOGIC;
            rx_empty : OUT STD_LOGIC;

            clk : IN STD_LOGIC;
            rst : IN STD_LOGIC;

            sck  : OUT STD_LOGIC;
            cs   : OUT STD_LOGIC;
            miso : IN STD_LOGIC_VECTOR(N_SENSORS - 1 DOWNTO 0);
            mosi : OUT STD_LOGIC;

            s_axis_out_tdata  : OUT STD_LOGIC_VECTOR(STREAM_WIDTH - 1 DOWNTO 0);
            s_axis_out_tkeep  : OUT STD_LOGIC_VECTOR((STREAM_WIDTH/8) - 1 DOWNTO 0);
            s_axis_out_tvalid : OUT STD_LOGIC;
            s_axis_out_tready : IN STD_LOGIC;
            s_axis_out_tlast  : OUT STD_LOGIC;
            s_axis_aclk       : IN STD_LOGIC;
            s_axis_aresetn    : IN STD_LOGIC
        );
    END COMPONENT;

    -- Signals to connect to the UUT
    SIGNAL cpha      : STD_LOGIC := '0';
    SIGNAL cpol      : STD_LOGIC := '0';
    SIGNAL clk_div   : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL lsb_first : STD_LOGIC := '0';

    SIGNAL data_tx  : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL data_rx : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL tx_full  : STD_LOGIC;
    SIGNAL tx_empty : STD_LOGIC;
    SIGNAL rx_full  : STD_LOGIC;
    SIGNAL rx_empty : STD_LOGIC;

    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL rst : STD_LOGIC := '1';

    SIGNAL sck  : STD_LOGIC;
    SIGNAL cs   : STD_LOGIC;
    SIGNAL miso : STD_LOGIC_VECTOR(9 DOWNTO 0) := (OTHERS => '0');
    SIGNAL mosi : STD_LOGIC;

    SIGNAL s_axis_out_tdata  : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL s_axis_out_tkeep  : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL s_axis_out_tvalid : STD_LOGIC;
    SIGNAL s_axis_out_tready : STD_LOGIC := '1';
    SIGNAL s_axis_out_tlast  : STD_LOGIC;
    SIGNAL s_axis_aclk       : STD_LOGIC := '0';
    SIGNAL s_axis_aresetn    : STD_LOGIC := '1';

    CONSTANT CLK_PERIOD : TIME := 10 ns;

BEGIN
    -- Instantiate the Unit Under Test (UUT)
    UUT: spi_core
        GENERIC MAP (
            N_SENSORS    => 10,
            STREAM_WIDTH => 32,
            TRANSFER_WIDTH   => 8
        )
        PORT MAP (
            cpha      => cpha,
            cpol      => cpol,
            clk_div   => clk_div,
            lsb_first => lsb_first,

            data_tx  => data_tx,
            data_rx => data_rx,
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

            s_axis_out_tdata  => s_axis_out_tdata,
            s_axis_out_tkeep  => s_axis_out_tkeep,
            s_axis_out_tvalid => s_axis_out_tvalid,
            s_axis_out_tready => s_axis_out_tready,
            s_axis_out_tlast  => s_axis_out_tlast,
            s_axis_aclk       => s_axis_aclk,
            s_axis_aresetn    => s_axis_aresetn
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
        WAIT FOR CLK_PERIOD;
        s_axis_aclk <= '1';
        WAIT FOR CLK_PERIOD;
    END PROCESS;

    -- Stimulus process
    stim_proc: PROCESS
    BEGIN
 
        -- Configure SPI parameters
        clk_div <= X"000A";  -- Set clock divider
        cpha <= '0';         -- Set CPHA
        cpol <= '1';         -- Set CPOL
        lsb_first <= '0';    -- MSB first
        
        -- Reset UUT
        rst <= '1';
        WAIT FOR 50 ns;
        rst <= '0';
        
        -- Provide input data
        data_tx <= X"0000_00aa";
        miso <= B"11_1100_1100";  -- Simulated sensor data

        -- Wait for a few clock cycles
        WAIT FOR 5000 ns;

        -- Check outputs
        --ASSERT cs = '0' REPORT "Chip select did not assert correctly";
        --ASSERT mosi = data_in(31) REPORT "MOSI did not output correctly";

        -- End simulation
        WAIT;
    END PROCESS;

END Behavioral;
