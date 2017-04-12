library ieee;
use ieee.std_logic_1164.all;

entity mux2_1 is
  port (
    i_DATA_A : in  std_logic;
    i_DATA_B : in  std_logic;
    i_SEL    : in  std_logic;
    o_DATA   : out std_logic
  );
end mux2_1;

architecture arch_1 of mux2_1 is

begin
  process (i_SEL, i_DATA_A, i_DATA_B)
  begin
    case i_SEL is 
      when '0' =>
        o_DATA <= i_DATA_A;
      when '1' =>
        o_DATA <= i_DATA_B;
      when others =>
        o_DATA <= '0';
    end case;
  end process;
end arch_1;