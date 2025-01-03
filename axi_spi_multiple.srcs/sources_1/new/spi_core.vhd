----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/02/2025 11:54:10 PM
-- Design Name: 
-- Module Name: spi_core - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY spi_core IS
    GENERIC (
        N_SENSORS      : INTEGER := 8;  -- Number of sensors
        STREAM_WIDTH   : INTEGER := 32; -- Width of the axi stream output
        TRANSFER_WIDTH : INTEGER := 8   -- Width of the read data
    );
    PORT (
        -- Configuration
        cpha      : IN STD_LOGIC;
        cpol      : IN STD_LOGIC;
        clk_div   : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        lsb_first : IN STD_LOGIC;

        -- Rx/Tx Data
        data_tx  : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        data_rx  : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        tx_full  : OUT STD_LOGIC;
        tx_empty : OUT STD_LOGIC;
        rx_full  : OUT STD_LOGIC;
        rx_empty : OUT STD_LOGIC;

        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;

        -- Harware Signals
        sck  : OUT STD_LOGIC;
        cs   : OUT STD_LOGIC;
        miso : IN STD_LOGIC_VECTOR(N_SENSORS - 1 DOWNTO 0);
        mosi : OUT STD_LOGIC;

        -- Axi stream output
        s_axis_out_tdata  : OUT STD_LOGIC_VECTOR(STREAM_WIDTH - 1 DOWNTO 0);
        s_axis_out_tkeep  : OUT STD_LOGIC_VECTOR((STREAM_WIDTH/8) - 1 DOWNTO 0);
        s_axis_out_tvalid : OUT STD_LOGIC;
        s_axis_out_tready : IN STD_LOGIC;
        s_axis_out_tlast  : OUT STD_LOGIC;
        s_axis_aclk       : IN STD_LOGIC;
        s_axis_aresetn    : IN STD_LOGIC
    );
END spi_core;

ARCHITECTURE Behavioral OF spi_core IS

    -- Create array to hold all sensor data
    TYPE data_array IS ARRAY(0 TO N_SENSORS - 1) OF STD_LOGIC_VECTOR(TRANSFER_WIDTH - 1 DOWNTO 0);
    SIGNAL sensor_data : data_array;
    SIGNAL bit_count : INTEGER RANGE 0 TO TRANSFER_WIDTH - 1 := 0;
    SIGNAL clk_count : INTEGER RANGE 0 TO 2 ** 16 - 1 := 0;
    SIGNAL spi_clk : STD_LOGIC := '0';
    SIGNAL shift_reg_tx : STD_LOGIC_VECTOR(TRANSFER_WIDTH - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL chip_select : STD_LOGIC := '1';
    SIGNAL transfer_done : STD_LOGIC := '0';
    -- FSM States
    -- TYPE state IS (IDLE, CS_LOW, TRANSFER, CS_HIGH);
    -- SIGNAL state : state := IDLE;
BEGIN
    -- SPI Clock Generation
    PROCESS (clk, rst)
    BEGIN
        IF rst = '1' THEN
            clk_count <= 0;
            spi_clk <= cpol;
        ELSIF rising_edge(clk) THEN
            IF clk_count = TO_INTEGER(UNSIGNED(clk_div)) THEN
                clk_count <= 0;
                spi_clk <= NOT spi_clk;
            ELSE
                clk_count <= clk_count + 1;
            END IF;
        END IF;
    END PROCESS;

    -- Main SPI Logic
    PROCESS (spi_clk, rst)
    BEGIN
        IF rst = '1' THEN
            tx_empty <= '1';
            tx_full <= '0';
            rx_empty <= '1';
            rx_full <= '0';
            bit_count <= 0;
            chip_select <= '1';
            transfer_done <= '0';
            data_rx <= (OTHERS => '0');
            mosi <= '0';
            FOR i IN 0 TO N_SENSORS - 1 LOOP
                sensor_data(i) <= (OTHERS => '0');
            END LOOP;
        ELSIF rising_edge(spi_clk) THEN
            IF transfer_done = '0' THEN
                -- Start of transfer
                IF bit_count = 0 THEN
                    chip_select <= '0';
                    shift_reg_tx <= data_tx(TRANSFER_WIDTH - 1 DOWNTO 0);
                END IF;

                -- Shift out MOSI and shift in MISO
                IF lsb_first = '1' THEN
                    mosi <= shift_reg_tx(0);
                    shift_reg_tx <= '0' & shift_reg_tx(TRANSFER_WIDTH - 1 DOWNTO 1);
                    FOR i IN 0 TO N_SENSORS - 1 LOOP
                        sensor_data(i) <= miso(i) & sensor_data(i)(TRANSFER_WIDTH - 1 DOWNTO 1);
                    END LOOP;
                ELSE
                    mosi <= shift_reg_tx(TRANSFER_WIDTH - 1);
                    shift_reg_tx <= shift_reg_tx(TRANSFER_WIDTH - 2 DOWNTO 0) & '0';
                    FOR i IN 0 TO N_SENSORS - 1 LOOP
                        sensor_data(i) <= sensor_data(i)(TRANSFER_WIDTH - 2 DOWNTO 0) & miso(i);
                    END LOOP;
                END IF;

                -- Increment bit count
                IF bit_count = TRANSFER_WIDTH - 1 THEN
                    bit_count <= 0;
                    transfer_done <= '1';
                    chip_select <= '1';
                ELSE
                    bit_count <= bit_count + 1;
                END IF;
            END IF;
        END IF;
    END PROCESS;

    -- -- Output Data Management
    -- PROCESS (transfer_done, s_axis_aclk)
    --     SIGNAL result_index : INTEGER := 0;
    -- BEGIN
    --     IF s_axis_aresetn = '0' THEN
    --         s_axis_out_tdata <= (OTHERS => '0');
    --         s_axis_out_tkeep <= (OTHERS => '0');
    --         s_axis_out_tvalid <= '0';
    --         s_axis_out_tlast <= '0';
    --         result_index <= 0;
    --     ELSIF rising_edge(s_axis_aclk) THEN
    --         IF transfer_done = '1' AND s_axis_out_tready = '1' THEN
    --             IF result_index < N_SENSORS THEN
    --                 s_axis_out_tdata <= sensor_data(result_index);
    --                 s_axis_out_tkeep <= (OTHERS => '1');
    --                 s_axis_out_tvalid <= '1';
    --                 result_index <= result_index + 1;
    --             ELSE
    --                 -- Transfer to AXIS is done
    --                 s_axis_out_tdata <= (OTHERS => '0');
    --                 s_axis_out_tkeep <= (OTHERS => '0');
    --                 s_axis_out_tvalid <= '0';
    --                 result_index <= 0;
    --                 transfer_done <= '0';
    --             END IF;
    --             IF result_index = N_SENSORS - 1 THEN
    --                 s_axis_out_tlast <= '1';
    --             ELSE
    --                 s_axis_out_tlast <= '0';
    --             END IF;
    --             s_axis_out_tkeep <= (OTHERS => '1');
    --         ELSE
    --             result_index <= 0;
    --             s_axis_out_tdata <= (OTHERS => '0');
    --             s_axis_out_tvalid <= '0';
    --             s_axis_out_tlast <= '0';
    --         END IF;
    --     END IF;
    -- END PROCESS;
    sck <= spi_clk;
    cs <= chip_select;
END Behavioral;
