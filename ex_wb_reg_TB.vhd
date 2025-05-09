library ieee;
use ieee.std_logic_1164.all;

	-- Add your library and packages declaration here ...

entity ex_wb_reg_tb is
end ex_wb_reg_tb;

architecture TB_ARCHITECTURE of ex_wb_reg_tb is
	-- Component declaration of the tested unit
	component ex_wb_reg
	port(
		clk : in STD_LOGIC;
		rst_bar : in STD_LOGIC;
		instructionThrough_In : in STD_LOGIC_VECTOR(24 downto 0);
		computed_ALU_Result : in STD_LOGIC_VECTOR(127 downto 0);
		instructionThrough_Out : out STD_LOGIC_VECTOR(24 downto 0);
		out_computed_data : out STD_LOGIC_VECTOR(127 downto 0) );
	end component;

	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal clk : STD_LOGIC;
	signal rst_bar : STD_LOGIC;
	signal instructionThrough_In : STD_LOGIC_VECTOR(24 downto 0);
	signal computed_ALU_Result : STD_LOGIC_VECTOR(127 downto 0);
	-- Observed signals - signals mapped to the output ports of tested entity
	signal instructionThrough_Out : STD_LOGIC_VECTOR(24 downto 0);
	signal out_computed_data : STD_LOGIC_VECTOR(127 downto 0);

	-- Add your code here ...

begin

	-- Unit Under Test port map
	UUT : ex_wb_reg
		port map (
			clk => clk,
			rst_bar => rst_bar,
			instructionThrough_In => instructionThrough_In,
			computed_ALU_Result => computed_ALU_Result,
			instructionThrough_Out => instructionThrough_Out,
			out_computed_data => out_computed_data
		);

	--Below VHDL code is an inserted .\compile\EX_WB_wave.vhs
	--User can modify it ....

