--MUX Instruction Decode Stage
library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity MUX_IDStage is
  port (
      Mux_s: in std_logic :='0';
      RegData,ALUout: in std_logic_vector(31 downto 0):=(others=>'0');
      Muxout: out std_logic_vector(31 downto 0):=(others=>'0')
    );
  end MUX_IDStage;
  
architecture MUX_IDStage_arc of MUX_IDStage is
begin
 Muxout <= RegData when Mux_s = '0' else
           ALUout  when Mux_s = '1' else (others=>'0');
        
end MUX_IDStage_arc;