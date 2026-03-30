library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package adder_package is

    component fulladd is
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

    component bcd4 is
        port(
            cin  : in  std_logic;
            A    : in  std_logic_vector(3 downto 0);
            B    : in  std_logic_vector(3 downto 0);
            S    : out std_logic_vector(3 downto 0);
            cout : out std_logic
        );
    end component;

end adder_package;

package body adder_package is
end adder_package;
