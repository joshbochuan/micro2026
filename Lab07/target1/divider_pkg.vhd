library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use shift_reg_pkg.all;
use adder_pkg.all;

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
use shift_reg_pkg.all;

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
	type state_type is (S0, S1, S2a, S2b, S3, S4);
	signal state : state_type;
	
begin
	 -- add logic
	process(clk, clear)
	begin
		if clear = '1' then
			-- TODO
		elsif rising_edge(clock) then
			case state is
				when S0 =>
					SFTREG: shift_register port map(clk, clear,'1', '0', "00000000" & dividend, '0', remainder);
					-- SFTREG: shift_register port map(clk, clear, load, lr_sel, di, sdi, remainder);
					state <= S1;
				
				when s1 =>
					
					if remainder < 0 then
						state <= s2a;
					else
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
					
			
	end
end logicfunc;