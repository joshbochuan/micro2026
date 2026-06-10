library ieee;
use ieee.std_logic_1164.all;
use work.divider_pkg.all;

entity divider_combinational is
	port (
		SW: in std_logic_vector(15 downto 0);
		HEX0: out std_logic_vector(6 downto 0);
		HEX1: out std_logic_vector(6 downto 0);
		HEX2: out std_logic_vector(6 downto 0);
		HEX3: out std_logic_vector(6 downto 0);
	);
end divider_combinational;

architecture structural of divider_combinational is
	signal dividend, divisor: std_logic_vector(7 downto 0);
	signal quotient, remainder: std_logic_vector(7 downto 0);
begin
	dividend <= SW(15 downto 8);
	divisor <= SW(7 downto 0);

	DIV: divider port map(dividend, divisor, quotient, remainder);
	
	H0: hex_to_7seg port map(remainder(3 downto 0), HEX0);
	H1: hex_to_7seg port map(remainder(7 downto 4), HEX1);
	H2: hex_to_7seg port map(quotient(3 downto 0), HEX2);
	H3: hex_to_7seg port map(quotient(7 downto 4), HEX3);
end structural;