library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

entity PU_TB is
	generic (
		n : integer := 8
		);
end PU_TB;   

architecture beh of PU_TB is 
	
	-- Component Declaration for the Unit Under Test (UUT)
	component proc
		port (
			clk        : in STD_LOGIC;
			reset      : in STD_LOGIC;
			d1         : in STD_LOGIC_VECTOR(n*2-1 downto 0);
			d2         : in STD_LOGIC_VECTOR(n-1 downto 0);
			d3         : in STD_LOGIC;
			r1    	  : out STD_LOGIC_VECTOR(n-1 downto 0);
			r2	  	  : out STD_LOGIC_VECTOR(n-1 downto 0);
			IRQ1, IRQ2 : out STD_LOGIC
			);
	end component;
	
	--inputs
	signal clock : std_logic := '0';
	signal reset : std_logic := '0';
	signal data1 : std_logic_vector(n*2-1 downto 0) := (others => 'Z');
	signal data2 : std_logic_vector(n-1 downto 0) := (others => 'Z');
	signal data3 : std_logic := '0';
	
	--Outputs
	signal rest1 : std_logic_vector(n-1 downto 0) := (others => 'Z'); 
	signal rest2 : std_logic_vector(n-1 downto 0) := (others => 'Z');
	signal Interrupt1 : std_logic := 'Z'; 
	signal Interrupt2 : std_logic := 'Z';
	
	-- Clock period definitions
	constant clock_period : time := 50 ns;
	
begin
	-- Instantiate the Unit Under Test (UUT)
	uut: proc port map (clock, reset, data1, data2, data3, rest1, rest2, Interrupt1, Interrupt2 );
	
	-- Clock process definitions
	clock_process :process
	begin
		clock <= '0';
		wait for clock_period/2;
		clock <= '1';
		wait for clock_period/2;
	end process;
	
	-- Stimulus process
	stim_proc: process
	begin 
		wait for 100 ns;
		reset <= '1';
		data1 <= "0000000000011001";	-- "1000011100010110" = 34 582
		data2 <= "00000101"; -- "01001110" = 78
		data3 <= '0'; 
		
		wait for 5000 ns;
		
		reset <= '0';
		
		wait for 100 ns;
		reset <= '1';
		data1 <= "0000000000001110";	-- "1000011100010110" = 34 582
		data2 <= "00000101"; -- "01001110" = 78
		data3 <= '1'; 
		
		wait for 5000 ns;
		wait;
	end process;	
end;

configuration TESTBENCH_FOR_PU of PU_TB is
	for beh
		for UUT : proc
			use entity work.proc(top_level);
		end for;
	end for;
end TESTBENCH_FOR_PU;

