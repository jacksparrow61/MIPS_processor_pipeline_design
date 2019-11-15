-- Register file
-- 32 x 32 bit registers and R0=0
-- ID Stage -- instruction decode stage
library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Rfile is
  generic
  (
    datasize: integer:=31;
    no_reg: integer:=31;
    add : integer:=4
  );
  port (
    clk, WriteEn: in std_logic :='0';  
    ReadReg1: in std_logic_vector(add downto 0):=(others=>'0');
    ReadReg2: in std_logic_vector(add downto 0):=(others=>'0');
    WriteReg: in std_logic_vector(add downto 0):=(others=>'0');
    Writedata: in std_logic_vector(datasize downto 0):=(others=>'0');
    ReadData1: out std_logic_vector(datasize downto 0):=(others=>'0');
    ReadData2: out std_logic_vector(datasize downto 0):=(others=>'0')
);
end Rfile;

architecture Rfile_arc of Rfile is
  type Reg is array (0 to no_reg) of std_logic_vector (datasize downto 0);
  signal r: Reg := (others=>(others=>'0'));
  begin
    process(clk)
      begin
        r(1) <= X"00000003";
        r(2) <= X"00000003";
        r(4) <= X"00000009";
        r(5) <= X"00000002";
        r(7) <= X"00000003";
        r(8) <= X"00000006";
        r(10) <= X"00000005";
        r(11) <= X"00000007";
        r(13) <= X"0000000E";
        r(15) <= X"0000000F";
        r(18) <= X"000000FE";
        
        if(rising_edge(clk)) then
        --if write enable is not set
        ReadData1 <= r(to_integer(unsigned(ReadReg1)));
        ReadData2 <= r(to_integer(unsigned(ReadReg2)));
        
        if(WriteEn ='1') then
        r(to_integer(unsigned(WriteReg))) <= Writedata;
      end if;
    end if;
  end process;
end Rfile_arc;
    