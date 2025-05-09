LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
use work.all;

ENTITY ALU_tb IS
END ENTITY;

ARCHITECTURE structural OF ALU_tb IS
    SIGNAL instruction : std_logic_vector(24 DOWNTO 0);
    SIGNAL Rd          : std_logic_vector(127 DOWNTO 0);
    SIGNAL Rs1, Rs2, Rs3 : std_logic_vector(127 DOWNTO 0);

BEGIN
    UUT: ENTITY ALU PORT MAP 
        (
        instruction => instruction, 
        Rd => Rd, Rs1 => Rs1, Rs2 => Rs2, Rs3 => Rs3
        );

    PROCESS
    BEGIN
        -- Initialize registers with hexadecimal values
        Rs1 <= x"00000000abcd1100000000007000ffff";
        Rs2 <= x"00000000000000020000000000000001";
        Rs3 <= x"00000000000000020000000000007fff";

        instruction(20 downto 5) <= x"8000";
        instruction(4 downto 0) <= "00000";

        for loop_control in 0 to 3 loop 

            instruction(24 downto 23) <= std_logic_vector(to_unsigned(loop_control, 2));

            --test load immediate instruction
            if loop_control = 0 then
                for i in 0 to 3 loop    --cycle through the load index in "li" instruction

                    instruction(23 downto 21) <= std_logic_vector(to_unsigned(i, 3));
                    wait for 20 ns;

                end loop;

            end if;

            if loop_control = 1 then
                for i in 4 to 7 loop    --cycle through the load index in "li" instruction

                    instruction(23 downto 21) <= std_logic_vector(to_unsigned(i, 3));
                    wait for 20 ns;

                end loop;

            end if;

            if loop_control = 2 then
                --test R4 instructions
                --instruction(24 downto 23) <= "10";
                for j in 0 to 7 loop

                    instruction(22 downto 20) <= std_logic_vector(to_unsigned(j, 3));
                    wait for 20 ns;

                end loop;

            end if;

            if loop_control = 3 then
                --test R3 instructions
                --instruction(24 downto 23) <= "11";
                for k in 0 to 15 loop

                    instruction(18 downto 15) <= std_logic_vector(to_unsigned(k, 4));
                    wait for 20 ns;

                end loop;

            end if;

        end loop;--loop_control

        std.env.finish;

    END PROCESS;

END ARCHITECTURE;