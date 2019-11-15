-- MUX in IF Stage
--libraries
library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity MUX_IF_Stage is
  port 
      (
        Mux_sel : in std_logic :='0';
        PCplus4, Bra_PC : in std_logic_vector(31 downto 0) :=(others=>'0');
        Mux_out : out std_logic_vector(31 downto 0) :=(others=>'0')
        );
end MUX_IF_Stage;
architecture Mux_IF_arc of MUX_IF_Stage is
begin
  Mux_out <=  PCplus4 when Mux_sel = '0' else
              Bra_PC  when Mux_sel = '1' else (others=>'0');
end Mux_IF_arc;
            

