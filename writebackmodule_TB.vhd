library ieee;
use ieee.std_logic_1164.all;

	-- Add your library and packages declaration here ...

entity writebackmodule_tb is
end writebackmodule_tb;

architecture TB_ARCHITECTURE of writebackmodule_tb is
	-- Component declaration of the tested unit
	component writebackmodule
	port(
		rst_bar : in STD_LOGIC;
		instruction : in STD_LOGIC_VECTOR(24 downto 0);
		in_computed_data : in STD_LOGIC_VECTOR(127 downto 0);
		write_signal : out STD_LOGIC;
		wb_address : out STD_LOGIC_VECTOR(4 downto 0);
		wb_computed_data : out STD_LOGIC_VECTOR(127 downto 0) );
	end component;

	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal rst_bar : STD_LOGIC;
	signal instruction : STD_LOGIC_VECTOR(24 downto 0);
	signal in_computed_data : STD_LOGIC_VECTOR(127 downto 0);
	-- Observed signals - signals mapped to the output ports of tested entity
	signal write_signal : STD_LOGIC;
	signal wb_address : STD_LOGIC_VECTOR(4 downto 0);
	signal wb_computed_data : STD_LOGIC_VECTOR(127 downto 0);

	-- Add your code here ...

begin

	-- Unit Under Test port map
	UUT : writebackmodule
		port map (
			rst_bar => rst_bar,
			instruction => instruction,
			in_computed_data => in_computed_data,
			write_signal => write_signal,
			wb_address => wb_address,
			wb_computed_data => wb_computed_data
		);

	--Below VHDL code is an inserted .\compile\wb_module_wave.vhs
	--User can modify it ....

STIMULUS: process
begin  -- of stimulus process
--wait for <time to next event>; -- <current time>

	instruction <= "0000000000000000000000000";
	rst_bar <= '0';
	in_computed_data <= "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
    wait for 15 ns; --0 fs
	rst_bar <= '1';
    wait for 85 ns; --15 ns
	instruction <= "0000000000000000000001010";
    wait for 18 ns; --100 ns
	in_computed_data <= "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001111";
    wait for 82 ns; --118 ns
	instruction <= "0000000000000000000010100";
    wait for 36 ns; --200 ns
	in_computed_data <= "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011110";
    wait for 64 ns; --236 ns
	instruction <= "0000000000000000000011110";
    wait for 54 ns; --300 ns
	in_computed_data <= "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000101101";
    wait for 46 ns; --354 ns
	instruction <= "0000000000000000000101000";
    wait for 72 ns; --400 ns
	in_computed_data <= "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000111100";
    wait for 28 ns; --472 ns
	instruction <= "0000000000000000000110010";
    wait for 90 ns; --500 ns
	in_computed_data <= "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001001011";
    wait for 10 ns; --590 ns
	instruction <= "0000000000000000000111100";
    wait for 100 ns; --600 ns
	instruction <= "0000000000000000001000110";
    wait for 8 ns; --700 ns
	in_computed_data <= "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001011010";
    wait for 92 ns; --708 ns
	instruction <= "0000000000000000001010000";
    wait for 26 ns; --800 ns
	in_computed_data <= "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001101001";
    wait for 74 ns; --826 ns
	instruction <= "0000000000000000001011010";
    wait for 44 ns; --900 ns
	in_computed_data <= "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001111000";
    wait for 56 ns; --944 ns
	instruction <= "0000000000000000001100100";
--	end of stimulus events
	wait;
end process; -- end of stimulus process
	



	-- Add your stimulus here ...

end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_writebackmodule of writebackmodule_tb is
	for TB_ARCHITECTURE
		for UUT : writebackmodule
			use entity work.writebackmodule(behavioral);
		end for;
	end for;
end TESTBENCH_FOR_writebackmodule;

