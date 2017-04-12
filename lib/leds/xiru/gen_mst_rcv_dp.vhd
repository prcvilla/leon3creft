library ieee;
use ieee.std_logic_1164.all;
library work;
use work.xiru_package.all;

entity gen_mst_rcv_dp is
  port (
    i_CLK               : in  std_logic;
    i_RST               : in  std_logic;
    i_FLIT_H1_REG_ENA   : in  std_logic;
    i_FLIT_DATA_REG_ENA : in  std_logic := '0';
    i_NET_DATA          : in  std_logic_vector(c_DATA_WIDTH+2 downto 0);
    o_SPC_BE            : out std_logic_vector(c_BE_WIDTH-1 downto 0);
    o_SPC_OPC           : out std_logic_vector(c_OPC_WIDTH-1 downto 0);
    o_SPC_DATA          : out std_logic_vector(c_DATA_WIDTH-1 downto 0)
  );
end gen_mst_rcv_dp;

architecture rtl of gen_mst_rcv_dp is
  signal w_SPC_OPC : std_logic_vector(c_OPC_WIDTH-1 downto 0) := (others => '0');

begin

  u_SPC_BE_REG: reg
    generic map (
      p_DATA_WIDTH    => c_BE_WIDTH,
      p_DEFAULT_VALUE => 0
    )
    port map ( 
      i_CLK  => i_CLK,
      i_RST  => i_RST,
      i_WR   => i_FLIT_H1_REG_ENA,
      i_DATA => i_NET_DATA(c_X_ADDR_WIDTH+c_Y_ADDR_WIDTH+c_Z_ADDR_WIDTH+c_OPC_WIDTH+c_THID_WIDTH+c_BE_WIDTH-1 downto c_X_ADDR_WIDTH+c_Y_ADDR_WIDTH+c_Z_ADDR_WIDTH+c_OPC_WIDTH+c_THID_WIDTH),
      o_DATA => o_SPC_BE
    );

  u_SPC_DATA_REG: reg
    generic map (
      p_DATA_WIDTH    => c_DATA_WIDTH,
      p_DEFAULT_VALUE => 0
    )
    port map ( 
      i_CLK  => i_CLK,
      i_RST  => i_RST,
      i_WR   => i_FLIT_DATA_REG_ENA,
      i_DATA => i_NET_DATA(c_DATA_WIDTH-1 downto 0),
      o_DATA => o_SPC_DATA
    );

  u_SPC_OPC_REG: reg
    generic map (
      p_DATA_WIDTH    => c_OPC_WIDTH,
      p_DEFAULT_VALUE => 0
    )
    port map ( 
      i_CLK  => i_CLK,
      i_RST  => i_RST,
      i_WR   => '1',
      i_DATA => w_SPC_OPC,
      o_DATA => o_SPC_OPC
    );

  process (i_FLIT_DATA_REG_ENA,i_NET_DATA) 
  begin
    if (i_FLIT_DATA_REG_ENA = '1') then
      if (i_NET_DATA(c_DATA_WIDTH+2) = '1') then
        w_SPC_OPC <= c_OPC_IDLE;
      else
        w_SPC_OPC <= c_OPC_DVA;
      end if;
    else
      w_SPC_OPC <= c_OPC_IDLE;
    end if;
  end process;

end rtl;