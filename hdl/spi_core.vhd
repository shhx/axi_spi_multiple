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
        N_SENSORS        : INTEGER := 8;  -- Number of sensors
        N_CHIP_SELECTS   : INTEGER := 1;  -- Number of chip selects
        STREAM_WIDTH     : INTEGER := 32; -- Width of the axi stream output
        CS_WAIT_CYCLES   : INTEGER := 5;  -- Number of clock cycles to wait after CS is asserted
        MAX_NUMBER_READS : INTEGER := 1   -- Maximum number of read transfers
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

        -- Automatic Transfer mode
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
END spi_core;

ARCHITECTURE Behavioral OF spi_core IS

    -- Create array to hold all sensor data
    TYPE data_array IS ARRAY(0 TO N_SENSORS - 1) OF STD_LOGIC_VECTOR(MAX_NUMBER_READS * 8 - 1 DOWNTO 0);
    SIGNAL sensor_data : data_array;
    SIGNAL clk_count : INTEGER RANGE 0 TO 2 ** 16 - 1 := 0;
    SIGNAL wait_count : INTEGER RANGE 0 TO 2 ** 16 - 1 := 0;
    SIGNAL spi_clk : STD_LOGIC := '0';
    SIGNAL spi_sample_clk : STD_LOGIC := '0';
    SIGNAL shift_reg_tx : STD_LOGIC_VECTOR(MAX_NUMBER_READS * 8 - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL chip_select : STD_LOGIC := '1';
    SIGNAL spi_transfer_done : STD_LOGIC := '0';
    SIGNAL prev_spi_transfer_done : STD_LOGIC := '0';
    SIGNAL axis_transfer_done : STD_LOGIC := '0';
    SIGNAL bit_count : INTEGER RANGE 0 TO MAX_NUMBER_READS * 8 - 1 := 0;
    SIGNAL bits_to_transfer : INTEGER RANGE 0 TO 8 * MAX_NUMBER_READS := 0;
    SIGNAL prev_transfer_inhibit : STD_LOGIC := '1';
    SIGNAL axi_transfer_error : STD_LOGIC := '0';
    SIGNAL result_index : INTEGER RANGE 0 TO N_SENSORS - 1 := 0;
    -- FSM States
    TYPE fsm_state IS (IDLE, CS_LOW_WAIT, TRANSFER, CS_HIGH_WAIT, LONG_WAIT);
    SIGNAL state : fsm_state := IDLE;
BEGIN
    -- SPI Clock Generation FSM
    bits_to_transfer <= to_integer(unsigned(xfer_count)) * 8;

    PROCESS (clk, rst)
        VARIABLE SPI_CLK_CYCLES : INTEGER := 0;
        VARIABLE SPI_CLK_CYCLES_HALF : INTEGER := SPI_CLK_CYCLES / 2;
    BEGIN
        SPI_CLK_CYCLES := to_integer(unsigned(clk_div));
        SPI_CLK_CYCLES_HALF := SPI_CLK_CYCLES / 2;
        IF rst = '0' THEN
            clk_count <= 0;
            wait_count <= 0;
            spi_clk <= '0';
            spi_sample_clk <= '0';
            chip_select <= '1';
            state <= IDLE;
        ELSIF rising_edge(clk) THEN
            prev_transfer_inhibit <= transfer_inhibit;
            IF transfer_inhibit = '1' THEN
                state <= IDLE;
            END IF;
            CASE state IS
                WHEN IDLE =>
                    chip_select <= '1';
                    spi_clk <= '0';
                    clk_count <= 0;
                    IF (prev_transfer_inhibit = '1' AND transfer_inhibit = '0') OR (automatic_transfers = '1' AND transfer_inhibit = '0') THEN
                        wait_count <= 0;
                        state <= CS_LOW_WAIT;
                    END IF;

                WHEN CS_LOW_WAIT =>
                    chip_select <= '0';
                    IF wait_count = CS_WAIT_CYCLES THEN
                        wait_count <= 0;
                        state <= TRANSFER;
                    ELSE
                        wait_count <= wait_count + 1;
                    END IF;

                WHEN TRANSFER =>
                    IF clk_count = SPI_CLK_CYCLES_HALF AND cpha = '1' THEN
                        spi_sample_clk <= NOT spi_sample_clk;
                    ELSIF clk_count = SPI_CLK_CYCLES AND cpha = '0' THEN
                        spi_sample_clk <= NOT spi_sample_clk;
                    END IF;

                    IF clk_count = SPI_CLK_CYCLES THEN
                        spi_clk <= NOT spi_clk;
                        clk_count <= 0;
                    ELSE
                        clk_count <= clk_count + 1;
                    END IF;

                    IF spi_transfer_done = '1' THEN
                        wait_count <= 0;
                        state <= CS_HIGH_WAIT;
                    END IF;

                WHEN CS_HIGH_WAIT =>
                    IF wait_count = CS_WAIT_CYCLES THEN
                        wait_count <= 0;
                        IF automatic_transfers = '1' THEN
                            state <= LONG_WAIT;
                        ELSE
                            state <= IDLE;
                        END IF;
                    ELSE
                        wait_count <= wait_count + 1;
                    END IF;

                WHEN LONG_WAIT =>
                    chip_select <= '1';
                    spi_clk <= '0';
                    clk_count <= 0;
                    IF wait_count = to_integer(unsigned(long_wait_cycles)) THEN
                        wait_count <= 0;
                        state <= IDLE;
                    ELSE
                        wait_count <= wait_count + 1;
                    END IF;

                WHEN OTHERS =>
                    state <= IDLE;
            END CASE;
        END IF;
    END PROCESS;

    -- SPI Transfer FSM
    PROCESS (spi_sample_clk, rst, state, automatic_transfers)
    BEGIN
        IF rst = '0' THEN
            tx_empty <= '1';
            tx_full <= '0';
            rx_empty <= '1';
            rx_full <= '0';
            bit_count <= 0;
            spi_transfer_done <= '0';
        ELSE
            CASE state IS
                WHEN TRANSFER =>
                    IF rising_edge(spi_sample_clk) THEN
                        -- Increment bit count
                        IF bit_count = bits_to_transfer - 1 THEN
                            spi_transfer_done <= '1';
                            bit_count <= 0;
                        ELSE
                            bit_count <= bit_count + 1;
                            spi_transfer_done <= '0';
                        END IF;
                    END IF;
                WHEN CS_LOW_WAIT =>
                    spi_transfer_done <= '0';
                    bit_count <= 0;
                WHEN OTHERS =>
                    bit_count <= 0;
            END CASE;
        END IF;
    END PROCESS;

    -- SPI Data Management
    PROCESS (rst, chip_select, lsb_first, bit_count, miso, data_tx)
    BEGIN
        IF rst = '0' THEN
            mosi <= 'Z';
            FOR i IN 0 TO N_SENSORS - 1 LOOP
                sensor_data(i) <= (OTHERS => '0');
            END LOOP;
        ELSIF chip_select = '0' THEN
            IF lsb_first = '1' THEN
                mosi <= data_tx(bit_count);
                FOR i IN 0 TO N_SENSORS - 1 LOOP
                    sensor_data(i)(bit_count) <= miso(i);
                END LOOP;
            ELSE
                mosi <= data_tx(bits_to_transfer - 1 - bit_count);
                FOR i IN 0 TO N_SENSORS - 1 LOOP
                    sensor_data(i)(bits_to_transfer - 1 - bit_count) <= miso(i);
                END LOOP;
            END IF;
        ELSE
            -- if chip_select = '1' then mosi should be tri-stated
            FOR i IN 0 TO N_SENSORS - 1 LOOP
                sensor_data(i) <= (OTHERS => '0');
            END LOOP;
            mosi <= 'Z';
        END IF;
    END PROCESS;

    -- Output Data Management
    PROCESS (spi_transfer_done, s_axis_out_aclk, s_axis_out_aresetn)
        VARIABLE zeros : STD_LOGIC_VECTOR(STREAM_WIDTH - MAX_NUMBER_READS * 8 - 1 DOWNTO 0) := (OTHERS => '0');
    BEGIN
        IF s_axis_out_aresetn = '0' THEN
            s_axis_out_tdata <= (OTHERS => '0');
            s_axis_out_tkeep <= (OTHERS => '0');
            s_axis_out_tvalid <= '0';
            s_axis_out_tlast <= '0';
            axis_transfer_done <= '0';
            axi_transfer_error <= '0';
            result_index <= 0;
        ELSIF rising_edge(s_axis_out_aclk) THEN
            prev_spi_transfer_done <= spi_transfer_done;
            -- IF spi_transfer_done = '1' AND axis_transfer_done = '0' THEN
            -- IF result_index < N_SENSORS THEN
            --     s_axis_out_tdata <= zeros & sensor_data(result_index);
            --     s_axis_out_tvalid <= '1';
            --     axis_transfer_done <= '0';
            -- ELSE
            --     -- Transfer to AXIS is done
            --     s_axis_out_tdata <= (OTHERS => '0');
            --     s_axis_out_tvalid <= '0';
            --     result_index <= 0;
            -- END IF;
            -- IF result_index = N_SENSORS - 1 THEN
            --     s_axis_out_tlast <= '1';
            --     axis_transfer_done <= '1';
            -- ELSE
            --     s_axis_out_tlast <= '0';
            -- END IF;
            -- IF s_axis_out_tready = '1' THEN
            --     result_index <= result_index + 1;
            -- END IF;
            IF spi_transfer_done = '1' AND axis_transfer_done = '0' THEN
                IF result_index < N_SENSORS THEN
                    s_axis_out_tdata <= zeros & sensor_data(result_index);
                    s_axis_out_tvalid <= '1';
                    s_axis_out_tlast <= '0';
                    IF s_axis_out_tready = '1' THEN
                        result_index <= result_index + 1;
                    END IF;
                    IF result_index = N_SENSORS - 1 THEN
                        s_axis_out_tlast <= '1';
                        axis_transfer_done <= '1';
                    END IF;
                ELSE
                    -- Transfer to AXIS is done
                    s_axis_out_tdata <= (OTHERS => '0');
                    s_axis_out_tvalid <= '0';
                    s_axis_out_tlast <= '0';
                    result_index <= 0;
                END IF;
                s_axis_out_tkeep <= (OTHERS => '1');
            ELSIF spi_transfer_done = '0' THEN
                axis_transfer_done <= '0';
                s_axis_out_tvalid <= '0';
            ELSE
                result_index <= 0;
                s_axis_out_tdata <= (OTHERS => '0');
                s_axis_out_tvalid <= '0';
                s_axis_out_tlast <= '0';
            END IF;

            IF prev_spi_transfer_done = '1' AND spi_transfer_done = '0' AND axis_transfer_done = '0' THEN
                axi_transfer_error <= '1';
            ELSE
                axi_transfer_error <= '0';
            END IF;
        END IF;
    END PROCESS;

    PROCESS (selected_cs, chip_select)
    BEGIN
        cs <= (OTHERS => '1');
        -- Set the desired chip's select to the given value, use one-hot encoding.
        -- Bits set to '0' will be selected.
        FOR i IN 0 TO N_CHIP_SELECTS - 1 LOOP
            IF selected_cs(i) = '0' THEN
                cs(i) <= chip_select;
            END IF;
        END LOOP;
    END PROCESS;

    sck <= spi_clk XOR cpol;
    xfer_error <= axi_transfer_error;
END Behavioral;
