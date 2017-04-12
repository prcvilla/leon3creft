library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library work;
use work.xiru_package.all;

entity xiru_ahb_slv_lite is
  generic (
    p_FIFO_TYPE  : string  := "RING";
    p_DEPTH      : integer := 4;
    p_LOG2_DEPTH : integer := 2;
    p_FC_TYPE    : string  := "CREDIT";    -- options: CREDIT or HANDSHAKE
    p_CREDIT     : integer := 4;           -- maximum number of credits
    p_X_SRC      : natural := 0;
    p_Y_SRC      : natural := 0;
    p_Z_SRC      : natural := 0
  );
	port (
-- Core signals
	  clk             : in  std_logic                     := '0';              --        clock.clk
	  reset           : in  std_logic                     := '0';              --   reset_sink.reset
	  hbusreq		  : out std_logic					  := '0';		       --    ahb_slave.hbusreq
	  hlock		      : out std_logic					  := '0';			   --			  .hlock
	  haddr           : out std_logic_vector(31 downto 0) := (others => '0');  --   		  .haddr
	  htrans		  : out std_logic_vector(1 downto 0)  := (others => '0');  --			  .htrans
	  hwrite		  : out	std_logic					  := '0';			   --			  .hwrite
	  hsize		      : out std_logic_vector(2 downto 0)  := (others => '0');  --			  .hsize
	  hburst		  : out std_logic_vector(2 downto 0)  := (others => '0');  --			  .hburst
	  hprot		      : out	std_logic_vector(3 downto 0)  := (others => '0');  --			  .hprot
	  hwdata		  : out	std_logic_vector(31 downto 0) := (others => '0');  --			  .hwdata
	  hgrant		  : in  std_logic_vector(15 downto 0) := (others => '0');  --			  .hgrant
	  hready		  : in  std_logic					  := '0';			   --			  .hready
	  hresp		      : in  std_logic_vector(1 downto 0)  := (others => '0');  --			  .hresp
	  hrdata		  : in  std_logic_vector(31 downto 0) := (others => '0');  --			  .hrdata
-- NoC signals
	  i_OUT_RET     : in  std_logic                                  := '0';             --     export_0.export
      o_OUT_VAL     : out std_logic;                                                     --             .export
	  o_OUT_DATA    : out std_logic_vector(c_DATA_WIDTH+1 downto 0);                     --             .export
	  o_IN_RET      : out std_logic;                                                     --             .export
	  i_IN_VAL      : in  std_logic                                  := '0';             --             .export
	  i_IN_DATA     : in  std_logic_vector(c_DATA_WIDTH+1 downto 0)  := (others => '0')  --             .export
	);
end entity xiru_ahb_slv_lite;

