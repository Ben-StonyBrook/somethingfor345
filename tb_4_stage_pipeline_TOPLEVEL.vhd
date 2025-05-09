library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;
use std.textio.all;
use ieee.std_logic_textio.all;

entity testbench is
end testbench;

--}} End of automatically maintained section

architecture behavioral of testbench is

--system controls
signal clk_tb : std_logic;	
signal reset_bar_tb : std_logic;

--Stage 1
signal instructionIn_tb : std_logic_vector(24 downto 0);
signal IB_to_IFID_instr_tb : std_logic_vector(24 downto 0);

--Stage 2
signal IFID_to_RF_and_IDEX_instr_tb : std_logic_vector(24 downto 0);
signal rs1_transfer_tb, rs2_transfer_tb, rs3_transfer_tb : std_logic_vector(4 downto 0); 
signal rs1_data_transfer_tb, rs2_data_transfer_tb, rs3_data_transfer_tb : std_logic_vector(127 downto 0);

--Stage 3
signal IDEX_to_fwdUnit_and_EXWB_instr_tb : std_logic_vector(24 downto 0);	--forwarding unit
signal rs1_addr_fwd_tb, rs2_addr_fwd_tb, rs3_addr_fwd_tb : std_logic_vector(4 downto 0);
signal rs1_data_fwd_tb, rs2_data_fwd_tb, rs3_data_fwd_tb : std_logic_vector(127 downto 0);

signal fwdUnit_to_ALU_instr_tb : std_logic_vector(24 downto 0);	--ALU
signal alu_src_data_1_tb, alu_src_data_2_tb, alu_src_data_3_tb : std_logic_vector(127 downto 0);
signal alu_result_data_tb : std_logic_vector(127 downto 0);

--Stage 4
signal EXWB_to_wbModule_instr_tb : std_logic_vector(24 downto 0);
signal wb_data_tb : std_logic_vector(127 downto 0);

signal wr_Sig_tb : std_logic;
signal wr_addr_tb : std_logic_vector(4 downto 0);
signal outputDataWB_tb : std_logic_vector(127 downto 0);

--clock cycle period
constant period : time := 20 ns; 			

