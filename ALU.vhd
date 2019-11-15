--ALU
library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ALU is
   port(
    clk: in std_logic;
    ALUin1, ALUin2 : in std_logic_vector(31 downto 0);
    ALUcontrol: in std_logic_vector(2 downto 0);
    ALUout: out std_logic_vector(31 downto 0)
    );
  end ALU;

architecture ALU_a of ALU is
  begin
    process(clk)
      begin
        if(rising_edge(clk)) then
        case ALUcontrol is 
        when "010" =>
          ALUout  <= std_logic_vector(unsigned (ALUin1) + unsigned (ALUin2));
        when "110" =>
          ALUout  <= std_logic_vector(unsigned (ALUin1) - unsigned (ALUin2));
        when "000" =>
          ALUout  <= std_logic_vector(unsigned (ALUin1) and  unsigned (ALUin2));
        when "001" =>
          ALUout  <= std_logic_vector(unsigned (ALUin1) or unsigned (ALUin2));
        when others=>
          ALUout <= (others=>'X');
        end case; 
      end if;
    end process;  
end ALU_a;