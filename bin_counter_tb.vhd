-- Jared Day
-- 10/21/2017

-- This is the test bench file. From Dr. Clements PPT from Chu CH4 p 84. 
-- I will copy this exactly and use it on the universal binary counter i have created. 


LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY bin_counter_tb IS
END bin_counter_tb;

ARCHITECTURE arch OF bin_counter_tb IS
CONSTANT THREE: integer := 3;
CONSTANT T: time := 20 ns;				-- clk period
SIGNAL clk, reset: std_logic;
SIGNAL syn_clr, load, en, up: std_logic;
SIGNAL d: std_logic_vector(THREE-1 DOWNTO 0);
SIGNAL max_tick, min_tick: std_logic;
SIGNAL q: std_logic_vector(THREE-1 DOWNTO 0);

BEGIN
-- *****************************
-- instantiation
--******************************
counter_unit: ENTITY work.univ_counter1(ckt)
GENERIC MAP(N =>THREE)
PORT MAP (i_clk => clk, i_reset => reset, i_synclear => syn_clr, i_load => load, i_en => en, i_up => up, i_d => d,
			max_tick => max_tick, min_tick => min_tick, o_Q=> q);
			
--**************************
-- clock
--**************************
-- 20 ns clock running forever

PROCESS 
BEGIN
clk <= '0';
WAIT FOR T/2;
clk <=  '1';
WAIT FOR T/2;
END PROCESS;

--**************************
-- RESET
--**************************

--reset asserted for T/2;
reset <= '1', '0' AFTER T/2;

--**************************
-- other stimulus
--**************************
PROCESS
BEGIN
	--***********************
	-- initial input
	--***********************
	syn_clr <= '0';
	load <= '0';
	en <= '0';
	up <= '1';	-- count up
	d <= (OTHERS =>'0');
	WAIT UNTIL falling_edge(clk);
	WAIT UNTIL falling_edge(clk);
	
	--**********************
	-- test load
	--**********************
	load <= '1';
	d <= "011";
	WAIT UNTIL falling_edge(clk);
	load <= '0';
	-- pause 2 clock
	WAIT UNTIL falling_edge(clk);
	WAIT UNTIL falling_edge(clk);
	
	--**********************
	-- test syn_clear
	--**********************
	syn_clr <= '1';	-- clear
	WAIT UNTIL falling_edge(clk);
	syn_clr <= '0';
	
	--**************************
	-- test up counter and pause
	--**************************
	en <= '1';
	up <= '1';
	FOR i IN 1 TO 10 LOOP	-- count for 10 clocks
		WAIT UNTIL falling_edge(clk);
	END LOOP;
	en <='0';
	WAIT UNTIL falling_edge(clk);
	WAIT UNTIL falling_edge(clk);
	en <= '1';
	WAIT UNTIL falling_edge(clk);
	WAIT UNTIL falling_edge(clk);
	
	--****************************
	-- test down counter
	--****************************
	up <= '0';
	FOR i IN 1 TO 10 LOOP	-- count for 10 clocks
		WAIT UNTIL falling_edge(clk);
	END LOOP;
	
	--*************************
	-- other wait conditions
	--*************************
	-- continue until q = 2
	WAIT UNTIL q = "010";
	WAIT UNTIL falling_edge(clk);
	up <= '1';
	
	-- continue until min_tick changes value
	WAIT ON min_tick;
	WAIT UNTIL falling_edge(clk);
	up <= '0';
	WAIT FOR 4*T;	-- wait for 80 ns
	en <= '0';
	WAIT FOR 4*T;
	
	--*********************
	-- TERMINATE SIMULATION
	--*********************
	
	ASSERT false
		REPORT "SIMULATION COMPLETED"
	SEVERITY failure;
	END PROCESS;
END arch;
	
