library ieee;
use ieee.std_logic_1164.all;

package cpu_pkg is
	component cpu is
		port (
			data:   in std_logic_vector(7 downto 0);
			opcode: in std_logic_vector(3 downto 0);
			rs:     in std_logic_vector(1 downto 0);
			rt:     in std_logic_vector(1 downto 0);
			clock:  in std_logic;
			
			rsValueOut: out std_logic_vector(7 downto 0);
			rtValueOut: out std_logic_vector(7 downto 0);
			hazardOut:  out std_logic;
			exeBusyOut: out std_logic;
			ifOpOut:    out std_logic_vector(3 downto 0);
			idOpOut:    out std_logic_vector(3 downto 0);
			exOpOut:    out std_logic_vector(3 downto 0)
		);
	end component;
end cpu_pkg;

library ieee;
use ieee.std_logic_1164.all;
use work.cpu_pkg.all;
use work.divider_pkg.all;
use work.alu_pkg.all;

entity cpu is
	port (
		data:   in std_logic_vector(7 downto 0);
		opcode: in std_logic_vector(3 downto 0);
		rs:     in std_logic_vector(1 downto 0);
		rt:     in std_logic_vector(1 downto 0);
		clock:  in std_logic;
		
		rsValueOut: out std_logic_vector(7 downto 0); -- done
		rtValueOut: out std_logic_vector(7 downto 0); -- done
		hazardOut:  out std_logic;
		exeBusyOut: out std_logic;
		ifOpOut:    out std_logic_vector(3 downto 0);
		idOpOut:    out std_logic_vector(3 downto 0);
		exOpOut:    out std_logic_vector(3 downto 0)
	);
end cpu;

architecture logicfunc of cpu is
	-- register file
	signal regs: std_logic_vector(31 downto 0);
	
	-- ifid register
	signal IFID_opcode: std_logic_vector(3 downto 0);
	signal IFID_rsID, IFID_rtID: std_logic_vector(1 downto 0);
	signal IFID_data: std_logic_vector(7 downto 0);
	
	-- idex register
	signal IDEX_opcode: std_logic_vector(3 downto 0);
	signal IDEX_rsID, IDEX_rtID: std_logic_vector(1 downto 0);
	signal IDEX_rsData, IDEX_rtData: std_logic_vector(7 downto 0);
	
	-- exwb register
	signal EXWB_res: std_logic_vector(7 downto 0);
	signal EXWB_rsID: std_logic_vector(1 downto 0);
	
	-- stuff
	signal exeBusy: std_logic;
	signal hazard: std_logic;
	
	-- forwarding
	signal IDEXInA, IDEXInB: std_logic_vector(7 downto 0); -- mux i think
	signal regOutA, regOutB: std_logic_vector(7 downto 0);
	signal aluRes: std_logic_vector(7 downto 0); -- uses aluRes and EXWB_res for forwarding input
	
	-- temporary values
	signal addValue, andValue, subABValue, subBAValue, norValue, sltValue: std_logic_vector(7 downto 0);
	signal remainder: std_logic_vector(15 downto 0);
	signal divideInit, divideDone: std_logic;
begin
	ALU_ADD: alu8 port map(IDEX_rsData, IDEX_rtData, "0010", addValue);
	ALU_AND: alu8 port map(IDEX_rsData, IDEX_rtData, "0000", andValue);
	ALU_SUBAB: alu8 port map(IDEX_rsData, IDEX_rtData, "0110", subABValue);
	ALU_SUBBA: alu8 port map(IDEX_rsData, IDEX_rtData, "0110", subBAValue);
	ALU_NOR: alu8 port map(IDEX_rsData, IDEX_rtData, "1100", norValue);
	ALU_SLT: alu8 port map(IDEX_rsData, IDEX_rtData, "0111", sltValue);
	
	DIV: divider port map(clock, divideInit, IDEX_rsData, IDEX_rtData, remainder, divideDone);
	
	-- alu signal
	with IDEX_opcode select
		aluRes <= IDEX_rtData            when "0000",
					 IDEX_rtData  				when "0001",
					 addValue   			   when "0010",
					 andValue               when "0011",
					 subABValue             when "0101",
					 subBAValue             when "1001",
					 norValue               when "0100",
					 remainder(7 downto 0)  when "1000", -- division
					 IDEX_rsData            when others;
	
	-- registers
	with IDEX_rsID select
		regOutA <= regs(7 downto 0)   when "00",
					  regs(15 downto 8)  when "01",
					  regs(23 downto 16) when "10",
					  regs(31 downto 24) when others;
	with IDEX_rtID select
		regOutB <= regs(7 downto 0)   when "00",
					  regs(15 downto 8)  when "01",
					  regs(23 downto 16) when "10",
					  regs(31 downto 24) when others;
	
	-- hazard detection
	hazard <= '1' when (EXWB_rsID = IFID_rsID) or (EXWB_rsID = IFID_rtID)
				 or (EXWB_rsID = IDEX_rsID) or (EXWB_rsID = IDEX_rtID)
				 or (IDEX_rsID = IFID_rsID) or (IDEX_rsID = IFID_rtID)
				 else '0';
	
	-- ID forwarding
	IDEXInA <= aluRes   when IFID_rsID = IDEX_rsID else
				  EXWB_res when IFID_rsID = EXWB_rsID else
				  regOutA;
	IDEXInB <= IFID_data when IFID_opcode = "0000" else -- load
				  aluRes    when IFID_rtID = IDEX_rsID else
				  EXWB_res  when IFID_rtID = EXWB_rsID else
				  regOutB;
	
	process(clock)
	begin
		-- things go here
		if rising_edge(clock) then
			if IDEX_opcode = "1000" and divideDone = '0' then
				exeBusy <= '1';
				divideInit <= '0'; -- actually let the divider start doing stuff
			elsif exeBusy = '0' or divideDone = '1' then -- division either never started or now finished 
				-- IF
				IFID_opcode <= opcode;
				IFID_rsID <= rs;
				IFID_rtID <= rt;
				IFID_data <= data;
				
				-- ID
				IDEX_opcode <= IFID_opcode;
				IDEX_rsID <= IFID_rsID;
				IDEX_rtID <= IFID_rtID;
				IDEX_rsData <= IDEXInA;
				IDEX_rtData <= IDEXInB;
								
				-- EX
				EXWB_rsID <= IDEX_rsID;
				EXWB_res <= aluRes;
				exeBusy <= '0';
				divideInit <= '1';
				
				-- WB
				case EXWB_rsID is
					when "00"   => regs(7 downto 0)   <= EXWB_res;
					when "01"   => regs(15 downto 8)  <= EXWB_res;
					when "10"   => regs(23 downto 16) <= EXWB_res;
					when others => regs(31 downto 24) <= EXWB_res;
				end case;
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
	