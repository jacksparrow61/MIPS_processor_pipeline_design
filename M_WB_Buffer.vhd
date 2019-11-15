--mem/WB buffer
library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity M_WB_Buffer is
  generic (
  width: integer:=31
  );
  port(
    clk: in std_logic;
    RegWriteM, MemtoRegM: in std_logic:='0';
    -- ALU output and Reg output
    DWBin1, DWBin2: in std_logic_vector(31 downto 0):= (others=>'0');
    -- address for writing back into mem
    WBAin : in std_logic_vector(4 downto 0) := (others=>'0');
    RegWriteW, MemtoRegW: out std_logic :='0';
    DWBo1, DWBo2: out std_logic_vector(31 downto 0):= (others=>'0');
    WBAout : out std_logic_vector(4 downto 0) := (others=>'0')
  );
end M_WB_Buffer;

architecture a of M_WB_Buffer is 
begin
  process(clk)
    begin
      if(falling_edge(clk)) then
      RegWriteW <=  RegWriteM;
      MemtoRegW <=  MemtoRegM;
      --data read from Write back stage
      DWBo1     <=  DWBin1;
      -- output from ALU in write back stage
      DWBo2     <=  DWBin2;
      -- write backa ddress
      WBAout    <=  WBAin;
    end if;
  end process;    
end a;