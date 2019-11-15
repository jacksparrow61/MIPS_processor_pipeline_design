-- Instruction memory
library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- size of memory is 2048 Bytes => 2048/32 = 512 instructions

entity ins_mem is 
generic
(
  ins_datasize  : integer:= 7;
  ins_mem_add   : integer:= 31;
  ins_sz        : integer:= 2047;
  inst_out       : integer:= 31 
  );
port
    (
        PC : in std_logic_vector(ins_mem_add downto 0);
        Ins_out : out std_logic_vector(inst_out downto 0)
        );
end ins_mem;

architecture ins_mem_arc of ins_mem is
  type ins_block is array (0 to ins_sz) of std_logic_vector (ins_datasize downto 0);
  signal i: ins_block;
begin
  --**************************************
  --instruction 1 
  I(0) <= X"00";
  I(1) <= X"22";
  I(2) <= X"18";
  I(3) <= X"20";
  -- that means instruction 1 = X00221820 
  -- = 0000 0000 0010 0010  0001 1000 0010 0000
  -- = 000000 00001 00010 00011 00000 100000
  --    ADD     R1     R2   R3   => R3 =R1+R2
  --**************************************
  --instruction 2 
  I(4) <= X"00";
  I(5) <= X"65";
  I(6) <= X"30";
  I(7) <= X"20";
  -- that means instruction 1 = X00653022 
  -- = 0000 0000 0110 0101 0011 0000 0010 0010 
  -- = 000000 00011 000101 00110 00000 100010
  --    SUB     R3     R5   R6   => R6 =R3-R5
  --**************************************
  --instruction 3
  -- AND
  I(8)  <= X"00";I(9)  <= X"E8";I(10) <= X"48";I(11) <= X"24";
  --OR
  I(12) <= X"01";I(13) <= X"4B";I(14) <= X"60";I(15) <= X"25";
  --ADDI
  I(16) <= X"21";I(17) <= X"AE";I(18) <= X"00";I(19) <= X"08";
  --SUBI
  --STORE
  I(20) <= X"31";I(21) <= X"F0";I(22) <= X"00";I(23) <= X"03";
  --LOAD
  I(24) <= X"AC";I(25) <= X"12";I(26) <= X"00";I(27) <= X"02";
  --ADD
  I(28) <= X"8C";I(29) <= X"11";I(30) <= X"00";I(31) <= X"02";
  --ADD
  I(32) <= X"02"; I(33) <= X"32"; I(34) <= X"98"; I(35) <= X"20";

  
  Ins_out<=i(to_integer(unsigned(PC))) 
         & i(to_integer(unsigned(PC)) +1) 
         & i(to_integer(unsigned(PC)) +2) 
         & i(to_integer(unsigned(PC)) +3);
end ins_mem_arc;
 
  