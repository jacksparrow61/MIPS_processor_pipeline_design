library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

-- testbench for MIPS

entity MIPS32_tb is
end MIPS32_tb;

architecture arc of MIPS32_tb is
  
  component MIPS32 is 
    port(
      clk: in std_logic
    );
  end component;
  
  signal clk: std_logic:='0';
  constant clk_period: time:=100 ns;
  
begin
  uut: MIPS32
  port map (clk=>clk);
    --clock generation
    clk_process: process
    begin
      clk<='0';
      wait for clk_period/2;
      clk<='1';
      wait for clk_period/2;
    end process;
  end;
