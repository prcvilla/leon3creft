-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- ParIS - beta distribution 1.1 
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- This code is part of the VHDL description of ParIS router, the building block
-- of SoCINfp network. It was implemented by Cesar A. Zeferino and Frederico
-- G. M. do Espirito Santo at UNIVALI (Itajai, Brazil), in cooperation with
-- Altamiro A. Susin from UFRGS (Porto Alegre, Brazil).
--
-- where:
--   ParIS   = Parameterizable Interconnect Switch
--   SoCINfp = System-on-Chip Interconnection Network - fully parameterizable
--   UNIVALI = Universidade do Vale do Itaja�
--   UFRGS   = Universidade Federal do Rio Grande do Sul
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- General features of the current version
-- They are offered the following option for synthesis:
-- a)Routing     : XY and West-First (N/S before E, or E befor N/S)
-- b)Arbitration : round-robin
-- c)Flow-control: credit-based (synchronous) and handshake (assynchronous)
-- d)Buffers FIFO: at the input and/or at the output channels, with the
--                 following implementations:
--                 - LUT/FF-based (RING and SHIFT architectures)
--                 - Embedded-RAM-based (Altera function)
--                 - no buffers (NONE)
-- e)Switches    : only LUT-based 
-- f)Physical    : some physical parameters can be customized:
--                 - channel widths (DATA_WIDTH+2) 
--                 - routing information width (RIB_WIDTH)
--                 - FIFO's depth
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Please, we ask that any publication of researches based on this code refers 
-- to the following paper:
--
-- C. A. Zeferino, F. G. M. do Espirito Santo, A. A. Susin. ParIS: A Parameteri-
-- zable Interconnect Switch for Networks-on-Chip. In: Proceedings of the 17th 
-- Symposium on Integrated Circuits and Systems (SBCCI),ACM Press, 2004.
-- pp.204-209.
--
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- VERY IMPORTANT:
-- This code was synthesized and verified only using Altera Quartus II tools.
-- Since it based on a hierarchical inheritance of parameters, from the higher
-- level entities to the lower level ones, it is possible that synthesis does
-- not work in EDA tools requiring a botton-up compilation flow, like Modelsim.
--
-- NOTE: We are not responsible for its use in real applications.
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
---------------
---------------
entity paris is
---------------
---------------
  generic(
    -- address of a paris instance
    p_XID                 : integer := 2;         -- x-coordinate
    p_YID                 : integer := 2;         -- y-coordinate

    -- usage of each communication port
    p_USE_LOCAL           : integer := 1;         -- local port must be implemented
    p_USE_NORTH           : integer := 1;         -- north port must be implemented
    p_USE_EAST            : integer := 1;         -- east  port must be implemented
    p_USE_SOUTH           : integer := 1;         -- south port must be implemented
    p_USE_WEST            : integer := 1;         -- west  port must be implemented

    -- data channel and rib widths
    p_DATA_WIDTH          : integer := 32;         -- width of the data channel 
    p_RIB_WIDTH           : integer := 18;         -- width of the rib field in the header

    -- parameters for the input buffers
    p_XIN_FIFO_TYPE       : string  := "RING";   -- options: NONE, RING, SHIFT or ALTERA
    p_LIN_FIFO_DEPTH      : integer := 4;         -- depth of the local input buffer
    p_NIN_FIFO_DEPTH      : integer := 4;         -- depth of the north input buffer
    p_EIN_FIFO_DEPTH      : integer := 4;         -- depth of the east  input buffer
    p_SIN_FIFO_DEPTH      : integer := 4;         -- depth of the south input buffer
    p_WIN_FIFO_DEPTH      : integer := 4;         -- depth of the west  input buffer
    p_LIN_FIFO_LOG2_DEPTH : integer := 2;         -- used only for altera type
    p_NIN_FIFO_LOG2_DEPTH : integer := 2;         -- used only for altera type
    p_EIN_FIFO_LOG2_DEPTH : integer := 2;         -- used only for altera type
    p_SIN_FIFO_LOG2_DEPTH : integer := 2;         -- used only for altera type
    p_WIN_FIFO_LOG2_DEPTH : integer := 2;         -- used only for altera type

    -- parameters for the output buffers
    p_XOUT_FIFO_TYPE       : string  := "NONE";   -- options: NONE, RING, SHIFT or ALTERA
    p_LOUT_FIFO_DEPTH      : integer := 4;        -- depth of the local input buffer
    p_NOUT_FIFO_DEPTH      : integer := 4;        -- depth of the north input buffer
    p_EOUT_FIFO_DEPTH      : integer := 4;        -- depth of the east  input buffer
    p_SOUT_FIFO_DEPTH      : integer := 4;        -- depth of the south input buffer
    p_WOUT_FIFO_DEPTH      : integer := 4;        -- depth of the west  input buffer
    p_LOUT_FIFO_LOG2_DEPTH : integer := 2;        -- used only for altera type
    p_NOUT_FIFO_LOG2_DEPTH : integer := 2;        -- used only for altera type
    p_EOUT_FIFO_LOG2_DEPTH : integer := 2;        -- used only for altera type
    p_SOUT_FIFO_LOG2_DEPTH : integer := 2;        -- used only for altera type
    p_WOUT_FIFO_LOG2_DEPTH : integer := 2;        -- used only for altera type

    -- parameters for the flow controllers 
    p_FC_TYPE        : string  := "HANDSHAKE";      -- options: CREDIT or HANDSHAKE
    p_LOUT_FC_CREDIT : integer := 4;             -- initial number of credits for lout
    p_NOUT_FC_CREDIT : integer := 4;             -- initial number of credits for nout
    p_EOUT_FC_CREDIT : integer := 4;             -- initial number of credits for eout
    p_SOUT_FC_CREDIT : integer := 4;             -- initial number of credits for sout
    p_WOUT_FC_CREDIT : integer := 4;             -- initial number of credits for wout

    -- parameters for routing circuits, arbiters and switches
    p_ROUTING_TYPE   : string  := "XY";          -- options: XY or WF
    p_WF_TYPE        : string  := "Y_BEFORE_E";  -- options: E_BEFORE_Y, Y_BEFORE_E
    p_ARBITER_TYPE   : string  := "RANDOM"; -- options: ROUND_ROBIN,STATIC or RANDOM
    p_SWITCH_TYPE    : string  := "LOGIC"        -- options: LOGIC (to be implemented: TRI)
  );
  port(
    i_CLK       : in   std_logic;
    i_RST       : in   std_logic;
    -- local communication port
    i_LIN_DATA  : in   std_logic_vector(p_DATA_WIDTH+1 downto 0);
    i_LIN_VAL   : in   std_logic;
    o_LIN_RET   : out  std_logic;  
    o_LOUT_DATA : out  std_logic_vector(p_DATA_WIDTH+1 downto 0);
    o_LOUT_VAL  : out  std_logic;
    i_LOUT_RET  : in   std_logic;
    -- north communication port
    i_NIN_DATA  : in   std_logic_vector(p_DATA_WIDTH+1 downto 0);
    i_NIN_VAL   : in   std_logic;
    o_NIN_RET   : out  std_logic;  
    o_NOUT_DATA : out  std_logic_vector(p_DATA_WIDTH+1 downto 0);
    o_NOUT_VAL  : out  std_logic;
    i_NOUT_RET  : in   std_logic;
    -- east communication port
    i_EIN_DATA  : in   std_logic_vector(p_DATA_WIDTH+1 downto 0);
    i_EIN_VAL   : in   std_logic;
    o_EIN_RET   : out  std_logic;  
    o_EOUT_DATA : out  std_logic_vector(p_DATA_WIDTH+1 downto 0);
    o_EOUT_VAL  : out  std_logic;
    i_EOUT_RET  : in   std_logic;
    -- south communication port
    i_SIN_DATA  : in   std_logic_vector(p_DATA_WIDTH+1 downto 0);
    i_SIN_VAL   : in   std_logic;
    o_SIN_RET   : out  std_logic;  
    o_SOUT_DATA : out  std_logic_vector(p_DATA_WIDTH+1 downto 0);
    o_SOUT_VAL  : out  std_logic;
    i_SOUT_RET  : in   std_logic;
    -- west communication port
    i_WIN_DATA  : in   std_logic_vector(p_DATA_WIDTH+1 downto 0);
    i_WIN_VAL   : in   std_logic;
    o_WIN_RET   : out  std_logic;  
    o_WOUT_DATA : out  std_logic_vector(p_DATA_WIDTH+1 downto 0);
    o_WOUT_VAL  : out  std_logic;
    i_WOUT_RET  : in   std_logic);
