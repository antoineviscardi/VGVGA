library ieee;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;

entity vga_driver is
	port(
	CLK		: in std_logic;
	RST	: in std_logic;
	HSYNC	: out std_logic;
	VSYNC	: out std_logic;
	VIDEO	: out std_logic;
	X		: out std_logic_vector(9 downto 0);
	Y		: out std_logic_vector(9 downto 0)
	);
end vga_driver;	   

architecture behaviour of vga_driver is

-- HORIZONTAL CONSTANTS
constant h_fp	: integer := 16;
constant h_bp	: integer := 48;
constant h_ret	: integer := 96;
constant h_res	: integer := 640;   
constant h_max	: integer := 800;
constant h_video_on_start	: integer := 144;
constant h_video_on_stop	: integer := 784;

-- VERTICAL CONSTANTS
constant v_fp	: integer := 10;
constant v_bp	: integer := 33;
constant v_ret	: integer := 2;
constant v_res	: integer := 480;	
constant v_max	: integer := 525;
constant v_video_on_start	: integer := 35;
constant v_video_on_stop	: integer := 515; 

-- INTERNAL SIGNALS
signal h_count_internal		: unsigned(9 downto 0);
signal v_count_internal 	: unsigned(9 downto 0);
signal h_sync_internal		: std_logic;	
signal v_sync_internal		: std_logic;	
signal h_video_on_internal	: std_logic;
signal v_video_on_internal	: std_logic;	 

begin
	-- increments horizontal and vertical count values
	count_process: process(CLK, RST)
	begin
		if (RST = '1') then
			h_count_internal <= (others => '0');
			v_count_internal <= (others => '0'); 
		elsif (rising_edge(CLK)) then
			h_count_internal <= h_count_internal + 1;
			if (h_count_internal > h_max) then
				h_count_internal <= (others => '0');
				v_count_internal <= v_count_internal + 1;
				if (v_count_internal > v_max) then
					v_count_internal <= (others => '0');
				end if;
			end if;
		end if;
	end process; 
	
	-- sets h_sync internal signal
	h_sync_process: process(CLK, RST)
	begin		
		if (RST = '1') then 
			h_sync_internal <= '1';
		elsif (rising_edge(CLK)) then
			if (h_count_internal < h_ret) then
				h_sync_internal <= '0';
			else
				h_sync_internal <= '1';
			end if;
		end if;
	end process;
	
	-- sets v_sync internal signal
	v_sync_process: process(CLK, RST)
	begin		
		if (RST = '1') then 
			v_sync_internal <= '1';	 
		elsif (rising_edge(CLK)) then
			if (v_count_internal < v_ret) then
				v_sync_internal <= '0';
			else
				v_sync_internal <= '1';
			end if;	  
		end if;
	end process;	 	
	
	-- sets video_on (horizontal component) internal signal
	h_video_on_process: process(CLK, RST)
	begin		
		if (RST = '1') then 
			h_video_on_internal <= '0';
		elsif (rising_edge(CLK)) then	
			if ((h_count_internal > h_video_on_start) and 
				(h_count_internal < h_video_on_stop)) then
				h_video_on_internal <= '1';
			else
				h_video_on_internal <= '0';
			end if;
		end if;
	end process;   
	
	-- sets video_on (vertical component) internal signal
	v_video_on_process: process(CLK, RST)
	begin		
		if (RST = '1') then 
			v_video_on_internal <= '0';	
		elsif (rising_edge(CLK)) then
			if ((v_count_internal > v_video_on_start) and 
				(v_count_internal < v_video_on_stop)) then
				v_video_on_internal <= '1';
			else
				v_video_on_internal <= '0';
			end if;
		end if;
	end process;	  
	
	-- set external signals from internal signals
	X <= std_logic_vector(h_count_internal - h_video_on_start);
	Y <= std_logic_vector(v_count_internal - v_video_on_start);
	HSYNC <= h_sync_internal;
	VSYNC <= v_sync_internal;
	VIDEO <= '1' when (h_video_on_internal = '1' and v_video_on_internal = '1') else '0'; 
	
end behaviour;
	