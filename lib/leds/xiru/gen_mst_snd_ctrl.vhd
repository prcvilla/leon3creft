library ieee;
use ieee.std_logic_1164.all;
library work;
use work.xiru_package.all;

entity gen_mst_snd_ctrl is
  port (
    i_CLK               : in  std_logic;
    i_RST               : in  std_logic;
    i_SPC_OPC           : in  std_logic_vector(c_OPC_WIDTH-1 downto 0) := (others => '0');
	i_BL_REG			: in  std_logic_vector(c_BL_WIDTH-1 downto 0) := (others => '0');
    i_NET_WOK           : in  std_logic;
	i_COUNTER           : in  std_logic_vector(3 downto 0);
    o_SPC_WAIT_SND      : out std_logic;
    o_NET_WR            : out std_logic;
    o_FLIT_SEL          : out std_logic_vector(2 downto 0);
    o_COUNTER_ENA       : out std_logic
  );
end gen_mst_snd_ctrl;

architecture rtl of gen_mst_snd_ctrl is
  type t_STATE is (S0, S1, S2, S3, S4, S5, S6, S7);
  signal r_STATE      : t_STATE;
  signal r_NEXT_STATE : t_STATE;

begin
  process (i_CLK)
  begin
    if (i_RST = '1') then
      r_STATE <= S0;
    elsif (i_CLK'event and i_CLK='1') then
      r_STATE <= r_NEXT_STATE;
    end if;
  end process;

  process (r_STATE, i_SPC_OPC, i_BL_REG, i_NET_WOK, i_COUNTER)
  begin
    case r_STATE is

	  when S0 => r_NEXT_STATE <= S1;
-- waiting for transaction:  
      when S1 => if (i_SPC_OPC = c_OPC_WR or i_SPC_OPC = c_OPC_RD) then
                   r_NEXT_STATE <= S2;
                 else
                   r_NEXT_STATE <= S1;
                 end if;
-- sending H0 flit:
      when S2 => if (i_NET_WOK = '1') then
                   r_NEXT_STATE <= S3;
                 else
                   r_NEXT_STATE <= S2;
                 end if;
-- sending H1 flit:
      when S3 => if (i_NET_WOK = '1') then
                   if (i_SPC_OPC = c_OPC_RD) then
                     r_NEXT_STATE <= S7;
                   else
                     r_NEXT_STATE <= S4;
                   end if;
				 else
				   r_NEXT_STATE <= S3;
				 end if;
-- sending PL + ADDR flit:
      when S4 => if (i_NET_WOK = '1') then
                   if (i_BL_REG = "0000") then 
                      r_NEXT_STATE <= S6;
				   elsif (i_BL_REG /= "0000") then
				      r_NEXT_STATE <= S5;
                   end if;
                 else
                   r_NEXT_STATE <= S4;
                 end if;
-- sending PL + DATA flit:
      when S5 => if (i_NET_WOK = '1') then
				   if (i_COUNTER = "0001") then
                     r_NEXT_STATE <= S6;
                   else
                     r_NEXT_STATE <= S5;
                   end if;
				 else
				   r_NEXT_STATE <= S5;
				 end if;
-- sending EOP + DATA flit:
      when S6 => if (i_NET_WOK = '1') then
                   r_NEXT_STATE <= S1;
                 else
                   r_NEXT_STATE <= S6;
                 end if;
-- sending EOP + ADDR flit:				 
      when S7 => if ((i_SPC_OPC = "0010" or i_SPC_OPC = "1001") and i_NET_WOK = '1') then
                   r_NEXT_STATE <= S7;
                else
                   r_NEXT_STATE <= S1;
                end if;

    end case;
  end process;

  o_NET_WR            <= '1';
  o_SPC_WAIT_SND      <= '0' when (r_STATE = S1 or r_STATE = S2) else '1' when (r_STATE = S0 or r_STATE = S4 or r_STATE = S5 or r_STATE = S6 or r_STATE = S7);
  o_FLIT_SEL          <= "000" when (r_STATE = S2) else
                         "001" when (r_STATE = S3) else
                         "010" when (r_STATE = S4) else
                         "011" when (r_STATE = S5) else
                         "100" when (r_STATE = S6) else
						 "101" when (r_STATE = S7) else
                         "000";
  o_COUNTER_ENA       <= '1' when (r_STATE = S4) else '0';

end rtl;