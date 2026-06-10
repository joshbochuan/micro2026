Library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.alu_pkg.all;
use work.divider_pkg.all;
use work.sevenseg_pkg.all;

entity target1 is
    port (
        SW   : in  std_logic_vector(16 downto 0);
        KEY  : in  std_logic_vector(0 downto 0);
        LEDR : out std_logic_vector(15 downto 0);

        HEX0 : out std_logic_vector(6 downto 0);
        HEX1 : out std_logic_vector(6 downto 0);
        HEX2 : out std_logic_vector(6 downto 0);
        HEX3 : out std_logic_vector(6 downto 0);
        HEX4 : out std_logic_vector(6 downto 0);
        HEX5 : out std_logic_vector(6 downto 0)
    );
end target1;

architecture structural of target1 is
    signal data   : std_logic_vector(7 downto 0);
    signal opcode : std_logic_vector(3 downto 0);
    signal rs     : std_logic_vector(1 downto 0);
    signal rt     : std_logic_vector(1 downto 0);

    signal clock : std_logic;
    signal reset : std_logic;

    signal R0, R1, R2, R3 : std_logic_vector(7 downto 0) := (others => '0');

    signal rs_value : std_logic_vector(7 downto 0);
    signal rt_value : std_logic_vector(7 downto 0);
	 
	 signal add_value: std_logic_vector(7 downto 0);
	 signal and_value: std_logic_vector(7 downto 0);
	 signal subAB_value: std_logic_vector(7 downto 0);
	 signal subBA_value: std_logic_vector(7 downto 0);
	 signal slt_value: std_logic_vector(7 downto 0);
	 signal div_value: std_logic_vector(7 downto 0);
begin

    -- switch input
    data   <= SW(7 downto 0);
    opcode <= SW(11 downto 8);
    rs     <= SW(13 downto 12);
    rt     <= SW(15 downto 14);

    clock <= KEY(0);
    reset <= SW(16);

    LEDR(7 downto 0)   <= data;
    LEDR(11 downto 8)  <= opcode;
    LEDR(13 downto 12) <= rs;
    LEDR(15 downto 14) <= rt;

    with rs select
        rs_value <= R0 when "00",
                    R1 when "01",
                    R2 when "10",
                    R3 when others;

    with rt select
        rt_value <= R0 when "00",
                    R1 when "01",
                    R2 when "10",
                    R3 when others;
	
	 -- alu: 
	-- 0000 and
	-- 0001 or
	-- 0010 add
	-- 0110 subtract
	-- 0111 set-less-than
	-- 1100 nor
    ALU_ADD: alu8 port map(rs_value, rt_value, "0010", add_value);
	 ALU_AND: alu8 port map(rs_value, rt_value, "0000", and_value);
	 ALU_SUBAB: alu8 port map(rs_value, rt_value, "0110", subAB_value);
	 ALU_SUBBA: alu8 port map(rt_value, rs_value, "0110", subBA_value);
	 ALU_SLT: alu8 port map(rs_value, rt_value, "0111", slt_value);
	 
	 with rt_value select
		div_value <= "00000000" when "00000000",
						 std_logic_vector(unsigned(rs_value) / unsigned(rt_value)) when others;
						  
    process(clock, reset)
		variable res : std_logic_vector(7 downto 0);
    begin
        if reset = '1' then
            R0 <= (others => '0');
            R1 <= (others => '0');
            R2 <= (others => '0');
            R3 <= (others => '0');

        elsif rising_edge(clock) then
			  case opcode is
					when "0000" => res := data;
					when "0001" => res := rt_value;
					when "0010" => res := add_value;
					when "0011" => res := and_value;
					when "0101" => res := subAB_value;
					when "1001" => res := subBA_value;
					when "0100" => res := slt_value;
					when "1000" => res := div_value;
					when others => res := rs_value;
			  end case;
			  
			  case rs is
					when "00" => R0 <= res;
					when "01" => R1 <= res;
					when "10" => R2 <= res;
					when "11" => R3 <= res;
					when others => null;
			  end case;
        end if;
    end process;

    H0: hex_to_7seg port map(data(3 downto 0), HEX0);
    H1: hex_to_7seg port map(data(7 downto 4), HEX1);

    H2: hex_to_7seg port map(rs_value(3 downto 0), HEX2);
    H3: hex_to_7seg port map(rs_value(7 downto 4), HEX3);

    H4: hex_to_7seg port map(rt_value(3 downto 0), HEX4);
    H5: hex_to_7seg port map(rt_value(7 downto 4), HEX5);

end structural;