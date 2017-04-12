library ieee;
use ieee.std_logic_1164.all;
library work;
use work.xiru_package.all;

entity net_lite_rcv is
  generic (
    p_FIFO_TYPE  : string  := "RING";
    p_DEPTH      : integer := 4;
    p_LOG2_DEPTH : integer := 2;
    p_FC_TYPE    : string  := "CREDIT"    -- options: CREDIT or HANDSHAKE
  );
  port (
    i_CLK      : in  std_logic;
    i_RST      : in  std_logic;
    o_RET      : out std_logic;
    i_VAL      : in  std_logic;
    i_DATA     : in  std_logic_vector(c_DATA_WIDTH+1 downto 0);
    i_NET_RD   : in  std_logic;
    o_NET_ROK  : out std_logic;
    o_NET_DATA : out std_logic_vector(c_DATA_WIDTH+1 downto 0)
  );
end net_lite_rcv;

architecture rtl of net_lite_rcv is
  signal w_WOK           : std_logic := '0';
  signal w_ROK           : std_logic := '0';
  signal w_WR            : std_logic := '0';

begin
  
  u_FIFO: fifo
    generic map (
      p_FIFO_TYPE  => p_FIFO_TYPE,
      p_WIDTH      => c_DATA_WIDTH+2,
      p_DEPTH      => p_DEPTH,
      p_LOG2_DEPTH => p_LOG2_DEPTH
    )
    port map (
      i_CLK  => i_CLK,
      i_RST  => i_RST,
      o_ROK  => w_ROK,
      o_WOK  => w_WOK,
      i_RD   => i_NET_RD,
      i_WR   => w_WR,
      i_DIN  => i_DATA,
      o_DOUT => o_NET_DATA
    );

  u_IFC: ifc
    generic map (
      p_FC_TYPE => p_FC_TYPE
    )
    port map (
      i_CLK => i_CLK,
      i_RST => i_RST,
      i_VAL => i_VAL,
      o_RET => o_RET,
      o_WR  => w_WR,
      i_WOK => w_WOK,
      i_RD  => i_NET_RD,
      i_ROK => w_ROK
    );

  o_NET_ROK     <= w_ROK;

end rtl;