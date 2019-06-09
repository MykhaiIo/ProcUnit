library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

entity proc is 
	generic (
		n : integer := 8
		);
	port(
		clk        : in STD_LOGIC;
		reset      : in STD_LOGIC;
		d1         : in STD_LOGIC_VECTOR(n*2-1 downto 0);
		d2         : in STD_LOGIC_VECTOR(n-1 downto 0);
		d3         : in STD_LOGIC;
		r1    	  : out STD_LOGIC_VECTOR(n-1 downto 0);
		r2	  	  : out STD_LOGIC_VECTOR(n-1 downto 0);
		IRQ1, IRQ2 : out STD_LOGIC
		);
end proc;


architecture top_level of proc is 
	component CU
		port(
			clk, reset : in std_logic;
			x : in std_logic_vector(1 to 5);
			y : out std_logic_vector(1 to 15)
			); 
	end component; 
	
	component DP
		port (
			clk       : in STD_LOGIC;
			reset     : in STD_LOGIC;
			d1        : in STD_LOGIC_VECTOR(n*2-1 downto 0);
			d2        : in STD_LOGIC_VECTOR(n-1 downto 0); 
			d3        : in STD_LOGIC;
			y 	      : in STD_LOGIC_VECTOR(1 to 15);
			x         : out STD_LOGIC_VECTOR(1 to 5);
			r1    	  : out STD_LOGIC_VECTOR(n-1 downto 0);
			r2	  	  : out STD_LOGIC_VECTOR(n-1 downto 0);
			IRQ1, IRQ2: out STD_LOGIC
			);
	end component;	
	
	signal y : std_logic_vector(1 to 15);
	signal x : std_logic_vector(1 to 5);
	signal nclk: std_logic;
	
begin
	-- enter your statements here --
	nclk<=not clk;
	
	ControlUnit: CU port map (clk, reset, x, y);
	DataPath: DP port map (nclk, reset, d1, d2, d3, y, x, r1, r2, IRQ1, IRQ2);
	
end top_level;
