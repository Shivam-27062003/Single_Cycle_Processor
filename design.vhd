-- Code your design here
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;


entity multicycle_processor is
port(
	clk: in std_logic;
    clk2: in std_logic;
    state: in std_logic_vector(1 downto 0);
    reset: in std_logic
    );
end entity;


architecture beh of multicycle_processor is

component alu is 
port(
	op1: in std_logic_vector(31 downto 0);
    op2: in std_logic_vector(31 downto 0);
    opc: in std_logic_vector(3 downto 0);
    carryin: in std_logic;
    carryout: out std_logic;
    ans: out std_logic_vector(31 downto 0)
    );
end component;

component PC is
port(
	input: in std_logic_vector(31 downto 0);
	pw: in std_logic;
    clk1: in std_logic;
	output: out std_logic_vector(6 downto 0)
	);
end component;

component mem is
port(
	mw: in std_logic;
	add1: in std_logic_vector(6 downto 0);
	data1: in std_logic_vector(31 downto 0);
	output1: out std_logic_vector(31 downto 0);
    clk2: in std_logic;
	);
end component;

component flag is
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
end component;

component REGFILE IS
PORT(
	RD1: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    RD2: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    WR1: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    DATA: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    W_SEL: IN STD_LOGIC;
    CLK3: IN STD_LOGIC;
    OUT1: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    OUT2: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END component;

component CC is 
	port(
    	Z1: in std_logic;
        Cond: in std_logic_vector(3 downto 0);
        Res: out std_logic
        );
end component;

signal opc,cond,rd1,rd2,wr1: std_logic_vector(3 downto 0);
signal data,out1,out2,S,output1,data1,input,ans,op1,op2: std_logic_vector(31 downto 0);
signal output,add1: std_logic_vector(6 downto 0);
signal z1,res,w_sel,cin,a31,b31,z,n,v,c,mw,pw,carryin,carryout: std_logic;

-- signal state: std_logic_vector(1 downto 0);
signal IR: std_logic_vector(31 downto 0);
signal DR: std_logic_vector(31 downto 0);
signal A: std_logic_vector(31 downto 0);
signal B: std_logic_vector(31 downto 0);
signal Res1: std_logic_vector(31 downto 0);

begin
comp1: alu port map(op1,op2,opc,carryin,carryout,ans);
comp2: PC port map(input,pw,clk2,output);
comp3: mem port map(mw,add1,data1,output1,clk2);
comp4: flag port map(cin,a31,b31,s,z,n,v,c);
comp5: REGFILE port map(rd1,rd2,wr1,data,w_sel,clk2,out1,out2);
comp6: CC port map(z1,cond,res);


process(clk,output1,output,ans,state,out1,out2) is
begin

	if(reset='1') then
    	input<="00000000000000000000000000000000";
--         state<="00";
        pw<='1';
  	else
    	if(state="00") then 
        	pw<='0';
            add1<=output;
            mw<='0';
            IR<=output1;
            DR<=output1;
            op1(31 downto 9)<="00000000000000000000000";
            op1(8 downto 2)<=output;
            op1(1 downto 0)<="00";
            op2<="00000000000000000000000000000100";
            opc<="0110";
            carryin<='0';
            input<=ans;
            pw<=clk;
       	elsif(state="01") then
        	rd1<=IR(19 downto 16);
            if(IR(27 downto 26)="01") then
            	rd2<=IR(15 downto 12);
           	else
            	rd2<=IR(3 downto 0);
          	end if;
            wr1<=IR(15 downto 12);
            w_sel<='0';
            A<=out1;
            B<=out2;
            pw<='0';
       	elsif(state="10") then
        	case IR(27 downto 26) is
            	when "00"=>
                	op1<=A;
                    if(IR(25)='0') then
                    	op2<=B;
                  	else
                    	op2(31 downto 8)<="000000000000000000000000";
                        op2(7 downto  0)<=IR(7 downto 0);
                  	end if;
                    opc<=IR(24 downto 21);
                    carryin<='0';
                    Res1<=ans;
                    cin<=carryout;
                    a31<=op1(31);
                    b31<=op2(31);
                    s<=ans;
              	when "10" =>
                    op1(31 downto 7)<="0000000000000000000000000";
                    op1(6 downto 0)<=output;
                	case IR(29 downto 28) is
                    	when "10" =>
                        	op2(31 downto 26)<="000000";
                            op2(1 downto 0)<="00";
                            op2(25 downto 2)<=IR(23 downto 0);
                      	when "11"=>
                        	op2<="00000000000000000000000000000000";
                       	when others=>
                        	z1<=z;
                            cond(3 downto 2)<="00";
                            cond(1 downto 0)<=IR(29 downto 28);
                            if(res='1') then 
                            	op2(31 downto 26)<="000000";
                            	op2(1 downto 0)<="00";
                            	op2(25 downto 2)<=IR(23 downto 0);
                          	else
                            	op2<="00000000000000000000000000000000";
                			end if;
             		end case;
                   	opc<="0100";
                    carryin<='0';
                    input<=ans;
                    pw<='1';
              	when "01"=>
                	op1<=A;
                    if(IR(25)='1') then
                    	op2(31 downto 12)<="00000000000000000000";
                        op2(11 downto 0)<=IR(11 downto 0);
                   	else 
                    	op2<="00000000000000000000000000000000";
                   	end if;
                    carryin<='0';
                    if(IR(23)='1') then
                    	opc<="0100";
                	else 
                    	opc<="0011";
                  	end if;
                    Res1<=ans;
             	when others=>
                	null;
       		end case;
            
            else
        	if(IR(27 downto 26)="00") then
            	data<=Res1;
                w_sel<='1';
         	elsif(IR(27 downto 26)="01") then
            	data1<=B;
                add1<=res1(6 downto 0);
                mw<='1';
                data<=output1;
                w_sel<='1';
            end if;
      	end if;
  	end if;
end process;
end beh;
                
                
        	
        	
                	
                
                       
               
                    
            
        	
    	


