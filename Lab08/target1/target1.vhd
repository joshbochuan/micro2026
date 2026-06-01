library ieee;
use ieee.std_logic_1164.all;
use work.adder_pkg.all;
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

    type state_type is (S_WAIT);
    signal state : state_type := S_WAIT;

    signal data   : std_logic_vector(7 downto 0);
    signal opcode : std_logic_vector(3 downto 0);
    signal rs     : std_logic_vector(1 downto 0);
    signal rt     : std_logic_vector(1 downto 0);

    signal clock : std_logic;
    signal reset : std_logic;

    signal R0, R1, R2, R3 : std_logic_vector(7 downto 0) := (others => '0');

    signal rs_value : std_logic_vector(7 downto 0);
    signal rt_value : std_logic_vector(7 downto 0);

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

    process(clock, reset)
    begin
        if reset = '1' then
            R0 <= (others => '0');
            R1 <= (others => '0');
            R2 <= (others => '0');
            R3 <= (others => '0');
            state <= S_WAIT;

        elsif falling_edge(clock) then
            case state is

                when S_WAIT =>
                    case opcode is

                        -- Load Rs
                        -- Rs <= Data
                        when "0000" =>
                            case rs is
                                when "00" => R0 <= data;
                                when "01" => R1 <= data;
                                when "10" => R2 <= data;
                                when "11" => R3 <= data;
                                when others => null;
                            end case;

                        -- Move Rs, Rt
                        -- Rs <= Rt
                        when "0001" =>
                            case rs is
                                when "00" => R0 <= rt_value;
                                when "01" => R1 <= rt_value;
                                when "10" => R2 <= rt_value;
                                when "11" => R3 <= rt_value;
                                when others => null;
                            end case;

                        when others =>
                            null;

                    end case;

                    state <= S_WAIT;

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