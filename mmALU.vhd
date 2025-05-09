LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;	

ENTITY ALU IS
    PORT (			
        instruction   : IN  std_logic_vector(24 DOWNTO 0);
        Rs1      : IN  std_logic_vector(127 DOWNTO 0);
        Rs2      : IN  std_logic_vector(127 DOWNTO 0);
        Rs3      : IN  std_logic_vector(127 DOWNTO 0);	--Rs3 data only used for R4 instructions
		
		Rd       : OUT std_logic_vector(127 DOWNTO 0)
    );
END ENTITY ALU;	


ARCHITECTURE Behavioral OF ALU IS  

-- using int/long arrays, we can index the bit field range of range sizes 
-- this method will hopefully be able to produce saturation rounding
	--TYPE int_array IS ARRAY (3 DOWNTO 0) OF INTEGER RANGE -2**31 TO (2**31) - 1;   -- we use integer array for calculating integer bit fields
	TYPE long_array IS ARRAY (1 DOWNTO 0) OF SIGNED (63 downto 0); 		-- we have to be careful with long because the values are too large for integer type but it fits within signed
	TYPE signed_array_4 IS ARRAY (3 DOWNTO 0) OF signed(31 DOWNTO 0);
	
	function saturate_int(x: signed) return signed is
	    constant MAX_INT : signed(31 downto 0) := to_signed(2**31 - 1, 32);
	    constant MIN_INT : signed(31 downto 0) := to_signed(-2**31, 32);
	    variable y : signed(31 downto 0);
	begin
	    if x > MAX_INT then
	        y := MAX_INT;
	    elsif x < MIN_INT then
	        y := MIN_INT;
	    else
	        y := resize(x, 32);
	    end if;
	    return y;
	end function;
	
	function saturate_long(x: signed) return signed is
	    constant MAX_LONG : signed(63 downto 0) := to_signed(2**63 - 1, 64);
	    constant MIN_LONG : signed(63 downto 0) := to_signed(-2**63, 64);
	    variable y : signed(63 downto 0);
	begin
	    if x > MAX_LONG then
	        y := MAX_LONG;
	    elsif x < MIN_LONG then
	        y := MIN_LONG;
	    else
	        y := resize(x, 64);
	    end if;
	    return y;
	end function;

		
