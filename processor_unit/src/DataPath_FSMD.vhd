library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_unsigned.all;
use IEEE.STD_logic_arith.all;

entity DP is
	generic (
		n : integer := 8
		);
	port(
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
end entity;		   

architecture beh of DP is
	signal a  : std_logic_vector(n*2 downto 0);
	signal b  : std_logic_vector(n downto 0);
	signal c  : std_logic_vector(n-1 downto 0);
	signal TgA: std_logic;
	signal cnt: std_logic_vector(3 downto 0);
	signal RestoringDivision: std_logic;
begin
	process (clk,reset) is
		variable zeros : std_logic_vector(n*2 downto n+1)	:= (others => '0');
	begin
		if reset='0' then a<=(others=>'0');
			b<=(others=>'0');
			c<=(others=>'0');
			cnt<="1111";
		elsif rising_edge(clk) then	
			
			if y(1)='1' then RestoringDivision<=d3;
			end if;
			
			if y(2)='1' then a<='0'&d1;
			elsif y(4)='1' then a(2*n downto n)<=a(2*n downto n)+not b+(zeros&'1');
			elsif y(6)='1' then a<=a(2*n-1 downto 0) &'0';
			elsif y(9)='1' then a(2*n downto n)<=a(2*n downto n)+b;
			end if;
			
			if y(3)='1' then b<='0'&d2;
			end if;
			
			if y(7)='1' then c<=(others=>'0');
			elsif y(10)='1' then c<=c(n-2 downto 0) & not a(2*n);
			end if;
			
			if y(8)='1' then cnt<="1111";
			elsif y(11)='1' then cnt<=cnt-1;
			end if;
			
			if y(5)='1' then TgA<=a(2*n);
			end if; 
			
			if y(12)='1' then r1<=c;
			end if;
			
			if y(13)='1' then r2<=a(2*n-1 downto n);
			end if;
			
			if y(14)='1' then IRQ1<='1';
			end if;
			
			if y(15)='1' then IRQ2<='1';
			end if;		      
			
		end if;
	end process;
	
	x(1)<='1' when b = 0 else '0';
	x(2)<=a(2*n);
	x(3)<=RestoringDivision;
	x(4)<=TgA;
	x(5)<='1' when cnt = 0 else '0';
	
end architecture;