
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity CC is 
	port(
    	Z1: in std_logic;
        Cond: in std_logic_vector(3 downto 0);
        Res: out std_logic
        );
end CC;


architecture beh of CC is
begin
process(Z1,Cond) is
begin
case Cond is
	when "0000"=>
      if(Z1='1') then
          Res<='1';
      else 
          Res<='0';
      end if;
	when "0001"=>
    	if(Z1='1') then
        	Res<='0';
    	else
        	Res<='1';
        end if;
    when others=>
    	Res<='Z';
end case;
end process;
end beh;