BEGIN  

	
    PROCESS (instruction, Rs1, Rs2, Rs3)
	
		--variable for storing the final output as the result of the ALU operations
		VARIABLE Rd_temp   : std_logic_vector(127 DOWNTO 0);		
		VARIABLE Rd_temp_R4_int : signed_array_4;
		VARIABLE Rd_temp_R4_long : long_array;
	
		--variables for load immediate
        VARIABLE imm_value : std_logic_vector(15 DOWNTO 0);
        VARIABLE index     : INTEGER RANGE 0 TO 7;
		
		-- R4 Variables ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        VARIABLE temp_prod : std_logic_vector(127 DOWNTO 0);  -- 128-bit product result
		
		-- R3 Variables ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		VARIABLE shift_amt : INTEGER range 0 to 15; --shift amount constraints for 4 bit val  
		VARIABLE count_1s : unsigned(31 downto 0);
		VARIABLE countHalfword : std_logic_vector(15 DOWNTO 0);
		VARIABLE countLead0s : integer range 0 to 16;
		VARIABLE sumAHS	: signed(15 DOWNTO 0);
		VARIABLE diffSFHS : signed(15 DOWNTO 0);
		VARIABLE prodMLHU : unsigned(31 downto 0);
		VARIABLE prodMLHCU : unsigned(31 downto 0); 
		VARIABLE broadcast_word : std_logic_vector(31 downto 0);   
		VARIABLE ROTword_rs1, ROTword_rs2 : std_logic_vector(31 DOWNTO 0);
   		VARIABLE shift_amountRot : integer range 0 to 32;
		
    BEGIN						  
		if instruction(24) = '1' then	--check for R4 or R3 type instruction
			
			if instruction(23) = '0' then	--R4 instruction
				
				case instruction(22 downto 20) is	
					
				    when "000" =>  -- signed int m-add low
				        Rd_temp_R4_int(3) := saturate_int(signed(rs3(111 downto 96)) * signed(rs2(111 downto 96)) + signed(rs1(127 downto 96)));
				        Rd_temp_R4_int(2) := saturate_int(signed(rs3(79 downto 64)) * signed(rs2(79 downto 64)) + signed(rs1(95 downto 64)));
				        Rd_temp_R4_int(1) := saturate_int(signed(rs3(47 downto 32)) * signed(rs2(47 downto 32)) + signed(rs1(63 downto 32)));
				        Rd_temp_R4_int(0) := saturate_int(signed(rs3(15 downto 0)) * signed(rs2(15 downto 0)) + signed(rs1(31 downto 0)));
				        Rd_temp := std_logic_vector(Rd_temp_R4_int(3)) & std_logic_vector(Rd_temp_R4_int(2)) & std_logic_vector(Rd_temp_R4_int(1)) & std_logic_vector(Rd_temp_R4_int(0));
				
				    when "001" =>  -- signed int m-add high
				        Rd_temp_R4_int(0) := saturate_int(signed(rs3(31 downto 16)) * signed(rs2(31 downto 16)) + signed(rs1(31 downto 0)));
				        Rd_temp_R4_int(1) := saturate_int(signed(rs3(63 downto 48)) * signed(rs2(63 downto 48)) + signed(rs1(63 downto 32)));
				        Rd_temp_R4_int(2) := saturate_int(signed(rs3(95 downto 80)) * signed(rs2(95 downto 80)) + signed(rs1(95 downto 64)));
				        Rd_temp_R4_int(3) := saturate_int(signed(rs3(127 downto 112)) * signed(rs2(127 downto 112)) + signed(rs1(127 downto 96)));
				        Rd_temp := std_logic_vector(Rd_temp_R4_int(3)) & std_logic_vector(Rd_temp_R4_int(2)) & std_logic_vector(Rd_temp_R4_int(1)) & std_logic_vector(Rd_temp_R4_int(0));
				
				    when "010" =>  -- signed int m-sub low
				        Rd_temp_R4_int(0) := saturate_int(signed(rs1(31 downto 0)) - signed(rs3(15 downto 0)) * signed(rs2(15 downto 0)));
				        Rd_temp_R4_int(1) := saturate_int(signed(rs1(63 downto 32)) - signed(rs3(47 downto 32)) * signed(rs2(47 downto 32)));
				        Rd_temp_R4_int(2) := saturate_int(signed(rs1(95 downto 64)) - signed(rs3(79 downto 64)) * signed(rs2(79 downto 64)));
				        Rd_temp_R4_int(3) := saturate_int(signed(rs1(127 downto 96)) - signed(rs3(111 downto 96)) * signed(rs2(111 downto 96)));
				        Rd_temp := std_logic_vector(Rd_temp_R4_int(3)) & std_logic_vector(Rd_temp_R4_int(2)) & std_logic_vector(Rd_temp_R4_int(1)) & std_logic_vector(Rd_temp_R4_int(0));
				
				    when "011" =>  -- signed int m-sub high
				        Rd_temp_R4_int(0) := saturate_int(signed(rs1(31 downto 0)) - signed(rs3(31 downto 16)) * signed(rs2(31 downto 16)));
				        Rd_temp_R4_int(1) := saturate_int(signed(rs1(63 downto 32)) - signed(rs3(63 downto 48)) * signed(rs2(63 downto 48)));
				        Rd_temp_R4_int(2) := saturate_int(signed(rs1(95 downto 64)) - signed(rs3(95 downto 80)) * signed(rs2(95 downto 80)));
				        Rd_temp_R4_int(3) := saturate_int(signed(rs1(127 downto 96)) - signed(rs3(127 downto 112)) * signed(rs2(127 downto 112)));
				        Rd_temp := std_logic_vector(Rd_temp_R4_int(3)) & std_logic_vector(Rd_temp_R4_int(2)) & std_logic_vector(Rd_temp_R4_int(1)) & std_logic_vector(Rd_temp_R4_int(0));
				
				    when "100" =>  -- signed long m-add low
				        Rd_temp_R4_long(0) := saturate_long(signed(rs3(31 downto 0)) * signed(rs2(31 downto 0)) + signed(rs1(63 downto 0)));
				        Rd_temp_R4_long(1) := saturate_long(signed(rs3(95 downto 64)) * signed(rs2(95 downto 64)) + signed(rs1(127 downto 64)));
				        Rd_temp := std_logic_vector(Rd_temp_R4_long(1)) & std_logic_vector(Rd_temp_R4_long(0));
				
				    when "101" =>  -- signed long m-add high
				        Rd_temp_R4_long(0) := saturate_long(signed(rs3(63 downto 32)) * signed(rs2(63 downto 32)) + signed(rs1(63 downto 0)));
				        Rd_temp_R4_long(1) := saturate_long(signed(rs3(127 downto 96)) * signed(rs2(127 downto 96)) + signed(rs1(127 downto 64)));
				        Rd_temp := std_logic_vector(Rd_temp_R4_long(1)) & std_logic_vector(Rd_temp_R4_long(0));
				
				    when "110" =>  -- signed long m-sub low
				        Rd_temp_R4_long(0) := saturate_long(signed(rs1(63 downto 0)) - signed(rs3(31 downto 0)) * signed(rs2(31 downto 0)));
				        Rd_temp_R4_long(1) := saturate_long(signed(rs1(127 downto 64)) - signed(rs3(95 downto 64)) * signed(rs2(95 downto 64)));
				        Rd_temp := std_logic_vector(Rd_temp_R4_long(1)) & std_logic_vector(Rd_temp_R4_long(0));
				
				    when "111" =>  -- signed long m-sub high
				        Rd_temp_R4_long(0) := saturate_long(signed(rs1(63 downto 0)) - signed(rs3(63 downto 32)) * signed(rs2(63 downto 32)));
				        Rd_temp_R4_long(1) := saturate_long(signed(rs1(127 downto 64)) - signed(rs3(127 downto 96)) * signed(rs2(127 downto 96)));
				        Rd_temp := std_logic_vector(Rd_temp_R4_long(1)) & std_logic_vector(Rd_temp_R4_long(0));
				
				    when others =>
				        null;
				end case;

			elsif instruction(23) = '1' then		--R3 instruction
				
				case instruction(18 downto 15) is
					
					when "0000" =>	--NOP		
						   null; -- technically this works as a NOP code
						   
						   
					when "0001" =>	--SHRHI	
					-- technically can use a function here
					
						shift_amt := to_integer(unsigned(rs2(3 downto 0)));
						for i in 0 to 7 loop --use loop to do calculations on each halfword (8 of them)
							Rd_temp((16*i) + 15 downto (16*i)) := std_logic_vector(shift_right(unsigned(rs1((16 * i) + 15 downto (16*i))), shift_amt));	  
							-- previous line has alot going on, it uses i for indexing, mulitplied by 16 due to halfword size
							-- we use unsigned value of rs1 to ensure ZExt is done properly	   
						END LOOP; 
						
								
					when "0010" =>	--AU
					-- unsigned addition with packed 32-bit values, no propagation beyond 32-bit
					FOR i in 0 to 3 LOOP
						Rd_temp((32*i) + 31 downto (32 * i)) := std_logic_vector(unsigned(Rs1((32*i) + 31 downto (32*i))) + unsigned(Rs2((32 * i) + 31 DOWNTO (32 * i))));	 
					END LOOP;
					
					
					when "0011" =>	--CNT1W 
					-- count 1s in each packed 32-bit word of the contents of register rs1, results are placed into corresponding word slots in register rd
						for i in 0 to 3 loop 
							count_1s := (others => '0'); -- fill count var.
							
							for j in 0 to 31 loop
								if Rs1((32*i) + j) = '1' then
									count_1s := count_1s + 1;   -- count '1's 
								end if;
							end loop;
							
							Rd_temp((32*i) + 31 downto (32*i)) := std_logic_vector(count_1s); -- put count value in Rd_temp
						end loop;
						
						
					when "0100" =>	--AHS
					-- packed 16-bit halfword signed addition with saturation of the contents of registers rs1 and rs2 
						FOR i IN 0 TO 7 LOOP
			            	sumAHS := signed(Rs1((16 * i) + 15 DOWNTO (16 * i))) + signed(Rs2((16 * i) + 15 DOWNTO (16 * i)));
			
			            -- Apply saturation to clamp values within 16-bit signed range (-32768 to 32767)
			            	IF sumAHS > 32767 THEN
			                	Rd_temp((16 * i) + 15 DOWNTO (16 * i)) := std_logic_vector(to_signed(32767, 16));
			            	ELSIF sumAHS < -32768 THEN
			                	Rd_temp((16 * i) + 15 DOWNTO (16 * i)) := std_logic_vector(to_signed(-32768, 16));
			           	 	ELSE
			               	 	Rd_temp((16 * i) + 15 DOWNTO (16 * i)) := std_logic_vector(sumAHS(15 DOWNTO 0));
			            	END IF;
							
				        END LOOP;
						
						
					when "0101" =>	--NOR
					--bitwise logical NOR of the contents of registers rs1 and rs2
						Rd_temp := NOT (Rs1 or Rs2);
						
						
					when "0110" =>	--BCW
					--broadcast the rightmost 32-bit word of register rs1 to each of the four 32-bit words of register rd
						broadcast_word := Rs1(31 downto 0);
					
						for i in 0 to 3 loop
							Rd_temp((i*32)+ 31 downto (i*32)):= broadcast_word;
						end loop;	
						
						
					when "0111" =>	--MAXWS
					-- for each of the four 32-bit word slots, place the maximum signed value between rs1 and rs2 in register rd
						for i in 0 to 3 loop
							
							if signed( Rs1((i*32)+ 31 downto (i*32)) ) > signed( Rs2((i*32)+ 31 downto (i*32)) ) then
								Rd_temp((i*32)+ 31 downto (i*32)):= std_logic_vector( signed( Rs1((i*32)+ 31 downto (i*32)) ) );
								
							elsif signed( Rs2((i*32)+ 31 downto (i*32)) ) > signed( Rs1((i*32)+ 31 downto (i*32)) ) then
								Rd_temp((i*32)+ 31 downto (i*32)):= std_logic_vector( signed( Rs2((i*32)+ 31 downto (i*32)) ) );
							
							else --the two signed values are equal, doesn't matter which register the word is being loaded in from 
								Rd_temp((i*32)+ 31 downto (i*32)):= std_logic_vector( signed( Rs1((i*32)+ 31 downto (i*32)) ) );
								
							end if;	
							
						end loop;
						
					
					when "1000" =>	--MINWS
					--for each of the four 32-bit word slots, place the minimum  signed value between rs1 and rs2 in register rd
						for i in 0 to 3 loop
							
							if signed( Rs1((i*32)+ 31 downto (i*32)) ) < signed( Rs2((i*32)+ 31 downto (i*32)) ) then
								Rd_temp((i*32)+ 31 downto (i*32)):= std_logic_vector( signed( Rs1((i*32)+ 31 downto (i*32)) ) );
								
							elsif signed( Rs2((i*32)+ 31 downto (i*32)) ) < signed( Rs1((i*32)+ 31 downto (i*32)) ) then
								Rd_temp((i*32)+ 31 downto (i*32)):= std_logic_vector( signed( Rs2((i*32)+ 31 downto (i*32)) ) );
							
							else --the two signed values are equal, doesn't matter which register the word is being loaded in from 
								Rd_temp((i*32)+ 31 downto (i*32)):= std_logic_vector( signed( Rs1((i*32)+ 31 downto (i*32)) ) );
								
							end if;	
							
						end loop;
						
					
					when "1001" =>	--MLHU
					--The 16 rightmost bits of each of the four 32-bit slots in register rs1 are multiplied by the 16 rightmost 
					--bits of the corresponding 32-bit slots in register rs2, treating both operands as unsigned. The four 32-bit
					--products are placed into the corresponding slots of register rd.
						for i in 0 to 3 loop
							
							prodMLHU := unsigned( Rs1((32*i + 15) downto (32*i)) ) * unsigned( Rs2((32*i + 15) downto (32*i)) );
							Rd_temp((32*i + 31) downto (32*i)) := std_logic_vector(prodMLHU);
							
						end loop;
					
					
					when "1010" =>	--MLHCU
					--The 16 rightmost bits of each of the four 32-bit slots in register rs1 are multiplied by a 5-bit value in the 
					--rs2 field of the instruction, treating both operands as unsigned. The four 32-bit	products are placed into the 
					--corresponding slots of register rd.
						for i in 0 to 3 loop
							
							prodMLHCU := unsigned( Rs1((32*i + 15) downto (32*i)) ) * resize( unsigned( instruction(14 downto 10)), 16 );
							Rd_temp((32*i + 31) downto (32*i)) := std_logic_vector(prodMLHCU);	--resize: a numeric_std library function 																											--that pads our value to the specified 32 bits
							
						end loop;
						
						
					when "1011" => --AND 
						--bitwise logical AND of the contents of registers rs1 and rs2
						Rd_temp := Rs1 AND Rs2;
						
					when "1100" =>	--CLZH		
					-- for each of the eight 16-bit halfword slots in register rs1, count the number of zero bits to the left of the first “1”
						FOR i IN 0 TO 7 LOOP
				            countHalfword := Rs1((16 * i) + 15 DOWNTO (16 * i));  -- Extract 16-bit halfword
				            countLead0s := 0;
				
				            -- Count leading zeros (loop through bits from MSB to LSB)
				            FOR j IN 15 DOWNTO 0 LOOP
								
				                IF countHalfword(j) = '1' THEN
				                    EXIT;  -- Stop counting when first '1' is found
									
				                ELSE
				                    countLead0s := countLead0s + 1;
									
				                END IF;
								
				            END LOOP;
				
				            -- If the halfword is all zeroes, count remains 16
				            Rd_temp((16 * i) + 15 DOWNTO (16 * i)) := std_logic_vector(to_unsigned(countLead0s, 16));
				        END LOOP;
						
					
					when "1101" =>	--ROTW
					--the contents of each 32-bit field in register rs1 are rotated to the right according to the value of the 5 least significant 
					--bits of the corresponding 32-bit field in register rs2. The results are placed in register rd. Bits rotated out of the right 
					--end of each word are rotated in on the left end of the same 32-bit word field.   
					
					-- rotate bits in word 
				        FOR i IN 0 TO 3 LOOP
				            ROTword_rs1 := Rs1((32 * i) + 31 DOWNTO (32 * i));  -- Extract 32-bit word from Rs1
				            ROTword_rs2 := Rs2((32 * i) + 31 DOWNTO (32 * i));  -- Extract 32-bit word from Rs2
				
				            -- Get shift amount from the least significant 5 bits (0 to 31)
				            shift_amountRot := to_integer(unsigned(ROTword_rs2(4 DOWNTO 0)));
				
				            -- Perform right rotation
				            Rd_temp((32 * i) + 31 DOWNTO (32 * i)) := 
				                ROTword_rs1(shift_amountRot - 1 DOWNTO 0) & ROTword_rs1(31 DOWNTO shift_amountRot);
					    END LOOP;					
					

					when "1110" =>	--SFWU
					--packed 32-bit word unsigned subtract of the contentsof rs1 from rs2 (rd = rs2 - rs1)					
					for i in 0 to 3 loop
						
						Rd_temp((32*i) + 31 downto (32 * i)) := std_logic_vector( unsigned( Rs2((32*i) + 31 downto (32*i)) ) - unsigned( Rs1((32 * i) + 31 DOWNTO (32 * i) ) ) );
						
					end loop;	
						
					
					when "1111" =>	--SFHS
					--packed 16-bit halfword signed subtraction with saturation of the contents of rs1 from rs2 (rd = rs2 - rs1)
						for i in 0 to 7 loop
							
							diffSFHS := signed( Rs2((16 * i) + 15 DOWNTO (16 * i)) ) - signed( Rs1((16 * i) + 15 DOWNTO (16 * i)) );
							
							--check for overflow/underflow, if so readjust the value to within bounds; otherwise, keep computed value
							if to_integer( signed(diffSFHS) ) > (2**16 - 1) then
								--overflow, set result to 2^16 - 1
								Rd_temp((16 * i) + 15 DOWNTO (16 * i)) := std_logic_vector( to_signed(2**16 - 1, 16) );
								
							elsif to_integer( signed( Rd_temp((16 * i) + 15 DOWNTO (16 * i)) ) ) < (-1 * (2**16)) then
								--underflow, set result to -2^16
								Rd_temp((16 * i) + 15 DOWNTO (16 * i)) := std_logic_vector( to_signed(-1 * (2**16), 16) );
								
							else
								Rd_temp((16 * i) + 15 DOWNTO (16 * i)) := std_logic_vector(diffSFHS);
								
							end if;
								  
						end loop;
					
					
					when others => null;
		
				end case; 
	
			end if;
		
		elsif instruction(24) = '0' then	--load immediate instruction
			--Load a 16-bit Immediate value (half-word) from the [20:5] instruction field into the 16-bit field 
			--specified by the Load Index field [23:21] of the 128-bit register rd. Other fields of register rd are not changed 			
			
			index := to_integer(unsigned(instruction(23 DOWNTO 21)));  -- Extract Load Index
            imm_value := instruction(20 DOWNTO 5);  -- Extract Immediate Value
            Rd_temp(16 * (index + 1) - 1 DOWNTO 16 * index) := imm_value;
		
		end if;
        
        Rd <= Rd_temp; -- Update Rd only after processing	
		
    END PROCESS;
END ARCHITECTURE Behavioral;