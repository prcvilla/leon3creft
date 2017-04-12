library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library work;
use work.xiru_package.all;

entity wrapper_ahb is
  generic(
    -- NoC
    p_PARIS_INPUT_FIFO_TYPE        : string  := "RING";          	-- options: NONE, SHIFT, RING or ALTERA
    p_PARIS_INPUT_FIFO_DEPTH       : integer := 4;             	  -- options: >=1
    p_PARIS_INPUT_FIFO_LOG2_DEPTH  : integer := 2;           	    -- options: = log2(FIFO_DEPTH) - used only in altera buffers            
    p_PARIS_FC_TYPE                : string  := "CREDIT";      	  -- options: handshake or credit
    -- NI Master
    p_X_SRC_MST      : natural := 0;
    p_Y_SRC_MST      : natural := 0;
    p_Z_SRC_MST      : natural := 0;
    -- NI Slave
    p_X_SRC_SLV      : natural := 1;
    p_Y_SRC_SLV      : natural := 0;
    p_Z_SRC_SLV      : natural := 0
  );
	port (  
		clk             : in  std_logic                      := '0';             --    clock_sink.clk
		reset           : in  std_logic                      := '0';             --    reset_sink.reset
		
		slv_hbusreq     : out std_logic                      := '0';             --    ahb_slave.hbusreq
		slv_hlock       : out std_logic                      := '0';             --             .hlock
		slv_haddr       : out std_logic_vector(31 downto 0)  := (others => '0'); --             .haddr
		slv_htrans      : out std_logic_vector(1 downto 0)   := (others => '0'); --             .htrans
		slv_hwrite      : out std_logic                      := '0';             --             .hwrite
		slv_hsize       : out std_logic_vector(2 downto 0)   := (others => '0'); --             .hsize
		slv_hburst      : out std_logic_vector(2 downto 0)   := (others => '0'); --             .hburst
		slv_hprot       : out std_logic_vector(3 downto 0)   := (others => '0'); --             .hprot
		slv_hwdata      : out std_logic_vector(31 downto 0)  := (others => '0'); --             .hwdata
		slv_hgrant      : in  std_logic_vector(15 downto 0)  := (others => '0'); --             .hgrant
		slv_hready      : in  std_logic				         := '0';             --             .hready
		slv_hresp       : in  std_logic_vector(1 downto 0)   := (others => '0'); --             .hresp
		slv_hrdata      : in  std_logic_vector(31 downto 0)  := (others => '0'); --             .hrdata
		
		mst_hbusreq     : in  std_logic                      := '0';             --   ahb_master.hbusreq
		mst_hlock       : in  std_logic                      := '0';             --             .hlock
		mst_haddr       : in  std_logic_vector(31 downto 0)  := (others => '0'); --             .haddr
		mst_htrans      : in  std_logic_vector(1 downto 0)   := (others => '0'); --             .htrans
		mst_hwrite      : in  std_logic                      := '0';             --             .hwrite
		mst_hsize       : in  std_logic_vector(2 downto 0)   := (others => '0'); --             .hsize
		mst_hburst      : in  std_logic_vector(2 downto 0)   := (others => '0'); --             .hburst
		mst_hprot       : in  std_logic_vector(3 downto 0)   := (others => '0'); --             .hprot
		mst_hwdata      : in  std_logic_vector(31 downto 0)  := (others => '0'); --             .hwdata
		mst_hgrant      : out std_logic_vector(15 downto 0)  := (others => '0'); --             .hgrant
		mst_hready      : out std_logic				         := '0';             --             .hready
		mst_hresp       : out std_logic_vector(1 downto 0)   := (others => '0'); --             .hresp
		mst_hrdata      : out std_logic_vector(31 downto 0)  := (others => '0')  --             .hrdata
	);
end entity wrapper_ahb;

