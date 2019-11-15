-- 2 input mux in Wb stage to select Read Data / ALU output
library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity WB_Stage is
  port(
    MemtoRegW: in std_logic:='0';
    ALUoutW, ReadDataW: in std_logic_vector(31 downto 0):=(others=>'0');
    ResultW: out std_logic_vector(31 downto 0):=(others=>'0')
  );
end WB_Stage;

architecture WB_Stage_a of WB_Stage is
begin
  ResultW <= ALUoutW  when  MemtoRegW='0' else
             ReadDataW when MemtoRegW='1' else
             (others=>'0');
end WB_Stage_a; 
