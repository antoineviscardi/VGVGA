library ieee;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use work.utils.all;

entity image_gen is 
	port(	
		CLK		: in	std_logic;
		RST		: in 	std_logic;
		VIDEO	: in	std_logic;
		X		: in	std_logic_vector(9 downto 0);
		Y		: in	std_logic_vector(9 downto 0);  	
		BTN		: in 	std_logic;
		SW		: in 	std_logic;
		PAUSE	: in	std_logic;	
		ADDR	: out 	std_logic_vector(12 downto 0);
		SEL		: out 	std_logic_vector(2 downto 0);
		E		: out	std_logic
		); 
end image_gen;	   

architecture behavior of image_gen is	

constant move_count_max : integer := 100000;
constant respawn_count_max : integer := 50000000;
constant hiddenX : integer := 0;
constant hiddenY : integer := 481;
constant y_max : integer := 480;
constant x_max : integer := 640;

signal count_i 			: integer range 0 to 100000 := 1;
signal respawn_count_i	: integer range 0 to 50000000 := 1;
signal enemy_dead 		: std_logic := '0';

begin
	process(CLK, RST) 										  
	
	variable enemyInitSpeedX : integer range -15 to 15 := -1;
	variable enemyInitSpeedY : integer range -15 to 15 := 1;
	
	variable spaceship 		: object := (20,0,64,32,0,2);
	variable laser 			: object := (hiddenX,hiddenY,16,4,6,0);	 
	variable enemy 			: object := (x_max-33,1,32,32,enemyInitSpeedX,enemyInitSpeedY);
	variable pauseLabel 	: object := (251,224,138,32,0,0);
	variable gameoverLabel 	: object := (256,224,128,32,0,0);
	
	
	variable tempY : std_logic_vector(9 downto 0);
	variable tempX : std_logic_vector(9 downto 0);
	variable gameover : std_logic := '0';
	
	begin 
		if (RST = '1') then 
			SEL <= (others => '0');
			ADDR <= (others => '0');
			E <= '0';
			
			enemy_dead <= '0';
			gameover := '0';
			
			spaceship.x := 20;
			spaceship.y := 0;
			laser.x := hiddenX;
			laser.y := hiddenY;
			enemy.x := x_max-33;
			enemy.y := 1;
			
			enemyInitSpeedX := -1;
			enemy.speedX := enemyInitSpeedX;
			
			enemyInitSpeedY := 1;
			enemy.speedY := enemyInitSpeedY;
			
		elsif (rising_edge(CLK)) then
			if (VIDEO = '0') then 
				SEL <= (others => '0');
				ADDR <= (others => '0');
				E <= '0';
			end if;
			
			
			-- MAIN GAME LOGIC 	
			
			-- RESPAWN ENEMY
			if (enemy_dead = '1' and respawn_count_i = 0) then
				enemyInitSpeedX := enemyInitSpeedX - 1;
				enemy.speedX := enemyInitSpeedX;
		
				enemyInitSpeedY := enemyInitSpeedY + 1;
				enemy.speedY := enemyInitSpeedY;
				
				enemy.x := x_max-33;
				enemy.y := 1;
				enemy_dead <= '0';
			end if;	
			
			-- DISPLAY OBJECTS
			
			-- GAMEOVER
			if (gameover = '1' and
				to_integer(unsigned(X)) >= gameoverLabel.x and to_integer(unsigned(X)) <= gameoverLabel.x + gameoverLabel.width) and 
				(to_integer(unsigned(Y)) >= gameoverLabel.y and (to_integer(unsigned(Y)) < gameoverLabel.y + gameoverLabel.height)) then
				SEL 	<= "111";
				E 		<= '1';
				tempY 	:= std_logic_vector(unsigned(Y) - to_unsigned(gameoverLabel.y, Y'length));
				tempX 	:= std_logic_vector(unsigned(X) - to_unsigned(gameoverLabel.x, X'length));
				ADDR 	<=  '0' & tempY(4 downto 0) & tempX(6 downto 0);
				
			-- PAUSE
			elsif (PAUSE = '0' and gameover = '0' and
				to_integer(unsigned(X)) >= pauseLabel.x and to_integer(unsigned(X)) <= pauseLabel.x + pauseLabel.width) and 
				(to_integer(unsigned(Y)) >= pauseLabel.y and (to_integer(unsigned(Y)) < pauseLabel.y + pauseLabel.height)) then
				SEL 	<= "110";
				E 		<= '1';
				tempY 	:= std_logic_vector(unsigned(Y) - to_unsigned(pauseLabel.y, Y'length));
				tempX 	:= std_logic_vector(unsigned(X) - to_unsigned(pauseLabel.x, X'length));
				ADDR 	<=  tempY(4 downto 0) & tempX(7 downto 0);	
				
			-- SPACESHIP
			elsif (to_integer(unsigned(X)) >= spaceship.x and to_integer(unsigned(X)) <= spaceship.x + spaceship.width) and 
				(to_integer(unsigned(Y)) >= spaceship.y and (to_integer(unsigned(Y)) < spaceship.y + spaceship.height)) then
				SEL		<= "000";
				E 		<= '1';
				tempY 	:= std_logic_vector(unsigned(Y) - to_unsigned(spaceship.y, Y'length));
				tempX 	:= std_logic_vector(unsigned(X) - to_unsigned(spaceship.x, X'length));
				ADDR 	<= "00" & tempY(4 downto 0) & tempX(5 downto 0);

			-- LASER
			elsif (to_integer(unsigned(X)) >= laser.x and to_integer(unsigned(X)) <= laser.x + laser.width) and 
				(to_integer(unsigned(Y)) >= laser.y and (to_integer(unsigned(Y)) < laser.y + laser.height)) then
				SEL 	<= "001";
				E		<= '1';	
				tempY 	:= std_logic_vector(unsigned(Y) - to_unsigned(laser.y, Y'length));
				tempX 	:= std_logic_vector(unsigned(X) - to_unsigned(laser.x, X'length));
				ADDR	<= "0000000" & tempY(1 downto 0) & tempX(3 downto 0);
			
			-- ENEMY
			elsif (to_integer(unsigned(X)) >= enemy.x and to_integer(unsigned(X)) <= enemy.x + enemy.width) and 
				(to_integer(unsigned(Y)) >= enemy.y and (to_integer(unsigned(Y)) < enemy.y + enemy.height)) then
				SEL 	<= "011";
				E		<= '1';	
				tempY 	:= std_logic_vector(unsigned(Y) - to_unsigned(enemy.y, Y'length));
				tempX 	:= std_logic_vector(unsigned(X) - to_unsigned(enemy.x, X'length));
				ADDR	<= "000" & tempY(4 downto 0) & tempX(4 downto 0);
				
			else
				SEL <= "000";
				E <= '0';
				ADDR <= (others => '0');
			end if;	 

			
			-- MOVE OBJECTS
			if (count_i = 0 and PAUSE = '1') then 
				
				-- SPACESHIP
				if (spaceship.y < hiddenY) then
					if (SW = '0' and spaceship.y < y_max - spaceship.height) then
						spaceship.y := spaceship.y + spaceship.speedY;
					elsif (SW = '1' and spaceship.y > 0) then 
						spaceship.y := spaceship.y - spaceship.speedY;
					end if;
				end if;
				
				-- LASER
				if (laser.y < hiddenY and laser.x < x_max) then 
					laser.x := laser.x + laser.speedX;
				elsif (laser.x >= x_max) then
					laser.x := hiddenX;
					laser.y := hiddenY;
				elsif (BTN = '1') then 
					laser.x := 85;
					laser.y := spaceship.y + 14;
				end if;
				
				-- ENEMY1
				if (enemy.y < hiddenY) then
					
					-- BOUNCE ON X
					if (enemy.x <= 0 or enemy.x + enemy.width >= x_max) then
						enemy.speedX := -enemy.speedX;
					end if;
					
					-- BOUNCE ON Y
					if (enemy.y <= 0 or enemy.y + enemy.height >= y_max) then
						enemy.speedY := -enemy.speedY;
					end if;	
					
					-- MOVE
					enemy.x := enemy.x + enemy.speedX;
					enemy.y := enemy.y + enemy.speedY;
					
					if (enemy.x < 0) then 
						enemy.x := 0;
					elsif (enemy.x > x_max) then 
						enemy.x := x_max;
					end if;
					
					if (enemy.y < 0) then 
						enemy.y := 0;
					elsif (enemy.y > y_max) then 
						enemy.y := y_max;
					end if;
					
				end if;
			end if;	   
			
			-- COLLISIONS
			
			-- LASER & ENEMY
			if (enemy.Y < hiddenY and laser.y < hiddenY and
				laser.x + laser.width >= enemy.x and laser.x < enemy.x + enemy.width and
				laser.y + laser.height >= enemy.y and laser.y < enemy.y + enemy.height) then
				enemy.x := hiddenX;
				enemy.y := hiddenY;
				laser.x := hiddenX;
				laser.y := hiddenY;
				enemy_dead <= '1';
			end if;
			
			-- SPACESHIP & ENEMY
			if (spaceship.y < hiddenY and enemy.y < hiddenY and
				spaceship.x + spaceship.width >= enemy.x and spaceship.x < enemy.x + enemy.width and
				spaceship.y + spaceship.height >= enemy.y and spaceship.y < enemy.y + enemy.height) then
				spaceship.x := hiddenX;
				spaceship.y := hiddenY;	
				gameover := '1';
			end if;
			
			
		end if;
	end process;
	
	move_count : process (CLK, RST)
	begin
		if (RST = '1' or count_i = move_count_max) then 
			count_i <= 0;
		elsif (rising_edge(CLK)) then 
			count_i <= count_i + 1;
		end if;
	end process; 
	
	respawn_count : process (CLK, RST)
	begin  
		if (RST = '1' or respawn_count_i = respawn_count_max) then
			respawn_count_i <= 0;
		elsif (rising_edge(CLK) and enemy_dead = '1' and PAUSE = '1') then	 
			respawn_count_i <= respawn_count_i + 1;
		end if;
	end process;

end behavior;

