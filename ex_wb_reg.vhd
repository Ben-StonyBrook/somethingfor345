library IEEE;
use IEEE.std_logic_1164.all;

entity EX_WB_Reg is
	port(
	clk : in STD_LOGIC;
	rst_bar : in std_logic;
	
	instructionThrough_In : in std_logic_vector(24 downto 0);
	computed_ALU_Result : in std_logic_vector(127 downto 0); 
	
	instructionThrough_Out : out std_logic_vector(24 downto 0);	
	out_computed_data : out std_logic_vector(127 downto 0)	
	);
end EX_WB_Reg;

--}} End of automatically maintained section

architecture structural of EX_WB_Reg is	   
begin
		
	write_back : process(rst_bar, clk)
	
	variable hold_data : std_logic_vector(127 downto 0); 
	variable instr_hold : std_logic_vector(24 downto 0);
	
	begin
		
		if rst_bar = '0' then
			instructionThrough_Out <= (others => '0');	 
	        out_computed_data <= (others => '0');
		
		else
			--read on a rising edge clock
			if rising_edge(clk) then
				instr_hold := instructionThrough_In;	--read instruction from the ID/EX register
				hold_Data := computed_ALU_Result;	--read data from ALU to the variable
			end if;
			
			--write to the write-back module (if necessary depending on instruction)
			--from the EX/WB register on a falling edge clock
			if falling_edge(clk) then
				
				instructionThrough_Out <= instr_hold;
				out_computed_data <= hold_data;
				
			end if;
			
		end if;
				
		
	end process write_back;	

end structural;
