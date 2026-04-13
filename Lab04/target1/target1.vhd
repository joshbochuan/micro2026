Library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.alu_pkg.all;

entity target1 is
	Port (
		LEDR: out std_logic_vector(1 downto 0);
		SW: in std_logic_vector(6 downto 0)
	);
end target1;

architecture structural of target1 is
	signal cin: std_logic;
	signal a: std_logic;
	signal b: std_logic;
	signal ctrl: std_logic_vector(3 downto 0);
begin
	b <= SW(0);
	a <= SW(1);
	cin <= SW(2);
	ctrl <= SW(6 downto 3);
	FA0: alu1 port map(a, b, cin, ctrl, LEDR(0), LEDR(1));
end structural;