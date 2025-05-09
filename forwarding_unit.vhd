library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity forwardingUnit is
    port (
		rst_bar : in std_logic;

-------------------------------------------------------------INPUTS FROM ID/EX REGISTER-------------------------------------------------------------
		-- current instruction that will have its register address fields compared with those of the previous instruction
		instruction_ex : in std_logic_vector(24 downto 0);
		
		-- register address inputs
        rs1_addr_rf : in std_logic_vector(4 downto 0);
        rs2_addr_rf : in std_logic_vector(4 downto 0);
		rs3_addr_rf : in std_logic_vector(4 downto 0);  
		
		-- data being read from the register file
		rs1_Data_rf : in std_logic_vector(127 downto 0);
        rs2_Data_rf : in std_logic_vector(127 downto 0);
		rs3_Data_rf : in std_logic_vector(127 downto 0);	  
				
		
-------------------------------------------------------------INPUTS FROM EX/WB REGISTER------------------------------------------------------------- 		
		-- destination register address to be compared with any of the source registers' addresses
        rd_addr_wb : in  std_logic_vector(4 downto 0); 
		
		-- new data that was calculated by the ALU in the previous instruction
		rd_new_data : in std_logic_vector(127 downto 0);
		
		
-------------------------------------------------------------------OUTPUTS TO ALU-------------------------------------------------------------------		
		--instruction to be sent to the ALU so it can identify the type of instruction
		instruction_sent : out std_logic_vector(24 downto 0);
		
		-- data to be sent to the ALU in the event of no hazards being detected
        rs1_Data_sent : out std_logic_vector(127 downto 0);
        rs2_Data_sent : out std_logic_vector(127 downto 0);
		rs3_Data_sent : out std_logic_vector(127 downto 0)
    );
end forwardingUnit;

architecture behavioral of forwardingUnit is
begin

    process(rst_bar, instruction_ex, rs1_addr_rf, rs2_addr_rf, rs3_addr_rf, 
	rs1_Data_rf, rs2_Data_rf, rs3_Data_rf, rd_addr_wb, rd_new_data)
    begin
        
		if rst_bar = '0' then
			rs1_Data_sent <= (others => '0');
			rs2_Data_sent <= (others => '0');
			rs3_Data_sent <= (others => '0');
			instruction_sent <= "1100001011000000000000000";
			
		else
			--if the rd address of the instruction written back = the address of any of the 
			--source registers of the incoming instruction, forward the data held by written-back rd
			if rd_addr_wb = rs1_addr_rf	then
				rs1_Data_sent <= rd_new_data;
				rs2_Data_sent <= rs2_Data_rf;
				rs3_Data_sent <= rs3_Data_rf; 
				
			elsif rd_addr_wb = rs2_addr_rf then
				rs1_Data_sent <= rs1_Data_rf;
				rs2_Data_sent <= rd_new_data;  
				rs3_Data_sent <= rs3_Data_rf;	 
					
			elsif rd_addr_wb = rs3_addr_rf then
				rs1_Data_sent <= rs1_Data_rf;
				rs2_Data_sent <= rs2_Data_rf;
				rs3_Data_sent <= rd_new_data;
							
			else	--otherwise, send the current data from the register file
				rs1_Data_sent <= rs1_Data_rf;
				rs2_Data_sent <= rs2_Data_rf;
				rs3_Data_sent <= rs3_Data_rf; 
				
			end if;	
			
			--unconditionally forward the current instruction from the ID/EX register to the ALU
			instruction_sent <= instruction_ex;
			
		end if;	
		
    end process;

end behavioral;