-- Code your design here
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity flag is
	port(
        Cin: in std_logic;
    	A31: in std_logic;
        B31: in std_logic;
        S: in std_logic_vector(31 downto 0);
       	Z: out std_logic;
        N: out std_logic;
        V: out std_logic;
        C: out std_logic
        );
end entity;


architecture beh of flag is

signal temp1: std_logic;
signal temp2: std_logic;

begin
process(Cin,A31,B31,S,temp1,temp2) is
begin
if((unsigned(S))=0) then Z<='1';
else Z<='0';
end if;
if(S(31)='1') then N<='1';
else N<='0';
end if;
C<=Cin; 
temp1<=A31 and B31 and (not S(31));
temp2<= (not A31) and (not B31) and S(31);
V<=temp2 or temp1;
end process;
end beh;


        