library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity segmentDisplay2 is
    Port (
        x, y : in  STD_LOGIC;
        a1, b1, c1, d1, e1, f1, g1, a2, b2, c2, d2, e2, f2, g2 : out STD_LOGIC
    );
end segmentDisplay2;

architecture BooleanLogic of segmentDisplay2 is
begin
	-- 03, 12
	a1 <= y;
	b1 <= '0';
	c1 <= '0';
	d1 <= y;
	e1 <= y;
	f1 <= y;
	g1 <= '1';
	a2 <= '0';
	b2 <= '0';
	c2 <= y;
	d2 <= '0';
	e2 <= x;
	f2 <= '1';
	g2 <= '0';
end BooleanLogic;