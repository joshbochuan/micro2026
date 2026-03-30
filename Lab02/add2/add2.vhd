library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.adder_package.all;
use work.sevenseg_pkg.all;

entity add2 is
port (
	X: in std_logic_vector(7 downto 0);
	Y: in std_logic_vector(7 downto 0);
	H0: out std_logic_vector(6 downto 0);
	H1: out std_logic_vector(6 downto 0);
	cout: out std_logic;
	neg: out std_logic
);
end add2;

architecture a of add2 is
	signal m0, m1: std_logic_vector(3 downto 0);
	signal sign: std_logic;
	signal S: std_logic_vector(8 downto 0);
	signal res: std_logic_vector(7 downto 0);
	signal mask: std_logic_vector(7 downto 0);
begin
	FA0: sub9 port map('1', X, Y, S, cout);
	sign <= S(8);
	
	-- convert S to positive
	mask(7) <= sign;
	mask(6) <= sign;
	mask(5) <= sign;
	mask(4) <= sign;
	mask(3) <= sign;
	mask(2) <= sign;
	mask(1) <= sign;
	mask(0) <= sign;
	FA1: adder8 port map(sign, (S(7 downto 0) xor mask), "00000000", res, open);
	
	m0 <= res(3 downto 0);
	m1 <= res(7 downto 4);
	H0 <= hex_to_7seg(m0);
	H1 <= hex_to_7seg(m1);
	neg <= not sign;
	
end a;