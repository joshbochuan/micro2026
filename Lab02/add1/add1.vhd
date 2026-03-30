library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.adder_package.all;
use work.sevenseg_pkg.all;



entity add1 is
port (
	X: in std_logic_vector(7 downto 0);
	Y: in std_logic_vector(7 downto 0);
	H0: out std_logic_vector(6 downto 0);
	H1: out std_logic_vector(6 downto 0);
	cout: out std_logic
);
end add1;

architecture a of add1 is
	signal m0, m1: std_logic_vector(3 downto 0);
	signal S: std_logic_vector(7 downto 0);
begin
	FA0: adder8 port map('0', X, Y, S, cout);
	m0 <= S(3 downto 0);
	m1 <= S(7 downto 4);
	H0 <= hex_to_7seg(m0);
	H1 <= hex_to_7seg(m1);
	
end a;