architecture rtl of wrapper_ahb is

  component xiru_ahb_mst_lite is
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
	  clk           : in  std_logic                       := '0';              --         clock.clk
	  reset         : in  std_logic                       := '0';              --    reset_sink.reset
	  hbusreq	    : in  std_logic						  := '0';			   --    ahb_master.hbusreq
	  hlock		    : in  std_logic						  := '0';			   --			   .hlock
	  haddr         : in  std_logic_vector(31 downto 0)   := (others => '0');  --   		   .haddr
	  htrans		: in  std_logic_vector(1 downto 0)	  := (others => '0');  --			   .htrans
	  hwrite		: in  std_logic						  := '0';			   --			   .hwrite
	  hsize		    : in  std_logic_vector(2 downto 0)	  := (others => '0');  --			   .hsize
	  hburst		: in  std_logic_vector(2 downto 0)	  := (others => '0');  --			   .hburst
	  hprot		    : in  std_logic_vector(3 downto 0)	  := (others => '0');  --			   .hprot
	  hwdata		: in  std_logic_vector(31 downto 0)	  := (others => '0');  --			   .hwdata
	  hgrant		: out std_logic_vector(15 downto 0)	  := (others => '0');  --			   .hgrant
	  hready		: out std_logic						  := '0';			   --			   .hready
	  hresp		    : out std_logic_vector(1 downto 0)	  := (others => '0');  --			   .hresp
	  hrdata		: out std_logic_vector(31 downto 0)	  := (others => '0');  --			   .hrdata
  -- NoC signals
      i_OUT_RET     : in  std_logic                                  := '0';             --     export_0.export
      o_OUT_VAL     : out std_logic;                                                     --             .export
      o_OUT_DATA    : out std_logic_vector(c_DATA_WIDTH+1 downto 0);                     --             .export
      o_IN_RET      : out std_logic;                                                     --             .export
      i_IN_VAL      : in  std_logic                                  := '0';             --             .export
      i_IN_DATA     : in  std_logic_vector(c_DATA_WIDTH+1 downto 0)  := (others => '0')  --             .export
    );
  end component xiru_ahb_mst_lite;

--  component xiru_ahb_slv_lite is
--    generic (
--      p_FIFO_TYPE  : string  := "RING";
--      p_DEPTH      : integer := 4;
--      p_LOG2_DEPTH : integer := 2;
--      p_FC_TYPE    : string  := "CREDIT";    -- options: CREDIT or HANDSHAKE
--      p_CREDIT     : integer := 4;           -- maximum number of credits
--      p_X_SRC      : natural := 0;
--      p_Y_SRC      : natural := 0;
--      p_Z_SRC      : natural := 0
--    );
--    port (
--  -- Core signals
--	  clk           : in  std_logic                       := '0';              --        clock.clk
--	  reset         : in  std_logic                       := '0';              --   reset_sink.reset
--	  hbusreq	    : out std_logic					      := '0';		       --    ahb_slave.hbusreq
--	  hlock		    : out std_logic					      := '0';			   --			  .hlock
--	  haddr         : out std_logic_vector(31 downto 0)   := (others => '0');  --   		  .haddr
--	  htrans	    : out std_logic_vector(1 downto 0)    := (others => '0');  --			  .htrans
--	  hwrite	    : out std_logic				          := '0';			   --			  .hwrite
--	  hsize		    : out std_logic_vector(2 downto 0)    := (others => '0');  --			  .hsize
--	  hburst	    : out std_logic_vector(2 downto 0)    := (others => '0');  --			  .hburst
--	  hprot		    : out std_logic_vector(3 downto 0)    := (others => '0');  --			  .hprot
--	  hwdata	    : out std_logic_vector(31 downto 0)   := (others => '0');  --			  .hwdata
--	  hgrant	    : in  std_logic_vector(15 downto 0)   := (others => '0');  --			  .hgrant
--	  hready	    : in  std_logic					      := '0';			   --			  .hready
--	  hresp		    : in  std_logic_vector(1 downto 0)    := (others => '0');  --			  .hresp
--	  hrdata	    : in  std_logic_vector(31 downto 0)   := (others => '0');  --			  .hrdata
--  -- NoC signals
--      i_OUT_RET     : in  std_logic                                  := '0';             --     export_0.export
--      o_OUT_VAL     : out std_logic;                                                     --             .export
--      o_OUT_DATA    : out std_logic_vector(c_DATA_WIDTH+1 downto 0);                     --             .export
--      o_IN_RET      : out std_logic;                                                     --             .export
--      i_IN_VAL      : in  std_logic                                  := '0';             --             .export
--      i_IN_DATA     : in  std_logic_vector(c_DATA_WIDTH+1 downto 0)  := (others => '0')  --             .export
--    );
--  end component xiru_ahb_slv_lite;

  signal w_OUT_RET_MST  : std_logic;                     -- i_OUT_RET
  signal w_OUT_VAL_MST  : std_logic;                     -- o_OUT_VAL
  signal w_OUT_DATA_MST : std_logic_vector(33 downto 0); -- o_OUT_DATA
  signal w_IN_RET_MST   : std_logic;                     -- o_IN_RET
  signal w_IN_VAL_MST   : std_logic;                     -- i_IN_VAL
  signal w_IN_DATA_MST  : std_logic_vector(33 downto 0); -- i_IN_DATA

