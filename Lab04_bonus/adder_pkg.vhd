library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package adder_pkg is

    component adder1 is
        port(
            cin, x, y : in  std_logic;
            s, cout   : out std_logic
        );
    end component;

    component adder7 is
        port(
            cin  : in  std_logic;
            X    : in  std_logic_vector(6 downto 0);
            Y    : in  std_logic_vector(6 downto 0);
            S    : out std_logic_vector(6 downto 0);
            cout : out std_logic
        );
    end component;

end adder_pkg;

package body adder_pkg is
end adder_pkg;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity adder1 is
	 port (
		  cin, x, y : in  std_logic;
		  s, cout   : out std_logic
	 );
end adder1;

architecture func of adder1 is
begin
	 s    <= x xor y xor cin;
	 cout <= (x and y) or (cin and x) or (cin and y);
end func;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.adder_pkg.all;
entity adder7 is
	 port(
		  cin  : in  std_logic;
		  X    : in  std_logic_vector(6 downto 0);
		  Y    : in  std_logic_vector(6 downto 0);
		  S    : out std_logic_vector(6 downto 0);
		  cout : out std_logic
	 );
end adder7;

architecture structural of adder7 is
	 signal C : std_logic_vector(7 downto 0);
begin
	 C(0) <= cin;
	 FA0: adder1 port map(C(0), X(0), Y(0), S(0), C(1));
	 FA1: adder1 port map(C(1), X(1), Y(1), S(1), C(2));
	 FA2: adder1 port map(C(2), X(2), Y(2), S(2), C(3));
	 FA3: adder1 port map(C(3), X(3), Y(3), S(3), C(4));
	 FA4: adder1 port map(C(4), X(4), Y(4), S(4), C(5));
	 FA5: adder1 port map(C(5), X(5), Y(5), S(5), C(6));
	 FA6: adder1 port map(C(6), X(6), Y(6), S(6), C(7));
	 cout <= C(7);
end structural;
