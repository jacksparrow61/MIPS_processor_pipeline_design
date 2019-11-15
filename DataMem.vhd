-- Data memory
-- width = 32bits, length = 1024 Bytes
library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity DataMem is
  generic(
    datasize: integer:=31;
    address: integer:=31;
    memory_length: integer:=4096
  );
  port(
    clk, WriteData: in std_logic:='0';
    -- data memory address input is 32 bits inc ase of ALU output and 11 bits to access mem inc ase of load,
    -- data mem data input is the data to be stored in the memory
    DataMemAddIn, DataMemDataIn: in std_logic_vector(31 downto 0):=(others=>'0');
    DataMemOut: out std_logic_vector(31 downto 0):=(others=>'0')
  ); 
end DataMem;

architecture mem of DataMem is
  -- array of 256 entries each 4Bytes
  type blk is array(0 to memory_length) of std_logic_vector(7 downto 0);
  signal temp: blk:=(others=>(others=>'0'));
  signal temp2: std_logic_vector(31 downto 0);
  
  begin
    process(clk)
      begin
        if(rising_edge(clk)) then
        if(WriteData ='1') then
        temp(to_integer(unsigned(temp2(11 downto 0)))) <= DataMemDataIn(31 downto 24);
        temp(to_integer(unsigned(temp2(11 downto 0)))+1) <= DataMemDataIn(23 downto 16);
        temp(to_integer(unsigned(temp2(11 downto 0)))+2) <= DataMemDataIn(15 downto 8);
        temp(to_integer(unsigned(temp2(11 downto 0)))+3) <= DataMemDataIn(7 downto 0);
      end if;
      
      if(WriteData ='0') then
        DataMemOut(31 downto 24) <= temp(to_integer(unsigned(temp2(11 downto 0))));
        DataMemOut(23 downto 16) <= temp(to_integer(unsigned(temp2(11 downto 0)))+1);
        DataMemOut(15 downto 8) <= temp(to_integer(unsigned(temp2(11 downto 0)))+2);
        DataMemOut( 7 downto 0) <= temp(to_integer(unsigned(temp2(11 downto 0)))+3);
      end if;
    end if;
  end process;  
end mem;
