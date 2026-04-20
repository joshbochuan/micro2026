Library IEEE;
use IEEE.STD_LOGIC_1164.all;

use work.adder_pkg.all;
use work.sevenseg_pkg.all;

entity Lab04_bonus is
	port(
		SW: in std_logic_vector(17 downto 0);
		HEX0: out std_logic_vector(6 downto 0);
		HEX1: out std_logic_vector(6 downto 0)
	);
end Lab04_bonus;

architecture structural of Lab04_bonus is
	signal a: std_logic_vector(6 downto 0);
	signal b: std_logic_vector(6 downto 0);
	signal opCode: std_logic_vector(3 downto 0);
	signal res: std_logic_vector(6 downto 0);
	signal add: std_logic_vector(6 downto 0);
	signal sub: std_logic_vector(6 downto 0);
begin
	opCode <= SW(17 downto 14);
	a <= SW(13 downto 7);
	b <= SW(6 downto 0);
	
	FA_ADD: adder7 port map('0', a, b, add, open);
	FA_SUB: adder7 port map('1', a, not b, sub, open);
	
	process (a, b, opCode)
	begin
		case opCode is
			when "0000" => res <= a and b;
			when "0001" => res <= a or b;
			when "0010" => res <= add;
			when "0110" => res <= sub;
			when "0111" => res <= "000000" & sub(6);
			when "1100" => res <= a nor b;
			when others => res <= "0000000";
		end case;
	end process;
		
	HEX0 <= hex_to_7seg(res(3 downto 0));
	HEX1 <= hex_to_7seg("0" & res(6 downto 4));
	
end structural;