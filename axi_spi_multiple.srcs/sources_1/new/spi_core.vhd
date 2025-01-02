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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY spi_core IS
    GENERIC (
        N_SENSORS    : INTEGER := 8; -- Number of sensors
        STREAM_WIDTH : INTEGER := 32 -- Width of the axi stream output
    );
    PORT (
        -- Configuration
        cpha    : IN STD_LOGIC;
        cpol    : IN STD_LOGIC;
        clk_div : IN STD_LOGIC_VECTOR(15 DOWNTO 0);

        -- Rx/Tx Data
        data_in  : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        data_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);

        -- Harware Signals
        clk  : IN STD_LOGIC;
        rst  : IN STD_LOGIC;
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

BEGIN
END Behavioral;
