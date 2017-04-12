library ieee;
use ieee.std_logic_1164.all;
library work;
use work.xiru_package.all;

entity gen_slv is
  generic (
    p_X_SRC      : natural := 0;
    p_Y_SRC      : natural := 0;
    p_Z_SRC      : natural := 0
  );
  port (
    i_CLK       : in  std_logic;
    i_RST       : in  std_logic;

    i_SPC_WAIT  : in  std_logic;
    i_SPC_OPC   : in  std_logic_vector(c_OPC_WIDTH-1 downto 0);
    i_SPC_BE    : in  std_logic_vector(c_BE_WIDTH-1 downto 0);
    i_SPC_DATA  : in  std_logic_vector(c_DATA_WIDTH-1 downto 0);

    o_SPC_OPC     : out std_logic_vector(c_OPC_WIDTH-1 downto 0);
    o_SPC_BE      : out std_logic_vector(c_BE_WIDTH-1 downto 0);
    o_SPC_ADDR    : out std_logic_vector(c_ADDR_WIDTH-1 downto 0);
    o_SPC_DATA    : out std_logic_vector(c_DATA_WIDTH-1 downto 0);
	o_SPC_COUNTER : out std_logic_vector(3 downto 0);
	o_SPC_FRAME   : out std_logic_vector(1 downto 0);
	o_SPC_BL      : out std_logic_vector(c_BL_WIDTH-1 downto 0);
	o_SPC_BS      : out std_logic_vector(c_BS_WIDTH-1 downto 0);
	
    o_NET_WR    : out std_logic;
    o_NET_DATA  : out std_logic_vector(c_DATA_WIDTH+1 downto 0);
    i_NET_WOK   : in  std_logic;

    o_NET_RD    : out std_logic;
    i_NET_DATA  : in  std_logic_vector(c_DATA_WIDTH+2 downto 0);
    i_NET_ROK   : in  std_logic
  );
end gen_slv;

architecture rtl of gen_slv is
  signal w_FLIT_SEL               : std_logic_vector(1 downto 0) := (others => '0');
  signal w_FLIT_RCV_H1_REG_ENA    : std_logic := '0';
  signal w_FLIT_RCV_ADDR_REG_ENA  : std_logic := '0';
  signal w_FLIT_RCV_DATA_REG_ENA  : std_logic := '0';
  signal w_FLIT_RCV_SEL_MUX_ADDR  : std_logic := '0';
  signal w_FLIT_RCV_SEL_MUX_BURST : std_logic_vector (1 downto 0) := (others => '0');
  signal w_COUNTER                : std_logic_vector(3 downto 0) := (others => '0');
  signal w_COUNTER_ENA			  : std_logic := '0';
  signal w_DST                    : std_logic_vector(c_X_ADDR_WIDTH+c_Y_ADDR_WIDTH+c_Z_ADDR_WIDTH-1 downto 0);
  signal w_o_SPC_BL               : std_logic_vector(c_BL_WIDTH-1 downto 0) := (others => '0');
  signal w_o_SPC_BS               : std_logic_vector(c_BS_WIDTH-1 downto 0) := (others => '0');

  component gen_slv_snd_ctrl is
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
  end component;

  component gen_slv_snd_dp is
    generic (
      p_X_SRC          : natural := 0;
      p_Y_SRC          : natural := 0;
      p_Z_SRC          : natural := 0
    );
    port (
      i_CLK               : in  std_logic;
      i_RST               : in  std_logic;
      i_FLIT_SEL          : in  std_logic_vector(1 downto 0);
      i_SPC_WAIT          : in  std_logic;
      i_SPC_OPC           : in  std_logic_vector(c_OPC_WIDTH-1 downto 0);
      i_SPC_BE            : in  std_logic_vector(c_BE_WIDTH-1 downto 0);
      i_SPC_DATA          : in  std_logic_vector(c_DATA_WIDTH-1 downto 0);
      i_DST               : in  std_logic_vector(c_X_ADDR_WIDTH+c_Y_ADDR_WIDTH+c_Z_ADDR_WIDTH-1 downto 0);
      o_NET_DATA          : out std_logic_vector(c_DATA_WIDTH+1 downto 0)
    );
  end component;

  component gen_slv_rcv_ctrl is
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
  end component;

  component gen_slv_rcv_dp is
    port (
      i_CLK               : in  std_logic;
      i_RST               : in  std_logic;
      i_FLIT_H1_REG_ENA   : in  std_logic;
      i_FLIT_ADDR_REG_ENA : in  std_logic;
      i_FLIT_DATA_REG_ENA : in  std_logic;
      i_COUNTER_ENA       : in  std_logic; --
	  i_SEL_MUX_ADDR	  : in  std_logic; --
	  i_SEL_MUX_BURST     : in  std_logic_vector(1 downto 0); --
      i_NET_DATA          : in  std_logic_vector(c_DATA_WIDTH+2 downto 0);
      o_SPC_ADDR          : out std_logic_vector(c_ADDR_WIDTH-1 downto 0);
      o_SPC_DATA          : out std_logic_vector(c_DATA_WIDTH-1 downto 0);
      o_SPC_OPC           : out std_logic_vector(c_OPC_WIDTH-1 downto 0);
      o_SPC_BE            : out std_logic_vector(c_BE_WIDTH-1 downto 0);
	  o_SPC_BL			  : out std_logic_vector(c_BL_WIDTH-1 downto 0); --
	  o_SPC_BS			  : out std_logic_vector(c_BS_WIDTH-1 downto 0); --
	  o_COUNTER    		  : out std_logic_vector(3 downto 0); --
      o_DST               : out std_logic_vector(c_X_ADDR_WIDTH+c_Y_ADDR_WIDTH+c_Z_ADDR_WIDTH-1 downto 0)
    );
  end component;

