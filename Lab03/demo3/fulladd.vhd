library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fulladd is
    port (
        cin, x, y : in  std_logic;
        s, cout   : out std_logic
    );
end fulladd;

architecture func of fulladd is
begin
    s    <= x xor y xor cin;
    cout <= (x and y) or (cin and x) or (cin and y);
end func;