begin

  u0: component xiru_ahb_mst_lite
    generic map(
      p_FIFO_TYPE   => p_PARIS_INPUT_FIFO_TYPE,
      p_DEPTH       => p_PARIS_INPUT_FIFO_DEPTH,
      p_LOG2_DEPTH  => p_PARIS_INPUT_FIFO_LOG2_DEPTH,
      p_FC_TYPE     => p_PARIS_FC_TYPE,
      p_CREDIT      => p_PARIS_INPUT_FIFO_DEPTH,
      p_X_SRC       => p_X_SRC_MST,
      p_Y_SRC       => p_Y_SRC_MST,
      p_Z_SRC       => p_Z_SRC_MST
    )
    port map(
      clk           => clk,
      reset         => reset,
	  hbusreq       => mst_hbusreq,
	  hlock         => mst_hlock,
	  haddr         => mst_haddr,
	  htrans        => mst_htrans,
	  hwrite        => mst_hwrite,
	  hsize         => mst_hsize,
	  hburst        => mst_hburst,
	  hprot         => mst_hprot,
	  hwdata        => mst_hwdata,
	  hgrant        => mst_hgrant,
	  hready        => mst_hready,
	  hresp         => mst_hresp,
	  hrdata        => mst_hrdata,
      i_OUT_RET     => w_OUT_RET_MST,
      o_OUT_VAL     => w_OUT_VAL_MST,
      o_OUT_DATA    => w_OUT_DATA_MST,
      o_IN_RET      => w_IN_RET_MST,
      i_IN_VAL      => w_IN_VAL_MST,
      i_IN_DATA     => w_IN_DATA_MST
    );

--  u1: component xiru_ahb_slv_lite
--    generic map(
--      p_FIFO_TYPE   => p_PARIS_INPUT_FIFO_TYPE,
--      p_DEPTH       => p_PARIS_INPUT_FIFO_DEPTH,
--      p_LOG2_DEPTH  => p_PARIS_INPUT_FIFO_LOG2_DEPTH,
--      p_FC_TYPE     => p_PARIS_FC_TYPE,
--      p_CREDIT      => p_PARIS_INPUT_FIFO_DEPTH,
--      p_X_SRC       => p_X_SRC_SLV,
--      p_Y_SRC       => p_Y_SRC_SLV,
--      p_Z_SRC       => p_Z_SRC_SLV
--    )
--    port map(
--      clk           => clk,
--      reset         => reset,
--	  hbusreq       => slv_hbusreq,
--	  hlock         => slv_hlock,
--	  haddr         => slv_haddr,
--	  htrans        => slv_htrans,
--	  hwrite        => slv_hwrite,
--	  hsize         => slv_hsize,
--	  hburst        => slv_hburst,
--	  hprot         => slv_hprot,
--	  hwdata        => slv_hwdata,
--	  hgrant        => slv_hgrant,
--	  hready        => slv_hready,
--	  hresp         => slv_hresp,
--	  hrdata        => slv_hrdata,
--      i_OUT_RET     => w_IN_RET_MST,
--      o_OUT_VAL     => w_IN_VAL_MST,
--      o_OUT_DATA    => w_IN_DATA_MST,
--      o_IN_RET      => w_OUT_RET_MST,
--      i_IN_VAL      => w_OUT_VAL_MST,
--      i_IN_DATA     => w_OUT_DATA_MST
--    );

end architecture rtl; -- of wrapper_avl
