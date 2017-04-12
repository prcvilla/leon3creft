library ieee;
use ieee.std_logic_1164.all;
library work;
use work.xiru_package.all;

entity net_lite_snd is
  generic (
    p_FIFO_TYPE  : string  := "RING";
    p_DEPTH      : integer := 4;
    p_LOG2_DEPTH : integer := 2;
    p_FC_TYPE    : string  := "CREDIT";    -- options: CREDIT or HANDSHAKE
    p_CREDIT     : integer := 4            -- maximum number of credits
  );
  port (
    i_CLK      : in  std_logic;
    i_RST      : in  std_logic;
    i_RET      : in  std_logic;
    o_VAL      : out std_logic;
    o_DATA     : out std_logic_vector(c_DATA_WIDTH+1 downto 0);
    i_NET_WR   : in  std_logic;
    o_NET_WOK  : out std_logic;
    i_NET_DATA : in  std_logic_vector(c_DATA_WIDTH+1 downto 0)
  );
end net_lite_snd;

architecture rtl of net_lite_snd is
  signal w_RD          : std_logic := '0';
  signal w_WR          : std_logic := '0';
  signal w_ROK         : std_logic := '0';
  signal w_NET_WOK     : std_logic := '0';

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
      o_WOK  => w_NET_WOK,
      i_RD   => w_RD,
      i_WR   => w_WR,
      i_DIN  => i_NET_DATA,
      o_DOUT => o_DATA
    );

  u_OFC: ofc
    generic map (
      p_FC_TYPE => p_FC_TYPE,
      p_CREDIT  => p_CREDIT
    )  
    port map(
      i_RST   => i_RST, 
      i_CLK   => i_CLK,
      o_VAL   => o_VAL,
      i_RET   => i_RET,
      o_RD    => w_RD,
      i_ROK   => w_ROK
    );

  w_WR      <= i_NET_WR and w_NET_WOK;
  o_NET_WOK <= w_NET_WOK;

end rtl;