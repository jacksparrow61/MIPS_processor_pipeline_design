-- MIPS 32 design
-- MAIN file


library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- MIPS takes only clock as an input
entity MIPS32 is
  port(
    clk: in std_logic:='0'
  );
end MIPS32;

architecture MIPS32_arc of MIPS32 is
  
component IF_Stage is
  port
  (
    clk: in std_logic:='0';
    en1,en2: in std_logic :='1';
    PCSrc_D: in std_logic :='0';
    PCBra_D: in std_logic_vector(31 downto 0) :=(others =>'0');
    
    inst_out, PCplus4: out std_logic_vector(31 downto 0):=(others =>'0')
    );
end component;


component ID_Stage is
  port 
(
  clk :in std_logic :='0';
  flush :in std_logic :='1';
  mux1_s, mux2_s: in std_logic:='X'; -- muxes to select RD1 and RD2
  RegWriteWB : in std_logic :='X'; -- from the hazard unit
  WBA_OutWB : in std_logic_vector(4 downto 0) := (others=>'0');
  InstD, WriteData, PCplus4, ALUout: in std_logic_vector(31 downto 0) := (others=>'0');
  
  -- control signals
  RegWriteE, MemtoRegE, MemWriteE, ALUsrcE, RegDstE, PCSrcD, BraD: out std_logic :='0';
  --ALU control bits 
  ALUcontrolE: out std_logic_vector(2 downto 0) := (others=>'X');
  
  RsE, RtE, RdE, RsD, RtD : out std_logic_vector(4 downto 0) := (others=>'0');
  IEBout1, IEBout2,SignImE: out std_logic_vector(31 downto 0) := (others=>'0');
  AdderOut: out  std_logic_vector(31 downto 0) := (others=>'0')
);
end component;


component EX_Stage is
  port(
    
  clk: in std_logic:='0';
  RegWriteE, MemtoRegE, MemWriteE, ALUsrcE, RegDstE : in std_logic:='0';
  ALUcontrolE: in std_logic_vector(2 downto 0) := (others=>'X');
  FwdAE,FwdBE: in std_logic_vector(1 downto 0) :=  (others =>'0');
  ReadIn1, ReadIn2, SignImE, ALUoutM,ResW: in std_logic_vector(31 downto 0) :=  (others =>'0');
  RsE, RtE, RdE  : in std_logic_vector(4 downto 0) :=  (others =>'0'); 
  
  RegWriteM, MemtoRegM, MemWriteM: out std_logic:='X';
  ALUoutM2 : out std_logic_vector(31 downto 0):=(others=>'0');
  WriteDataM: out std_logic_vector(31 downto 0):=(others=>'0');
  WBAoutE, WBAoutM: out std_logic_vector(4 downto 0):=(others=>'0')
  
);
end component;


component Mem_Stage is
  port(
     clk: in std_logic :='0';
     RegWriteM, MemtoRegM, MemWriteM: in std_logic:='X';
     ALUoutM, WriteDataM : in std_logic_vector(31 downto 0);
     WBAin : in std_logic_vector(4 downto 0) := (others=>'0');
     RegWriteW, MemtoRegW: out std_logic :='X';
     DWBo1, DWBo2: out std_logic_vector(31 downto 0):= (others=>'0');
     WBAout : out std_logic_vector(4 downto 0) := (others=>'0')
  );
end component;

component WB_Stage is
  port(
    MemtoRegW: in std_logic:='X';
    ALUoutW, ReadDataW: in std_logic_vector(31 downto 0):=(others=>'0');
    ResultW: out std_logic_vector(31 downto 0):=(others=>'0')
  );
end component;

