Library IEEE;
use IEEE.STD_LOGIC_1164.all;

package alu_pkg is
	component alu1 is
		port (
			a: in STD_LOGIC;
			b: in STD_LOGIC;
			cin: in std_logic;
			ctrl: in STD_LOGIC_VECTOR(3 downto 0);
			res: out STD_LOGIC;
			cout: out std_logic
		);
	end component;
end alu_pkg;

Library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.alu_pkg.all;

entity alu1 is
	port (
		a: in STD_LOGIC;
		b: in STD_LOGIC;
		cin: in std_logic;
		ctrl: in STD_LOGIC_VECTOR(3 downto 0);
		res: out STD_LOGIC;
		cout: out std_logic
	);
end alu1;

architecture structural of alu1 is
	signal Ainvert: std_logic;
	signal Bnegate: std_logic;
	signal AandB: std_logic;
	signal AorB: std_logic;
	signal AplusB: std_logic;
begin
	Ainvert <= (a xor ctrl(3));
	Bnegate <= (b xor ctrl(2));
	AandB <= (Ainvert and Bnegate);
	AorB <= (Ainvert or Bnegate);
	AplusB <= (Ainvert xor Bnegate xor cin);
	cout <= (Ainvert and Bnegate) or (Ainvert and cin) or (Bnegate and cin);
	res <= (((not ctrl(0)) and (not ctrl(1)) and (Ainvert and Bnegate))
				or ((ctrl(0) and (not ctrl(1)) and AorB))
				or ((not ctrl(0)) and ctrl(1) and AplusB));
end architecture;