architecture rtl of xiru_ahb_slv_lite is

  signal w_i_NET_WR      : std_logic;
  signal w_o_NET_WOK     : std_logic;
  signal w_i_NET_DATA    : std_logic_vector(c_DATA_WIDTH+1 downto 0);
  signal w_i_NET_RD      : std_logic;
  signal w_o_NET_ROK     : std_logic;
  signal w_o_NET_DATA    : std_logic_vector(c_DATA_WIDTH+1 downto 0);
  signal w_o_SPC_START   : std_logic;
  signal w_o_SPC_OPC     : std_logic_vector(c_OPC_WIDTH-1 downto 0);
  signal w_o_SPC_BL      : std_logic_vector(c_BL_WIDTH-1 downto 0); --
  signal w_o_SPC_BS      : std_logic_vector(c_BS_WIDTH-1 downto 0); --
  signal w_o_SPC_BE      : std_logic_vector(c_BE_WIDTH-1 downto 0);
  signal w_o_SPC_ADDR    : std_logic_vector(c_ADDR_WIDTH-1 downto 0);
  signal w_o_SPC_DATA    : std_logic_vector(c_DATA_WIDTH-1 downto 0);
  signal w_o_SPC_FRAME   : std_logic_vector(1 downto 0);
  signal w_o_SPC_COUNTER : std_logic_vector(3 downto 0);
  signal w_i_SPC_WAIT    : std_logic;
  signal w_i_SPC_OPC     : std_logic_vector(c_OPC_WIDTH-1 downto 0);
  signal w_i_SPC_BE      : std_logic_vector(c_BE_WIDTH-1 downto 0);
  signal w_i_SPC_DATA    : std_logic_vector(c_DATA_WIDTH-1 downto 0);

  signal w_o_NET_DATA_LITE  : std_logic_vector(c_DATA_WIDTH+2 downto 0);

  component spc_ahb_slv is
    port (
-- Specific signals
	  clk           : in  std_logic                       := '0';              --        clock.clk
	  reset         : in  std_logic                       := '0';              --   reset_sink.reset
	  hbusreq	    : out std_logic			   	          := '0';	           --    ahb_slave.hbusreq
      hlock		    : out std_logic					      := '0';			   --			  .hlock
	  haddr         : out std_logic_vector(31 downto 0)   := (others => '0');  --   		  .haddr
	  htrans		: out std_logic_vector(1 downto 0)    := (others => '0');  --			  .htrans
	  hwrite		: out	std_logic					  := '0';			   --			  .hwrite
	  hsize		    : out std_logic_vector(2 downto 0)    := (others => '0');  --			  .hsize
	  hburst	    : out std_logic_vector(2 downto 0)    := (others => '0');  --			  .hburst
	  hprot		    : out	std_logic_vector(3 downto 0)  := (others => '0');  --			  .hprot
	  hwdata		: out	std_logic_vector(31 downto 0) := (others => '0');  --			  .hwdata
	  hgrant		: in  std_logic_vector(15 downto 0)   := (others => '0');  --			  .hgrant
	  hready		: in  std_logic					      := '0';			   --			  .hready
	  hresp		    : in  std_logic_vector(1 downto 0)    := (others => '0');  --			  .hresp
	  hrdata		: in  std_logic_vector(31 downto 0)   := (others => '0');  --			  .hrdata
-- Generic signals
      o_SPC_OPC     : out std_logic_vector(c_OPC_WIDTH-1 downto 0);
      o_SPC_BE      : out std_logic_vector(c_BE_WIDTH-1 downto 0);
      o_SPC_DATA    : out std_logic_vector(c_DATA_WIDTH-1 downto 0);
      o_SPC_WAIT    : out std_logic;
      i_SPC_START   : in  std_logic;
      i_SPC_OPC     : in  std_logic_vector(c_OPC_WIDTH-1 downto 0);
	  i_SPC_BL      : in  std_logic_vector(c_BL_WIDTH-1 downto 0);
	  i_SPC_BS      : in  std_logic_vector(c_BS_WIDTH-1 downto 0);
      i_SPC_BE      : in  std_logic_vector(c_BE_WIDTH-1 downto 0);
      i_SPC_ADDR    : in  std_logic_vector(c_ADDR_WIDTH-1 downto 0);
      i_SPC_DATA    : in  std_logic_vector(c_DATA_WIDTH-1 downto 0);
	  i_SPC_COUNTER : in  std_logic_vector(3 downto 0); --
	  i_SPC_FRAME   : in  std_logic_vector(1 downto 0) --
    );
  end component;

  component gen_slv is
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
	  o_SPC_BL      : out std_logic_vector(3 downto 0);
	  o_SPC_BS      : out std_logic_vector(2 downto 0);
	
      o_NET_WR    : out std_logic;
      o_NET_DATA  : out std_logic_vector(c_DATA_WIDTH+1 downto 0);
      i_NET_WOK   : in  std_logic;

      o_NET_RD    : out std_logic;
      i_NET_DATA  : in  std_logic_vector(c_DATA_WIDTH+2 downto 0);
      i_NET_ROK   : in  std_logic
    );
  end component;

  component net_lite is
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
  end component;

