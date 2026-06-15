library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package sevenseg_pkg is
	component hex_to_7seg is
		port (
			hex: in std_logic_vector(3 downto 0);
			res: out std_logic_vector(6 downto 0)
		);
	end component;
end sevenseg_pkg;

package body sevenseg_pkg is
end sevenseg_pkg;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.sevenseg_pkg.all;

entity hex_to_7seg is
port (
		hex: in std_logic_vector(3 downto 0);
		res: out std_logic_vector(6 downto 0)
	);
end hex_to_7seg;

architecture structural of hex_to_7seg is
begin
	res(0) <= (not hex(3) and not hex(2) and not hex(1) and hex(0)) or
			(not hex(3) and hex(2) and not hex(1) and not hex(0)) or
			(hex(3) and not hex(2) and hex(1) and hex(0)) or
			(hex(3) and hex(2) and not hex(1) and not hex(0)) or
			(hex(3) and hex(2) and not hex(1) and hex(0));

	res(1) <= (not hex(3) and hex(2) and not hex(1) and hex(0)) or
			(not hex(3) and hex(2) and hex(1) and not hex(0)) or
			(hex(3) and not hex(2) and hex(1) and hex(0)) or
			(hex(3) and hex(2) and not hex(1) and not hex(0)) or
			(hex(3) and hex(2) and hex(1) and not hex(0)) or
			(hex(3) and hex(2) and hex(1) and hex(0));

	res(2) <= (not hex(3) and not hex(2) and hex(1) and not hex(0)) or
			(hex(3) and hex(2) and not hex(0)) or
			(hex(3) and hex(2) and hex(1));

	res(3) <= (not hex(2) and not hex(1) and hex(0)) or
			(not hex(3) and hex(2) and not hex(1) and not hex(0)) or
			(hex(2) and hex(1) and hex(0)) or
			(hex(3) and not hex(2) and hex(1) and not hex(0));

	res(4) <= (not hex(3) and hex(0)) or
			(not hex(3) and hex(2) and not hex(1)) or
			(not hex(2) and not hex(1) and hex(0));

	res(5) <= (not hex(3) and not hex(2) and hex(0)) or
			(not hex(3) and not hex(2) and hex(1)) or
			(not hex(3) and hex(1) and hex(0)) or
			(hex(3) and hex(2) and not hex(1));

	res(6) <= (not hex(3) and not hex(2) and not hex(1)) or
			(not hex(3) and hex(2) and hex(1) and hex(0));
			
end structural;


