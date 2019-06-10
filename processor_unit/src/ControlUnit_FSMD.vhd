library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CU is 
	port (
		clk, reset : in std_logic;
		x : in std_logic_vector(1 to 5);
		-- yin : out std_logic_vector(1 to 15);
		y : out std_logic_vector(1 to 15)
		);
end entity;    

architecture beh of CU is 
	type stateType is (a1, a2, a3, a4, a5, a6, a7, a8, a9, a10);
	signal state_reg, state_next : stateType; 
	signal controlSig : std_logic_vector(1 to 15);
begin 
	-- state register : state_reg
	-- This process contains sequential part and all the D-FF are 
	-- included in this process. Hence, onlcontrolSig 'clk' and 'reset' are 
	-- required for this process. 
	process(clk, reset)
	begin
		if reset = '0' then
			state_reg <= a1;
		elsif rising_edge(clk) then
			state_reg <= state_next;
		end if;
	end process; 
	
	-- next state logic and outputs
	-- This is combinational of the sequential design, 
	-- which contains the logic for next-state and outputs
	-- include all signals and input in sensitive-list except state_next
	process(x, state_reg) 
	begin 
		state_next <= state_reg; -- default state_next
		-- default outputs
		controlSig <= "000000000000000";
		case state_reg is
			when a1 =>
				controlSig(1)<='1';
				controlSig(2)<='1';
				controlSig(3)<='1';
				state_next <= a2; 	
			
			when a2 =>
				if x(1) = '0' then
					controlSig(4)<='1';                
					state_next <= a3; 
				else
					controlSig(14)<='1';
					state_next <= a1; 
				end if;
			
			when a3 =>
				if x(2) = '0' then
					controlSig(15)<='1';                
					state_next <= a1; 
				elsif x(3) = '1' then
					controlSig(9)<='1';
					state_next <= a4; 
				else
					controlSig(5)<='1';              
					state_next <= a4; 
				end if;	
			
			when a4 =>
				controlSig(6)<='1';
				controlSig(7)<='1';
				controlSig(8)<='1';
				state_next <= a5; 
			
			when a5 =>
				if x(3) = '1' then
					controlSig(4)<='1';                 
					state_next <= a7; 
				elsif x(4) = '1' then
					controlSig(9)<='1';
					state_next <= a6; 
				else
					controlSig(4)<='1';                 
					state_next <= a6; 
				end if;
			
			when a6 =>
				controlSig(5)<='1';
				state_next <= a7; 
			
			when a7 =>
				controlSig(10)<='1';
				controlSig(11)<='1';
				state_next <= a8; 
			
			when a8 =>
				if x(3) = '0' then                  
					state_next <= a9; 
				elsif x(2) = '0' then
					state_next <= a9; 
				else
					controlSig(9)<='1';                 
					state_next <= a9; 
				end if;
			
			when a9 =>
				if x(5) = '0' then
					controlSig(6)<='1';
					state_next <= a5; 
				elsif x(3) = '1' then
					state_next <= a10; 
				elsif x(4) = '0' then
					state_next <= a10; 
				else
					controlSig(9)<='1';                
					state_next <= a10; 
				end if;
			
			when a10 =>
				controlSig(12)<='1';
				controlSig(13)<='1';
			state_next <= a1; 		
		end case; 
	end process;  
	
	-- optional D-FF to remove glitches
	process(clk, reset)
	begin 
		if reset = '0' then 
			y <= "000000000000000";
		elsif rising_edge(clk) then
			y <= controlSig;  
		end if;
	end process; 
	
	-- yin <= controlSig;
	
end architecture;