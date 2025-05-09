library ieee;
use ieee.std_logic_1164.all;

	-- Add your library and packages declaration here ...

entity id_ex_reg_tb is
end id_ex_reg_tb;

architecture TB_ARCHITECTURE of id_ex_reg_tb is
	-- Component declaration of the tested unit
	component id_ex_reg
	port(
		clk : in STD_LOGIC;
		rst_bar : in STD_LOGIC;
		instructionThrough_In : in STD_LOGIC_VECTOR(24 downto 0);
		dataIn1 : in STD_LOGIC_VECTOR(127 downto 0);
		dataIn2 : in STD_LOGIC_VECTOR(127 downto 0);
		dataIn3 : in STD_LOGIC_VECTOR(127 downto 0);
		instructionThrough_Out : out STD_LOGIC_VECTOR(24 downto 0);
		forwardAddress1 : out STD_LOGIC_VECTOR(4 downto 0);
		forwardAddress2 : out STD_LOGIC_VECTOR(4 downto 0);
		forwardAddress3 : out STD_LOGIC_VECTOR(4 downto 0);
		dataOut1 : out STD_LOGIC_VECTOR(127 downto 0);
		dataOut2 : out STD_LOGIC_VECTOR(127 downto 0);
		dataOut3 : out STD_LOGIC_VECTOR(127 downto 0) );
	end component;

	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal clk : STD_LOGIC;
	signal rst_bar : STD_LOGIC;
	signal instructionThrough_In : STD_LOGIC_VECTOR(24 downto 0);
	signal dataIn1 : STD_LOGIC_VECTOR(127 downto 0);
	signal dataIn2 : STD_LOGIC_VECTOR(127 downto 0);
	signal dataIn3 : STD_LOGIC_VECTOR(127 downto 0);
	-- Observed signals - signals mapped to the output ports of tested entity
	signal instructionThrough_Out : STD_LOGIC_VECTOR(24 downto 0);
	signal forwardAddress1 : STD_LOGIC_VECTOR(4 downto 0);
	signal forwardAddress2 : STD_LOGIC_VECTOR(4 downto 0);
	signal forwardAddress3 : STD_LOGIC_VECTOR(4 downto 0);
	signal dataOut1 : STD_LOGIC_VECTOR(127 downto 0);
	signal dataOut2 : STD_LOGIC_VECTOR(127 downto 0);
	signal dataOut3 : STD_LOGIC_VECTOR(127 downto 0);

	-- Add your code here ...

begin

	-- Unit Under Test port map
	UUT : id_ex_reg
		port map (
			clk => clk,
			rst_bar => rst_bar,
			instructionThrough_In => instructionThrough_In,
			dataIn1 => dataIn1,
			dataIn2 => dataIn2,
			dataIn3 => dataIn3,
			instructionThrough_Out => instructionThrough_Out,
			forwardAddress1 => forwardAddress1,
			forwardAddress2 => forwardAddress2,
			forwardAddress3 => forwardAddress3,
			dataOut1 => dataOut1,
			dataOut2 => dataOut2,
			dataOut3 => dataOut3
		);

	--Below VHDL code is an inserted .\compile\id_ex_wave.vhs
	--User can modify it ....

STIMULUS: process
begin  -- of stimulus process
--wait for <time to next event>; -- <current time>

	dataIn2 <= "00000000000000000000000000000000000000000000000000000000000000000000000100100011010001010110011110001001101010111100110111101111";
	dataIn3 <= "00001101111010101101101111101110111111011110101011011011111011101111000100100011010001010110011110001001101010111100110111101111";
	clk <= '0';
	rst_bar <= '0';
	instructionThrough_In <= "1101001000110111000101010";
	dataIn1 <= "00000000000000000000000000000000000000000000000000000000000000001111111111111111111111111111111111101110111011100001001000110100";
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
    wait for 10 ns; --120 ns
	clk <= '1';
    wait for 6 ns; --130 ns
	instructionThrough_In <= "1101001000110111000110101";
    wait for 4 ns; --136 ns
	clk <= '0';
    wait for 10 ns; --140 ns
	clk <= '1';
    wait for 10 ns; --150 ns
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
    wait for 10 ns; --250 ns
	clk <= '0';
    wait for 10 ns; --260 ns
	clk <= '1';
    wait for 2 ns; --270 ns
	instructionThrough_In <= "1101001000110111001000000";
    wait for 8 ns; --272 ns
	clk <= '0';
    wait for 10 ns; --280 ns
	clk <= '1';
    wait for 10 ns; --290 ns
	clk <= '0';
    wait for 10 ns; --300 ns
	clk <= '1';
    wait for 10 ns; --310 ns
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
    wait for 10 ns; --370 ns
	clk <= '0';
    wait for 10 ns; --380 ns
	clk <= '1';
    wait for 10 ns; --390 ns
	clk <= '0';
    wait for 8 ns; --400 ns
	instructionThrough_In <= "1101001000110111001001011";
    wait for 2 ns; --408 ns
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
    wait for 10 ns; --460 ns
	clk <= '1';
    wait for 10 ns; --470 ns
	clk <= '0';
    wait for 10 ns; --480 ns
	clk <= '1';
    wait for 10 ns; --490 ns
	clk <= '0';
    wait for 10 ns; --500 ns
	clk <= '1';
    wait for 10 ns; --510 ns
	clk <= '0';
    wait for 10 ns; --520 ns
	clk <= '1';
    wait for 10 ns; --530 ns
	clk <= '0';
    wait for 4 ns; --540 ns
	instructionThrough_In <= "1101001000110111001010110";
    wait for 6 ns; --544 ns
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
    wait for 10 ns; --620 ns
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
	instructionThrough_In <= "1101001000110111001100001";
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
    wait for 10 ns; --750 ns
	clk <= '0';
    wait for 10 ns; --760 ns
	clk <= '1';
    wait for 10 ns; --770 ns
	clk <= '0';
    wait for 10 ns; --780 ns
	clk <= '1';
    wait for 10 ns; --790 ns
	clk <= '0';
    wait for 10 ns; --800 ns
	clk <= '1';
    wait for 6 ns; --810 ns
	instructionThrough_In <= "1101001000110111001101100";
    wait for 4 ns; --816 ns
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
    wait for 10 ns; --880 ns
	clk <= '1';
    wait for 10 ns; --890 ns
	clk <= '0';
    wait for 10 ns; --900 ns
	clk <= '1';
    wait for 10 ns; --910 ns
	clk <= '0';
    wait for 10 ns; --920 ns
	clk <= '1';
    wait for 10 ns; --930 ns
	clk <= '0';
    wait for 10 ns; --940 ns
	clk <= '1';
    wait for 2 ns; --950 ns
	instructionThrough_In <= "1101001000110111001110111";
    wait for 8 ns; --952 ns
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

configuration TESTBENCH_FOR_id_ex_reg of id_ex_reg_tb is
	for TB_ARCHITECTURE
		for UUT : id_ex_reg
			use entity work.id_ex_reg(structural);
		end for;
	end for;
end TESTBENCH_FOR_id_ex_reg;

