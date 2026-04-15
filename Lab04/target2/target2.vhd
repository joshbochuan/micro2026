Library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.all;
use work.sevenseg_pkg.all;

entity target2 is
	Port (
		SW: in std_logic_vector(17 downto 0);
		HEX0: out std_logic_vector(6 downto 0);
		HEX1: out std_logic_vector(6 downto 0)
	);
end target2;

architecture structure of target2 is
	signal a: std_logic_vector(6 downto 0);
	signal b: std_logic_vector(6 downto 0);
	signal ctrl: std_logic_vector(3 downto 0);
	signal res: std_logic_vector(6 downto 0);
begin
	b <= SW(6 downto 0);
	a <= SW(13 downto 7);
	ctrl <= SW(17 downto 14);
	ALU: alu7 port map (
		a => a,
		b => b,
		ctrl => ctrl,
		res => res,
		cout => open,
		overflow => open
	);
	HEX0 <= hex_to_7seg(res(3 downto 0));
	HEX1 <= hex_to_7seg("0"&res(6 downto 4));
end structure;