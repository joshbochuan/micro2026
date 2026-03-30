library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity segmentDisplay1 is
    Port (
        w, x, y, z : in  STD_LOGIC;
        a, b, c, d, e, f, g : out STD_LOGIC
    );
end segmentDisplay1;

architecture BooleanLogic of segmentDisplay1 is
begin

    ------------------------------------------------------------------
    -- a = Σ(1,4,11,12,13)
    ------------------------------------------------------------------
    a <= (not w and not x and not y and z) or
         (not w and x and not y and not z) or
         (w and not x and y and z) or
         (w and x and not y and not z) or
         (w and x and not y and z);

    ------------------------------------------------------------------
    -- b = Σ(5,6,11,12,14,15)
    ------------------------------------------------------------------
    b <= (not w and x and not y and z) or
         (not w and x and y and not z) or
         (w and not x and y and z) or
         (w and x and not y and not z) or
         (w and x and y and not z) or
         (w and x and y and z);

    ------------------------------------------------------------------
    -- c = w'x'yz' + wxz' + wxy
    ------------------------------------------------------------------
    c <= (not w and not x and y and not z) or
         (w and x and not z) or
         (w and x and y);

    ------------------------------------------------------------------
    -- d = x'y'z + w'xy'z' + xyz + wx'yz'
    ------------------------------------------------------------------
    d <= (not x and not y and z) or
         (not w and x and not y and not z) or
         (x and y and z) or
         (w and not x and y and not z);

    ------------------------------------------------------------------
    -- e = w'z + w'xy' + x'y'z
    ------------------------------------------------------------------
    e <= (not w and z) or
         (not w and x and not y) or
         (not x and not y and z);

    ------------------------------------------------------------------
    -- f = w'x'z + w'x'y + w'yz + wxy'
    ------------------------------------------------------------------
    f <= (not w and not x and z) or
         (not w and not x and y) or
         (not w and y and z) or
         (w and x and not y);

    ------------------------------------------------------------------
    -- g = w'x'y' + w'xyz
    ------------------------------------------------------------------
    g <= (not w and not x and not y) or
         (not w and x and y and z);

end BooleanLogic;