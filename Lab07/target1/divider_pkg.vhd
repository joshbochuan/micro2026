library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.shift_reg_pkg.all;
use work.adder_pkg.all;

package divider_pkg is
	component divider is
		port (
			clk: in std_logic;
			clear: in std_logic;
			divisor: in std_logic_vector(7 downto 0);
			dividend: in std_logic_vector(7 downto 0);
			remainder: buffer std_logic_vector(15 downto 0)
		);
	end component;
end package;
		
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.shift_reg_pkg.all;
use work.adder_pkg.all;

entity divider is
	port (
		clk: in std_logic;
		clear: in std_logic;
		divisor: in std_logic_vector(7 downto 0);
		dividend: in std_logic_vector(7 downto 0);
		remainder: buffer std_logic_vector(15 downto 0)
	);
end divider;

architecture logicfunc of divider is
	signal qo: std_logic_vector(15 downto 0);

	signal w: std_logic;
	type state_type is (s0, s1, s2a, s2b, s3, s4);
	signal state : state_type;
	
	signal shiftClear: std_logic_vector(15 downto 0);
	signal shiftInit: std_logic_vector(15 downto 0);
	signal shiftSub: std_logic_vector(15 downto 0);
	signal shiftBack: std_logic_vector(15 downto 0);
	
begin
	 -- add logic
	 
	shiftClear <= "0000000000000000";
	
	shiftInit <= "00000000" & dividend;
	
	-- SFTREG: shift_register port map(clk, clear, load, lr_sel, di, sdi, remainder);
	shiftSub(15 downto 9) <= remainder(14 downto 8);
	Q1_SUB: adder8 port map('1', remainder(7 downto 0), not divisor, shiftSub(8 downto 1));
	shiftSub(0) <= '1';
	
	shiftBack(15 downto 1) <= remainder(14 downto 0);
	shiftBack(0) <= '0';
	
	process(clk, clear)
	begin
		if clear = '1' then
			remainder <= shiftClear;
			state <= s0;
		elsif rising_edge(clk) then
			case state is
				when s0 =>
					remainder <= shiftInit;
					state <= S1;
				when s1 =>
					if shiftSub(7) = '0' then
						remainder <= shiftSub;
						state <= s2a;
					else
						remainder <= shiftBack;
						state <= s2b;
					end if;
				when s2a =>
					state <= s3;
				when s2b =>
					state <= s3;
				when s3 =>
					if w = '0' then
						state <= s1;
					else
						state <= s4;
					end if;
				when others =>
					state <= state;
			end case;
		end if;
			
	end process;
end logicfunc;