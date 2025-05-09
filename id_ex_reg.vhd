library IEEE;
use IEEE.std_logic_1164.all;

entity ID_EX_Reg is
	port(
		clk : in STD_LOGIC;
		rst_bar : in std_logic;
		instructionThrough_In : in std_logic_vector(24 downto 0);	--instructionThrough_In comes from the IF/ID register
		
		--data read from the register file
		dataIn1 : in std_logic_vector(127 downto 0);
		dataIn2 : in std_logic_vector(127 downto 0);
		dataIn3 : in std_logic_vector(127 downto 0);
		
		instructionThrough_Out : out std_logic_vector(24 downto 0);	--instructionThrough_Out goes to the forwarding unit
			
		--register addresses to be compared in the forwarding unit
		forwardAddress1 : out std_logic_vector(4 downto 0);
		forwardAddress2 : out std_logic_vector(4 downto 0);
		forwardAddress3 : out std_logic_vector(4 downto 0);	
		
		--data to be written to the forwarding unit for determining which data should be sent
		dataOut1 : out std_logic_vector(127 downto 0);
		dataOut2 : out std_logic_vector(127 downto 0);
		dataOut3 : out std_logic_vector(127 downto 0)	
	);
end ID_EX_Reg;

--}} End of automatically maintained section

architecture structural of ID_EX_Reg is						   
begin		
		
	forward : process(clk, rst_bar)
	
	variable hold_Addr1, hold_Addr2, hold_Addr3, hold_AddrRd : std_logic_vector(4 downto 0);
	variable hold_Data1, hold_Data2, hold_Data3 : std_logic_vector(127 downto 0);
	variable instr_hold : std_logic_vector(24 downto 0);
	
	begin
		
		if rst_bar = '0' then
			instructionThrough_Out <= (others => '0');
			
			forwardAddress1 <= (others => '0');
	        forwardAddress2 <= (others => '0');
	        forwardAddress3 <= (others => '0');
			
			dataOut1 <= (others => '0');
			dataOut2 <= (others => '0');
			dataOut3 <= (others => '0');
			
		else
			--Read from register file to the ID/EX register on a rising edge clock
			if rising_edge(clk) then 
				--parse the 25-bit instruction for the 5-bit source register addresses and store them in variables	
				hold_Addr1 := instructionThrough_In(9 downto 5);
				hold_Addr2 := instructionThrough_In(14 downto 10);
				hold_Addr3 := instructionThrough_In(19 downto 15);
				
				--store the decoded data for each of the 2 or 3 source registers into their respective variables
				hold_Data1 := dataIn1;
				hold_Data2 := dataIn2;			  
				hold_Data3 := dataIn3;	
					
				--variable for holding the 25-bit instruction until it's written on a falling edge clock
				instr_hold := instructionThrough_In;
			end if;
			
			--On a falling edge clock, write the registers' addresses and data to the forwarding unit from the ID/EX register, 
			--and the 25-bit instruction to the forwarding unit and EX/WB register
			if falling_edge(clk) then 	
				--write the 5-bit source register addresses in each field of the intruction to the forwarding unit
				forwardAddress1 <= hold_Addr1;
				forwardAddress2 <= hold_Addr2;
				forwardAddress3 <= hold_Addr3;
				
				--write the data for each of the 2 or 3 source registers to the forwarding unit
				dataOut1 <= hold_Data1;
				dataOut2 <= hold_Data2;										   
				dataOut3 <= hold_Data3;
				
				instructionThrough_Out <= instr_hold;	--write the instruction to the forwarding unit & the EX/WB register
			end if;
			
		end if;		 
		
		
	end process forward;	

end structural;
