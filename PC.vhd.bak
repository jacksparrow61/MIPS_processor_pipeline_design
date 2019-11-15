-- Program Counter
-- libraries
library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity PC is
  port
      (
        clk : in std_logic;
        en : in std_logic :='1';
        PC_in : in std_logic_vector(31 downto 0) :=(others=>'0');
        PC_out : out std_logic_vector(31 downto 0) :=(others=>'0');
        PCplus4 : out std_logic_vector(31 downto 0) :=(others=>'0')
        );
end PC;

architecture PC_arc of PC is 
begin
  process(clk)
    begin
      if (rising_edge(clk)) then
        PC_out<=PC_in;
        if(en = '1') then
        PCplus4<=std_logic_vector( unsigned(PC_in) + X"4" );
      else
        PCplus4<=std_logic_vector( unsigned(PC_in));
      end if;
    end if;
  end process;
end PC_arc;
      