end paris;

-------------------------------
-------------------------------
architecture arch_1 of paris is
-------------------------------
-------------------------------

-------------
component xin 
-------------
  generic(
    p_XID             : integer:= 2;           -- x-coordinate  
    p_YID             : integer:= 2;           -- y-coordinate
    p_USE_THIS        : integer:= 1;           -- defines if the module must be used
    p_MODULE_ID       : string := "l";         -- identifier of the port in the router
    p_DATA_WIDTH      : integer:= 8;           -- width of data channel 
    p_RIB_WIDTH       : integer:= 18;          -- width of the rib field in the header
    p_ROUTING_TYPE    : string := "XY";        -- type of routing algorithm
    p_WF_TYPE         : string := "Y_BEFORE_E";-- options: E_BEFORE_Y, Y_BEFORE_E
    p_FC_TYPE         : string := "CREDIT";    -- options: CREDIT or HANDSHAKE
    p_FIFO_TYPE       : string := "SHIFT";     -- options: NONE, SHIFT, RING & ALTERA
    p_FIFO_DEPTH      : integer:= 4;           -- number of positions
    p_FIFO_LOG2_DEPTH : integer:= 2;           -- log2 of the number of positions 
    p_SWITCH_TYPE     : string := "LOGIC"      -- options: LOGIC (to implement: TRI)
  );
  port(
    -- system interface
    i_CLK   : in  std_logic;                         -- clock
    i_RST   : in  std_logic;                         -- reset

    -- link signals
    i_DATA 		: in std_logic_vector(p_DATA_WIDTH+1 downto 0); -- input channel
    i_VAL  		: in  std_logic;                       -- data validation
    o_RET  		: out std_logic;                       -- return (cr/ack)

    -- commands and status signals interconnecting input and output channels
    o_X_REQL  : out std_logic;                       -- request to lout
    o_X_REQN  : out std_logic;                       -- request to nout
    o_X_REQE  : out std_logic;                       -- request to eout
    o_X_REQS  : out std_logic;                       -- request to sout
    o_X_REQW  : out std_logic;                       -- request to wout
    o_X_ROK   : out std_logic;                       -- rok to the outputs
    i_X_RD    : in  std_logic_vector (3 downto 0);   -- rd cmd. from the outputs
    i_X_GNT   : in  std_logic_vector (3 downto 0);   -- grant from the outputs
    i_X_LIDLE : in  std_logic;                       -- status from lout
    i_X_NIDLE : in  std_logic;                       -- status from nout
    i_X_EIDLE : in  std_logic;                       -- status from eout
    i_X_SIDLE : in  std_logic;                       -- status from sout
    i_X_WIDLE : in  std_logic;                       -- status from wout

    -- data to the output channels
    o_X_DOUT  : out std_logic_vector(p_DATA_WIDTH+1 downto 0) -- output data bus
  );
end component;

