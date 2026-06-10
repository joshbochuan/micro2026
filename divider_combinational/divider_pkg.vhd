library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

package divider_pkg is
	component divider is
		generic (n: integer := 8);
		port(
			dividend: in std_logic_vector(n-1 downto 0);
			divisor: in std_logic_vector(n-1 downto 0);
			quotient: out std_logic_vector(n-1 downto 0);
			remainder: out std_logic_vector(n-1 downto 0)
		);
	end component;
end divider_pkg;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity divider is
	generic (n: integer := 8);
	port(
		dividend: in std_logic_vector(n-1 downto 0);
		divisor: in std_logic_vector(n-1 downto 0);
		quotient: out std_logic_vector(n-1 downto 0);
		remainder: out std_logic_vector(n-1 downto 0)
	);
end divider8;

architecture structural of divider is
	signal buf: std_logic_vector((2*n)-1 downto 0);
	signal sub_value: std_logic_vector(n-1 downto 0);
begin
	process(dividend, divisor)
	begin
		buf(n downto 1) <= dividend;
		for i in 1 to n loop
			sub_value <= std_logic_vector(signed(buf(2*n-2 downto n-1)) - signed(divisor));
			if (buf(2*n-1) = '1') then
				buf(2*n-1 downto n) <= buf(2*n-2 downto n-1);
				buf(n-1 downto 1) <= buf(n-2 downto 0);
				buf(0) <= '0';
			else
				buf(2*n-1 downto n) <= sub_value;
				buf(n-1 downto 1) <= buf(n-2 downto 0);
				buf(0) <= '1';
			end if;
		end loop;
		buf(2*n-2 downto n) <= buf(2*n-1 downto n+1);
		buf(2*n-1) <= '0';
		quotient <= buf(n-1 downto 0);
		remainder <= buf(2*n-1 downto n);
	end process;
end structural;