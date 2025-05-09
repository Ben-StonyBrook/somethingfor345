library IEEE;
use IEEE.std_logic_1164.all;

entity writebackModule is
	port(
	 	 rst_bar : in std_logic;
	
		 instruction : in STD_LOGIC_VECTOR(24 downto 0);
		 in_computed_data : in STD_LOGIC_VECTOR(127 downto 0);
		 
		 write_signal : out STD_LOGIC;	--determines if data should be written back to register file
			 
		--for writing back to register file and forwarding unit 
		 wb_address : out STD_LOGIC_VECTOR(4 downto 0);
		 wb_computed_data : out STD_LOGIC_VECTOR(127 downto 0)
	     );
end writebackModule;

--}} End of automatically maintained section

architecture behavioral of writebackModule is
begin

	process(rst_bar, instruction, in_computed_data)
	
	variable write_enable : std_logic;
	
	begin
		
		if rst_bar = '0' then
			write_signal <= '1';
			wb_address <= (others => '0');
			wb_computed_data <= (others => '0');
			
		else 
			--the only instruction that doesn't WB to the RF is "nop";
			if instruction(24 downto 23) = "11" and instruction(18 downto 15) = "0000" then
				write_enable := '0';
			else
				write_enable := '1';
			end if;	
			
			write_signal <= write_enable;
			
			--On an asserted write signal, send the write register's address and its 
			--data back to the RF and the forwarding unit
			if write_enable = '1' then
				
				wb_address <= instruction(4 downto 0);
				wb_computed_data <= in_computed_data;
			
			end if;
		
		end if;	
		
	end process;	

end behavioral;
