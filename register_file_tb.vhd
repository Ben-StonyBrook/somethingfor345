library ieee;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.all;

entity testbench is
end testbench;

--}} End of automatically maintained section

architecture structural of testbench is

signal clk_tb : std_logic;
signal rst_bar_tb : std_logic;
signal instruction_decode_tb : std_logic_vector(24 downto 0);
									 
signal read_addr1_tb, read_addr2_tb, read_addr3_tb : std_logic_vector(4 downto 0);

signal write_addr_tb : std_logic_vector(4 downto 0);
signal write_data_tb : std_logic_vector(127 downto 0);
signal write_signal_tb : std_logic;

signal read_data1_tb, read_data2_tb, read_data3_tb : std_logic_vector(127 downto 0);

constant period : time := 20 ns;

begin

	UUT : entity registerFile port map(	
		clk => clk_tb,
		rst_bar => rst_bar_tb,
		instruction_decode => instruction_decode_tb,
		
		read_addr1 => read_addr1_tb,
		read_addr2 => read_addr2_tb,
		read_addr3 => read_addr3_tb,
		
		write_addr => write_addr_tb,
		write_data => write_data_tb,
		write_signal => write_signal_tb,
		
		read_data1 => read_data1_tb,
		read_data2 => read_data2_tb,
		read_data3 => read_data3_tb 
		
		);		 	 
	
	instruction_decode_tb <= "1000110101000111101001011";
		
	--Process for controlling the system clock input
	clkControl : process
	begin
		
		clk_tb <= '1';
		wait for period / 2;   
		clk_tb <= '0';
		wait for period / 2;

	end process clkControl;
	
	--Reset bar
	rst_bar_tb <= '0', '1' after 21 ns;
		
	--Process for controlling the write_signal input
	writeSignalControl : process
	begin
		
		--for i in 0 to 31 loop
--			
--
--			write_signal_tb <= '1';
--			wait for period * 20;   
--			write_signal_tb <= '0';
--			wait for period * 10;
--			
--		end loop;

		write_signal_tb <= '0';
		wait for period * 21;
		write_signal_tb <= '1';
		wait for period * 21;

--		write_signal_tb <= '1';
--		wait for period / 2;   
--		write_signal_tb <= '0';
--		wait for period / 2;

	end process writeSignalControl;
	
	
	--Process for testing input values in register file
	stimulus : process
    begin
		-- Wait for global reset
        wait for 10 ns;
		
		-- Initialize read registers 5, 10, 12
        read_addr1_tb <= "00101";  -- Expect DEADBEEF...
        read_addr2_tb <= "01010";  -- Expect 01234567...
        read_addr3_tb <= "01100";  -- Expect 0s (was never written)
        wait for period;
       
        ---- Write 0xDEADBEEF... to register 5
        write_addr_tb <= "00101";  -- Register 5
        write_data_tb <= x"DEADBEEFDEADBEEFDEADBEEFCB34BEEF";
    	
        wait for period;

        -- Write to register 10
        write_addr_tb <= "01010";  -- Register 10
        write_data_tb <= x"0123456789ABCDEF0123456789ABCDEF";
      
        wait for period;

        -- Write to register 12
        write_addr_tb <= "01100";  -- Register 12
        write_data_tb <= x"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF";
  
        wait for period;

        
		
		------ Write to register 15
--        write_addr_tb <= "01111";
--        write_data_tb <= x"FEDCBA9876543210FEDCBA9876543210";
--    
--        wait for period;
--
--        -- Write to register 16
--        write_addr_tb <= "10000";
--        write_data_tb <= x"FEEDABC123459876543210BEAD789789";
--      
--        wait for period;
--
--        -- Write to register 17
--        write_addr_tb <= "10001";
--        write_data_tb <= x"F0FFFFFFFFFFFFFFFFFFFFFFFFFFFFF0";
--  
--        wait for period;
--
--        -- Read from registers 15, 16, 17
--        read_addr1_tb <= "01111";
--        read_addr2_tb <= "10000"; 
--        read_addr3_tb <= "10001"; 
--        wait for period;
		
       -- std.env.finish;
		
    end process stimulus;
	
end structural;
