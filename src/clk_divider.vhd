library ieee;
use ieee.std_logic_1164.all;

entity clk_divider is
	port (
	CLK		: in std_logic;	
	RST		: in std_logic;
	CLK_OUT	: out std_logic
	);
end clk_divider;

architecture behaviour of clk_divider is
signal clk_i : std_logic;
begin
	process(CLK, RST)
	begin		
		if (RST = '1') then
			clk_i <= '0';
		elsif (rising_edge(CLK)) then
			clk_i <= not clk_i;
		end if;
	end process;
	
	CLK_OUT <= clk_i;
	
end behaviour;
	