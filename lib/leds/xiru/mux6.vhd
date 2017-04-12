library ieee;
use ieee.std_logic_1164.all;

entity mux6 is
  generic (
    p_DATA_WIDTH : natural := 32
  );
  port (
    i_DATA_A : in  std_logic_vector(p_DATA_WIDTH-1 downto 0);
    i_DATA_B : in  std_logic_vector(p_DATA_WIDTH-1 downto 0);
    i_DATA_C : in  std_logic_vector(p_DATA_WIDTH-1 downto 0);
    i_DATA_D : in  std_logic_vector(p_DATA_WIDTH-1 downto 0);
    i_DATA_E : in  std_logic_vector(p_DATA_WIDTH-1 downto 0);
    i_DATA_F : in  std_logic_vector(p_DATA_WIDTH-1 downto 0);
    i_SEL    : in  std_logic_vector(2 downto 0);
    o_DATA   : out std_logic_vector(p_DATA_WIDTH-1 downto 0)
  );
end mux6;

architecture arch_1 of mux6 is

begin
  process (i_SEL, i_DATA_A, i_DATA_B, i_DATA_C, i_DATA_D, i_DATA_E, i_DATA_F)
  begin
    case i_SEL is 
      when "000" =>
        o_DATA <= i_DATA_A;
      when "001" =>
        o_DATA <= i_DATA_B;
      when "010" =>
        o_DATA <= i_DATA_C;
      when "011" =>
        o_DATA <= i_DATA_D;
      when "100" =>
        o_DATA <= i_DATA_E;
      when "101" =>
        o_DATA <= i_DATA_F;
      when others =>
        o_DATA <= (others => '0');
    end case;
  end process;
end arch_1;