library ieee;
use ieee.std_logic_1164.all;

entity CU_TB is
end CU_TB;

architecture beh of CU_TB is 
	
	-- Component Declaration for the Unit Under Test (UUT)
	component CU
		port(
			clk, reset : in std_logic;
			x : in std_logic_vector(1 to 5);
			y : out std_logic_vector(1 to 15)
			); 
	end component;
	
	--inputs
	signal clock : std_logic := '0';
	signal reset : std_logic := '0';
	signal infoSig : std_logic_vector(1 to 5);
	
	--Outputs
	signal controlSig : std_logic_vector(1 to 15);
	
	-- Clock period definitions
	constant clock_period : time := 50 ns;
	
begin
	-- Instantiate the Unit Under Test (UUT)
	uut: CU port map (clock, reset, infoSig, controlSig);
	
	-- Clock process definitions
	clock_process: process
	begin
		clock <= '0';
		wait for clock_period/2;
		clock <= '1';
		wait for clock_period/2;
	end process;
	
	-- Stimulus process
	stim: process
		
		begin
			wait for 100 ns;
			reset <= '1'; -- a1
			-- testing iterruptions
			wait for clock_period; -- a2
			infoSig(1)<='1'; 
			wait for clock_period*2; -- a1 -> a2
			infoSig<=(others => '0');
			infoSig(1)<='0';
			wait for clock_period; -- a3
			infoSig<=(others => '0');
			infoSig(2)<='0';	
			
			-- mormal functionning
			wait for clock_period*2; -- a1 -> a2
			infoSig<=(others => '0');
			infoSig(1)<='0';
			wait for clock_period; -- a3
			infoSig<=(others => '0');
			infoSig(2)<='1';
			infoSig(3)<='1'; -- x2 and x3
			wait for clock_period*2; -- a4 -> a5
			infoSig<=(others => '0');
			infoSig(3)<='1';
			wait for clock_period*2; -- a7 -> a8
			infoSig<=(others => '0');
			infoSig(2)<='1';
			infoSig(3)<='1';
			wait for clock_period;	 -- a9 
			infoSig<=(others => '0');
			
			-- cnt /= 0
			infoSig(5)<='0';
			wait for clock_period;	 -- a5
			infoSig<=(others => '0');
			infoSig(3)<='0';
			infoSig(4)<='0';
			wait for clock_period*3; -- a6 -> a7 -> a8
			infoSig<=(others => '0');
			infoSig(3)<='0';
			wait for clock_period;	 -- a9
			infoSig<=(others => '0');
			
			-- cnt /= 0
			infoSig(5)<='0';
			wait for clock_period;	 -- a5
			infoSig<=(others => '0');
			infoSig(3)<='0';
			infoSig(4)<='1';
			wait for clock_period*3; -- a6 -> a7 -> a8
			infoSig<=(others => '0');
			infoSig(2)<='0';
			infoSig(3)<='1';
			wait for clock_period;   -- a9
			infoSig<=(others => '0');
			
			-- cnt = 0
			infoSig(3)<='1';
			infoSig(5)<='1'; 
			
			-- new loop
			wait for clock_period*3; -- a10 -> a1 -> a2
			infoSig<=(others => '0');
			infoSig(1)<='0';
			wait for clock_period; -- a3
			infoSig<=(others => '0');
			infoSig(2)<='0';
			infoSig(3)<='0'; -- x2 and ~x3
			wait for clock_period*2; -- a4 -> a5
			infoSig<=(others => '0');
			infoSig(3)<='1';
			wait for clock_period*2; -- a7 -> a8 
			infoSig<=(others => '0');
			infoSig(2)<='1';
			infoSig(3)<='1';
			wait for clock_period;	 -- a9
			infoSig<=(others => '0');
			infoSig(3)<='0';
			infoSig(4)<='1';
			infoSig(5)<='1'; 
			wait;
		
	end process;	
end;

configuration TESTBENCH_FOR_CU of CU_TB is
	for beh
		for UUT : CU
			use entity work.CU(beh);
		end for;
	end for;
end TESTBENCH_FOR_CU;
