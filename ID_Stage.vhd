--libraries
-- ID Stage -- instruction decode stage
library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ID_Stage is 
  generic (
    width, datasize, no_reg: integer:=31;
    add: integer:=4
	);
port 
(
  clk, flush :in std_logic :='0';
  mux1_s, mux2_s: in std_logic:='0'; -- muxes to select RD1 and RD2
  RegWriteWB : in std_logic :='0'; -- from the hazard unit
  WBA_OutWB : in std_logic_vector(4 downto 0) := (others=>'0');
  InstD, WriteData, PCplus4, ALUout: in std_logic_vector(31 downto 0) := (others=>'0');
  
  -- control signals
  RegWriteE, MemtoRegE, MemWriteE, ALUsrcE, RegDstE, PCSrcD, BraD: out std_logic :='0';
  --ALU control bits 
  ALUcontrolE: out std_logic_vector(2 downto 0) := (others=>'0');
  
  RsE, RtE, RdE, RsD, RtD : out std_logic_vector(4 downto 0) := (others=>'0');
  IEBout1, IEBout2,SignImE: out std_logic_vector(31 downto 0) := (others=>'0');
  AdderOut: out  std_logic_vector(31 downto 0) := (others=>'0')
);
end ID_Stage;
  
architecture ID_Stage_arc of ID_Stage is 

component controlunit is
  port(
      clk: in std_logic;
      opcode, funct: in std_logic_vector(5 downto 0):=(others=>'0');
      RegWriteD,MemtoRegD, MemWriteD, ALUsrcD, RegDstD, BraD: out std_logic:='0';
      ALUcontrolID: out std_logic_vector(2 downto 0):=(others=>'0')
    );
end component;

component Rfile is --register file
port(
  clk, WriteEn: in std_logic :='0';  
  --access contents of operand 1
  ReadReg1: in std_logic_vector(add downto 0):=(others=>'0');
  --access contents of operand 2
  ReadReg2: in std_logic_vector(add downto 0):=(others=>'0');
  --write to register @address
  WriteReg: in std_logic_vector(add downto 0):=(others=>'0');
  --write back data
  Writedata: in std_logic_vector(datasize downto 0):=(others=>'0');
  --output from operand 1
  ReadData1: out std_logic_vector(datasize downto 0):=(others=>'0');
  --output from operand 2
  ReadData2: out std_logic_vector(datasize downto 0):=(others=>'0')
);
end component;

component MUX_IDstage is
  port (
      Mux_s: in std_logic :='0';
      RegData,ALUout: in std_logic_vector(31 downto 0):=(others=>'0');
      Muxout: out std_logic_vector(31 downto 0):=(others=>'0')
    );
  end component;
  
component BranchDetect is
  port(
    BraD: in std_logic :='0';
    Brain1, Brain2: in std_logic_vector(31 downto 0);
    Braout: out std_logic:='0'
  );
end component;

component SignExt is
  port(
    Sin: in std_logic_vector(15 downto 0) := (others=>'0');
    Sout: out std_logic_vector(31 downto 0) := (others=>'0')
  );
end component;

component adderID is
  port(
    PCplus4: in std_logic_vector(31 downto 0) := (others=>'0');
    Sout: in  std_logic_vector(31 downto 0) := (others=>'0');
    AdderOut: out std_logic_vector (31 downto 0) := (others=>'0')
  );
end component;

component ID_EX_Buffer is
  port(
    clk,flush: in std_logic:='0';
    RegWrireD,MemtoRegD, MemWriteD, ALUsrcD, RegDstD: in std_logic:='X';
    ALUcontrolID : in std_logic_vector(2 downto 0) := (others=>'X');
    ReadReg1, ReadReg2, WriteReg: in  std_logic_vector(4 downto 0) := (others=>'0');
    IEBin1,IEBin2, SignImD: in std_logic_vector(width downto 0) := (others=>'0');
    RegWriteE,MemtoRegE, MemWriteE, ALUsrcE, RegDstE : out std_logic:='X';
    ALUcontrolE: out std_logic_vector(2 downto 0) := (others=>'X');
    RsE,RtE,RdE: out std_logic_vector(4 downto 0) := (others=>'0');
    IEBout1, IEBout2, SignImE: out std_logic_vector(width downto 0) := (others=>'0')
  );
end component;

signal SignEtoAdder, RegtoMux1, RegtoMux2, Mux1toIEB, Mux2toIEB: std_logic_vector(datasize downto 0);
signal RWD, MRD, MWD, ASD, RDD, BD: std_logic;
signal ACD: std_logic_vector(2 downto 0);

begin
  BraD  <= BD;
  RsD   <= InstD(25 downto 21);
  RtD   <= InstD(20 downto 16);
  c1       :  controlunit port map(clk, InstD(31 downto 26), InstD(5 downto 0), RWD, MRD, MWD, ASD, RDD, BD, ACD);
  se       :  SignExt     port map(InstD(15 downto 0), SignEtoAdder);
  adder    :  adderID     port map(PCplus4, SignEtoAdder, AdderOut);
  regfile  :  Rfile       port map(clk, RegWriteWB, InstD(25 downto 21), InstD(20 downto 16), WBA_OutWB, Writedata, RegtoMux1, RegtoMux2);
  m1       :  MUX_IDstage port map(mux1_s, RegtoMux1, ALUout, Mux1toIEB);
  m2       :  MUX_IDstage port map(mux2_s, RegtoMux2, ALUout, Mux2toIEB);
  bra      : BranchDetect port map(BD, Mux1toIEB, Mux2toIEB, PCsrcD); 
  IE       : ID_EX_Buffer port map(clk, flush, RWD, MRD, MWD, ASD, RDD, ACD, InstD(25 downto 21), 
                                   InstD(20 downto 16), InstD(15 downto 11), Mux1toIEB, Mux2toIEB, 
                                   SignEtoAdder, RegWriteE, MemtoRegE, MemWriteE, ALUsrcE, RegDstE, 
                                   ALUcontrolE, RsE, RtE, RdE, IEBout1, IEBout2, SignImE);
end ID_Stage_arc; 
 
