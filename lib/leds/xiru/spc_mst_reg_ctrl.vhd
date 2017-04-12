library ieee;
use ieee.std_logic_1164.all;
library work;
use work.xiru_package.all;

entity spc_mst_reg_ctrl is
  port (
    i_CLK               : in  std_logic;
    i_RST               : in  std_logic;
    i_HWRITE            : in  std_logic;
	i_HTRANS            : in  std_logic_vector(1 downto 0);
    i_HBURST            : in  std_logic_vector(2 downto 0);
    o_ENA_REG_DATA      : out std_logic;
    o_START             : out std_logic
  );
end spc_mst_reg_ctrl;

architecture rtl of spc_mst_reg_ctrl is
  type t_STATE is (S0, S1, S2, S3, S4, S5);
  signal r_STATE      : t_STATE;
  signal r_NEXT_STATE : t_STATE;
  
begin
  process (i_CLK, i_RST)
  begin
    if (i_RST = '1') then
      r_STATE <= S0;
    elsif (i_CLK'event and i_CLK='1') then
      r_STATE <= r_NEXT_STATE;
    end if;
  end process;
  
 process (r_STATE, i_HWRITE, i_HTRANS, i_HBURST)
  begin
    case r_STATE is
-- recording H0 registers:
      when S0 => if (i_HTRANS = "10") then
                   r_NEXT_STATE <= S1;
				 else
                   r_NEXT_STATE <= S0;
                 end if;
-- recording H1 registers:
      when S1 => r_NEXT_STATE <= S2;
-- recording ADDR register:	  
	  when S2 => if (i_HWRITE = '0') then
                   r_NEXT_STATE <= S0;
                 elsif (i_HWRITE = '1') then
				   r_NEXT_STATE <= S3;
                 end if;
-- recording DATA register:
      when S3 => if (i_HBURST /= "000") then
                   r_NEXT_STATE <= S4;
                 else 
                   r_NEXT_STATE <= S0;
                 end if;
-- recording burst DATA registers:
      when S4 => if (i_HTRANS = "11") then
                   r_NEXT_STATE <= S4;
                 else
                   r_NEXT_STATE <= S5;
                 end if;
-- EOP flit:
      when S5 => r_NEXT_STATE <= S0;
	  
    end case;
  end process;
  
  o_START              <= '1' when (r_STATE = S0 or r_STATE = S1 or r_STATE = S2) else '0';
  o_ENA_REG_DATA       <= '1' when (r_STATE = S2 or r_STATE = S3 or r_STATE = S4) else '0';
  
end rtl;