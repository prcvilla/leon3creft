library ieee;
use ieee.std_logic_1164.all;
library work;
use work.xiru_package.all;

entity gen_mst is
  generic (
    p_X_SRC      : natural := 0;
    p_Y_SRC      : natural := 0;
    p_Z_SRC      : natural := 0
  );
  port (
    i_CLK       : in  std_logic;
    i_RST       : in  std_logic;

    i_SPC_ADDR  	   : in  std_logic_vector(c_ADDR_WIDTH-1 downto 0);
    i_SPC_DATA  	   : in  std_logic_vector(c_DATA_WIDTH-1 downto 0);
    i_SPC_OPC   	   : in  std_logic_vector(c_OPC_WIDTH-1 downto 0);
	i_SPC_ENA_REG_DATA : in  std_logic;
	i_SPC_START 	   : in  std_logic;
	i_SPC_BL           : in  std_logic_vector(c_BL_WIDTH-1 downto 0);
	i_SPC_BS     	   : in  std_logic_vector(c_BS_WIDTH-1 downto 0);
    i_SPC_BE   		   : in  std_logic_vector(c_BE_WIDTH-1 downto 0);

	o_SPC_WAIT_SND  : out std_logic;
    o_SPC_OPC       : out std_logic_vector(c_OPC_WIDTH-1 downto 0);
    o_SPC_BE        : out std_logic_vector(c_BE_WIDTH-1 downto 0);
    o_SPC_DATA      : out std_logic_vector(c_DATA_WIDTH-1 downto 0);

    o_NET_WR    : out std_logic;
    o_NET_DATA  : out std_logic_vector(c_DATA_WIDTH+1 downto 0);
    i_NET_WOK   : in  std_logic;

    o_NET_RD    : out std_logic;
    i_NET_DATA  : in  std_logic_vector(c_DATA_WIDTH+2 downto 0);
    i_NET_ROK   : in  std_logic
  );
end gen_mst;

architecture rtl of gen_mst is
  signal w_FLIT_SEL              : std_logic_vector(2 downto 0) := (others => '0');
  signal w_FLIT_RCV_H1_REG_ENA   : std_logic := '0';
  signal w_FLIT_RCV_DATA_REG_ENA : std_logic := '0';
  signal w_OPC_REG               : std_logic_vector(c_OPC_WIDTH-1 downto 0);
  signal w_BL_REG				 : std_logic_vector(c_BL_WIDTH-1 downto 0);
  signal w_COUNTER                : std_logic_vector(3 downto 0) := (others => '0');
  signal w_COUNTER_ENA			  : std_logic := '0';

  component gen_mst_snd_ctrl is
    port (
      i_CLK               : in  std_logic;
      i_RST               : in  std_logic;
      i_SPC_OPC           : in  std_logic_vector(c_OPC_WIDTH-1 downto 0);
	  i_BL_REG		      : in  std_logic_vector(c_BL_WIDTH-1 downto 0);
      i_NET_WOK           : in  std_logic;
	  i_COUNTER           : in  std_logic_vector(3 downto 0);
      o_SPC_WAIT_SND      : out std_logic;
      o_NET_WR            : out std_logic;
      o_FLIT_SEL          : out std_logic_vector(2 downto 0);
      o_COUNTER_ENA       : out std_logic
    );
  end component;

  component gen_mst_snd_dp is
    generic (
      p_X_SRC          : natural := 0;
      p_Y_SRC          : natural := 0;
      p_Z_SRC          : natural := 0
    );
    port (
      i_CLK        	     : in  std_logic;
      i_RST        	     : in  std_logic;
      i_SPC_ADDR   	     : in  std_logic_vector(c_ADDR_WIDTH-1 downto 0);
      i_SPC_DATA    	 : in  std_logic_vector(c_DATA_WIDTH-1 downto 0);
      i_SPC_OPC     	 : in  std_logic_vector(c_OPC_WIDTH-1 downto 0);
	  i_SPC_ENA_REG_DATA : in  std_logic;
      i_SPC_START        : in  std_logic;
	  i_SPC_BL           : in  std_logic_vector(c_BL_WIDTH-1 downto 0);
	  i_SPC_BS     	     : in  std_logic_vector(c_BS_WIDTH-1 downto 0);
      i_SPC_BE           : in  std_logic_vector(c_BE_WIDTH-1 downto 0);
      i_FLIT_SEL         : in  std_logic_vector(2 downto 0);
      i_COUNTER_ENA      : in  std_logic;
	  o_BL_REG           : out std_logic_vector(c_BL_WIDTH-1 downto 0);
      o_NET_DATA         : out std_logic_vector(c_DATA_WIDTH+1 downto 0);
	  o_COUNTER    	     : out std_logic_vector(3 downto 0)
    );
  end component;

  component gen_mst_rcv_ctrl is
      port (
      i_CLK               : in  std_logic;
      i_RST               : in  std_logic;
      i_SPC_OPC           : in  std_logic_vector(c_OPC_WIDTH-1 downto 0);
      i_NET_FRAME         : in  std_logic_vector(1 downto 0);
      i_NET_ROK           : in  std_logic;
      o_NET_RD            : out std_logic;
      o_FLIT_H1_REG_ENA   : out std_logic;
      o_FLIT_DATA_REG_ENA : out std_logic
    );
  end component;

  component gen_mst_rcv_dp is
    port (
      i_CLK               : in  std_logic;
      i_RST               : in  std_logic;
      i_FLIT_H1_REG_ENA   : in  std_logic;
      i_FLIT_DATA_REG_ENA : in  std_logic;
      i_NET_DATA          : in  std_logic_vector(c_DATA_WIDTH+2 downto 0);
      o_SPC_BE            : out std_logic_vector(c_BE_WIDTH-1 downto 0);
      o_SPC_OPC           : out std_logic_vector(c_OPC_WIDTH-1 downto 0);
      o_SPC_DATA          : out std_logic_vector(c_DATA_WIDTH-1 downto 0)
    );
  end component;

