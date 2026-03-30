library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.adder_package.all;

entity sub9 is
    Port (
		  cin  : in  STD_LOGIC;
        X    : in  STD_LOGIC_VECTOR(7 downto 0);
        Y    : in  STD_LOGIC_VECTOR(7 downto 0);
        S  : out STD_LOGIC_VECTOR(8 downto 0);
        cout : out STD_LOGIC
    );
end sub9;

architecture Structural of sub9 is

    signal C : STD_LOGIC_VECTOR(9 downto 0);

begin

    C(0) <= cin;

    FA0: fulladd port map(C(0), X(0), not Y(0), S(0), C(1));
	 FA1: fulladd port map(C(1), X(1), not Y(1), S(1), C(2));
	 FA2: fulladd port map(C(2), X(2), not Y(2), S(2), C(3));
	 FA3: fulladd port map(C(3), X(3), not Y(3), S(3), C(4));
	 FA4: fulladd port map(C(4), X(4), not Y(4), S(4), C(5));
	 FA5: fulladd port map(C(5), X(5), not Y(5), S(5), C(6));
	 FA6: fulladd port map(C(6), X(6), not Y(6), S(6), C(7));
	 FA7: fulladd port map(C(7), X(7), not Y(7), S(7), C(8));
	 FA8: fulladd port map(C(8), '0', '1', S(8), C(9));

    Cout <= C(9);

end Structural;