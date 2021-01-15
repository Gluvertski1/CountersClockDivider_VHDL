-- Jared Day
--10/20/2017

-- lab 8a.

-- This design is the universal counter described in Table 4.1 Chu Ch4 page 82. This will have a generic
-- set to 8 bits. A min and max tick output. synch. load input. asynch reset. 

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;


ENTITY univ_counter1 IS
GENERIC (N: integer := 4);													-- value for # of bit counter
PORT(
		i_en				: IN std_logic;									-- enables the counter.
		i_clk				: IN std_logic;									-- clk and reset inputs	
		i_reset			: IN std_logic;
		i_up				: IN std_logic;									-- either count up or down.
		i_load			: IN std_logic;									-- input load value		
		i_synclear		: IN std_logic;
		i_d				: IN std_logic_vector(N-1 DOWNTO 0);
		o_Q				: OUT std_logic_vector(N-1 DOWNTO 0);		-- outputs from reg.
		max_tick 		: OUT std_logic;
		min_tick 		: OUT std_logic);
END univ_counter1;


ARCHITECTURE ckt of univ_counter1 IS
SIGNAL r_reg	: std_logic_vector(N-1 DOWNTO 0);								-- register held state
SIGNAL r_next	: std_logic_vector(N-1 DOWNTO 0);								-- register held next state


BEGIN

----------------------------------------------------------------------
-- THIS IS THE FLIP FLOP IT ONLY MOVES THE NEXT STATE INTO THE REG.
----------------------------------------------------------------------

	PROCESS(i_clk, i_reset, r_next)												-- sensitivity list
	BEGIN	
			--IF (i_reset = '1') THEN
					--r_reg <= (OTHERS => '0');							-- reset value					
			IF (i_clk'EVENT and i_clk = '1') THEN
					r_reg <= r_next;										-- otherwise clock it and send through the FF
			END IF;
	END PROCESS;

-----------------------------------------------------------------------
-- THIS IS THE NEXT STATE LOGIC.
------------------------------------------------------------------------
	PROCESS(i_en, i_up, i_load, r_next, r_reg, i_d, i_synclear)
		BEGIN
		
			IF (i_synclear = '1') THEN
				r_next <= (OTHERS => '0');
			ELSE
				IF(i_load = '1')	THEN
					--r_next <= unsigned(i_d);
					r_next <= i_d;
				ELSE
					IF(i_en = '1') THEN
				
					-- next state
						IF(i_up = '1') THEN
							r_next <= std_logic_vector(unsigned(r_reg) + 1);										-- count up
						ELSE	
							r_next <= std_logic_vector(unsigned(r_reg) - 1);
						END IF;
					ELSE		-- do nothing and dont enable the counter. pause.
						r_next <= r_reg;
					END IF;
				END IF;
			END IF;
	END PROCESS;
	-- max and min tick

	max_tick <= '1' WHEN unsigned(r_reg) =(2**N - 1) ELSE '0';
	min_tick <= '1' WHEN unsigned(r_reg) = "0" ELSE '0';
	
	-- output 
	o_Q <= r_reg;
END ckt;
		
		