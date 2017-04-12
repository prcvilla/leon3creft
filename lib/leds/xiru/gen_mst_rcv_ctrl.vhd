library ieee;
use ieee.std_logic_1164.all;
library work;
use work.xiru_package.all;

entity gen_mst_rcv_ctrl is
  port (
    i_CLK               : in  std_logic;
    i_RST               : in  std_logic;
    i_SPC_OPC           : in  std_logic_vector(c_OPC_WIDTH-1 downto 0) := (others => '0');
    i_NET_FRAME         : in  std_logic_vector(1 downto 0);
    i_NET_ROK           : in  std_logic;
    o_NET_RD            : out std_logic;
    o_FLIT_H1_REG_ENA   : out std_logic;
    o_FLIT_DATA_REG_ENA : out std_logic
  );
end gen_mst_rcv_ctrl;

architecture rtl of gen_mst_rcv_ctrl is
  type t_STATE is (S0, S1, S2, S3, S4);
  signal r_STATE      : t_STATE;
  signal r_NEXT_STATE : t_STATE;
  signal w_HEADER_PRESENT : std_logic;

begin

  w_HEADER_PRESENT <= '1' when (i_NET_FRAME = c_FRAME_BOP) else '0';

  process (i_CLK, i_RST)
  begin
    if (i_RST='1') then
      r_STATE <= S0;
    elsif (i_CLK'event and i_CLK='1') then
      r_STATE <= r_NEXT_STATE;
    end if;
  end process;

  process (r_STATE, i_SPC_OPC, i_NET_ROK, i_NET_FRAME, w_HEADER_PRESENT)
  begin
    case r_STATE is
      -- Waitintg the packet header
	  when S0 => if (i_NET_FRAME = c_FRAME_BOP) then
	               if (i_NET_ROK='1' and w_HEADER_PRESENT='1') then
                     r_NEXT_STATE <= S1;
                   else
                     r_NEXT_STATE <= S0;
                   end if;
				 else
				   r_NEXT_STATE <= S0;
       end if;
      -- Receiving the first header flit
      when S1 => if (i_NET_ROK='1') then
                   r_NEXT_STATE <= S2;
                 else
                   r_NEXT_STATE <= S1;
                 end if;

      -- Receiving the second header flit
      when S2 => if (i_NET_ROK='1') then
                   if (i_NET_FRAME /= c_FRAME_EOP ) then
                     r_NEXT_STATE <= S3;
                   else
                     r_NEXT_STATE <= S4;
                   end if;
                 else 
                    r_NEXT_STATE <= S2;
                 end if;
				 
      -- Receiving the payload flits
      when S3 => if (i_NET_ROK='1') then
				   if (i_NET_FRAME = c_FRAME_EOP) then
                     r_NEXT_STATE <= S4;
                   else
                     r_NEXT_STATE <= S3;
                   end if;
				 else
				   r_NEXT_STATE <= S3;
				 end if;
				 
      -- Receiving the trailer

      when S4 => r_NEXT_STATE <= S0;
                 
      -- OTHERS
      when others => r_NEXT_STATE <= S0;

    end case;
  end process;

  -- Read the input FIFO
  o_NET_RD            <= i_NET_ROK when (r_STATE = S0 or r_STATE = S1 or r_STATE = S2 or r_STATE = S3) else '0';

  -- Stores the seconf header's flit
  o_FLIT_H1_REG_ENA   <= '1' when (r_STATE = S1) else '0';

  -- Stores the data (received in the payload or in the trailer)
  o_FLIT_DATA_REG_ENA <= '1' when (r_STATE = S2 or r_STATE = S3) else '0';

end rtl;