--------------
component xout
--------------
  generic(
    p_USE_THIS        : integer := 1;            -- defines if the module must be used
    p_DATA_WIDTH      : integer := 8;            -- width of data channel 
    p_FC_TYPE         : string  := "CREDIT";     -- options: CREDIT or HANDSHAKE
    p_FC_CREDIT       : integer := 4;            -- maximum number of credits
    p_FIFO_TYPE       : string  := "SHIFT";      -- options: NONE, SHIFT, RING & ALTERA
    p_FIFO_DEPTH      : integer := 4;            -- number of positions
    p_FIFO_LOG2_DEPTH : integer := 2;            -- log2 of the number of positions 
    p_ARBITER_TYPE    : string  := "ROUND_ROBIN";-- options: ROUND_ROBIN
    p_SWITCH_TYPE     : string  := "LOGIC"       -- options: LOGIC (to implement: TRI)
  );
  port(
    -- system signals
    i_CLK  : in  std_logic;  -- clock
    i_RST  : in  std_logic;  -- reset
      
    -- link signals
    o_DATA  : out std_logic_vector(p_DATA_WIDTH+1 downto 0); -- output channel
    o_VAL   : out std_logic;                        -- data validation
    i_RET   : in  std_logic;                        -- return (cr/ack) 

    -- commands and status signals interconnecting input and output channels
    i_X_REQ     : in  std_logic_vector (3 downto 0);    -- reqs. from the inputs
    i_X_ROK     : in  std_logic_vector (3 downto 0);    -- rok from   the inputs
    o_X_RD      : out std_logic;                        -- rd cmd. to the inputs
    o_X_GNT     : out std_logic_vector (3 downto 0);    -- grant to the inputs
    o_X_IDLE    : out std_logic;                        -- status to  the inputs

    -- data from the input channels
    i_X_DIN0    : in  std_logic_vector(p_DATA_WIDTH+1 downto 0); -- channel 0 
    i_X_DIN1    : in  std_logic_vector(p_DATA_WIDTH+1 downto 0); -- channel 1
    i_X_DIN2    : in  std_logic_vector(p_DATA_WIDTH+1 downto 0); -- channel 2
    i_X_DIN3    : in  std_logic_vector(p_DATA_WIDTH+1 downto 0)  -- channel 3
  );
end component;

-----------
component x
-----------
  generic (
    p_ROUTING_TYPE : string := "XY"  -- options are XY or WF
  );
  port (
    i_L_REQN  : in  std_logic;
    i_L_REQE  : in  std_logic;
    i_L_REQS  : in  std_logic;
    i_L_REQW  : in  std_logic;
    --------------------------
    o_L_REQN  : out std_logic;
    o_L_REQE  : out std_logic;
    o_L_REQS  : out std_logic;
    o_L_REQW  : out std_logic;
    --------------------------
    i_N_REQL  : in  std_logic;
    i_N_REQE  : in  std_logic;
    i_N_REQS  : in  std_logic;
    i_N_REQW  : in  std_logic;
    --------------------------
    o_N_REQL  : out std_logic;
    o_N_REQE  : out std_logic;
    o_N_REQS  : out std_logic;
    o_N_REQW  : out std_logic;
    --------------------------
    i_E_REQL  : in  std_logic;
    i_E_REQN  : in  std_logic;
    i_E_REQS  : in  std_logic;
    i_E_REQW  : in  std_logic;
    --------------------------
    o_E_REQL  : out std_logic;
    o_E_REQN  : out std_logic;
    o_E_REQS  : out std_logic;
    o_E_REQW  : out std_logic;
    --------------------------
    i_S_REQL  : in  std_logic;
    i_S_REQN  : in  std_logic;
    i_S_REQE  : in  std_logic;
    i_S_REQW  : in  std_logic;
    --------------------------
    o_S_REQL  : out std_logic;  
    o_S_REQN  : out std_logic;  
    o_S_REQE  : out std_logic;  
    o_S_REQW  : out std_logic;
    --------------------------
    i_W_REQL  : in  std_logic;
    i_W_REQN  : in  std_logic;
    i_W_REQE  : in  std_logic;
    i_W_REQS  : in  std_logic;
    --------------------------
    o_W_REQL  : out std_logic;
    o_W_REQN  : out std_logic;
    o_W_REQE  : out std_logic;
    o_W_REQS  : out std_logic;
    --------------------------
    --------------------------
    i_L_GNTN  : in  std_logic;
    i_L_GNTE  : in  std_logic;
    i_L_GNTS  : in  std_logic;
    i_L_GNTW  : in  std_logic;
    --------------------------
    o_L_GNTN  : out std_logic;
    o_L_GNTE  : out std_logic;
    o_L_GNTS  : out std_logic;
    o_L_GNTW  : out std_logic;
    --------------------------
    i_N_GNTL  : in  std_logic;
    i_N_GNTE  : in  std_logic;
    i_N_GNTS  : in  std_logic;
    i_N_GNTW  : in  std_logic;
    --------------------------
    o_N_GNTL  : out std_logic;
    o_N_GNTE  : out std_logic;
    o_N_GNTS  : out std_logic;
    o_N_GNTW  : out std_logic;
    --------------------------
    i_E_GNTL  : in  std_logic;
    i_E_GNTN  : in  std_logic;
    i_E_GNTS  : in  std_logic;
    i_E_GNTW  : in  std_logic;
    --------------------------
    o_E_GNTL  : out std_logic;
    o_E_GNTN  : out std_logic;
    o_E_GNTS  : out std_logic;
    o_E_GNTW  : out std_logic;
    --------------------------
    i_S_GNTL  : in  std_logic;
    i_S_GNTN  : in  std_logic;
    i_S_GNTE  : in  std_logic;
    i_S_GNTW  : in  std_logic;
    --------------------------
    o_S_GNTL  : out std_logic;
    o_S_GNTN  : out std_logic;
    o_S_GNTE  : out std_logic;
    o_S_GNTW  : out std_logic;
    --------------------------
    i_W_GNTL  : in  std_logic;
    i_W_GNTN  : in  std_logic;
    i_W_GNTE  : in  std_logic;
    i_W_GNTS  : in  std_logic;
    --------------------------
    o_W_GNTL  : out std_logic;
    o_W_GNTN  : out std_logic;
    o_W_GNTE  : out std_logic;
    o_W_GNTS  : out std_logic);
    --------------------------
end component;

