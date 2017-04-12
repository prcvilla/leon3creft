library ieee;
use ieee.std_logic_1164.all;
library work;
use work.xiru_package.all;

entity gen_slv_snd_ctrl is
  port (
    i_CLK               : in  std_logic;
    i_RST               : in  std_logic;
    i_SPC_WAIT          : in  std_logic;
    i_NET_WOK           : in  std_logic;
	i_BL_REG            : in  std_logic_vector(c_BL_WIDTH-1 downto 0);
	i_COUNTER           : in  std_logic_vector(3 downto 0);
    o_NET_WR            : out std_logic;
    o_FLIT_SEL          : out std_logic_vector(1 downto 0)
  );
end gen_slv_snd_ctrl;

architecture rtl of gen_slv_snd_ctrl is
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

  process (r_STATE, i_NET_WOK, i_SPC_WAIT)
  begin
    case r_STATE is
      when S0 => if (i_SPC_WAIT = '1') then
                   r_NEXT_STATE <= S1;
                 else
                   r_NEXT_STATE <= S0;
                 end if;

      when S1 => if (i_NET_WOK = '1') then
                   r_NEXT_STATE <= S2;
                 else
                   r_NEXT_STATE <= S1;
                 end if;
				 
      when S2 => if (i_NET_WOK = '1') then
                   r_NEXT_STATE <= S3;
                 else
                   r_NEXT_STATE <= S2;
                 end if;

      when S3 => if (i_NET_WOK = '1') then
	               if (i_BL_REG = "0000") then
                     r_NEXT_STATE <= S5;
				   else
				     r_NEXT_STATE <= S4;
				   end if;
                 else
                   r_NEXT_STATE <= S3;
                 end if;

      when S4 => if (i_NET_WOK = '1' and i_COUNTER = "0001") then
                   r_NEXT_STATE <= S5;
				 else
				   r_NEXT_STATE <= S4;
				 end if;

      when S5 => if (i_NET_WOK = '1') then
                   r_NEXT_STATE <= S0;
				 else
				   r_NEXT_STATE <= S5;
				 end if;

    end case;
  end process;

  o_NET_WR            <= '1' when (r_STATE = S2 or r_STATE = S3 or r_STATE = S4 or r_STATE = S5) else '0';
  o_FLIT_SEL          <= "00" when (r_STATE = S2) else
                         "01" when (r_STATE = S3) else
                         "11" when (r_STATE = S4) else
						 "10" when (r_STATE = S5) else
                         "00";

end rtl;