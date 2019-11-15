library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity BranchDetect is 
  port(
    BraD: in std_logic :='0';
    Brain1, Brain2: in std_logic_vector(31 downto 0);
    Braout: out std_logic:='0'
  );
end BranchDetect;
architecture BD_a of BranchDetect is
  signal eq : std_logic_vector(31 downto 0);
begin
  Braout <= '1' when (BraD='1' and (unsigned(Brain1) = unsigned(Brain2)))
		else '0';
end BD_a;
		  