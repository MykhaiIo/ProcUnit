library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CU is 
	port (
		clk, reset : in std_logic;
		x : in std_logic_vector(1 to 5);
		y : out std_logic_vector(1 to 15)
		);
end entity; 

architecture beh of CU is 
	type stateType is (a1, a2, a3, a4, a5, a6, a7, a8, a9, a10);
	signal state_reg, state_next : stateType; 
begin 
	-- state register : state_reg
	-- This process contains sequential part and all the D-FF are 
	-- included in this process. Hence, only 'clk' and 'reset' are 
	-- required for this process. 
	process(clk, reset)
	begin
		if reset = '0' then
			state_reg <= a1;
			--y <= "000000000000000";
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
		y <= "000000000000000";
		case state_reg is
			when a1 =>
				y(1)<='1';
				y(2)<='1';
				y(3)<='1';
				-- y <= "111000000000000"; -- y1, y2, y3
				state_next <= a2; 	
			
			when a2 =>
				if x(1) = '0' then
					y(4)<='1';
					-- y <= "000100000000000";  -- y4                 
					state_next <= a3; 
				else
					y(14)<='1';
					-- y <= "000000000000010";	 -- y14
					state_next <= a1; 
				end if;
			
			when a3 =>
				if x(2) = '0' then
					y(15)<='1';
					-- y <= "000000000000001";   -- y15                
					state_next <= a1; 
				elsif x(3) = '1' then
					y(9)<='1';
					-- y <= "000000001000000";	  -- y9
					state_next <= a4; 
				else
					y(5)<='1';
					-- y <= "000010000000000";   -- y5              
					state_next <= a4; 
				end if;	
			
			when a4 =>
				y(6)<='1';
				y(7)<='1';
				y(8)<='1';
				-- y <= "000001110000000";	-- y6, y7, y8
				state_next <= a5; 
			
			when a5 =>
				if x(3) = '1' then
					y(4)<='1';
					-- y <= "000100000000000";  -- y4                 
					state_next <= a7; 
				elsif x(4) = '1' then
					y(9)<='1';
					-- y <= "000000001000000";  -- y9
					state_next <= a6; 
				else
					y(4)<='1';
					-- y <= "000100000000000";  -- y4                 
					state_next <= a6; 
				end if;
			
			when a6 =>
				y(5)<='1';
				-- y <= "000010000000000";   -- y5
				state_next <= a7; 
			
			when a7 =>
				y(10)<='1';
				y(11)<='1';
				-- y <= "000000000110000"; -- y10, y11
				state_next <= a8; 
			
			when a8 =>
				if x(3) = '0' then                  
					state_next <= a9; 
				elsif x(2) = '0' then
					state_next <= a9; 
				else
					y(9)<='1';
					-- y <= "000000001000000";  -- y9                  
					state_next <= a9; 
				end if;
			
			when a9 =>
				if x(5) = '0' then
					y(6)<='1';
					-- y <= "000001000000000";	-- y6
					state_next <= a5; 
				elsif x(3) = '1' then
					state_next <= a10; 
				elsif x(4) = '0' then
					state_next <= a10; 
				else
					y(9)<='1';
					-- y <= "000000001000000";  -- y9                
					state_next <= a10; 
				end if;
			
			when a10 =>
				y(12)<='1';
				y(13)<='1';
				-- y <= "000000000001100"; -- y12, y13
			state_next <= a1; 		
		end case;
	end process;  
	
	-- optional D-FF to remove glitches
	--process(clk, reset)
	--	begin 
	--		if reset = '0' then 
	--			new_output1 <= "000000000000000";
	--		elsif rising_edge(clk) then
	--			new_output1 <= y;  
	--		end if;
	--	end process; 
	
end architecture;