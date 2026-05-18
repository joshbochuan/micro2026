library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

package shift_reg_pkg is
	component shift_register is
		generic (n: integer := 16);
		port (
			clk: in std_logic;
			clear: in std_logic;
			load: in std_logic;
			lr_sel: in std_logic;
			di: in std_logic_vector(n-1 downto 0);
			sdi: in std_logic;
			qo: buffer std_logic_vector(n-1 downto 0)
		);
	end component;
end shift_reg_pkg;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.shift_reg_pkg.all;

entity shift_register is
	generic(n: integer:= 16);
	port (
		clk: in std_logic;
		clear: in std_logic;
		load: in std_logic;
		lr_sel: in std_logic;
		di: in std_logic_vector(n-1 downto 0);
		sdi: in std_logic;
		qo: buffer std_logic_vector(n-1 downto 0)
	);
end shift_register;

architecture structural of shift_register is
begin
	process(clk, clear)
	begin
		if clear = '1' then
			for i in 0 to n-1 loop
				qo(i) <= '0';
			end loop;
		elsif rising_edge(clk) then
			if load = '1' then
				qo <= di;
			elsif lr_sel = '1' then
				for i in n-1 downto 1 loop
					qo(i) <= qo(i-1);
				end loop;
				qo(0) <= sdi;
			else
				for i in 0 to n-2 loop
					qo(i) <= qo(i+1);
				end loop;
				qo(n-1) <= sdi;
			end if;
		end if;
	end process;
end structural;