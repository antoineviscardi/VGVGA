library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use std.textio.all;
use ieee.std_logic_textio.all; 
USE ieee.numeric_std.ALL;

entity rom_pauseLabel is
	 port(
		 CLK 	: in std_logic;
		 RST 	: in std_logic;	
		 E		: in std_logic;
		 ADDR	: in std_logic_vector(12 downto 0);
		 DATA 	: out std_logic_vector(7 downto 0)
	     );
end rom_pauseLabel; 

architecture behavior of rom_pauseLabel is
								  
constant data_width : integer := 8;
constant n : integer := 8192;

type rom_type is array (0 to n-1) of std_logic_vector(data_width-1 downto 0);

impure function init_rom_from_file (file_name : in string) return rom_type is
file rom_file : text is in file_name;
variable file_line : line;
variable rom : rom_type;
begin
	for i in rom_type'range loop
		readline(rom_file, file_line);
		read(file_line, rom(i));	
	end loop;
	return rom;
end function; 

constant rom : rom_type := init_rom_from_file("./pauseLabel.txt");

begin
	process(CLK, RST)		
	begin
		if (RST = '1' or E = '0') then
			DATA <= (others => '0');
		elsif(rising_edge(CLK)) then
			DATA <= rom(conv_integer(ADDR));
		end if;
	end process;
end behavior;
	