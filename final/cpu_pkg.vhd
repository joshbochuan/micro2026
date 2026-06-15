library ieee;
use ieee.std_logic_1164.all;

package cpu_pkg is
	component cpu is
		port (
			data:   in std_logic_vector(7 downto 0);
			opcode: in std_logic_vector(4 downto 0);
			rs:     in std_logic_vector(1 downto 0);
			rt:     in std_logic_vector(1 downto 0);
			clock:  in std_logic;
			
			rsValueOut: out std_logic_vector(7 downto 0);
			rtValueOut: out std_logic_vector(7 downto 0);
			hazardOut:  out std_logic;
			exeBusyOut: out std_logic;
			ifOpOut:    out std_logic(3 downto 0);
			idOpOut:    out std_logic(3 downto 0);
			exOpOut:    out std_logic(3 downto 0)
		);
	end component;
end cpu_pkg;

library ieee;
use ieee.std_logic_1164.all;
use work.cpu_pkg.all;

entity cpu is
	port (
		data:   in std_logic_vector(7 downto 0);
		opcode: in std_logic_vector(4 downto 0);
		rs:     in std_logic_vector(1 downto 0);
		rt:     in std_logic_vector(1 downto 0);
		clock:  in std_logic;
		
		rsValueOut: out std_logic_vector(7 downto 0); -- done
		rtValueOut: out std_logic_vector(7 downto 0); -- done
		hazardOut:  out std_logic;
		exeBusyOut: out std_logic;
		ifOpOut:    out std_logic(3 downto 0);
		idOpOut:    out std_logic(3 downto 0);
		exOpOut:    out std_logic(3 downto 0)
	);
end cpu;

architecture logicfunc of cpu is
	-- internal memory
	signal regs: std_logic_vector(31 downto 0);
	
	signal IFID_opcode: std_logic_vector(3 downto 0);
	signal IFID_rsID, IFID_rtID: std_logic_vector(1 downto 0);
	
	signal IDEX_opcode: std_logic_vector(3 downto 0);
	signal IDEX_rsID, IDEX_rtID: std_logic_vector(1 downto 0);
	signal IDEX_rsData, IDEX_rtData: std_logic_vector(7 downto 0);
	
	signal EXWB_res: std_logic_vector(7 downto 0);
	signal EXWB_rsID: std_logic_vector(1 downto 0);
	
	signal exeBusy: std_logic;
	signal hazard: std_logic;
	-- temporary values
	signal addValue, andValue, subABValue, subBAValue, norValue, sltValue: std_logic_vector(7 downto 0);
begin
	ALU_ADD: alu8 port map(IDEX_rsValue, IDEX_rtValue, "0010", addValue);
	ALU_AND: alu8 port map(IDEX_rsValue, IDEX_rtValue, "0000", andValue);
	ALU_SUBAB: alu8 port map(IDEX_rsValue, IDEX_rtValue, "0110", subABValue);
	ALU_SUBBA: alu8 port map(IDEX_rtValue, IDEX_rsValue, "0110", subBAValue);
	ALU_NOR: alu8 port map(IDEX_rsValue, IDEX_rtValue, "1100", norValue);
	ALU_SLT: alu8 port map(IDEX_rsValue, IDEX_rtValue, "0111", sltValue);
	
	process(clock)
		-- things go here
		if rising_edge(clock) then
			if exeBusy = '1' then
				-- division stuff
			else 
				-- IF
				IFID_opcode <= opcode;
				IFID_rsID <= rs;
				IFID_rtID <= rt;
				
				-- ID
				IDEX_opcode <= IFID_opcode;
				IDEX_rsID <= IFID_rsID;
				IDEX_rtID <= IFID_rtID;
				with IDEX_rsID select
					IDEX_rsData <= regs(7 downto 0)   when "00",
										regs(15 downto 8)  when "01",
										regs(23 downto 16) when "10",
										regs(31 downto 24) when others;
				with IDEX_rtID select
					IDEX_rtData <= regs(7 downto 0)   when "00",
										regs(15 downto 8)  when "01",
										regs(23 downto 16) when "10",
										regs(31 downto 24) when others;
				
				-- EX
				EXWB_rsID <= IDEX_rsID;
				case IDEX_opcode is
					when "0000" => EXWB_res <= data;
					when "0001" => EXWB_res <= IDEX_rtData;
					when "0010" => EXWB_res <= addValue;
					when "0011" => EXWB_res <= andValue;
					when "0101" => EXWB_res <= subABValue;
					when "1001" => EXWB_res <= subBAValue;
					when "0110" => EXWB_res <= norValue;
					when "0100" => EXWB_res <= sltValue;
					when "1111" => null;
					when "1000" =>
						exeBusy <= '1';
					when others => null;
				-- WB
				case EXWB_rsID is
					when "00"   => regs(7 downto 0)   <= EXWB_res;
					when "01"   => regs(15 downto 8)  <= EXWB_res;
					when "10"   => regs(23 downto 16) <= EXWB_res;
					when others => regs(31 downto 24) <= EXWB_res;
			end if;
		end if;
	end process;
	
	-- output
	with rs select
		rsValueOut <= regs(7 downto 0)   when "00",
						  regs(15 downto 8)  when "01",
						  regs(23 downto 16) when "10",
						  regs(31 downto 24) when others;
	with rt select
		rtValueOut <= regs(7 downto 0)   when "00",
						  regs(15 downto 8)  when "01",
						  regs(23 downto 16) when "10",
						  regs(31 downto 24) when others;
	ifOpOut <= opcode;
	idOpOut <= IFID_opcode;
	exOpOut <= IDEX_opcode;
	exeBusyOut <= exeBusy;
	hazardOut <= hazard;
	
end logicfunc;
	