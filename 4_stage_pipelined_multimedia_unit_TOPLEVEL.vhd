library ieee;
use ieee.std_logic_1164.all;
use work.all;

entity fourStagePipeline is
	
	port(	--input and output ports are used to map to the top level's testbench
	
		clk : in std_logic;	--system clock
		reset_bar : in std_logic;	--system reset (negative asserted)
		
		---------------------------------------Stage 1: Instruction Buffer----------------------------------------------- 
		
		--Instruction Buffer inputs instruction from the top level
		instructionIn : in std_logic_vector(24 downto 0);  

		--Instruction Buffer output to the IF/ID register
		IB_to_IFID_instr : out std_logic_vector(24 downto 0);
		
		
		-----------------------------------------Stage 2: Register File--------------------------------------------------
		
		--between the IF/ID register and the register file + ID/EX register	 
		IFID_to_RF_and_IDEX_instr : out std_logic_vector(24 downto 0);	--25-bit instruction sent from the IF/ID to the ID/EX register
		
		--Register File	inputs (listed as "out" due to it being sent to the top level's output)
		rs1_transfer : out std_logic_vector(4 downto 0);	--register address of rs1 being sent from the IF/ID register to the register file
		rs2_transfer : out std_logic_vector(4 downto 0);	--register address of rs2 being sent from the IF/ID register to the register file
		rs3_transfer : out std_logic_vector(4 downto 0);	--register address of rs3 being sent from the IF/ID register to the register file
		
		--Register File outputs to the ID/EX register (listed as "out" due to it being sent to the top level's output)
		rs1_data_transfer : out std_logic_vector(127 downto 0);	--rs1 data being sent from the register file to the ID/EX register
		rs2_data_transfer : out std_logic_vector(127 downto 0);	--rs2 data being sent from the register file to the ID/EX register
		rs3_data_transfer : out std_logic_vector(127 downto 0);	--rs3 data being sent from the register file to the ID/EX register	
			
			
		---------------------------------------Stage 3: Forwarding Unit & ALU-----------------------------------------------
		
		--between the ID/EX register and the forwarding unit + EX/WB register
		IDEX_to_fwdUnit_and_EXWB_instr : out std_logic_vector(24 downto 0);
		
		--Forwarding Unit inputs from the ID/EX register (listed as "out" due to it being sent to the top level's output)
		rs1_addr_fwd, rs2_addr_fwd, rs3_addr_fwd : out std_logic_vector(4 downto 0);	--register addresses for the current instruction 
		rs1_data_fwd, rs2_data_fwd, rs3_data_fwd : out std_logic_vector(127 downto 0);	--data from each source register for the current instruction
		
		--Forwarding Unit outputs to the ALU
		fwdUnit_to_ALU_instr : out std_logic_vector(24 downto 0);
		alu_src_data_1, alu_src_data_2, alu_src_data_3 : out std_logic_vector(127 downto 0);	--data that was chosen to be sent to the ALU
		
		--ALU output to the EX/WB reguster
		alu_result_data : out std_logic_vector(127 downto 0);
		
		
		--------------------------------------Stage 4: Write-Back Module------------------------------------------------
		
		--between the EX/WB register and the write-back module
		EXWB_to_wbModule_instr : out std_logic_vector(24 downto 0);
		wb_data : out std_logic_vector(127 downto 0);
		
		--Write-Back Module outputs to the forwarding unit + the register file if write back signal is '1'
		wr_Sig : out std_logic;		--write signal sent from the EX/WB register to the register file
		wr_addr : out std_logic_vector(4 downto 0);	--write address sent to both the RF and FWD Unit 
		outputDataWB : out std_logic_vector(127 downto 0)	--data written back to the forwarding unit and the RF to be sent to the results text file
	);
	
end fourStagePipeline;

--}} End of automatically maintained section


architecture structural of fourStagePipeline is	
begin
	
	u0 : entity instructionBuffer port map(	  
		clk => clk,	--system clock
		instruction_in => instructionIn,	--input instruction loaded from text file
																	  
		rst_bar => reset_bar,	--negative asserted reset
		
		--to IF_ID_Reg
		instruction_out => IB_to_IFID_instr
		);
		
	u1 : entity IF_ID_Reg port map(
		clk => clk,	--system clock
		rst_bar => reset_bar,	--negative asserted reset
		
		--from instructionBuffer
		instructionThrough_In => IB_to_IFID_instr, 
		
		--to ID_EX_Reg
		instructionThrough_Out => IFID_to_RF_and_IDEX_instr,
		
		--to registerFile
		outputAddr1 => rs1_transfer,	--to be also written to the results file
		outputAddr2 => rs2_transfer,	--to be also written to the results file
		outputAddr3 => rs3_transfer		--to be also written to the results file
		);
		
	u2 : entity registerFile port map(
		clk => clk,	--system clock
		rst_bar => reset_bar,	--negative asserted reset
				
		--from IF_ID_Reg
		instruction_decode => IFID_to_RF_and_IDEX_instr,
		
		read_addr1 => rs1_transfer,		--to be also written to the results file
		read_addr2 => rs2_transfer,		--to be also written to the results file
		read_addr3 => rs3_transfer,		--to be also written to the results file
		
		--from EX_WB_Reg
		write_addr => wr_addr,
		write_data => outputDataWB,	--to be also written to the results file
		write_signal => wr_Sig,
		
		--to ID_EX_Reg
		read_data1 => rs1_data_transfer,
		read_data2 => rs2_data_transfer,
		read_data3 => rs3_data_transfer 
		);

	u3 : entity ID_EX_Reg port map(
		clk => clk,	--system clock
		rst_bar => reset_bar,	--negative asserted reset
		
		--from IF_ID_Reg
		instructionThrough_In => IFID_to_RF_and_IDEX_instr,
		
		--from registerFile
		dataIn1 => rs1_data_transfer,
		dataIn2 => rs2_data_transfer,
		dataIn3 => rs3_data_transfer,
		
		--to forwardingUnit					  
		forwardAddress1 => rs1_addr_fwd,
		forwardAddress2 => rs2_addr_fwd,
		forwardAddress3 => rs3_addr_fwd,
														   
		dataOut1 => rs1_data_fwd,
		dataOut2 => rs2_data_fwd,
		dataOut3 => rs3_data_fwd,
		
		--to forwardingUnit and EX_WB_Reg
		instructionThrough_Out => IDEX_to_fwdUnit_and_EXWB_instr
		);
		
	u4 : entity forwardingUnit port map(
		rst_bar => reset_bar,	--negative asserted reset
		
		--from EX_WB_Reg
		rd_addr_wb => wr_addr,
		rd_new_data => outputDataWB,	--to be also written to the results file
		
		--from ID_EX_Reg
		instruction_ex => IDEX_to_fwdUnit_and_EXWB_instr,
		
		rs1_addr_rf => rs1_addr_fwd,
		rs2_addr_rf => rs2_addr_fwd,
		rs3_addr_rf => rs3_addr_fwd,
		
		rs1_Data_rf => rs1_data_fwd,
		rs2_Data_rf => rs2_data_fwd,
		rs3_Data_rf => rs3_data_fwd,
		
		--to ALU
		instruction_sent => fwdUnit_to_ALU_instr,
		rs1_Data_sent => alu_src_data_1,
		rs2_Data_sent => alu_src_data_2,
		rs3_Data_sent => alu_src_data_3
		);
		
	u5 : entity ALU port map( 		
		--from forwardingUnit
		instruction => fwdUnit_to_ALU_instr,
		Rs1 => alu_src_data_1,
		Rs2 => alu_src_data_2,
		Rs3 => alu_src_data_3,
		
		--to EX_WB_Reg
		Rd => alu_result_data
		);
		
	u6 : entity EX_WB_Reg port map(
		clk => clk,	--system clock
		rst_bar => reset_bar,	--negative asserted reset
		
		--from ID_EX_Reg
		instructionThrough_In => IDEX_to_fwdUnit_and_EXWB_instr,
		
		--from ALU
		computed_ALU_result => alu_result_data,
		
		--to writebackModule
		instructionThrough_Out => EXWB_to_wbModule_instr,
		out_computed_data => wb_data
		);
		
	u7 : entity writebackModule port map(
		rst_bar => reset_bar,	--negative asserted reset
		
		--from EX_WB_Reg
		instruction => EXWB_to_wbModule_instr,
		in_computed_data => wb_data,
		
		--to registerFile and forwardingUnit
		wb_address => wr_addr,
		wb_computed_data => outputDataWB,	--to be also written to the results file
		
		--to registerFile
		write_signal => wr_Sig
		); 
		

end structural;
