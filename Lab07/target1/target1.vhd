library ieee;
use ieee.std_logic_1164.all;
use work.divider_pkg.all;
use work.sevenseg_pkg.all;

entity target1 is
	port (
		SW: in std_logic_vector(16 downto 0);
		KEY: in std_logic_vector(0 downto 0);
		LEDR: out std_logic_vector(15 downto 0);
		HEX0: out std_logic_vector(6 downto 0);
		HEX1: out std_logic_vector(6 downto 0);
		HEX2: out std_logic_vector(6 downto 0);
		HEX3: out std_logic_vector(6 downto 0)
	);
end target1;

architecture structural of target1 is
	signal divisor: std_logic_vector(7 downto 0);
	signal dividend: std_logic_vector(7 downto 0);
	signal clock: std_logic;
	signal reset: std_logic;
	signal quotient: std_logic_vector(7 downto 0);
	signal remainder: std_logic_vector(7 downto 0);
begin
	divisor <= SW(7 downto 0);
	dividend <= SW(15 downto 8);
	clock <= KEY(0);
	reset <= SW(16);
	
	-- add logic
	
	LEDR(7 downto 0) <= quotient;
	LEDR(15 downto 8) <= remainder;
	H3: hex_to_7seg port map(quotient(7 downto 4), HEX3);
	H2: hex_to_7seg port map(quotient(3 downto 0), HEX2);
	H1: hex_to_7seg port map(remainder(7 downto 4), HEX1);
	H0: hex_to_7seg port map(remainder(3 downto 0), HEX0);
	
end structural;