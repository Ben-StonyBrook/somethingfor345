library IEEE;
use IEEE.std_logic_1164.all;

entity IF_ID_Reg is
	 port(
	 clk : in STD_LOGIC;
	 rst_bar : in std_logic;
	 										  
	 instructionThrough_In : in std_logic_vector(24 downto 0);	 --instructionThrough_In comes from the instruction buffer output
	 instructionThrough_Out : out std_logic_vector(24 downto 0);	--instructionThrough_Out goes to the ID/EX pipeline register
	 
	 --instructions' source addresses being sent to the register file 
	 outputAddr1 : out std_logic_vector(4 downto 0);
	 outputAddr2 : out std_logic_vector(4 downto 0);
	 outputAddr3 : out std_logic_vector(4 downto 0)
	     );
end IF_ID_Reg;

--}} End of automatically maintained section

architecture structural of IF_ID_Reg is			
begin										 
	
	transfer : process(clk, rst_bar)	
	begin
		
		if rst_bar = '0' then
			instructionThrough_Out <= (others => '0');
			outputAddr1 <= (others => '0');
	        outputAddr2 <= (others => '0');
	        outputAddr3 <= (others => '0');
		
		else 	   
			
			if falling_edge(clk) then 
		        -- immediately drive outputs   
				instructionThrough_Out <= instructionThrough_In;
				outputAddr1 <= instructionThrough_In(9 downto 5);
		        outputAddr2 <= instructionThrough_In(14 downto 10);
		        outputAddr3 <= instructionThrough_In(19 downto 15);
		    end if;
			
		end if;		   
	   
	end process;	
	
end structural;
						   