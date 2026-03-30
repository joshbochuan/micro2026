library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.adder_package.all;

entity adder4 is
    port(
        cin  : in  std_logic;
        X    : in  std_logic_vector(3 downto 0);
        Y    : in  std_logic_vector(3 downto 0);
        S    : out std_logic_vector(3 downto 0);
        cout : out std_logic
    );
end adder4;

architecture structural of adder4 is
    signal C : std_logic_vector(4 downto 0);
begin
    C(0) <= cin;

    FA0: fulladd port map(C(0), X(0), Y(0), S(0), C(1));
    FA1: fulladd port map(C(1), X(1), Y(1), S(1), C(2));
    FA2: fulladd port map(C(2), X(2), Y(2), S(2), C(3));
    FA3: fulladd port map(C(3), X(3), Y(3), S(3), C(4));

    cout <= C(4);
end structural;
