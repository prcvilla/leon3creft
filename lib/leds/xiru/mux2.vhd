library ieee;
use ieee.std_logic_1164.all;

entity mux2 is
  generic (
    p_DATA_WIDTH : natural := 32
  );
  port (
    i_DATA_A : in  std_logic_vector(p_DATA_WIDTH-1 downto 0);
    i_DATA_B : in  std_logic_vector(p_DATA_WIDTH-1 downto 0);
    i_SEL    : in  std_logic;
    o_DATA   : out std_logic_vector(p_DATA_WIDTH-1 downto 0)
  );
end mux2;

architecture arch_1 of mux2 is

begin
  process (i_SEL, i_DATA_A, i_DATA_B)
  begin
    case i_SEL is 
      when '0' =>
        o_DATA <= i_DATA_A;
      when '1' =>
        o_DATA <= i_DATA_B;
      when others =>
        o_DATA <= (others => '0');
    end case;
  end process;
end arch_1;