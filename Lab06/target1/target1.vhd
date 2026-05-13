library ieee;
use ieee.std_logic_1164.all;

entity target1 is
	port (
		SW: in std_logic_vector(1 downto 0);
		KEY: in std_logic_vector(0 downto 0);
		LEDR: out std_logic_vector(3 downto 1)
	);
end target1;

architecture behavioral of target1 is
	type state_type is (start, s1, s2a, s2b, s3, s4);
	signal state: state_type;
	signal w: std_logic;
	signal reset: std_logic;
	signal clock: std_logic;
	signal output: std_logic_vector(2 downto 0);
begin
	w <= SW(0);
	reset <= SW(1);
	clock <= KEY(0);
	
	process (reset, clock)
	begin
		if (reset = '1') then
			state <= start;
		elsif (rising_edge(clock)) then
			case state is
				when start =>
					if w = '0' then
						state <= start;
					else
						state <= s1;
					end if;
				when s1 =>
					if w = '0' then
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
	end process;
	
	with state select
		output <=   "000" when start,
						"001" when s1,
						"010" when s2a,
						"011" when s2b,
						"100" when s3,
						"101" when s4,
						"111" when others;
	
	LEDR(3 downto 1) <= output(2 downto 0);
end behavioral;