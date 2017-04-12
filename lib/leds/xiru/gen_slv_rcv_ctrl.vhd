library ieee;
use ieee.std_logic_1164.all;
library work;
use work.xiru_package.all;

entity gen_slv_rcv_ctrl is
  port (
    i_CLK               : in  std_logic;
    i_RST               : in  std_logic;
	i_SPC_WAIT          : in  std_logic; --
	i_BL_REG            : in  std_logic_vector(c_BL_WIDTH-1 downto 0); --
	i_BS_REG            : in  std_logic_vector(c_BS_WIDTH-1 downto 0); --
	i_COUNTER           : in  std_logic_vector(3 downto 0);
    i_NET_FRAME         : in  std_logic_vector(1 downto 0);
    i_NET_ROK           : in  std_logic;
    o_NET_RD            : out std_logic;
    o_FLIT_H1_REG_ENA   : out std_logic;
    o_FLIT_ADDR_REG_ENA : out std_logic;
    o_FLIT_DATA_REG_ENA : out std_logic;
	o_SEL_MUX_ADDR      : out std_logic; --
	o_SEL_MUX_BURST     : out std_logic_vector(1 downto 0); --
    o_COUNTER_ENA       : out std_logic --
  );
end gen_slv_rcv_ctrl;

architecture rtl of gen_slv_rcv_ctrl is
  type t_STATE is (S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, S12); --
  signal r_STATE      : t_STATE;
  signal r_NEXT_STATE : t_STATE;