---------
--signals
---------
-- requests from l
signal  w_LUNUSED   : std_logic;
signal  w_L_REQN_XIN : std_logic;
signal  w_L_REQN_XOUT: std_logic;
signal  w_L_REQE_XIN : std_logic;
signal  w_L_REQE_XOUT: std_logic;
signal  w_L_REQS_XIN : std_logic;
signal  w_L_REQS_XOUT: std_logic;
signal  w_L_REQW_XIN : std_logic;
signal  w_L_REQW_XOUT: std_logic;
-- requests from n
signal  w_NUNUSED   : std_logic;
signal  w_N_REQL_XIN : std_logic;
signal  w_N_REQL_XOUT: std_logic;
signal  w_N_REQE_XIN : std_logic;
signal  w_N_REQE_XOUT: std_logic;
signal  w_N_REQS_XIN : std_logic;
signal  w_N_REQS_XOUT: std_logic;
signal  w_N_REQW_XIN : std_logic;
signal  w_N_REQW_XOUT: std_logic;
-- requests from e
signal  w_EUNUSED   : std_logic;
signal  w_E_REQL_XIN : std_logic;
signal  w_E_REQL_XOUT: std_logic;
signal  w_E_REQN_XIN : std_logic;
signal  w_E_REQN_XOUT: std_logic;
signal  w_E_REQS_XIN : std_logic;
signal  w_E_REQS_XOUT: std_logic;
signal  w_E_REQW_XIN : std_logic;
signal  w_E_REQW_XOUT: std_logic;
-- requests from s
signal  w_SUNUSED   : std_logic;
signal  w_S_REQL_XIN : std_logic;
signal  w_S_REQL_XOUT: std_logic;
signal  w_S_REQN_XIN : std_logic;
signal  w_S_REQN_XOUT: std_logic;
signal  w_S_REQE_XIN : std_logic;
signal  w_S_REQE_XOUT: std_logic;
signal  w_S_REQW_XIN : std_logic;
signal  w_S_REQW_XOUT: std_logic;
-- requests from w
signal  w_WUNUSED : std_logic;
signal  w_W_REQL_XIN : std_logic;
signal  w_W_REQL_XOUT: std_logic;
signal  w_W_REQN_XIN : std_logic;
signal  w_W_REQN_XOUT: std_logic;
signal  w_W_REQE_XIN : std_logic;
signal  w_W_REQE_XOUT: std_logic;
signal  w_W_REQS_XIN : std_logic;
signal  w_W_REQS_XOUT: std_logic;
-- grants from l
signal  w_L_GNTN_XIN : std_logic;
signal  w_L_GNTN_XOUT: std_logic;
signal  w_L_GNTE_XIN : std_logic;
signal  w_L_GNTE_XOUT: std_logic;
signal  w_L_GNTS_XIN : std_logic;
signal  w_L_GNTS_XOUT: std_logic;
signal  w_L_GNTW_XIN : std_logic;
signal  w_L_GNTW_XOUT: std_logic;
-- grants from n
signal  w_N_GNTL_XIN : std_logic;
signal  w_N_GNTL_XOUT: std_logic;
signal  w_N_GNTE_XIN : std_logic;
signal  w_N_GNTE_XOUT: std_logic;
signal  w_N_GNTS_XIN : std_logic;
signal  w_N_GNTS_XOUT: std_logic;
signal  w_N_GNTW_XIN : std_logic;
signal  w_N_GNTW_XOUT: std_logic;
-- grants from e
signal  w_E_GNTL_XIN : std_logic;
signal  w_E_GNTL_XOUT: std_logic;
signal  w_E_GNTN_XIN : std_logic;
signal  w_E_GNTN_XOUT: std_logic;
signal  w_E_GNTS_XIN : std_logic;
signal  w_E_GNTS_XOUT: std_logic;
signal  w_E_GNTW_XIN : std_logic;
signal  w_E_GNTW_XOUT: std_logic;
-- grants from s
signal  w_S_GNTL_XIN : std_logic;
signal  w_S_GNTL_XOUT: std_logic;
signal  w_S_GNTN_XIN : std_logic;
signal  w_S_GNTN_XOUT: std_logic;
signal  w_S_GNTE_XIN : std_logic;
signal  w_S_GNTE_XOUT: std_logic;
signal  w_S_GNTW_XIN : std_logic;
signal  w_S_GNTW_XOUT: std_logic;
-- grants from w
signal  w_W_GNTL_XIN : std_logic;
signal  w_W_GNTL_XOUT: std_logic;
signal  w_W_GNTN_XIN : std_logic;
signal  w_W_GNTN_XOUT: std_logic;
signal  w_W_GNTE_XIN : std_logic;
signal  w_W_GNTE_XOUT: std_logic;
signal  w_W_GNTS_XIN : std_logic;
signal  w_W_GNTS_XOUT: std_logic;
-- data buses
signal  w_LDATA     : std_logic_vector(p_DATA_WIDTH+1 downto 0);
signal  w_NDATA     : std_logic_vector(p_DATA_WIDTH+1 downto 0);
signal  w_EDATA     : std_logic_vector(p_DATA_WIDTH+1 downto 0);
signal  w_SDATA     : std_logic_vector(p_DATA_WIDTH+1 downto 0);
signal  w_WDATA     : std_logic_vector(p_DATA_WIDTH+1 downto 0);
-- read status
signal  w_LROK      : std_logic;
signal  w_NROK      : std_logic;
signal  w_EROK      : std_logic;
signal  w_SROK      : std_logic;
signal  w_WROK      : std_logic;
-- read command
signal  w_LRD       : std_logic;
signal  w_NRD       : std_logic;
signal  w_ERD       : std_logic;
signal  w_SRD       : std_logic;
signal  w_WRD       : std_logic;
-- idle
signal  w_LIDLE     : std_logic;
signal  w_NIDLE     : std_logic;
signal  w_EIDLE     : std_logic;
signal  w_SIDLE     : std_logic;
signal  w_WIDLE     : std_logic;