component HazardUnit is
  port(
    clk: in std_logic;
    --address from various stages
    WriteRegW, WriteRegM, WriteRegE: in std_logic_vector( 4 downto 0):= (others=>'0');
    RsD, RtD, RsE, RtE, RdE: in std_logic_vector( 4 downto 0):= (others=>'0');
    --select lines for muxes in EX stage
    AE,BE: out std_logic_vector( 1 downto 0):= (others=>'0');
    --select lines for muxes in ID stage
    AD, BD: out std_logic:='0';
    
    --in presence LOAD instruction
    RegWriteM, RegWriteW, RegWriteE, MemtoRegM, MemtoRegE : in std_logic:='0';
    
    --stall control signals
    ID_Stall: out std_logic:='1'; 
    IF_Stall : out std_logic:='1';
    
    flush: out std_logic;
    BraD: in std_logic:='0'
    );

end component;


--signal declarations in whole design

--singals in ID stage
signal instruction_out, PCplus4, PCBraD: std_logic_vector(31 downto 0);

--control signals in Execute  stage
signal RegWriteE, MemtoRegE, MemWriteE, ALUsrcE, RegDstE, PCsrcD, BraD: std_logic;
signal ALUcontrolE: std_logic_vector(2 downto 0);

--register select signals in ID and EX stage
signal WriteRegW, RsE, RtE, RdE, RsD, RtD : std_logic_vector(4 downto 0);
signal IEBo1, IEBo2, SignImE, Add_ID_o: std_logic_vector(31 downto 0);

-- control signals in Memory access  stage
signal RegWriteM, MemtoRegM, MemWriteM: std_logic;

-- data signals from ALu and write data in Mem access stage
signal ALUoutM, WriteDataM : std_logic_vector(31 downto 0);
signal WBAoutE, WBAoutM: std_logic_vector(4 downto 0);

-- control signals in write back stage
signal RegWriteW, MemtoRegW : std_logic;
signal DWBo1, DWBo2: std_logic_vector(31 downto 0);
signal WBAoW: std_logic_vector(4 downto 0);

--final result to be fed back into Reg file
signal ResultW : std_logic_vector(31 downto 0);

--signals from hazard unit
signal FwdAD, FwdBD, ID_Stall, IF_Stall, flush : std_logic;
signal FwdAE, FwdBE: std_logic_vector(1 downto 0);

begin
  
  stage1  : IF_Stage  port map ( clk, IF_Stall, ID_Stall, PCsrcD, PCBraD, 
								instruction_out, PCplus4);
								
  stage2  : ID_Stage  port map ( clk, flush, FwdAD, FwdBD, RegWriteW, WBAoW, 
								instruction_out, ResultW, PCplus4, ALUoutM, 
								RegWriteE, MemtoRegE, MemWriteE, ALUsrcE, 
								RegDstE, PCsrcD, BraD, ALUcontrolE, RsE, RtE, 
								RdE, RsD, RtD, IEBo1, IEBo2, SignImE, Add_ID_o );
								
  stage3  : EX_Stage  port map ( clk, RegWriteE, MemtoRegE, MemWriteE, ALUsrcE, 
								RegDstE, ALUcontrolE, FwdAE, FwdBE, IEBo1, IEBo2, 
								SignImE, ALUoutM, ResultW, RsE, RtE, RdE, RegWriteM, 
								MemtoRegM, MemWriteM, ALUoutM, WriteDataM, WBAoutE, 
								WBAoutM);
								
  stage4  : Mem_Stage port map ( clk, RegWriteM, MemtoRegM, MemWriteM, ALUoutM, 
								WriteDataM, WBAoutM, RegWriteW, MemtoRegW, DWBo1, 
								DWBo2, WBAoW );
								
  stage5  : WB_Stage  port map ( MemtoRegW, DWBo2, DWBo1, ResultW);
  
  stage6  : HazardUnit port map( clk, WBAoW, WBAoutM, WBAoutE, RsE, RtE, RdE, RsD, 
								RtD, FwdAE, FwdBE, FwdAD, FwdBD, RegWriteM, 
								RegWriteW, RegWriteE, MemtoRegM, MemtoRegE, 
								ID_Stall, IF_Stall, flush, BraD);
   
end MIPS32_arc;
--hello