begin

  w_o_NET_DATA_LITE <= '0' & w_o_NET_DATA;

  u_SPC_AHB_SLV: spc_ahb_slv
    port map (
      clk           => clk,
      reset         => reset,
      hbusreq       => hbusreq,
      hlock	        => hlock,
      haddr         => haddr,
      htrans        => htrans,
      hwrite        => hwrite,
      hsize         => hsize,
      hburst        => hburst,
      hprot         => hprot,
	  hwdata		=> hwdata,
	  hgrant		=> hgrant,
	  hready		=> hready,
	  hresp			=> hresp,
	  hrdata		=> hrdata,
      o_SPC_OPC     => w_i_SPC_OPC,
      o_SPC_BE      => w_i_SPC_BE,
      o_SPC_DATA    => w_i_SPC_DATA,
      o_SPC_WAIT    => w_i_SPC_WAIT,
      i_SPC_START   => w_o_SPC_START,
      i_SPC_OPC     => w_o_SPC_OPC,
	  i_SPC_BL      => w_o_SPC_BL,
	  i_SPC_BS      => w_o_SPC_BS,
      i_SPC_BE      => w_o_SPC_BE,
      i_SPC_ADDR    => w_o_SPC_ADDR,
      i_SPC_DATA    => w_o_SPC_DATA,
	  i_SPC_COUNTER => w_o_SPC_COUNTER,
	  i_SPC_FRAME   => w_o_SPC_FRAME
    );

   u_GEN_SLV: gen_slv
    generic map (
      p_X_SRC      => p_X_SRC,
      p_Y_SRC      => p_Y_SRC,
      p_Z_SRC      => p_Z_SRC
    )
    port map (
      i_CLK       => clk,
      i_RST       => reset,

	  i_SPC_WAIT  => w_i_SPC_WAIT,
      i_SPC_OPC   => w_i_SPC_OPC,
      i_SPC_BE    => w_i_SPC_BE,
      i_SPC_DATA  => w_i_SPC_DATA,

      o_SPC_OPC     => w_o_SPC_OPC,
      o_SPC_BE      => w_o_SPC_BE,
      o_SPC_ADDR    => w_o_SPC_ADDR,
      o_SPC_DATA    => w_o_SPC_DATA,
	  o_SPC_COUNTER => w_o_SPC_COUNTER,
	  o_SPC_FRAME   => w_o_SPC_FRAME,
	  o_SPC_BL      => w_o_SPC_BL,
	  o_SPC_BS      => w_o_SPC_BS,

      o_NET_WR    => w_i_NET_WR,
      o_NET_DATA  => w_i_NET_DATA,
      i_NET_WOK   => w_o_NET_WOK,

      o_NET_RD    => w_i_NET_RD,
      i_NET_DATA  => w_o_NET_DATA_LITE,
      i_NET_ROK   => w_o_NET_ROK
    );

  u_NET_LITE: net_lite
    generic map (
      p_FIFO_TYPE  => p_FIFO_TYPE,
      p_DEPTH      => p_DEPTH,
      p_LOG2_DEPTH => p_LOG2_DEPTH,
      p_FC_TYPE    => p_FC_TYPE,
      p_CREDIT     => p_CREDIT
    )
    port map (
      i_CLK      => clk,
      i_RST      => reset,
      i_RET      => i_OUT_RET,
      o_VAL      => o_OUT_VAL,
      o_DATA     => o_OUT_DATA,
      i_NET_WR   => w_i_NET_WR,
      o_NET_WOK  => w_o_NET_WOK,
      i_NET_DATA => w_i_NET_DATA,
      o_RET      => o_IN_RET,
      i_VAL      => i_IN_VAL,
      i_DATA     => i_IN_DATA,
      i_NET_RD   => w_i_NET_RD,
      o_NET_ROK  => w_o_NET_ROK,
      o_NET_DATA => w_o_NET_DATA
    );

--	-- TODO: Auto-generated HDL template
--
--	o_IN_RET <= '0';
--
--	o_OUT_DATA <= "00000000000000000000000000000000000";
--
--	o_OUT_VAL <= '0';
--
--	readdata <= "00000000000000000000000000000000";
--
--  waitrequest <= '0';

end rtl; -- of xiru_avl_mst
