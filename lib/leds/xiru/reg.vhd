library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity reg is
  generic (
    p_DATA_WIDTH    : natural := 32;
    p_DEFAULT_VALUE : natural := 0
  );
  port ( 
    i_CLK  : in  std_logic;
    i_RST  : in  std_logic;
    i_WR   : in  std_logic;
    i_DATA : in  std_logic_vector(p_DATA_WIDTH-1 downto 0);
    o_DATA : out std_logic_vector(p_DATA_WIDTH-1 downto 0)
  );
end reg;

architecture arch_1 of reg is
  signal r_DATA : std_logic_vector(p_DATA_WIDTH-1 downto 0);

begin
  process (i_CLK, i_RST) 
  begin
    if (i_RST='1') then
      r_DATA <= conv_std_logic_vector(p_DEFAULT_VALUE, p_DATA_WIDTH);
    elsif (i_CLK'event and i_CLK='1') then
      if (i_WR='1') then
        r_DATA <= i_DATA;
      end if;
    end if;
  end process;

  o_DATA <= r_DATA;
end arch_1;