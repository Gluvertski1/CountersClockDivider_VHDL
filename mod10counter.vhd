-- Jared Day
-- 10/23/17

-- MOD 10 Counter (0..9) using a falling edge clock with enable input, async reset, 
-- synch parallel load, and a carry out. clock by the boards 50MHZ that has been divided 
-- down to a 1Hz clock. Then display the count on the 7 seg display. 


LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;


ENTITY mod10counter IS
GENERIC (N: integer := 4);													-- value for # of bit counter
PORT(
		i_en				: IN std_logic;									-- enables the counter.
		i_clk				: IN std_logic;									-- clk 
		i_load			: IN std_logic;									-- input load value		
		i_reset			: IN std_logic;
		i_d				: IN std_logic_vector(N-1 DOWNTO 0);
		o_Q				: OUT std_logic_vector(N-1 DOWNTO 0);		-- outputs from reg.
		max_tick 		: OUT std_logic);
END mod10counter;


ARCHITECTURE ckt of mod10counter IS
SIGNAL r_reg	: unsigned(N-1 DOWNTO 0);								-- register held state
SIGNAL r_next	: unsigned(N-1 DOWNTO 0);								-- register held next state


BEGIN

----------------------------------------------------------------------
-- THIS IS THE FLIP FLOP IT ONLY MOVES THE NEXT STATE INTO THE REG.
----------------------------------------------------------------------

	PROCESS(i_clk, i_reset)												-- sensitivity list
	BEGIN	
			IF (i_reset = '1') THEN
					r_reg <= (OTHERS => '0');							-- reset value					
			ELSIF(i_clk'EVENT and i_clk = '0') THEN
					r_reg <= r_next;										-- otherwise clock it and send through the FF
			END IF;
	END PROCESS;

-----------------------------------------------------------------------
-- THIS IS THE NEXT STATE LOGIC.
------------------------------------------------------------------------
	PROCESS(i_en, i_load, r_reg, i_d)
		BEGIN
				IF(i_load = '1' AND i_d < "1010") THEN
					r_next <= unsigned(i_d);
				ELSE 
					IF(i_en = '1') THEN
							IF(r_reg < "1001") THEN
							r_next <= r_reg + 1;
							
							ELSE 
							r_next <= (OTHERS => '0');
							
							END IF;
					ELSE 
						-- do nothing.
						r_next <= r_reg;
					END IF;
				END IF;	
	END PROCESS;
	
	max_tick <= '1' WHEN r_reg = ("1001") AND (i_en = '1') ELSE '0';
	
	-- output 
	o_Q <= std_logic_vector(r_reg);
END ckt;