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
	signal repetition: std_logic_vector(7 downto 0);
	signal nextRep: std_logic_vector(7 downto 0);
	type state_type is (s0, s1, s2a, s2b, s3, s4);
	signal state : state_type;
	
	signal clearValue: std_logic_vector(15 downto 0);
	signal initValue: std_logic_vector(15 downto 0);
	signal subValue: std_logic_vector(15 downto 0);
	signal successValue: std_logic_vector(15 downto 0);
	signal failValue: std_logic_vector(15 downto 0);
	
begin
	clearValue <= "0000000000000000";
	initValue <= "00000000" & dividend;
	
	-- SFTREG: shift_register port map(clk, clear, load, lr_sel, di, sdi, remainder);
	subValue(15 downto 8) <= remainder(15 downto 8);
	SUB: adder8 port map('1', remainder(7 downto 0), not divisor, subValue(7 downto 0), open);
	
	successValue(15 downto 1) <= remainder(14 downto 0);
	successValue(0) <= '1';
	
	failValue(15 downto 9) <= remainder(14 downto 8);
	ADD: adder8 port map('0', remainder(7 downto 0), divisor, failValue(8 downto 1), open);
	failValue(0) <= '0';
	
	REP_SUB: adder8 port map('0', repetition, "00000001", nextRep, open);
	
	process(clk, clear)
	begin
		if clear = '1' then
			remainder <= clearValue;
			state <= s0;
			repetition <= "00000000";
		elsif rising_edge(clk) then
			case state is
				when s0 =>
					remainder <= initValue;
					state <= S1;
				when s1 =>
					remainder <= subValue;
					if subValue(7) = '0' then
						-- success, go to s2a
						state <= s2a;
					else
						-- fail, go to s2b
						state <= s2b;
					end if;
				when s2a =>
					remainder <= successValue;
					state <= s3;
				when s2b =>
					remainder <= failValue;
					state <= s3;
				when s3 =>
					if repetition = "00001000" then -- 9th time when repetition is 8
						state <= s4;
					else
						repetition <= nextRep;
						state <= s1;
					end if;
				when others =>
					state <= state;
			end case;
		end if;
			
	end process;
end logicfunc;