library ieee;
use ieee.std_logic_1164.all;
library work;
use work.xiru_package.all;

entity spc_slv_htrans_ctrl is
  port (
    i_CLK               : in  std_logic;
    i_RST               : in  std_logic;
    i_SPC_COUNTER       : in  std_logic_vector(3 downto 0);
    i_SPC_FRAME         : in  std_logic_vector(1 downto 0);
    i_SPC_OPC           : in  std_logic_vector(3 downto 0);
	i_HREADY            : in  std_logic;
    o_HTRANS            : out std_logic_vector(1 downto 0)
  );
end spc_slv_htrans_ctrl;

architecture rtl of spc_slv_htrans_ctrl is
  type t_STATE is (S0, S1, S2, S3);
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
  
 process (r_STATE, i_SPC_COUNTER, i_SPC_FRAME, i_SPC_OPC, i_HREADY)
  begin
    case r_STATE is
      when S0 => if (i_HREADY = '1' and i_SPC_FRAME = c_FRAME_BOP) then
                   r_NEXT_STATE <= S1;
				 else
                   r_NEXT_STATE <= S0;
                 end if;

      when S1 => if (i_HREADY = '1') then
				   if (i_SPC_FRAME /= c_FRAME_EOP) then
				     if (i_SPC_OPC = c_OPC_WRB) then
				       r_NEXT_STATE <= S2;
				     elsif (i_SPC_OPC = c_OPC_RDB) then
				       r_NEXT_STATE <= S3;
				     end if;
				   else
				     r_NEXT_STATE <= S0;
				   end if;
				 else
				   r_NEXT_STATE <= S1;
				 end if;
				 

      when S2 => if (i_HREADY = '1' and i_SPC_FRAME = c_FRAME_EOP) then
                   r_NEXT_STATE <= S0;
                 elsif (i_HREADY = '1' and i_SPC_FRAME /= c_FRAME_EOP) then
                   r_NEXT_STATE <= S2;
                 end if;

      when S3 => if (i_HREADY = '1' and i_SPC_COUNTER = "0000") then
                   r_NEXT_STATE <= S0;
                 elsif (i_HREADY = '1' and i_SPC_COUNTER /= "0000") then
                   r_NEXT_STATE <= S3;
				 end if;
				 
    end case;
  end process;
  
  o_HTRANS  <= "10" when (r_STATE = S1) else
			   "11" when (r_STATE = S2 or r_STATE = S3) else
			   "00";
  
end rtl;