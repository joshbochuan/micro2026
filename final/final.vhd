library ieee;
use ieee.std_logic_1164.all;
use work.cpu_pkg.all;
use work.sevenseg_pkg.all;

entity final is
    port (
        SW   : in  std_logic_vector(15 downto 0);
        KEY  : in  std_logic_vector(0 downto 0);
        
        HEX0 : out std_logic_vector(6 downto 0);
        HEX1 : out std_logic_vector(6 downto 0);
        HEX2 : out std_logic_vector(6 downto 0);
        HEX3 : out std_logic_vector(6 downto 0);
        HEX4 : out std_logic_vector(6 downto 0);
        HEX5 : out std_logic_vector(6 downto 0);
		  HEX6 : out std_logic_vector(6 downto 0);
		  
		  LEDR : out std_logic_vector(7 downto 0);
		  LEDG : out std_logic_vector(1 downto 0)
    );
end final;

architecture Structural of final is
	signal data: std_logic_vector(7 downto 0);
	signal opcode: std_logic_vector(4 downto 0);
	signal rs, rt: std_logic_vector(1 downto 0);
	signal clock: std_logic;
	
	signal rsValue, rtValue: std_logic_vector(7 downto 0);
	signal ifOp, idOp, exOp: std_logic_vector(3 downto 0);
	signal hazard: std_logic;
	signal exeBusy: std_logic;
begin
	data   <= SW(7 downto 0);
	opcode <= SW(11 downto 8);
	rs     <= SW(13 downto 12);
	rt     <= SW(15 downto 14);
	clock  <= KEY(0);
	
	CPU_STAGE: cpu port map(
		data, 
		opcode, 
		rs, 
		rt, 
		clock, 
		rsValue, 
		rtValue, 
		hazard, 
		exeBusy,
		ifOp,
		idOp,
		exOp
	);
	
	HEX_RT0: hex_to_7seg port map(rtValue(3 downto 0), HEX0);
	HEX_RT1: hex_to_7seg port map(rtValue(7 downto 4), HEX1);
	HEX_RS0: hex_to_7seg port map(rsValue(3 downto 0), HEX2);
	HEX_RS1: hex_to_7seg port map(rsValue(7 downto 4), HEX3);
	HEX_IFOP: hex_to_7seg port map(ifOp, HEX6);
	HEX_IDOP: hex_to_7seg port map(idOp, HEX5);
	HEX_EXOP: hex_to_7seg port map(exOp, HEX4);
	
	LEDR(7 downto 0) <= data;
	LEDG(0) <= hazard;
	LEDG(1) <= exeBusy;
end Structural;