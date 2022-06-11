LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
    
entity PC is
port(
	input: in std_logic_vector(31 downto 0);
	pw: in std_logic;
    clk1: in std_logic;
	output: out std_logic_vector(6 downto 0)
	);
end entity;

architecture beh of PC is
signal mem: std_logic_vector(31 downto 0);
begin
K: process(clk1) is
begin
if(rising_edge(clk1)) then
	if(pw='1') then	
		mem<=input;
  	else
    	output<=mem(8 downto 2);
	end if;
end if;
end process;
end beh;