begin

  u_GEN_SLV_SND_CTRL: gen_slv_snd_ctrl
    port map (
      i_CLK               => i_CLK,
      i_RST               => i_RST,
      i_SPC_WAIT          => i_SPC_WAIT,
      i_NET_WOK           => i_NET_WOK,
	  i_BL_REG            => w_o_SPC_BL,
	  i_COUNTER           => w_COUNTER,
      o_NET_WR            => o_NET_WR,
      o_FLIT_SEL          => w_FLIT_SEL
    );

  u_GEN_SLV_SND_DP: gen_slv_snd_dp
    generic map (
      p_X_SRC          => p_X_SRC,
      p_Y_SRC          => p_Y_SRC,
      p_Z_SRC          => p_Z_SRC
    )
    port map (
      i_CLK               => i_CLK,
      i_RST               => i_RST,
      i_FLIT_SEL          => w_FLIT_SEL,
      i_SPC_WAIT          => i_SPC_WAIT,
      i_SPC_OPC           => i_SPC_OPC,
      i_SPC_BE            => i_SPC_BE,
      i_SPC_DATA          => i_SPC_DATA,
      i_DST               => w_DST,
      o_NET_DATA          => o_NET_DATA
    );

  u_GEN_SLV_RCV_CTRL: gen_slv_rcv_ctrl
    port map (
      i_CLK               => i_CLK,
      i_RST               => i_RST,
	  i_SPC_WAIT          => i_SPC_WAIT,
	  i_BL_REG            => w_o_SPC_BL,
	  i_BS_REG            => w_o_SPC_BS,
	  i_COUNTER           => w_COUNTER,
      i_NET_FRAME         => i_NET_DATA(c_DATA_WIDTH+1 downto c_DATA_WIDTH),
      i_NET_ROK           => i_NET_ROK,
      o_NET_RD            => o_NET_RD,
      o_FLIT_H1_REG_ENA   => w_FLIT_RCV_H1_REG_ENA,
      o_FLIT_ADDR_REG_ENA => w_FLIT_RCV_ADDR_REG_ENA,
      o_FLIT_DATA_REG_ENA => w_FLIT_RCV_DATA_REG_ENA,
      o_SEL_MUX_ADDR      => w_FLIT_RCV_SEL_MUX_ADDR,
	  o_SEL_MUX_BURST     => w_FLIT_RCV_SEL_MUX_BURST,
	  o_COUNTER_ENA       => w_COUNTER_ENA
    );

  u_GEN_SLV_RCV_DP: gen_slv_rcv_dp
    port map (
      i_CLK               => i_CLK,
      i_RST               => i_RST,
      i_FLIT_H1_REG_ENA   => w_FLIT_RCV_H1_REG_ENA,
      i_FLIT_ADDR_REG_ENA => w_FLIT_RCV_ADDR_REG_ENA,
      i_FLIT_DATA_REG_ENA => w_FLIT_RCV_DATA_REG_ENA,
	  i_COUNTER_ENA       => w_COUNTER_ENA,
	  i_SEL_MUX_ADDR      => w_FLIT_RCV_SEL_MUX_ADDR,
	  i_SEL_MUX_BURST     => w_FLIT_RCV_SEL_MUX_BURST,
      i_NET_DATA          => i_NET_DATA,
      o_SPC_ADDR          => o_SPC_ADDR,
      o_SPC_DATA          => o_SPC_DATA,
      o_SPC_OPC           => o_SPC_OPC,
      o_SPC_BE            => o_SPC_BE,
      o_SPC_BL            => w_o_SPC_BL,
	  o_SPC_BS            => w_o_SPC_BS,
      o_COUNTER           => w_COUNTER,
      o_DST               => w_DST
    );

  o_SPC_BL <= w_o_SPC_BL;
  o_SPC_BS <= w_o_SPC_BS;
  o_SPC_COUNTER <= w_COUNTER;
  o_SPC_FRAME <= i_NET_DATA(c_DATA_WIDTH+1 downto c_DATA_WIDTH);
  
	
end rtl;
