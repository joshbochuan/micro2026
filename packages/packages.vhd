library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.all; -- uses all packages available in this directory
use work.adder_pkg.all;
use work.sevenseg_pkg.all;
use work.alu_pkg.all;

entity packages is
	port (
		SW:   in std_logic_vector(17 downto 0);
		KEY:  in std_logic_vector(3 downto 0);
		LEDR: out std_logic_vector(17 downto 0);
		LEDG: out std_logic_vector(8 downto 0);
		HEX0: out std_logic_vector(6 downto 0);
		HEX1: out std_logic_vector(6 downto 0);
		HEX2: out std_logic_vector(6 downto 0);
		HEX3: out std_logic_vector(6 downto 0);
		HEX4: out std_logic_vector(6 downto 0);
		HEX5: out std_logic_vector(6 downto 0);
		HEX6: out std_logic_vector(6 downto 0);
		HEX7: out std_logic_vector(6 downto 0)
	);
end packages;

architecture structural of packages is
   signal tmp: std_logic;
begin
	-- do something
	HEX0 <= "0000000";
end structural;
