-- 2 input mux to select registers
library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity MuxR is
  port(
  s: in std_logic:= '0';
  i1,i2: in std_logic_vector(4 downto 0) := (others=>'0');
  o: out std_logic_vector(4 downto 0) := (others=>'0')
);
end MuxR;

architecture MRa of MuxR is 
begin
  o <= i1 when s = '0' else
       i2 when s = '1' else
       (others=>'0');
end MRa;
