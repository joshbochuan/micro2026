library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package adder_pkg is

    component adder1 is
        port(
            cin, x, y : in  std_logic;
            s, cout   : out std_logic
        );
    end component;

    component adder4 is
        port(
            cin  : in  std_logic;
            X    : in  std_logic_vector(3 downto 0);
            Y    : in  std_logic_vector(3 downto 0);
            S    : out std_logic_vector(3 downto 0);
            cout : out std_logic
        );
    end component;

	 component adder8 is
		 Port (
			  cin  : in  STD_LOGIC;
			  X    : in  STD_LOGIC_VECTOR(7 downto 0);
			  Y    : in  STD_LOGIC_VECTOR(7 downto 0);
			  S  : out STD_LOGIC_VECTOR(7 downto 0);
			  cout : out STD_LOGIC
		 );
	 end component;	 
	 
    component bcd_adder4 is
        port(
            cin  : in  std_logic;
            A    : in  std_logic_vector(3 downto 0);
            B    : in  std_logic_vector(3 downto 0);
            S    : out std_logic_vector(3 downto 0);
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
	 FA0: adder1 port map(C(0), X(0), Y(0), S(0), C(1));
	 FA1: adder1 port map(C(1), X(1), Y(1), S(1), C(2));
	 FA2: adder1 port map(C(2), X(2), Y(2), S(2), C(3));
	 FA3: adder1 port map(C(3), X(3), Y(3), S(3), C(4));
	 cout <= C(4);
end structural;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.adder_pkg.all;
entity adder8 is
	 Port (
		  cin  : in  STD_LOGIC;
		  X    : in  STD_LOGIC_VECTOR(7 downto 0);
		  Y    : in  STD_LOGIC_VECTOR(7 downto 0);
		  S  : out STD_LOGIC_VECTOR(7 downto 0);
		  cout : out STD_LOGIC
	 );
end adder8;

architecture Structural of adder8 is
	 signal C : STD_LOGIC_VECTOR(8 downto 0);
begin
	 C(0) <= cin;
	 FA0: adder1 port map(C(0), X(0), Y(0), S(0), C(1));
	 FA1: adder1 port map(C(1), X(1), Y(1), S(1), C(2));
	 FA2: adder1 port map(C(2), X(2), Y(2), S(2), C(3));
	 FA3: adder1 port map(C(3), X(3), Y(3), S(3), C(4));
	 FA4: adder1 port map(C(4), X(4), Y(4), S(4), C(5));
	 FA5: adder1 port map(C(5), X(5), Y(5), S(5), C(6));
	 FA6: adder1 port map(C(6), X(6), Y(6), S(6), C(7));
	 FA7: adder1 port map(C(7), X(7), Y(7), S(7), C(8));
	 Cout <= C(8);
end Structural;	

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.adder_pkg.all;
entity bcd_adder4 is
	 port(
		  cin  : in  std_logic;
		  A    : in  std_logic_vector(3 downto 0);
		  B    : in  std_logic_vector(3 downto 0);
		  S    : out std_logic_vector(3 downto 0);
		  cout : out std_logic
	 );
end bcd_adder4;

architecture structural of bcd_adder4 is
	 signal sum_raw  : std_logic_vector(3 downto 0);
	 signal sum_fix  : std_logic_vector(3 downto 0);
	 signal c_raw    : std_logic;
	 signal c_fix    : std_logic;
	 signal need_fix : std_logic;
begin
	 -- 第一次: A + B + cin
	 U0: adder4
		  port map(cin, A, B, sum_raw, c_raw);
	 -- 是否需要 BCD 修正(+6)
	 need_fix <= c_raw or (sum_raw(3) and sum_raw(2)) or (sum_raw(3) and sum_raw(1));
	 -- 第二次: 若需要則 +0110
	 U1: adder4
		  port map('0', sum_raw, "0110", sum_fix, c_fix);
	 -- 輸出選擇
	 S(0) <= (need_fix and sum_fix(0)) or ((not need_fix) and sum_raw(0));
	 S(1) <= (need_fix and sum_fix(1)) or ((not need_fix) and sum_raw(1));
	 S(2) <= (need_fix and sum_fix(2)) or ((not need_fix) and sum_raw(2));
	 S(3) <= (need_fix and sum_fix(3)) or ((not need_fix) and sum_raw(3));
	 -- BCD 進位
	 cout <= need_fix;
end structural;