begin
  process (i_CLK, i_RST)
  begin
    if (i_RST='1') then
      r_STATE <= S0;
    elsif (i_CLK'event and i_CLK='1') then
      r_STATE <= r_NEXT_STATE;
    end if;
  end process;

  process (r_STATE, i_NET_ROK, i_NET_FRAME, i_SPC_WAIT, i_BL_REG, i_BS_REG, i_COUNTER)
  begin
    case r_STATE is
      -- start
      when S0 => if (i_NET_ROK='1' and i_NET_FRAME=c_FRAME_BOP) then
                   r_NEXT_STATE <= S1;
                 else
                   r_NEXT_STATE <= S0;
                 end if;

      -- Receiving H1 flit
	  when S1 => if (i_NET_ROK='1' and i_NET_FRAME=c_FRAME_PL) then
        	       r_NEXT_STATE <= S2;
				 else
				   r_NEXT_STATE <= S1;
				 end if;

      -- Receiving the address flit
      when S2 => if (i_NET_ROK='1' and i_SPC_WAIT='1') then
                    if (i_NET_FRAME/=c_FRAME_EOP) then
                      r_NEXT_STATE <= S3;
					elsif (i_NET_FRAME=c_FRAME_EOP and (i_BL_REG="0000" or i_BL_REG="0001")) then
					  r_NEXT_STATE <= S4;
                    elsif (i_NET_FRAME=c_FRAME_EOP and i_BS_REG ="011") then
                      r_NEXT_STATE <= S9;
					elsif (i_NET_FRAME=c_FRAME_EOP and i_BS_REG="010" and i_BL_REG="0011") then
					  r_NEXT_STATE <= S10;
					elsif (i_NET_FRAME=c_FRAME_EOP and i_BS_REG="010" and i_BL_REG="0111") then
					  r_NEXT_STATE <= S11;
					elsif (i_NET_FRAME=c_FRAME_EOP and i_BS_REG="010" and i_BL_REG="1111") then
					  r_NEXT_STATE <= S12;
                    end if;
                 else 
                    r_NEXT_STATE <= S2;
                 end if;

      -- Receiving the first data flit
      when S3 => if (i_NET_ROK='1' and i_SPC_WAIT='1') then
                   if (i_BS_REG = "000") then
                     r_NEXT_STATE <= S4;
				   elsif (i_NET_FRAME/=c_FRAME_EOP and (i_BS_REG="001" or i_BS_REG="011")) then
				     r_NEXT_STATE <= S5;
				   elsif (i_NET_FRAME/=c_FRAME_EOP and i_BS_REG="010" and i_BL_REG="0011") then
				     r_NEXT_STATE <= S6;
				   elsif (i_NET_FRAME/=c_FRAME_EOP and i_BS_REG="001" and i_BL_REG="0111") then
				     r_NEXT_STATE <= S7;
				   elsif (i_NET_FRAME/=c_FRAME_EOP and i_BS_REG="001" and i_BL_REG="1111") then
				     r_NEXT_STATE <= S8;
				   end if;
                 else
                   r_NEXT_STATE <= S3;
                 end if;
				 
	  -- Receiving EOP flit
	  when S4 => r_NEXT_STATE <= S1;
	  
	  -- Receiving flits from INCR type burst
	  when S5 => if (i_NET_ROK='1' and i_SPC_WAIT='1' and i_COUNTER = "0000") then
	               r_NEXT_STATE <= S4;
				 else
				   r_NEXT_STATE <= S5;
				 end if;

	  -- Receiving flits from WRAP4 type burst
	  when S6 => if (i_NET_ROK='1' and i_SPC_WAIT='1' and i_COUNTER = "0000") then
	               r_NEXT_STATE <= S4;
				 else
				   r_NEXT_STATE <= S6;
				 end if;

	  -- Receiving flits from WRAP8 type burst
	  when S7 => if (i_NET_ROK='1' and i_SPC_WAIT='1' and i_COUNTER = "0000") then
	               r_NEXT_STATE <= S4;
				 else
				   r_NEXT_STATE <= S7;
				 end if;
				 
	  -- Receiving flits from WRAP16 type burst
	  when S8 => if (i_NET_ROK='1' and i_SPC_WAIT='1' and i_COUNTER = "0000") then
	               r_NEXT_STATE <= S4;
				 else
				   r_NEXT_STATE <= S8;
				 end if;
	 
	  -- Incrementing address for INCR type burst	 
	  when S9 => if (i_NET_ROK='1' and i_SPC_WAIT='1' and i_COUNTER = "0000") then
	               r_NEXT_STATE <= S4;
				 else
				   r_NEXT_STATE <= S9;
				 end if;

	  -- Incrementing address for WRAP4 type burst	
      when S10 => if (i_NET_ROK='1' and i_SPC_WAIT='1' and i_COUNTER = "0000") then
	               r_NEXT_STATE <= S4;
				 else
				   r_NEXT_STATE <= S10;
				 end if;
	
	  -- Incrementing address for WRAP8 type burst	
	  when S11 => if (i_NET_ROK='1' and i_SPC_WAIT='1' and i_COUNTER = "0000") then
	               r_NEXT_STATE <= S4;
				 else
				   r_NEXT_STATE <= S11;
				 end if;

	  -- Incrementing address for WRAP16 type burst	
	  when S12 => if (i_NET_ROK='1' and i_SPC_WAIT='1' and i_COUNTER = "0000") then
	               r_NEXT_STATE <= S4;
				 else
				   r_NEXT_STATE <= S12;
				 end if;

      when others => r_NEXT_STATE <= S0;

    end case;
  end process;

  o_NET_RD            <= '1' when (r_STATE = S0 or r_STATE = S1) else i_SPC_WAIT;
  o_FLIT_H1_REG_ENA   <= '1' when (r_STATE = S1) else '0';
  o_FLIT_ADDR_REG_ENA <= '0' when (r_STATE = S0 or r_STATE = S1 or r_STATE = S3 or r_STATE = S4) else '1';
  o_FLIT_DATA_REG_ENA <= '1' when (r_STATE = S3 or r_STATE = S5 or r_STATE = S6 or r_STATE = S7 or r_STATE = S8) else '0';
  o_SEL_MUX_ADDR      <= '0' when (r_STATE = S0 or r_STATE = S1 or r_STATE = S2) else '1';
  o_SEL_MUX_BURST     <= "00" when (r_STATE = S5 or r_STATE = S9) else
                         "01" when (r_STATE = S6 or r_STATE = S10) else
						 "10" when (r_STATE = S7 or r_STATE = S11) else
						 "11" when (r_STATE = S8 or r_STATE = S12) else
						 "00";
  o_COUNTER_ENA       <= '1' when (r_STATE = S2) else '0';

end rtl;