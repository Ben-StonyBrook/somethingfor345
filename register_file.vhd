library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;  

entity registerFile is
    port ( 
		clk : in std_logic;
		rst_bar : in std_logic;
		instruction_decode : in std_logic_vector(24 downto 0);
	
        read_addr1 : in STD_LOGIC_VECTOR(4 downto 0);  -- Address of the first register being read
        read_addr2 : in STD_LOGIC_VECTOR(4 downto 0);  -- Address of the second register being read
        read_addr3 : in STD_LOGIC_VECTOR(4 downto 0);  -- Address of the third register being read
			
        write_addr : in STD_LOGIC_VECTOR(4 downto 0);  -- Address of the register being written into the RF
        write_data : in STD_LOGIC_VECTOR(127 downto 0); -- Data of the register being written into the RF
		write_signal : in std_logic;		--when asserted, a 128-bit result can be written into the RF
		
        read_data1 : out STD_LOGIC_VECTOR(127 downto 0); -- Data of the first register being read
        read_data2 : out STD_LOGIC_VECTOR(127 downto 0); -- Data of the second register being read
        read_data3 : out STD_LOGIC_VECTOR(127 downto 0)  -- Data of the third register being read
		
          );
end registerFile;

architecture behavioral of registerFile is
										   								 
    -- Declare 32 registers, each 128 bits wide
    type reg_array is array(0 to 31) of STD_LOGIC_VECTOR(127 downto 0);
    signal reg_file : reg_array := (others => (others => '0')); -- Initialize registers to 0 
	
begin
		
    -- Process for writing & reading data is sensitive to the system clock
    process(clk, rst_bar)
    begin
		if rst_bar = '0' then
			read_data1 <= (others => '0');
	        read_data2 <= (others => '0');
	        read_data3 <= (others => '0');
			
		else   
			
			--operates on a rising edge clock
	        if rising_edge(clk) then
				
				if write_signal = '1' then	--only writes when write_signal = '1' (for all instructions except "nop")
					
					-- Write data to the selected register based on the write-back module
		        	reg_file(to_integer(unsigned(write_addr))) <= write_data;
							
				end if;
									
				-- On each cycle, data from the specified 128-bit registers are to be 
				-- read from the RF and sent to the ID/EX register
			    read_data1 <= reg_file(to_integer(unsigned(read_addr1)));
			    read_data2 <= reg_file(to_integer(unsigned(read_addr2)));
				read_data3 <= reg_file(to_integer(unsigned(read_addr3))); 
				
			end if;
			
		end if;	
			 
		
    end process;

end behavioral;  