begin
	
	--Unit Under Test is the top level 4-stage pipeline
	UUT : entity fourStagePipeline port map(
		clk => clk_tb,	--system clock (controlled by this testbench)
		
		-------------------------------Stage 1-------------------------------
		--Inputs
		instructionIn => instructionIn_tb,						 
		reset_bar => reset_bar_tb,
		
		--Outputs
		IB_to_IFID_instr => IB_to_IFID_instr_tb,
		
		-------------------------------Stage 2-------------------------------
		--Inputs
		IFID_to_RF_and_IDEX_instr => IFID_to_RF_and_IDEX_instr_tb,
		
		rs1_transfer => rs1_transfer_tb,
		rs2_transfer => rs2_transfer_tb,
		rs3_transfer => rs3_transfer_tb,
		
		--Note: the write-back address and its data inputs, as well as the write signal, are listed under "Stage 4"
									 
		--Outputs
		rs1_data_transfer => rs1_data_transfer_tb,
		rs2_data_transfer => rs2_data_transfer_tb,
		rs3_data_transfer => rs3_data_transfer_tb,
		
		-------------------------------Stage 3------------------------------- 
		--Forwarding Unit Inputs
		IDEX_to_fwdUnit_and_EXWB_instr => IDEX_to_fwdUnit_and_EXWB_instr_tb,
		
		rs1_addr_fwd => rs1_addr_fwd_tb,
		rs2_addr_fwd => rs2_addr_fwd_tb,
		rs3_addr_fwd => rs3_addr_fwd_tb,
		
		rs1_data_fwd => rs1_data_fwd_tb,
		rs2_data_fwd => rs2_data_fwd_tb,
		rs3_data_fwd => rs3_data_fwd_tb,
		
		--Note: the write-back address and its data inputs are listed under "Stage 4"
		
		--Forwarding Unit Outputs / ALU Inputs
		fwdUnit_to_ALU_instr => fwdUnit_to_ALU_instr_tb,
		alu_src_data_1 => alu_src_data_1_tb, 
		alu_src_data_2 => alu_src_data_2_tb, 
		alu_src_data_3 => alu_src_data_3_tb,
		
		--ALU Output
		alu_result_data => alu_result_data_tb,
		
		-------------------------------Stage 4-------------------------------
		--Inputs
		EXWB_to_wbModule_instr => EXWB_to_wbModule_instr_tb,
		wb_data => wb_data_tb,
		
		--Outputs
		wr_Sig => wr_Sig_tb,	--also an input for the register file(stage 2)
		wr_addr => wr_addr_tb,	--also an input for the register file (stage 2) and forwarding unit (stage 3)
		outputDataWB => outputDataWB_tb	--also an input for the register file (stage 2) and forwarding unit (stage 3)
		);
	
		
	-- System clock cycle process
	clk_cycle : process
	begin
		
		while true loop
            clk_tb <= '1';
            wait for period / 2;
            clk_tb <= '0';
            wait for period / 2;
        end loop;
		
	end process clk_cycle;	  

	--System reset signal control
	reset_bar_tb <= '0', '1' after 15 ns;
	
	
	---------------------------Process for reading input file and sending the instructions to the instruction buffer---------------------------	
	read_file : process
	
	--declare variables necessary for the input file read operation
	file input_file : text open read_mode is "output345.txt";	--syntax for declaring the input file handler
	variable row : line; 
	variable instr_read : std_logic_vector(24 downto 0);
	variable read_successful : boolean;		
	
	begin
		--Loop for reading from input text file
		while ( not (endfile(input_file)) ) loop   
				
			--read each of the binary formatted instructions from a test file created by the Assembler
			readline(input_file, row);
			read(row, instr_read, read_successful);
			
			instructionIn_tb <= instr_read;	--after reading, load each of the instructions into the instruction buffer
			
			wait for period;
							  
		end loop;
		
		wait for period * 8;
		std.env.finish;		

	end process;	   	  
	
	
	----------------------------------------------------Process for writing the result file----------------------------------------------------
	write_result_file : process	   
	
	--declare variables necessary for the output file write operation
	file results_file : text open write_mode is "ResultsFile.txt";	--syntax for declaring the output file handler
	variable rf_line_buffer : line;
	variable cycle_num : integer := 1;
	
	begin
		 				  
		wait until rising_edge(clk_tb);
		
		write(rf_line_buffer, STRING'("---------------------------------CLOCK CYCLE "));
		write(rf_line_buffer, cycle_num);
		write(rf_line_buffer, STRING'("---------------------------------"));
		writeline(results_file, rf_line_buffer);
		
		for i in 0 to 1 loop	--write two empty lines
			write(rf_line_buffer, LF);  
			writeline(results_file, rf_line_buffer);
		end loop;	
		
		--------------------------------------------------------------Stage 1--------------------------------------------------------------
		--Write the information based on the first pipeline stage 
		write(rf_line_buffer, STRING'("Stage 1: "));
		writeline(results_file, rf_line_buffer); 	   
		
		write(rf_line_buffer, STRING'("Loaded instruction = "));
		write(rf_line_buffer, instructionIn_tb);			   
		writeline(results_file, rf_line_buffer);
		
		write(rf_line_buffer, STRING'("Out instruction = "));
		write(rf_line_buffer, IB_to_IFID_instr_tb);
		writeline(results_file, rf_line_buffer);
		
		write(rf_line_buffer, LF);	--write an empty line  
		writeline(results_file, rf_line_buffer);
		
		
		--------------------------------------------------------------Stage 2--------------------------------------------------------------
		--From the register file, indicate the source registers being read and written, as well as their data 
		write(rf_line_buffer, STRING'("Stage 2: "));
		writeline(results_file, rf_line_buffer);
		
		write(rf_line_buffer, STRING'("Instruction: "));
		write(rf_line_buffer, IFID_to_RF_and_IDEX_instr_tb);
		writeline(results_file, rf_line_buffer);		
		
		write(rf_line_buffer, STRING'("Read Register 1: "));
		write(rf_line_buffer, rs1_transfer_tb);
		write(rf_line_buffer, STRING'("    -->    Read Data: "));
		write(rf_line_buffer, rs1_data_transfer_tb);
		writeline(results_file, rf_line_buffer);
		
		write(rf_line_buffer, STRING'("Read Register 2: "));
		write(rf_line_buffer, rs2_transfer_tb);
		write(rf_line_buffer, STRING'("    -->    Read Data: "));
		write(rf_line_buffer, rs2_data_transfer_tb);
		writeline(results_file, rf_line_buffer);
		
		write(rf_line_buffer, STRING'("Read Register 3: "));
		write(rf_line_buffer, rs3_transfer_tb);
		write(rf_line_buffer, STRING'("    -->    Read Data: "));
		write(rf_line_buffer, rs3_data_transfer_tb);
		writeline(results_file, rf_line_buffer);
		
		write(rf_line_buffer, STRING'("Write Signal: "));
		write(rf_line_buffer, wr_Sig_tb);
		writeline(results_file, rf_line_buffer);
		
		write(rf_line_buffer, STRING'("Write Register: "));
		write(rf_line_buffer, wr_addr_tb);
		write(rf_line_buffer, STRING'("    -->    Write Data: "));
		write(rf_line_buffer, outputDataWB_tb);
		writeline(results_file, rf_line_buffer);						   
		
		write(rf_line_buffer, LF);	--write an empty line  
		writeline(results_file, rf_line_buffer);
		
		
		--------------------------------------------------------------Stage 3--------------------------------------------------------------
		--At the forwarding unit, list the RF registers and WB registers and their data, then specify the data
		--being forwarded to the ALU. Afterwards, display the computed data coming out of the ALU.
		write(rf_line_buffer, STRING'("Stage 3: "));
		writeline(results_file, rf_line_buffer);
		
		write(rf_line_buffer, STRING'("Instruction: "));
		write(rf_line_buffer, IDEX_to_fwdUnit_and_EXWB_instr_tb);
		writeline(results_file, rf_line_buffer);
		
		write(rf_line_buffer, STRING'("Source Register 1: "));
		write(rf_line_buffer, rs1_addr_fwd_tb);
		write(rf_line_buffer, STRING'("    -->    Data: "));
		write(rf_line_buffer, rs1_data_fwd_tb);
		writeline(results_file, rf_line_buffer);
		
		write(rf_line_buffer, STRING'("Source Register 2: "));
		write(rf_line_buffer, rs2_addr_fwd_tb);
		write(rf_line_buffer, STRING'("    -->    Data: "));
		write(rf_line_buffer, rs2_data_fwd_tb);
		writeline(results_file, rf_line_buffer);
		
		write(rf_line_buffer, STRING'("Source Register 3: "));
		write(rf_line_buffer, rs3_addr_fwd_tb);
		write(rf_line_buffer, STRING'("    -->    Data: "));
		write(rf_line_buffer, rs3_data_fwd_tb);
		writeline(results_file, rf_line_buffer);
		
		write(rf_line_buffer, STRING'("Previous Instruction Destination Register: "));
		write(rf_line_buffer, wr_addr_tb);
		write(rf_line_buffer, STRING'("    -->    Data: "));
		write(rf_line_buffer, outputDataWB_tb);
		writeline(results_file, rf_line_buffer);
				
		write(rf_line_buffer, STRING'("Sent Instruction to ALU: "));
		write(rf_line_buffer, IDEX_to_fwdUnit_and_EXWB_instr_tb);
		writeline(results_file, rf_line_buffer);
		
		write(rf_line_buffer, STRING'("Sent Data 1: "));
		write(rf_line_buffer, alu_src_data_1_tb);
		writeline(results_file, rf_line_buffer);
		
		write(rf_line_buffer, STRING'("Sent Data 2: "));
		write(rf_line_buffer, alu_src_data_2_tb);
		writeline(results_file, rf_line_buffer);
		
		write(rf_line_buffer, STRING'("Sent Data 3: "));
		write(rf_line_buffer, alu_src_data_3_tb);
		writeline(results_file, rf_line_buffer);
		
		write(rf_line_buffer, STRING'("Computed Data: "));
		write(rf_line_buffer, alu_result_data_tb);
		writeline(results_file, rf_line_buffer);
		
		write(rf_line_buffer, LF);	--write an empty line  
		writeline(results_file, rf_line_buffer);
															  	   				
		
		--------------------------------------------------------------Stage 4--------------------------------------------------------------
		--For the write back stage, specify the value of write signal, and the write register and its data  
		--(if they are being written back)
		write(rf_line_buffer, STRING'("Stage 4: "));
		writeline(results_file, rf_line_buffer);
		
		write(rf_line_buffer, STRING'("Instruction: " ));
		write(rf_line_buffer, EXWB_to_wbModule_instr_tb);  
		writeline(results_file, rf_line_buffer);
		
		write(rf_line_buffer, STRING'("Pending Data = "));
		write(rf_line_buffer, wb_data_tb);
		writeline(results_file, rf_line_buffer);
		
		write(rf_line_buffer, STRING'("Write Signal = "));
		write(rf_line_buffer, wr_Sig_tb);
		writeline(results_file, rf_line_buffer);	
		
		write(rf_line_buffer, STRING'("Write-Back Register: "));
		write(rf_line_buffer, wr_addr_tb);
		write(rf_line_buffer, STRING'("    -->    Write-Back Data: "));
		write(rf_line_buffer, outputDataWB_tb);
		writeline(results_file, rf_line_buffer);
		
		
		for i in 0 to 2 loop	--write three empty lines
			write(rf_line_buffer, LF);  
			writeline(results_file, rf_line_buffer);
		end loop;				 
			
		cycle_num := cycle_num + 1;			
		
	end process write_result_file;	

end behavioral;
