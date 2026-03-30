library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package sevenseg_pkg is
    subtype nibble_t is STD_LOGIC_VECTOR(3 downto 0);
    subtype seg7_t   is STD_LOGIC_VECTOR(6 downto 0);
    function hex_to_7seg(wxyz : nibble_t) return seg7_t;
end sevenseg_pkg;

package body sevenseg_pkg is
function hex_to_7seg(wxyz : nibble_t) return seg7_t is
    variable w, x, y, z : STD_LOGIC;
    variable a, b, c, d, e, f, g : STD_LOGIC;
    variable seg : seg7_t;
begin
    w := wxyz(3);
    x := wxyz(2);
    y := wxyz(1);
    z := wxyz(0);

    a := (not w and not x and not y and z) or
         (not w and x and not y and not z) or
         (w and not x and y and z) or
         (w and x and not y and not z) or
         (w and x and not y and z);

    b := (not w and x and not y and z) or
         (not w and x and y and not z) or
         (w and not x and y and z) or
         (w and x and not y and not z) or
         (w and x and y and not z) or
         (w and x and y and z);

    c := (not w and not x and y and not z) or
         (w and x and not z) or
         (w and x and y);

    d := (not x and not y and z) or
         (not w and x and not y and not z) or
         (x and y and z) or
         (w and not x and y and not z);

    e := (not w and z) or
         (not w and x and not y) or
         (not x and not y and z);

    f := (not w and not x and z) or
         (not w and not x and y) or
         (not w and y and z) or
         (w and x and not y);

    g := (not w and not x and not y) or
         (not w and x and y and z);

    seg(0) := a;
    seg(1) := b;
    seg(2) := c;
    seg(3) := d;
    seg(4) := e;
    seg(5) := f;
    seg(6) := g;
    return seg;
end function;
end sevenseg_pkg;