STIMULUS: process
begin  -- of stimulus process
--wait for <time to next event>; -- <current time>

	instructionThrough_In <= "1000000100000111011011010";
	rst_bar <= '0';
	clk <= '0';
	computed_ALU_Result <= "00000001001001001000011101010110111011111110110010110011001000010000000100100100100001110101011011101111111011001011001100100001";
    wait for 10 ns; --0 fs
	clk <= '1';
    wait for 5 ns; --10 ns
	rst_bar <= '1';
    wait for 5 ns; --15 ns
	clk <= '0';
    wait for 10 ns; --20 ns
	clk <= '1';
    wait for 10 ns; --30 ns
	clk <= '0';
    wait for 10 ns; --40 ns
	clk <= '1';
    wait for 10 ns; --50 ns
	clk <= '0';
    wait for 10 ns; --60 ns
	clk <= '1';
    wait for 10 ns; --70 ns
	clk <= '0';
    wait for 10 ns; --80 ns
	clk <= '1';
    wait for 10 ns; --90 ns
	clk <= '0';
    wait for 10 ns; --100 ns
	clk <= '1';
    wait for 10 ns; --110 ns
	clk <= '0';
    wait for 6 ns; --120 ns
	instructionThrough_In <= "1000000100000111011101001";
    wait for 4 ns; --126 ns
	clk <= '1';
    wait for 10 ns; --130 ns
	clk <= '0';
    wait for 10 ns; --140 ns
	clk <= '1';
    wait for 6 ns; --150 ns
	computed_ALU_Result <= "00000001001001001000011101010110111011111110110010110011001000010000000100100100100001110101011011101111111011001011001101010011";
    wait for 4 ns; --156 ns
	clk <= '0';
    wait for 10 ns; --160 ns
	clk <= '1';
    wait for 10 ns; --170 ns
	clk <= '0';
    wait for 10 ns; --180 ns
	clk <= '1';
    wait for 10 ns; --190 ns
	clk <= '0';
    wait for 10 ns; --200 ns
	clk <= '1';
    wait for 10 ns; --210 ns
	clk <= '0';
    wait for 10 ns; --220 ns
	clk <= '1';
    wait for 10 ns; --230 ns
	clk <= '0';
    wait for 10 ns; --240 ns
	clk <= '1';
    wait for 2 ns; --250 ns
	instructionThrough_In <= "1000000100000111011111000";
    wait for 8 ns; --252 ns
	clk <= '0';
    wait for 10 ns; --260 ns
	clk <= '1';
    wait for 10 ns; --270 ns
	clk <= '0';
    wait for 10 ns; --280 ns
	clk <= '1';
    wait for 10 ns; --290 ns
	clk <= '0';
    wait for 10 ns; --300 ns
	clk <= '1';
    wait for 2 ns; --310 ns
	computed_ALU_Result <= "00000001001001001000011101010110111011111110110010110011001000010000000100100100100001110101011011101111111011001011001110000101";
    wait for 8 ns; --312 ns
	clk <= '0';
    wait for 10 ns; --320 ns
	clk <= '1';
    wait for 10 ns; --330 ns
	clk <= '0';
    wait for 10 ns; --340 ns
	clk <= '1';
    wait for 10 ns; --350 ns
	clk <= '0';
    wait for 10 ns; --360 ns
	clk <= '1';
    wait for 8 ns; --370 ns
	instructionThrough_In <= "1000000100000111100000111";
    wait for 2 ns; --378 ns
	clk <= '0';
    wait for 10 ns; --380 ns
	clk <= '1';
    wait for 10 ns; --390 ns
	clk <= '0';
    wait for 10 ns; --400 ns
	clk <= '1';
    wait for 10 ns; --410 ns
	clk <= '0';
    wait for 10 ns; --420 ns
	clk <= '1';
    wait for 10 ns; --430 ns
	clk <= '0';
    wait for 10 ns; --440 ns
	clk <= '1';
    wait for 10 ns; --450 ns
	clk <= '0';
    wait for 8 ns; --460 ns
	computed_ALU_Result <= "00000001001001001000011101010110111011111110110010110011001000010000000100100100100001110101011011101111111011001011001110110111";
    wait for 2 ns; --468 ns
	clk <= '1';
    wait for 10 ns; --470 ns
	clk <= '0';
    wait for 10 ns; --480 ns
	clk <= '1';
    wait for 10 ns; --490 ns
	clk <= '0';
    wait for 4 ns; --500 ns
	instructionThrough_In <= "1000000100000111100010110";
    wait for 6 ns; --504 ns
	clk <= '1';
    wait for 10 ns; --510 ns
	clk <= '0';
    wait for 10 ns; --520 ns
	clk <= '1';
    wait for 10 ns; --530 ns
	clk <= '0';
    wait for 10 ns; --540 ns
	clk <= '1';
    wait for 10 ns; --550 ns
	clk <= '0';
    wait for 10 ns; --560 ns
	clk <= '1';
    wait for 10 ns; --570 ns
	clk <= '0';
    wait for 10 ns; --580 ns
	clk <= '1';
    wait for 10 ns; --590 ns
	clk <= '0';
    wait for 10 ns; --600 ns
	clk <= '1';
    wait for 10 ns; --610 ns
	clk <= '0';
    wait for 4 ns; --620 ns
	computed_ALU_Result <= "00000001001001001000011101010110111011111110110010110011001000010000000100100100100001110101011011101111111011001011001111101001";
    wait for 6 ns; --624 ns
	instructionThrough_In <= "1000000100000111100100101";
	clk <= '1';
    wait for 10 ns; --630 ns
	clk <= '0';
    wait for 10 ns; --640 ns
	clk <= '1';
    wait for 10 ns; --650 ns
	clk <= '0';
    wait for 10 ns; --660 ns
	clk <= '1';
    wait for 10 ns; --670 ns
	clk <= '0';
    wait for 10 ns; --680 ns
	clk <= '1';
    wait for 10 ns; --690 ns
	clk <= '0';
    wait for 10 ns; --700 ns
	clk <= '1';
    wait for 10 ns; --710 ns
	clk <= '0';
    wait for 10 ns; --720 ns
	clk <= '1';
    wait for 10 ns; --730 ns
	clk <= '0';
    wait for 10 ns; --740 ns
	clk <= '1';
    wait for 6 ns; --750 ns
	instructionThrough_In <= "1000000100000111100110100";
    wait for 4 ns; --756 ns
	clk <= '0';
    wait for 10 ns; --760 ns
	clk <= '1';
    wait for 10 ns; --770 ns
	clk <= '0';
	computed_ALU_Result <= "00000001001001001000011101010110111011111110110010110011001000010000000100100100100001110101011011101111111011001011010000011011";
    wait for 10 ns; --780 ns
	clk <= '1';
    wait for 10 ns; --790 ns
	clk <= '0';
    wait for 10 ns; --800 ns
	clk <= '1';
    wait for 10 ns; --810 ns
	clk <= '0';
    wait for 10 ns; --820 ns
	clk <= '1';
    wait for 10 ns; --830 ns
	clk <= '0';
    wait for 10 ns; --840 ns
	clk <= '1';
    wait for 10 ns; --850 ns
	clk <= '0';
    wait for 10 ns; --860 ns
	clk <= '1';
    wait for 10 ns; --870 ns
	clk <= '0';
    wait for 2 ns; --880 ns
	instructionThrough_In <= "1000000100000111101000011";
    wait for 8 ns; --882 ns
	clk <= '1';
    wait for 10 ns; --890 ns
	clk <= '0';
    wait for 10 ns; --900 ns
	clk <= '1';
    wait for 10 ns; --910 ns
	clk <= '0';
    wait for 10 ns; --920 ns
	clk <= '1';
    wait for 6 ns; --930 ns
	computed_ALU_Result <= "00000001001001001000011101010110111011111110110010110011001000010000000100100100100001110101011011101111111011001011010001001101";
    wait for 4 ns; --936 ns
	clk <= '0';
    wait for 10 ns; --940 ns
	clk <= '1';
    wait for 10 ns; --950 ns
	clk <= '0';
    wait for 10 ns; --960 ns
	clk <= '1';
    wait for 10 ns; --970 ns
	clk <= '0';
    wait for 10 ns; --980 ns
	clk <= '1';
    wait for 10 ns; --990 ns
	clk <= '0';
--	end of stimulus events
	wait;
end process; -- end of stimulus process
	



	-- Add your stimulus here ...

end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_ex_wb_reg of ex_wb_reg_tb is
	for TB_ARCHITECTURE
		for UUT : ex_wb_reg
			use entity work.ex_wb_reg(structural);
		end for;
	end for;
end TESTBENCH_FOR_ex_wb_reg;

