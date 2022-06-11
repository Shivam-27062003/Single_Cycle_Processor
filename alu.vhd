library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity alu is 
port(
	op1: in std_logic_vector(31 downto 0);
    op2: in std_logic_vector(31 downto 0);
    opc: in std_logic_vector(3 downto 0);
    carryin: in std_logic;
    carryout: out std_logic;
    ans: out std_logic_vector(31 downto 0)
    );
end entity;

architecture beh of alu is
signal opt1: std_logic_vector(32 downto 0);
signal opt2: std_logic_vector(32 downto 0);
signal anstemp: unsigned(32 downto 0);
signal temp: std_logic_vector(32 downto 0);


begin

process(op1,op2,opc,carryin,opt1,opt2,anstemp,temp) is
begin
opt1(31 downto 0)<=op1;
opt1(32)<='0';
opt2(31 downto 0)<=op2;
opt2(32)<='0';
case opc is
	when "0000"=>
    	ans<=op1 and op2;
        carryout<='0';
  	when "0001"=>
    	ans<=op1 xor op2;
        carryout<='0';
  	when "0010"=>
    	anstemp<=unsigned(opt1)-unsigned(opt2);
        carryout<='0';
        temp<=std_logic_vector(anstemp);
        ans<=temp(31 downto 0);
  	when "0011"=>
    	anstemp<=unsigned(opt2)-unsigned(opt1);
        carryout<='0';
        temp<=std_logic_vector(anstemp);
        ans<=temp(31 downto 0);
	when "0100"=>
    	anstemp<=unsigned(opt1)+unsigned(opt2);
        temp<=std_logic_vector(anstemp);
        ans<=temp(31 downto 0);
        carryout<=temp(32);
  	when "0101"=>
    	if(carryin='1') then
        	anstemp<=unsigned(opt1)+unsigned(opt2)+"1";
   			temp<=std_logic_vector(anstemp);
        	ans<=temp(31 downto 0);
        	carryout<=temp(32);
      	else
        	anstemp<=unsigned(opt1)+unsigned(opt2);
        	temp<=std_logic_vector(anstemp);
        	ans<=temp(31 downto 0);
        	carryout<=temp(32);
      	end if;
 	when "0110"=>
    	if(carryin='1') then
        	anstemp<=unsigned(opt1)-unsigned(opt2)+"1";
   			temp<=std_logic_vector(anstemp);
        	ans<=temp(31 downto 0);
        	carryout<=temp(32);
      	else
        	anstemp<=unsigned(opt1)-unsigned(opt2);
        	temp<=std_logic_vector(anstemp);
        	ans<=temp(31 downto 0);
        	carryout<=temp(32);
      	end if;
  	when "0111"=>
    	carryout<='0';
        anstemp<=unsigned(opt2)-unsigned(opt1);
        temp<=std_logic_vector(anstemp);
        ans<=temp(31 downto 0);
  	when "1000"=>
    	carryout<='0';
        ans<=op1 and op2;
  	when "1001"=>
    	carryout<='0';
        ans<=op1 xor op2;
   	when "1010"=>
    	anstemp<=unsigned(opt1)-unsigned(opt2);
        carryout<='0';
        temp<=std_logic_vector(anstemp);
        ans<=temp(31 downto 0);
  	when "1011"=>
    	anstemp<=unsigned(opt1)+unsigned(opt2);
   		temp<=std_logic_vector(anstemp);
        ans<=temp(31 downto 0);
        carryout<=temp(32);
   	when "1100"=>
    	carryout<='0';
        ans<=op1 or op2;
   	when "1101"=>
    	carryout<='0';
        ans<=op2 or "00000000000000000000000000000000";
   	when "1110"=>
    	carryout<='0';
        ans<=op1 and (not op2);
   	when "1111"=>
    	ans<=not(op2);
  	when others=>
    	null;
   	end case;
end process;
end beh;