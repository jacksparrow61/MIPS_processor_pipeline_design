--adder ID stage 
library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity adderID is
  port(
    PCplus4: in std_logic_vector(31 downto 0) := (others=>'0');
    Sout: in  std_logic_vector(31 downto 0) := (others=>'0');
    AdderOut: out std_logic_vector (31 downto 0) := (others=>'0')
  );
  
end adderID;

architecture adderID_a of adderID is 

signal s : std_logic_vector(31 downto 0) := (others=>'0');
begin
  s <= Sout(29 downto 0) & "00";
  AdderOut <= std_logic_vector(unsigned(PCplus4) +unsigned(s));
end adderID_a;
