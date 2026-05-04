library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.shift_reg_pkg.all;

entity target1 is
	port (
		SW: in std_logic_vector(11 downto 0);
		KEY: in std_logic_vector(1 downto 0);
		LEDR: out std_logic_vector(5 downto 0)
	);
end target1;

architecture Behavorial of target1 is
	signal di: std_logic_vector(5 downto 0);
	signal load: std_logic;
	signal lr_sel: std_logic;
	signal clk: std_logic;
	signal clear: std_logic;
	signal sdi: std_logic;
	signal qo: std_logic_vector(5 downto 0);
begin
	di <= SW(5 downto 0);
	load <= SW(8);
	lr_sel <= SW(9);
	clk <= KEY(0);
	clear <= SW(10);
	sdi <= SW(11);
	
	SFTREG: shift_register port map(clk, clear, load, lr_sel, di, sdi, qo);
	
	LEDR <= qo;
	
end Behavorial;