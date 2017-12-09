library ieee;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

package utils is   				  
	
	type object is record
		x 		: integer range -63 to 1023;
		y 		: integer range -63 to 1023; -- outside of screen range of 480px to hide objects
		width	: integer range 0 to 640;
		height	: integer range 0 to 480;
		speedX	: integer range -15 to 15;
		speedY  : integer range -15 to 15;
	end record object;
	
end package;