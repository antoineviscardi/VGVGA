library ieee;
use ieee.std_logic_1164.ALL;

entity output_mux is
    Port ( S   : in  std_logic_vector(2 downto 0);
           I0  : in  std_logic_vector (7 downto 0);
           I1  : in  std_logic_vector (7 downto 0);
		   I2  : in  std_logic_vector (7 downto 0);
		   I3  : in  std_logic_vector (7 downto 0);
		   I4  : in  std_logic_vector (7 downto 0);
		   I5  : in  std_logic_vector (7 downto 0);
		   I6  : in  std_logic_vector (7 downto 0);
		   I7  : in  std_logic_vector (7 downto 0);
           O   : out std_logic_vector (7 downto 0));
end output_mux;

architecture behavior of output_mux is
begin
	with S select
    O <= 
	I0 when "000",
	I1 when "001", 
	I2 when "010",
	I3 when "011",
	I4 when "100",
	I5 when "101",
	I6 when "110",
	I7 when "111",
	(others => '0') when others;
end behavior;