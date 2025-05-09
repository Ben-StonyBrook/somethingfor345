library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;
use std.textio.all;

entity testbench is
end testbench;

--}} End of automatically maintained section

architecture structural of testbench is

signal clk_tb : std_logic;
signal instr_in_tb, instr_out_tb : std_logic_vector(24 downto 0);
signal rst_bar_tb : std_logic;
											  
constant period : time := 20 ns;   

begin
	--Unit Under Test is the description of the instruction buffer
	UUT : entity instructionBuffer port map(
		instruction_in => instr_in_tb,	   
		rst_bar => rst_bar_tb,
		clk => clk_tb,		   
		instruction_out => instr_out_tb
		);	
		
	--Clock cycle process
	clk_cycle : process
	begin
		
		while true loop
            clk_tb <= '1';
            wait for period / 2;
            clk_tb <= '0';
            wait for period / 2;
        end loop;
		
	end process clk_cycle;	
	
	--Reset bar
	rst_bar_tb <= '0', '1' after 21 ns;
	
	--Simulation process
	sim : process
	
	--declare variables necessary for the input file read operation
	file input_file : text open read_mode is "output345.txt";	--syntax for declaring the input file handler
	variable row : line; 
	variable instr_read : std_logic_vector(24 downto 0);
	variable read_successful : boolean;	  
	
	begin
		
		--Determine the number of lines in the input file (no more than 64)
		while not (endfile(input_file)) loop
			
			--read each of the binary formatted instructions from a test file created by the Assembler
			readline(input_file, row);
			read(row, instr_read, read_successful);
			
			instr_in_tb <= instr_read;
			wait for period;		 
						
		end loop;
		
		file_close(input_file);	
							   
		std.env.finish;
		
	end process sim;
	
end structural;