begin

  u_GEN_MST_SND_CTRL: gen_mst_snd_ctrl
    port map (
      i_CLK               => i_CLK,
      i_RST               => i_RST,
      i_SPC_OPC           =>  i_SPC_OPC,
	  i_BL_REG		  	  => w_BL_REG,
      i_NET_WOK           => i_NET_WOK,
	  i_COUNTER           => w_COUNTER,
      o_SPC_WAIT_SND      => o_SPC_WAIT_SND,
      o_NET_WR            => o_NET_WR,
      o_FLIT_SEL          => w_FLIT_SEL,
	  o_COUNTER_ENA       => w_COUNTER_ENA
    );

  u_GEN_MST_SND_DP: gen_mst_snd_dp
    generic map (
      p_X_SRC          => p_X_SRC,
      p_Y_SRC          => p_Y_SRC,
      p_Z_SRC          => p_Z_SRC
    )
    port map (
      i_CLK               => i_CLK,
      i_RST               => i_RST,
      i_SPC_ADDR          => i_SPC_ADDR,
      i_SPC_DATA          => i_SPC_DATA,
      i_SPC_OPC           => i_SPC_OPC,
	  i_SPC_ENA_REG_DATA  => i_SPC_ENA_REG_DATA,
      i_SPC_START         => i_SPC_START,
	  i_SPC_BL			  => i_SPC_BL,
	  i_SPC_BS			  => i_SPC_BS,
      i_SPC_BE            => i_SPC_BE,
      i_FLIT_SEL          => w_FLIT_SEL,
	  i_COUNTER_ENA       => w_COUNTER_ENA,
	  o_BL_REG			  => w_BL_REG,
      o_NET_DATA          => o_NET_DATA,
	  o_COUNTER           => w_COUNTER
    );

  u_GEN_MST_RCV_CTRL: gen_mst_rcv_ctrl
    port map (
      i_CLK               => i_CLK,
      i_RST               => i_RST,
	  i_SPC_OPC           => i_SPC_OPC,
      i_NET_FRAME         => i_NET_DATA(c_DATA_WIDTH+1 downto c_DATA_WIDTH),
      i_NET_ROK           => i_NET_ROK,
      o_NET_RD            => o_NET_RD,
      o_FLIT_H1_REG_ENA   => w_FLIT_RCV_H1_REG_ENA,
      o_FLIT_DATA_REG_ENA => w_FLIT_RCV_DATA_REG_ENA
    );

  u_GEN_MST_RCV_DP: gen_mst_rcv_dp
    port map (
      i_CLK               => i_CLK,
      i_RST               => i_RST,
      i_FLIT_H1_REG_ENA   => w_FLIT_RCV_H1_REG_ENA,
      i_FLIT_DATA_REG_ENA => w_FLIT_RCV_DATA_REG_ENA,
      i_NET_DATA          => i_NET_DATA,
      o_SPC_BE            => o_SPC_BE,
      o_SPC_OPC           => o_SPC_OPC,
      o_SPC_DATA          => o_SPC_DATA
    );

end rtl;