begin

  --------
  u_LIN: xin
  --------
  generic map(
    p_XID             => p_XID,
    p_YID             => p_YID,
    p_USE_THIS        => p_USE_LOCAL,    
    p_MODULE_ID       => "L",
    p_DATA_WIDTH      => p_DATA_WIDTH,
    p_RIB_WIDTH       => p_RIB_WIDTH,
    p_ROUTING_TYPE    => p_ROUTING_TYPE,
    p_WF_TYPE         => p_WF_TYPE,
    p_FC_TYPE         => p_FC_TYPE,
    p_FIFO_TYPE       => p_XIN_FIFO_TYPE,
    p_FIFO_DEPTH      => p_LIN_FIFO_DEPTH,
    p_FIFO_LOG2_DEPTH => p_LIN_FIFO_LOG2_DEPTH,
    p_SWITCH_TYPE     => p_SWITCH_TYPE
  )
  port map(
    i_CLK     => i_CLK,
    i_RST     => i_RST,
    i_DATA    => i_LIN_DATA,
    i_VAL     => i_LIN_VAL,
    o_RET     => o_LIN_RET,
    o_X_REQL  => w_LUNUSED,
    o_X_REQN  => w_L_REQN_XIN,
    o_X_REQE  => w_L_REQE_XIN,
    o_X_REQS  => w_L_REQS_XIN,
    o_X_REQW  => w_L_REQW_XIN,
    o_X_ROK   => w_LROK,
    i_X_RD(0) => w_NRD,
    i_X_RD(1) => w_ERD,
    i_X_RD(2) => w_SRD,
    i_X_RD(3) => w_WRD,
    i_X_GNT(0)=> w_N_GNTL_XIN,
    i_X_GNT(1)=> w_E_GNTL_XIN,
    i_X_GNT(2)=> w_S_GNTL_XIN,
    i_X_GNT(3)=> w_W_GNTL_XIN,
    i_X_LIDLE => w_LIDLE,
    i_X_NIDLE => w_NIDLE,
    i_X_EIDLE => w_EIDLE,
    i_X_SIDLE => w_SIDLE,
    i_X_WIDLE => w_WIDLE,
    o_X_DOUT  => w_LDATA  
  );
  
  
  --------
  u_NIN: xin
  --------
  generic map(
    p_XID             => p_XID,
    p_YID             => p_YID,
    p_USE_THIS        => p_USE_LOCAL,    
    p_MODULE_ID       => "N",
    p_DATA_WIDTH      => p_DATA_WIDTH,
    p_RIB_WIDTH       => p_RIB_WIDTH,
    p_ROUTING_TYPE    => p_ROUTING_TYPE,
    p_WF_TYPE         => p_WF_TYPE,
    p_FC_TYPE         => p_FC_TYPE,
    p_FIFO_TYPE       => p_XIN_FIFO_TYPE,
    p_FIFO_DEPTH      => p_NIN_FIFO_DEPTH,
    p_FIFO_LOG2_DEPTH => p_NIN_FIFO_LOG2_DEPTH,
    p_SWITCH_TYPE     => p_SWITCH_TYPE
  )
  port map(
    i_CLK     => i_CLK,
    i_RST     => i_RST,
    i_DATA    => i_NIN_DATA,
    i_VAL     => i_NIN_VAL,
    o_RET     => o_NIN_RET,
    o_X_REQL  => w_N_REQL_XIN,
    o_X_REQN  => w_NUNUSED,
    o_X_REQE  => w_N_REQE_XIN,
    o_X_REQS  => w_N_REQS_XIN,
    o_X_REQW  => w_N_REQW_XIN,
    o_X_ROK   => w_NROK,
    i_X_RD(0) => w_LRD,
    i_X_RD(1) => w_ERD,
    i_X_RD(2) => w_SRD,
    i_X_RD(3) => w_WRD,
    i_X_GNT(0)=> w_L_GNTN_XIN,
    i_X_GNT(1)=> w_E_GNTN_XIN,
    i_X_GNT(2)=> w_S_GNTN_XIN,
    i_X_GNT(3)=> w_W_GNTN_XIN, 
    i_X_LIDLE => w_LIDLE,
    i_X_NIDLE => w_NIDLE,
    i_X_EIDLE => w_EIDLE,
    i_X_SIDLE => w_SIDLE,
    i_X_WIDLE => w_WIDLE,
    o_X_DOUT  => w_NDATA  
  );
    

  --------
  u_EIN: xin
  --------
  generic map(
    p_XID             => p_XID,
    p_YID             => p_YID,
    p_USE_THIS        => p_USE_LOCAL,    
    p_MODULE_ID       => "E",
    p_DATA_WIDTH      => p_DATA_WIDTH,
    p_RIB_WIDTH       => p_RIB_WIDTH,
    p_ROUTING_TYPE    => p_ROUTING_TYPE,
    p_WF_TYPE         => p_WF_TYPE,
    p_FC_TYPE         => p_FC_TYPE,
    p_FIFO_TYPE       => p_XIN_FIFO_TYPE,
    p_FIFO_DEPTH      => p_EIN_FIFO_DEPTH,
    p_FIFO_LOG2_DEPTH => p_EIN_FIFO_LOG2_DEPTH,
    p_SWITCH_TYPE     => p_SWITCH_TYPE
  )
  port map(
    i_CLK     => i_CLK,
    i_RST     => i_RST,
    i_DATA    => i_EIN_DATA,
    i_VAL     => i_EIN_VAL,
    o_RET     => o_EIN_RET,
    i_X_GNT(0)=> w_L_GNTE_XIN,
    i_X_GNT(1)=> w_N_GNTE_XIN,
    i_X_GNT(2)=> w_S_GNTE_XIN,
    i_X_GNT(3)=> w_W_GNTE_XIN,
    i_X_RD(0) => w_LRD,
    i_X_RD(1) => w_NRD,
    i_X_RD(2) => w_SRD,
    i_X_RD(3) => w_WRD,
    i_X_LIDLE => w_LIDLE,
    i_X_NIDLE => w_NIDLE,
    i_X_EIDLE => w_EIDLE,
    i_X_SIDLE => w_SIDLE,
    i_X_WIDLE => w_WIDLE,
    o_X_DOUT  => w_EDATA,  
    o_X_REQL  => w_E_REQL_XIN,
    o_X_REQN  => w_E_REQN_XIN,
    o_X_REQE  => w_EUNUSED,
    o_X_REQS  => w_E_REQS_XIN,
    o_X_REQW  => w_E_REQW_XIN,
    o_X_ROK   => w_EROK
  );
    
  --------
  u_SIN: xin
  --------
  generic map(
    p_XID             => p_XID,
    p_YID             => p_YID,
    p_USE_THIS        => p_USE_LOCAL,    
    p_MODULE_ID       => "S",
    p_DATA_WIDTH      => p_DATA_WIDTH,
    p_RIB_WIDTH       => p_RIB_WIDTH,
    p_ROUTING_TYPE    => p_ROUTING_TYPE,
    p_WF_TYPE         => p_WF_TYPE,
    p_FC_TYPE         => p_FC_TYPE,
    p_FIFO_TYPE       => p_XIN_FIFO_TYPE,
    p_FIFO_DEPTH      => p_SIN_FIFO_DEPTH,
    p_FIFO_LOG2_DEPTH => p_SIN_FIFO_LOG2_DEPTH,
    p_SWITCH_TYPE     => p_SWITCH_TYPE
  )
  port map(
    i_CLK     => i_CLK,
    i_RST     => i_RST,
    i_DATA    => i_SIN_DATA,
    i_VAL     => i_SIN_VAL,
    o_RET     => o_SIN_RET,
    o_X_REQL  => w_S_REQL_XIN,
    o_X_REQN  => w_S_REQN_XIN,
    o_X_REQE  => w_S_REQE_XIN,
    o_X_REQS  => w_SUNUSED,
    o_X_REQW  => w_S_REQW_XIN,
    o_X_ROK   => w_SROK,
    i_X_RD(0) => w_LRD,
    i_X_RD(1) => w_NRD,
    i_X_RD(2) => w_ERD,
    i_X_RD(3) => w_WRD,
    i_X_GNT(0)=> w_L_GNTS_XIN,
    i_X_GNT(1)=> w_N_GNTS_XIN,
    i_X_GNT(2)=> w_E_GNTS_XIN,
    i_X_GNT(3)=> w_W_GNTS_XIN,
    i_X_LIDLE => w_LIDLE,
    i_X_NIDLE => w_NIDLE,
    i_X_EIDLE => w_EIDLE,
    i_X_SIDLE => w_SIDLE,
    i_X_WIDLE => w_WIDLE,
    o_X_DOUT  => w_SDATA
  );

  --------
  u_WIN: xin
  --------
  generic map(
    p_XID             => p_XID,
    p_YID             => p_YID,
    p_USE_THIS        => p_USE_LOCAL,    
    p_MODULE_ID       => "W",
    p_DATA_WIDTH      => p_DATA_WIDTH,
    p_RIB_WIDTH       => p_RIB_WIDTH,
    p_ROUTING_TYPE    => p_ROUTING_TYPE,
    p_WF_TYPE         => p_WF_TYPE,
    p_FC_TYPE         => p_FC_TYPE,
    p_FIFO_TYPE       => p_XIN_FIFO_TYPE,
    p_FIFO_DEPTH      => p_WIN_FIFO_DEPTH,
    p_FIFO_LOG2_DEPTH => p_WIN_FIFO_LOG2_DEPTH,
    p_SWITCH_TYPE     => p_SWITCH_TYPE
  )
  port map(
    i_CLK     => i_CLK,
    i_RST     => i_RST,
    i_DATA    => i_WIN_DATA,
    i_VAL     => i_WIN_VAL,
    o_RET     => o_WIN_RET,
    o_X_REQL  => w_W_REQL_XIN,
    o_X_REQN  => w_W_REQN_XIN,
    o_X_REQE  => w_W_REQE_XIN,
    o_X_REQS  => w_W_REQS_XIN,
    o_X_REQW  => w_WUNUSED,
    o_X_ROK   => w_WROK,
    i_X_RD(0) => w_LRD,
    i_X_RD(1) => w_NRD,
    i_X_RD(2) => w_ERD,
    i_X_RD(3) => w_SRD,
    i_X_GNT(0)=> w_L_GNTW_XIN,
    i_X_GNT(1)=> w_N_GNTW_XIN,
    i_X_GNT(2)=> w_E_GNTW_XIN,
    i_X_GNT(3)=> w_S_GNTW_XIN,
    i_X_LIDLE => w_LIDLE,
    i_X_NIDLE => w_NIDLE,
    i_X_EIDLE => w_EIDLE,
    i_X_SIDLE => w_SIDLE,
    i_X_WIDLE => w_WIDLE,
    o_X_DOUT  => w_WDATA  
  );

  ----------
  u_LOUT: xout
  ----------
  generic map(
    p_USE_THIS        => p_USE_LOCAL,    
    p_DATA_WIDTH      => p_DATA_WIDTH,
    p_FC_TYPE         => p_FC_TYPE,  
    p_FC_CREDIT       => p_LOUT_FC_CREDIT,
    p_FIFO_TYPE       => p_XOUT_FIFO_TYPE,
    p_FIFO_DEPTH      => p_LOUT_FIFO_DEPTH,
    p_FIFO_LOG2_DEPTH => p_LOUT_FIFO_LOG2_DEPTH,
    p_ARBITER_TYPE    => p_ARBITER_TYPE,
    p_SWITCH_TYPE     => p_SWITCH_TYPE
  )
  port map(
    i_CLK      => i_CLK,  
    i_RST      => i_RST,    
    o_DATA     => o_LOUT_DATA,    
    o_VAL      => o_LOUT_VAL,
    i_RET      => i_LOUT_RET,   
    i_X_REQ(0) => w_N_REQL_XOUT,   
    i_X_REQ(1) => w_E_REQL_XOUT,     
    i_X_REQ(2) => w_S_REQL_XOUT,     
    i_X_REQ(3) => w_W_REQL_XOUT,     
    i_X_ROK(0) => w_NROK,  
    i_X_ROK(1) => w_EROK,    
    i_X_ROK(2) => w_SROK,    
    i_X_ROK(3) => w_WROK,    
    o_X_RD     => w_LRD,
    o_X_GNT(0) => w_L_GNTN_XOUT,    
    o_X_GNT(1) => w_L_GNTE_XOUT,    
    o_X_GNT(2) => w_L_GNTS_XOUT,    
    o_X_GNT(3) => w_L_GNTW_XOUT,
    o_X_IDLE   => w_LIDLE,
    i_X_DIN0   => w_NDATA,
    i_X_DIN1   => w_EDATA,
    i_X_DIN2   => w_SDATA,
    i_X_DIN3   => w_WDATA
  );    
    
  ----------
  u_NOUT: Xout
  ----------
  GENERIC MAP(
    p_USE_THIS        => p_USE_NORTH,    
    p_DATA_WIDTH      => p_DATA_WIDTH,
    p_FC_TYPE         => p_FC_TYPE,  
    p_FC_CREDIT       => p_NOUT_FC_CREDIT,
    p_FIFO_TYPE       => p_XOUT_FIFO_TYPE,
    p_FIFO_DEPTH      => p_NOUT_FIFO_DEPTH,
    p_FIFO_LOG2_DEPTH => p_NOUT_FIFO_LOG2_DEPTH,
    p_ARBITER_TYPE    => p_ARBITER_TYPE,
    p_SWITCH_TYPE     => p_SWITCH_TYPE
   )
  PORT MAP(
    i_CLK      => i_CLK,  
    i_RST      => i_RST,    
    o_DATA => o_NOUT_DATA,    
    o_VAL  => o_NOUT_VAL,
    i_RET  => i_NOUT_RET,   
    i_X_REQ(0) => w_L_REQN_XOUT,   
    i_X_REQ(1) => w_E_REQN_XOUT,     
    i_X_REQ(2) => w_S_REQN_XOUT,     
    i_X_REQ(3) => w_W_REQN_XOUT,     
    i_X_ROK(0) => w_LROK,  
    i_X_ROK(1) => w_EROK,    
    i_X_ROK(2) => w_SROK,    
    i_X_ROK(3) => w_WROK,    
    o_X_RD     => w_NRD,
    o_X_GNT(0) => w_N_GNTL_XOUT,    
    o_X_GNT(1) => w_N_GNTE_XOUT,    
    o_X_GNT(2) => w_N_GNTS_XOUT,    
    o_X_GNT(3) => w_N_GNTW_XOUT,
    o_X_IDLE   => w_NIDLE,
    i_X_DIN0   => w_LDATA,
    i_X_DIN1   => w_EDATA,
    i_X_DIN2   => w_SDATA,
    i_X_DIN3   => w_WDATA
  );    
     
  ----------
  u_EOUT: Xout
  ----------
  GENERIC MAP(
    p_USE_THIS        => p_USE_EAST,    
    p_DATA_WIDTH      => p_DATA_WIDTH,
    p_FC_TYPE         => p_FC_TYPE,  
    P_FC_CREDIT       => p_EOUT_FC_CREDIT,
    p_FIFO_TYPE       => p_XOUT_FIFO_TYPE,
    p_FIFO_DEPTH      => p_EOUT_FIFO_DEPTH,
    p_FIFO_LOG2_DEPTH => p_EOUT_FIFO_LOG2_DEPTH,
    p_ARBITER_TYPE    => p_ARBITER_TYPE,
    p_SWITCH_TYPE     => p_SWITCH_TYPE
  )
  PORT MAP(
    i_CLK      => i_CLK,  
    i_RST      => i_RST,    
    o_DATA => o_EOUT_DATA,    
    o_VAL  => o_EOUT_VAL,
    i_RET  => i_EOUT_RET,   
    i_X_REQ(0) => w_L_REQE_XOUT,   
    i_X_REQ(1) => w_N_REQE_XOUT,     
    i_X_REQ(2) => w_S_REQE_XOUT,     
    i_X_REQ(3) => w_W_REQE_XOUT,     
    i_X_ROK(0) => w_LROK,  
    i_X_ROK(1) => w_NROK,    
    i_X_ROK(2) => w_SROK,    
    i_X_ROK(3) => w_WROK,    
    o_X_RD     => w_ERD,  
    o_X_GNT(0) => w_E_GNTL_XOUT,    
    o_X_GNT(1) => w_E_GNTN_XOUT,    
    o_X_GNT(2) => w_E_GNTS_XOUT,    
    o_X_GNT(3) => w_E_GNTW_XOUT,
    o_X_IDLE   => w_EIDLE,   
    i_X_DIN0   => w_LDATA,
    i_X_DIN1   => w_NDATA,
    i_X_DIN2   => w_SDATA,
    i_X_DIN3   => w_WDATA
  );      
     
  ----------
  u_SOUT: Xout
  ----------
  GENERIC MAP(
    p_USE_THIS        => p_USE_SOUTH,    
    p_DATA_WIDTH      => p_DATA_WIDTH,
    p_FC_TYPE         => p_FC_TYPE,  
    p_FC_CREDIT       => p_SOUT_FC_CREDIT,
    p_FIFO_TYPE       => p_XOUT_FIFO_TYPE,
    p_FIFO_DEPTH      => p_SOUT_FIFO_DEPTH,
    p_FIFO_LOG2_DEPTH => p_SOUT_FIFO_LOG2_DEPTH,
    p_ARBITER_TYPE    => p_ARBITER_TYPE,
    p_SWITCH_TYPE     => p_SWITCH_TYPE 
  ) 
  PORT MAP(
    i_CLK      => i_CLK,  
    i_RST      => i_RST,    
    o_DATA => o_SOUT_DATA,    
    o_VAL  => o_SOUT_VAL,
    i_RET  => i_SOUT_RET,   
    i_X_REQ(0) => w_L_REQS_XOUT,   
    i_X_REQ(1) => w_N_REQS_XOUT,     
    i_X_REQ(2) => w_E_REQS_XOUT,     
    i_X_REQ(3) => w_W_REQS_XOUT,     
    i_X_ROK(0) => w_LROK,  
    i_X_ROK(1) => w_NROK,    
    i_X_ROK(2) => w_EROK,    
    i_X_ROK(3) => w_WROK,    
    o_X_RD     => w_SRD,
    o_X_GNT(0) => w_S_GNTL_XOUT,    
    o_X_GNT(1) => w_S_GNTN_XOUT,    
    o_X_GNT(2) => w_S_GNTE_XOUT,    
    o_X_GNT(3) => w_S_GNTW_XOUT,
    o_X_IDLE   => w_SIDLE,
    i_X_DIN0   => w_LDATA,
    i_X_DIN1   => w_NDATA,
    i_X_DIN2   => w_EDATA,
    i_X_DIN3   => w_WDATA  
  );    

  ----------
  u_WOUT: Xout
  ----------
  GENERIC MAP(
    p_USE_THIS        => p_USE_WEST,    
    p_DATA_WIDTH      => p_DATA_WIDTH,
    p_FC_TYPE         => p_FC_TYPE,  
    p_FC_CREDIT       => p_WOUT_FC_CREDIT,
    p_FIFO_TYPE       => p_XOUT_FIFO_TYPE,
    p_FIFO_DEPTH      => p_WOUT_FIFO_DEPTH,
    p_FIFO_LOG2_DEPTH => p_WOUT_FIFO_LOG2_DEPTH,
    p_ARBITER_TYPE    => p_ARBITER_TYPE,
    p_SWITCH_TYPE     => p_SWITCH_TYPE
  )
  PORT MAP(
    i_CLK      => i_CLK,  
    i_RST      => i_RST,    
    o_DATA => o_WOUT_DATA,    
    o_VAL  => o_WOUT_VAL,
    i_RET  => i_WOUT_RET,   
    i_X_REQ(0) => w_L_REQW_XOUT,   
    i_X_REQ(1) => w_N_REQW_XOUT,     
    i_X_REQ(2) => w_E_REQW_XOUT,     
    i_X_REQ(3) => w_S_REQW_XOUT,     
    i_X_ROK(0) => w_LROK,  
    i_X_ROK(1) => w_NROK,    
    i_X_ROK(2) => w_EROK,    
    i_X_ROK(3) => w_SROK,
    o_X_RD     => w_WRD,  
    o_X_GNT(0) => w_W_GNTL_XOUT,    
    o_X_GNT(1) => w_W_GNTN_XOUT,    
    o_X_GNT(2) => w_W_GNTE_XOUT,    
    o_X_GNT(3) => w_W_GNTS_XOUT,
    o_X_IDLE   => w_WIDLE,
    i_X_DIN0   => w_LDATA,
    i_X_DIN1   => w_NDATA,
    i_X_DIN2   => w_EDATA,
    i_X_DIN3   => w_SDATA 
  );  
    
    
  -----
  u_X0: X
  -----
  GENERIC MAP(
    p_ROUTING_TYPE => p_ROUTING_TYPE
  )
  PORT MAP(
    i_L_REQN  => w_L_REQN_XIN,
    i_L_REQE  => w_L_REQE_XIN,
    i_L_REQS  => w_L_REQS_XIN,
    i_L_REQW  => w_L_REQW_XIN,
    ------------------------
    o_L_REQN => w_L_REQN_XOUT,
    o_L_REQE => w_L_REQE_XOUT,
    o_L_REQS => w_L_REQS_XOUT,
    o_L_REQW => w_L_REQW_XOUT,
    ------------------------
    i_N_REQL  => w_N_REQL_XIN,
    i_N_REQE  => w_N_REQE_XIN,
    i_N_REQS  => w_N_REQS_XIN,
    i_N_REQW  => w_N_REQW_XIN,
    ------------------------
    o_N_REQL => w_N_REQL_XOUT,
    o_N_REQE => w_N_REQE_XOUT,
    o_N_REQS => w_N_REQS_XOUT,
    o_N_REQW => w_N_REQW_XOUT,
    ------------------------
    i_E_REQL  => w_E_REQL_XIN,
    i_E_REQN  => w_E_REQN_XIN,
    i_E_REQS  => w_E_REQS_XIN,
    i_E_REQW  => w_E_REQW_XIN,
    ------------------------
    o_E_REQL => w_E_REQL_XOUT,
    o_E_REQN => w_E_REQN_XOUT,
    o_E_REQS => w_E_REQS_XOUT,
    o_E_REQW => w_E_REQW_XOUT,
    ------------------------
    i_S_REQL  => w_S_REQL_XIN,
    i_S_REQN  => w_S_REQN_XIN,
    i_S_REQE  => w_S_REQE_XIN,
    i_S_REQW  => w_S_REQW_XIN,
    ------------------------
    o_S_REQL => w_S_REQL_XOUT,
    o_S_REQN => w_S_REQN_XOUT,
    o_S_REQE => w_S_REQE_XOUT,
    o_S_REQW => w_S_REQW_XOUT,
    ------------------------
    i_W_REQL  => w_W_REQL_XIN,
    i_W_REQN  => w_W_REQN_XIN,
    i_W_REQE  => w_W_REQE_XIN,
    i_W_REQS  => w_W_REQS_XIN,
    ------------------------
    o_W_REQL => w_W_REQL_XOUT,
    o_W_REQN => w_W_REQN_XOUT,
    o_W_REQE => w_W_REQE_XOUT,
    o_W_REQS => w_W_REQS_XOUT,
    ------------------------

    i_L_GNTN  => w_L_GNTN_XOUT,
    i_L_GNTE  => w_L_GNTE_XOUT,
    i_L_GNTS  => w_L_GNTS_XOUT,
    i_L_GNTW  => w_L_GNTW_XOUT,
    ------------------------
    o_L_GNTN => w_L_GNTN_XIN,
    o_L_GNTE => w_L_GNTE_XIN,
    o_L_GNTS => w_L_GNTS_XIN,
    o_L_GNTW => w_L_GNTW_XIN,
    ------------------------
    i_N_GNTL  => w_N_GNTL_XOUT,
    i_N_GNTE  => w_N_GNTE_XOUT,
    i_N_GNTS  => w_N_GNTS_XOUT,
    i_N_GNTW  => w_N_GNTW_XOUT,  
    ------------------------
    o_N_GNTL => w_N_GNTL_XIN,
    o_N_GNTE => w_N_GNTE_XIN,
    o_N_GNTS => w_N_GNTS_XIN,
    o_N_GNTW => w_N_GNTW_XIN,
    ------------------------
    i_E_GNTL  => w_E_GNTL_XOUT,
    i_E_GNTN  => w_E_GNTN_XOUT,
    i_E_GNTS  => w_E_GNTS_XOUT,
    i_E_GNTW  => w_E_GNTW_XOUT,
    ------------------------
    o_E_GNTL => w_E_GNTL_XIN,
    o_E_GNTN => w_E_GNTN_XIN,
    o_E_GNTS => w_E_GNTS_XIN,
    o_E_GNTW => w_E_GNTW_XIN,
    ------------------------
    i_S_GNTL  => w_S_GNTL_XOUT,
    i_S_GNTN  => w_S_GNTN_XOUT,
    i_S_GNTE  => w_S_GNTE_XOUT,
    i_S_GNTW  => w_S_GNTW_XOUT,
    ------------------------
    o_S_GNTL => w_S_GNTL_XIN,
    o_S_GNTN => w_S_GNTN_XIN,
    o_S_GNTE => w_S_GNTE_XIN,
    o_S_GNTW => w_S_GNTW_XIN,
    ------------------------
    i_W_GNTL  => w_W_GNTL_XOUT,
    i_W_GNTN  => w_W_GNTN_XOUT,
    i_W_GNTE  => w_W_GNTE_XOUT, 
    i_W_GNTS  => w_W_GNTS_XOUT,
    ------------------------
    o_W_GNTL => w_W_GNTL_XIN,
    o_W_GNTN => w_W_GNTN_XIN,
    o_W_GNTE => w_W_GNTE_XIN,
    o_W_GNTS => w_W_GNTS_XIN);

END arch_1;  
