library ieee;
use ieee.std_logic_1164.all;

entity DP_TB is
	generic (
		n : integer := 8
		);
end DP_TB;

architecture beh of DP_TB is 
	
	-- Component Declaration for the Unit Under Test (UUT)
	component DP
		port (
			clk       : in STD_LOGIC;
			reset     : in STD_LOGIC;
			d1        : in STD_LOGIC_VECTOR(n*2-1 downto 0);
			d2        : in STD_LOGIC_VECTOR(n-1 downto 0); 
			d3        : in STD_LOGIC;
			y 	      : in STD_LOGIC_VECTOR(1 to 15);
			x         : out STD_LOGIC_VECTOR(1 to 5);
			r1, r2    : out STD_LOGIC_VECTOR(n-1 downto 0);
			IRQ1, IRQ2: out STD_LOGIC
			);
	end component;	
	
	--inputs
	signal clock : std_logic := '0';
	signal reset : std_logic := '0';
	signal data1 : std_logic_vector(n*2-1 downto 0) := (others => 'Z');
	signal data2 : std_logic_vector(n-1 downto 0) := (others => 'Z');
	signal data3 : std_logic := '0';
	signal controlSig : std_logic_vector(1 to 15);
	
	--Outputs
	signal infoSig : std_logic_vector(1 to 5);
	signal rest1 : std_logic_vector(n-1 downto 0) := (others => 'Z'); 
	signal rest2 : std_logic_vector(n-1 downto 0) := (others => 'Z');
	signal Interrupt1 : std_logic := 'Z'; 
	signal Interrupt2 : std_logic := 'Z'; 
	
	-- Clock period definitions
	constant clock_period : time := 50 ns;
	
begin
	-- Instantiate the Unit Under Test (UUT)
	uut: DP port map ( clock, reset, data1, data2, data3, controlSig,
		infoSig, rest1, rest2, Interrupt1, Interrupt2 );
	
	-- Clock process definitions
	clock_process: process
	begin
		clock <= '0';
		wait for clock_period/2;
		clock <= '1';
		wait for clock_period/2;
	end process;
	
	-- Stimulus process
	process
		procedure non_rest_div is
		begin  
			wait for 100 ns;
			--Initialize inputs
			reset <= '1';
			data1 <= "1000011100010110";	--"1000011100010110" = 34 582
			data2 <= "01001110"; -- "01001110" = 78
			data3 <= '0'; 
			
			wait for 50 ns;
			controlSig<=(others => '0');
			controlSig(1)<='1';
			controlSig(2)<='1';
			controlSig(3)<='1';	 -- y1, y2, y3
			
			wait for 50 ns;
			controlSig<=(others => '0');
			controlSig(4)<='1';  -- y4
			
			wait for 50 ns;
			controlSig<=(others => '0');
			controlSig(5)<='1';  -- y5 
			
			wait for 50 ns;
			controlSig<=(others => '0');
			controlSig(6)<='1';
			controlSig(7)<='1';
			controlSig(8)<='1';  -- y6, y7, y8	 
			
			wait for 50 ns;
			controlSig<=(others => '0');
			
			for cnt in 0 to 15 loop
				
				controlSig(4)<='1';  -- y4	
				
				wait for 50 ns;
				controlSig<=(others => '0');
				controlSig(5)<='1';  -- y5	
				
				wait for 50 ns;
				controlSig<=(others => '0');
				controlSig(10)<='1';
				controlSig(11)<='1'; -- y10, y11
				
				wait for 50 ns;
				controlSig<=(others => '0');
				controlSig(6)<='1';  -- y6	
				
				wait for 50 ns;
				
			end loop;
			controlSig<=(others => '0');
			controlSig(9)<='1';  -- y9
			
			wait for 50 ns;	
			controlSig<=(others => '0');
			controlSig(12)<='1';
			controlSig(13)<='1';  -- y12, y13
			
			wait for 200 ns;
		end procedure;
		
		procedure rest_div is
		begin  
			
			--Initialize inputs
			reset <= '1';
			data1 <= "1000011100010110";	--"1000011100010110" = 34 582
			data2 <= "01001110"; -- "01001110" = 78
			data3 <= '1'; 
			
			wait for 50 ns;
			controlSig<=(others => '0');
			controlSig(1)<='1';
			controlSig(2)<='1';
			controlSig(3)<='1';	 -- y1, y2, y3
			
			wait for 50 ns;
			controlSig<=(others => '0');
			controlSig(4)<='1';  -- y4
			
			wait for 50 ns;
			controlSig<=(others => '0');
			controlSig(9)<='1';  -- y9 
			
			wait for 50 ns;
			controlSig<=(others => '0');
			controlSig(6)<='1';
			controlSig(7)<='1';
			controlSig(8)<='1';  -- y6, y7, y8	 
			
			wait for 50 ns;
			controlSig<=(others => '0');
			
			for cnt in 0 to 15 loop
				
				controlSig(4)<='1';  -- y4	
				
				wait for 50 ns;
				controlSig<=(others => '0');
				controlSig(10)<='1';
				controlSig(11)<='1'; -- y10, y11
				
				wait for 50 ns;
				controlSig<=(others => '0');
				controlSig(9)<='1';  -- y9 
				
				wait for 50 ns;
				controlSig<=(others => '0');
				controlSig(6)<='1';  -- y6	
				
				wait for 50 ns;
				
			end loop;	
			controlSig<=(others => '0');
			controlSig(12)<='1';
			controlSig(13)<='1';  -- y12, y13
			
			wait;
		end procedure;
	begin 
		non_rest_div;
		wait for 10 ns;
		reset<='0';
		wait for 10 ns;
		rest_div;
	end process;
end;

configuration TESTBENCH_FOR_DP of DP_TB is
	for beh
		for UUT : DP
			use entity work.DP(beh);
		end for;
	end for;
end TESTBENCH_FOR_DP;
