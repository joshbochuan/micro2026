Library IEEE;
use IEEE.STD_LOGIC_1164.all;

package alu_pkg is
	component alu1 is
		port (
			a: in STD_LOGIC;
			b: in STD_LOGIC;
			cin: in std_logic;
			less: in std_logic;
			ctrl: in STD_LOGIC_VECTOR(3 downto 0);
			res: out STD_LOGIC;
			cout: out std_logic;
			set: out std_logic;
			overflow: out std_logic
		);
	end component;
	
	component alu7 is
	   port(
		    a: in STD_LOGIC_VECTOR(6 downto 0);
			 b: in STD_LOGIC_VECTOR(6 downto 0);
			 ctrl: in STD_LOGIC_VECTOR(3 downto 0);
			 res: out STD_LOGIC_VECTOR(6 downto 0);
			 cout: out std_logic;
			 overflow: out std_logic
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
		less: in std_logic;
		ctrl: in STD_LOGIC_VECTOR(3 downto 0);
		res: out STD_LOGIC;
		cout: out std_logic;
		set: out std_logic;
		overflow: out std_logic
	);
end alu1;

architecture structural of alu1 is
	signal Ainvert: std_logic;
	signal Bnegate: std_logic;
	signal AandB: std_logic;
	signal AorB: std_logic;
	signal AplusB: std_logic;
	signal carry: std_logic;
begin
	Ainvert <= (a xor ctrl(3));
	Bnegate <= (b xor ctrl(2));
	AandB <= (Ainvert and Bnegate);
	AorB <= (Ainvert or Bnegate);
	AplusB <= (Ainvert xor Bnegate xor cin);
	carry <= (Ainvert and Bnegate) or (Ainvert and cin) or (Bnegate and cin);
	cout <= carry;
	res <= (((not ctrl(0)) and (not ctrl(1)) and AandB)
				or ((ctrl(0) and (not ctrl(1)) and AorB))
				or ((not ctrl(0)) and ctrl(1) and AplusB)
				or (ctrl(0) and ctrl(1) and less));
	set <= AplusB;
	overflow <= cin xor carry;
end structural;

Library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.alu_pkg.all;

entity alu7 is
	port(
		 a: in STD_LOGIC_VECTOR(6 downto 0);
		 b: in STD_LOGIC_VECTOR(6 downto 0);
		 ctrl: in STD_LOGIC_VECTOR(3 downto 0);
		 res: out STD_LOGIC_VECTOR(6 downto 0);
		 cout: out std_logic;
		 overflow: out std_logic
	);
end alu7;

architecture structural of alu7 is
	signal c : STD_LOGIC_VECTOR(7 downto 0);
	signal set: std_logic;
begin
	c(0) <= ctrl(2);
	GEN_ALU : for i in 0 to 7 generate
	
		ALU_LSB: if i = 0 generate
			ALU_LSB_INST: alu1 port map(a(i), b(i), ctrl(2), '0', ctrl, open, c(i+1), open, open);
		end generate ALU_LSB;
		
		ALU_MIDDLE: if ((i>0) and (i<6)) generate
			ALU_MIDDLE_INST: alu1 port map(a(i), b(i), c(i), '0', ctrl, res(i), c(i+1), open, open);
		end generate ALU_MIDDLE;
		
		ALU_MSB: if i = 6 generate
			ALU_MSB_INST: alu1 port map(a(i), b(i), c(i), '0', ctrl, res(i), cout, set, overflow);
		end generate ALU_MSB;
		
		ALU_LAST: if i = 7 generate
			ALU_LAST_INST: alu1 port map(a(0), b(0), ctrl(2), set, ctrl, res(0), open, open);
		end generate ALU_LAST;
		
	end generate GEN_ALU;
end structural;