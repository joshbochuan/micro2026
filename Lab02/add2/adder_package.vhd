library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package adder_package is

   component fulladd
		port (cin, x, y : in std_logic;
				s, cout : out std_logic);
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
	
	component sub9 is
		 Port (
			  cin  : in  STD_LOGIC;
			  X    : in  STD_LOGIC_VECTOR(7 downto 0);
			  Y    : in  STD_LOGIC_VECTOR(7 downto 0);
			  S  : out STD_LOGIC_VECTOR(8 downto 0);
			  cout : out STD_LOGIC
		 );
	end component;

end adder_package;



package body adder_package is
end adder_package;