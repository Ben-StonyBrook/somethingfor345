library ieee;
use ieee.NUMERIC_STD.all;
use ieee.std_logic_1164.all;

	-- Add your library and packages declaration here ...

entity forwardingunit_tb is
end forwardingunit_tb;

architecture TB_ARCHITECTURE of forwardingunit_tb is
	-- Component declaration of the tested unit
	component forwardingunit
	port(
		rst_bar : in STD_LOGIC;
		instruction_ex : in STD_LOGIC_VECTOR(24 downto 0);
		rs1_addr_rf : in STD_LOGIC_VECTOR(4 downto 0);
		rs2_addr_rf : in STD_LOGIC_VECTOR(4 downto 0);
		rs3_addr_rf : in STD_LOGIC_VECTOR(4 downto 0);
		rs1_Data_rf : in STD_LOGIC_VECTOR(127 downto 0);
		rs2_Data_rf : in STD_LOGIC_VECTOR(127 downto 0);
		rs3_Data_rf : in STD_LOGIC_VECTOR(127 downto 0);
		rd_addr_wb : in STD_LOGIC_VECTOR(4 downto 0);
		rd_new_data : in STD_LOGIC_VECTOR(127 downto 0);
		instruction_sent : out STD_LOGIC_VECTOR(24 downto 0);
		rs1_Data_sent : out STD_LOGIC_VECTOR(127 downto 0);
		rs2_Data_sent : out STD_LOGIC_VECTOR(127 downto 0);
		rs3_Data_sent : out STD_LOGIC_VECTOR(127 downto 0) );
	end component;

	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal rst_bar : STD_LOGIC;
	signal instruction_ex : STD_LOGIC_VECTOR(24 downto 0);
	signal rs1_addr_rf : STD_LOGIC_VECTOR(4 downto 0);
	signal rs2_addr_rf : STD_LOGIC_VECTOR(4 downto 0);
	signal rs3_addr_rf : STD_LOGIC_VECTOR(4 downto 0);
	signal rs1_Data_rf : STD_LOGIC_VECTOR(127 downto 0);
	signal rs2_Data_rf : STD_LOGIC_VECTOR(127 downto 0);
	signal rs3_Data_rf : STD_LOGIC_VECTOR(127 downto 0);
	signal rd_addr_wb : STD_LOGIC_VECTOR(4 downto 0);
	signal rd_new_data : STD_LOGIC_VECTOR(127 downto 0);
	-- Observed signals - signals mapped to the output ports of tested entity
	signal instruction_sent : STD_LOGIC_VECTOR(24 downto 0);
	signal rs1_Data_sent : STD_LOGIC_VECTOR(127 downto 0);
	signal rs2_Data_sent : STD_LOGIC_VECTOR(127 downto 0);
	signal rs3_Data_sent : STD_LOGIC_VECTOR(127 downto 0);

	-- Add your code here ...

begin

	-- Unit Under Test port map
	UUT : forwardingunit
		port map (
			rst_bar => rst_bar,
			instruction_ex => instruction_ex,
			rs1_addr_rf => rs1_addr_rf,
			rs2_addr_rf => rs2_addr_rf,
			rs3_addr_rf => rs3_addr_rf,
			rs1_Data_rf => rs1_Data_rf,
			rs2_Data_rf => rs2_Data_rf,
			rs3_Data_rf => rs3_Data_rf,
			rd_addr_wb => rd_addr_wb,
			rd_new_data => rd_new_data,
			instruction_sent => instruction_sent,
			rs1_Data_sent => rs1_Data_sent,
			rs2_Data_sent => rs2_Data_sent,
			rs3_Data_sent => rs3_Data_sent
		);

	--Below VHDL code is an inserted .\compile\fwd_unit_wave.vhs
	--User can modify it ....

STIMULUS: process
begin  -- of stimulus process
--wait for <time to next event>; -- <current time>

	rs3_Data_rf <= "00000000000000000000000000000000000000000000000000000000000000001111111011011100101110101001100001110110010101000011001000010000";
	rd_addr_wb <= "11000";
	rd_new_data <= "00000000000000000000000000000000000000000000000000000000000000000000000000000000000011111111111111111111111111111111111111111111";
	instruction_ex <= "0000000000000000000000000";
	rst_bar <= '0';
	rs1_addr_rf <= "10101";
	rs1_Data_rf <= "00000000000000000000000000000000000000000000000000000000000000000000000000000000111011101110111011101110111011101111111111111111";
	rs3_addr_rf <= "11000";
	rs2_addr_rf <= "01100";
	rs2_Data_rf <= "00000000000000000000000000000000000000000000000000000000000000000000000100100011010001010110011110001001101010111100110111101111";
    wait for 15 ns; --0 fs
	rst_bar <= '1';
    wait for 85 ns; --15 ns
	instruction_ex <= "0000000000000000001000000";
    wait for 100 ns; --100 ns
	instruction_ex <= "0000000000000000010000000";
    wait for 100 ns; --200 ns
	instruction_ex <= "0000000000000000011000000";
    wait for 100 ns; --300 ns
	instruction_ex <= "0000000000000000100000000";
    wait for 100 ns; --400 ns
	instruction_ex <= "0000000000000000101000000";
    wait for 100 ns; --500 ns
	instruction_ex <= "0000000000000000110000000";
    wait for 100 ns; --600 ns
	instruction_ex <= "0000000000000000111000000";
    wait for 100 ns; --700 ns
	instruction_ex <= "0000000000000001000000000";
    wait for 100 ns; --800 ns
	instruction_ex <= "0000000000000001001000000";
    wait for 100 ns; --900 ns
	instruction_ex <= "0000000000000001010000000";
--	end of stimulus events
	wait;
end process; -- end of stimulus process
	



	-- Add your stimulus here ...

end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_forwardingunit of forwardingunit_tb is
	for TB_ARCHITECTURE
		for UUT : forwardingunit
			use entity work.forwardingunit(behavioral);
		end for;
	end for;
end TESTBENCH_FOR_forwardingunit;

