-- IF/ID stage buffer
library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity IF_ID_Buffer is
  generic
  (
    size : integer:=42;
    width: integer:=31;
    add:   integer:=4
  );
  port
  (
      clk: in std_logic;
      en: in std_logic :='1';
      clr: in std_logic :='0';
      IR_in : in std_logic_vector(width downto 0):=  (others =>'0');
      PC_in : in std_logic_vector(width downto 0):=  (others =>'0');
      
      Buffer_out : out std_logic_vector(width downto 0):=  (others =>'0');
      PC_out : out std_logic_vector(width downto 0):=  (others =>'0')
      );  
end IF_ID_Buffer;

architecture IF_ID_Buffer_arc of IF_ID_Buffer is 
     begin
       process(clk)
         begin
           if(falling_edge(clk) and en='1' and clr='0') then
           Buffer_out <=  IR_in;
           PC_out     <=  PC_in;
         elsif (clr='1') then
           Buffer_out <=  (others=>'0');
           PC_out     <=  (others=>'0');
         end if;
       end process;
     end IF_ID_Buffer_arc;