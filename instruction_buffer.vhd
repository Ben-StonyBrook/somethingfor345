library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity instructionBuffer is
	port(
		clk : in std_logic;	--system clock, where an instruction specified by PC is fetched in response to the clock's falling edge	
		instruction_in : in STD_LOGIC_VECTOR(24 downto 0);	--the binary format of the instruction being fetched  
		rst_bar : in std_logic;
		
		instruction_out : out STD_LOGIC_VECTOR(24 downto 0)	--output instruction is fetched and forwarded to the IF/ID register
	);
end instructionBuffer;

--}} End of automatically maintained section

architecture behavioral of instructionBuffer is

	-- Declare array with 64 items each 25-bit wide
    type memory_array is array (0 to 63) of std_logic_vector(24 downto 0);
    signal ProgramMemory: memory_array := (others => (others => '0'));		  
	signal program_counter : integer range 0 to 63;	     
	

begin			   

	fetch : process(clk, rst_bar)	
	begin  	
		
		if rst_bar = '0' then
			program_counter <= 0;			 
			
		end if;	
						 
			
		if rising_edge(clk) then	  			  
			instruction_out <= ProgramMemory(program_counter);
			
			if program_counter = 63 then
				program_counter <= 0;
			else 
				program_counter <= program_counter + 1;
			end if;		  
		
		end if;
		
		
		if falling_edge(clk) then		  
			ProgramMemory(program_counter) <= instruction_in;
		   
	    end if;		
		
	end process fetch;

end behavioral;