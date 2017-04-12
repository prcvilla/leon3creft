library ieee;
use ieee.std_logic_1164.all;
library work;
use work.xiru_package.all;

entity net_lite is
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
-- Injection
    i_RET      : in  std_logic;
    o_VAL      : out std_logic;
    o_DATA     : out std_logic_vector(c_DATA_WIDTH+1 downto 0);
    i_NET_WR   : in  std_logic;
    o_NET_WOK  : out std_logic;
    i_NET_DATA : in  std_logic_vector(c_DATA_WIDTH+1 downto 0);
-- Ejection
    o_RET      : out std_logic;
    i_VAL      : in  std_logic;
    i_DATA     : in  std_logic_vector(c_DATA_WIDTH+1 downto 0);
    i_NET_RD   : in  std_logic;
    o_NET_ROK  : out std_logic;
    o_NET_DATA : out std_logic_vector(c_DATA_WIDTH+1 downto 0)
  );
end net_lite;

architecture rtl of net_lite is

  component net_lite_snd is
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
  end component;

  component net_lite_rcv is
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
  end component;

begin

  u_NET_SND: net_lite_snd
    generic map (
      p_FIFO_TYPE  => p_FIFO_TYPE,
      p_DEPTH      => p_DEPTH,
      p_LOG2_DEPTH => p_LOG2_DEPTH,
      p_FC_TYPE    => p_FC_TYPE,
      p_CREDIT     => p_CREDIT
    )
    port map (
      i_CLK      => i_CLK,
      i_RST      => i_RST,

      i_RET      => i_RET,
      o_VAL      => o_VAL,
      o_DATA     => o_DATA,

      i_NET_WR   => i_NET_WR,
      o_NET_WOK  => o_NET_WOK,
      i_NET_DATA => i_NET_DATA
    );

  u_NET_RCV: net_lite_rcv
    generic map (
      p_FIFO_TYPE  => p_FIFO_TYPE,
      p_DEPTH      => p_DEPTH,
      p_LOG2_DEPTH => p_LOG2_DEPTH,
      p_FC_TYPE    => p_FC_TYPE
    )
    port map (
      i_CLK      => i_CLK,
      i_RST      => i_RST,

      o_RET      => o_RET,
      i_VAL      => i_VAL,
      i_DATA     => i_DATA,

      i_NET_RD   => i_NET_RD,
      o_NET_ROK  => o_NET_ROK,
      o_NET_DATA => o_NET_DATA
    );

end rtl;