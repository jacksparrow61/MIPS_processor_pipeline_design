-- 3 input mux of execute stage
library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity Mux3 is
  port(
  s: in std_logic_vector(1 downto 0) := (others=>'0');
  i1,i2,i3: in std_logic_vector(31 downto 0) := (others=>'0');
  o: out std_logic_vector(31 downto 0) := (others=>'0')
);
end Mux3;

architecture M3_a of Mux3 is 
begin
  o <= i1 when s = "00" else
       i2 when s = "01" else
       i3 when s = "10" else
     (others=>'0');
end M3_a;
   