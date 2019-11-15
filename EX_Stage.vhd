--libraries
-- EX Stage -- Execution stage
library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity EX_Stage is 
  port(
    
  clk: in std_logic:='0';
  RegWriteE, MemtoRegE, MemWriteE, ALUsrcE, RegDstE : in std_logic:='X';
  ALUcontrolE: in std_logic_vector(2 downto 0) := (others=>'X');
  FwdAE,FwdBE: in std_logic_vector(1 downto 0) :=  (others =>'0');
  ReadIn1, ReadIn2, SignImE, ALUoutM,ResW: in std_logic_vector(31 downto 0) :=  (others =>'X');
  RsE, RtE, RdE  : in std_logic_vector(4 downto 0) :=  (others =>'0'); 
  
  RegWriteM, MemtoRegM, MemWriteM: out std_logic:='X';
  ALUoutM2 : out std_logic_vector(31 downto 0):=(others=>'0');
  WriteDataM: out std_logic_vector(31 downto 0):=(others=>'0');
  WBAoutE, WBAoutM: out std_logic_vector(4 downto 0):=(others=>'0')
  
);
end EX_Stage;


architecture EX_a of EX_Stage is 
--3 input mux for input A
component MUX3 is
  port(
  s: in std_logic_vector(1 downto 0) := (others=>'X');
  i1,i2,i3: in std_logic_vector(31 downto 0) := (others=>'0');
  o: out std_logic_vector(31 downto 0) := (others=>'0')
);
end component;

--2 input MUX
component MUX2 is
  port(
  s: in std_logic:= 'X';
  i1,i2: in std_logic_vector(31 downto 0) := (others=>'0');
  o: out std_logic_vector(31 downto 0) := (others=>'0')
);
end component;

-- MUX for selecting Registers
component MUXR is
  port(
  s: in std_logic:= 'X';
  i1,i2: in std_logic_vector(4 downto 0) := (others=>'0');
  o: out std_logic_vector(4 downto 0) := (others=>'0')
);
end component;

--ALU Unit
component ALU is
  port(
    clk: in std_logic;
    ALUin1, ALUin2 : in std_logic_vector(31 downto 0);
    ALUcontrol: in std_logic_vector(2 downto 0);
    ALUout: out std_logic_vector(31 downto 0)
    );
end component;


--EX/Mem Buffer

component EX_M_Buffer is 
  port(
    clk: in std_logic;
    RegWriteE, MemtoRegE, MemWriteE: in std_logic:='X';
    -- signals for ALU output and Reg output
    EDBin1,EDBin2: in std_logic_vector(31 downto 0) :=  (others =>'0'); 
    --write back address input
    WBAin: in std_logic_vector(4 downto 0) :=  (others =>'0');
    
    RegWriteM, MemtoRegM, MemWriteM: out std_logic:='X';
    EDBout1,EDBout2: out std_logic_vector(31 downto 0) :=  (others =>'0');
    WBAout: out std_logic_vector(4 downto 0) :=  (others =>'0')
    );
end component;

signal SrcA, SrcB, Mux3to2,ALUtoEDB : std_logic_vector(31 downto 0);
signal Mux2toEDB: std_logic_vector(4 downto 0);  

begin
  WBAoutE <=  Mux2toEDB;
  m2  : MuxR port map(RegDstE, RtE, RdE, Mux2toEDB);
  m31 : Mux3 port map(FwdAE, ReadIn1, ResW, ALUoutM, SrcA);
  m32 : Mux3 port map(FwdBE, ReadIn2, ResW, ALUoutM, Mux3to2);
  m22 : Mux2 port map(ALUsrcE, Mux3to2, SignImE, SrcB);
  alu1 : ALU  port map(clk, SrcA, SrcB, ALUcontrolE, ALUtoEDB);
  buf : EX_M_Buffer port map(clk,RegWriteE, MemtoRegE, MemWriteE, 
							ALUtoEDB, Mux3to2, Mux2toEDB, RegWriteM, 
							MemtoRegM, MemWriteM, ALUoutM2, WriteDataM, WBAoutM); 
end EX_a;