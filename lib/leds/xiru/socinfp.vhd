--library ieee;
--use ieee.std_logic_1164.all;
--use ieee.std_logic_arith.all;
--
--------------------------
--------------------------
--package socin_package is
--------------------------
--------------------------
--  constant c_PAR_DATA_WIDTH : integer := 32;  -- width of the data channel
--  constant c_PAR_NUMB_COLS  : integer := 2;   -- number of columns (# routers in x direction)
--  constant c_PAR_NUMB_ROWS  : integer := 2;   -- number of rows (# routers in y directions)
--
--  -- 
--  type t_DATA_ROW0   is array (c_PAR_NUMB_ROWS-1 downto 0) of std_logic_vector(c_PAR_DATA_WIDTH+1 downto 0);
--  type t_DATA_ROW1   is array (c_PAR_NUMB_ROWS   downto 0) of std_logic_vector(c_PAR_DATA_WIDTH+1 downto 0);  
--  type t_DATA_LINK_X is array (c_PAR_NUMB_COLS   downto 0) of t_DATA_ROW0;
--  type t_DATA_LINK_Y is array (c_PAR_NUMB_COLS-1 downto 0) of t_DATA_ROW1;
--  type t_DATA_LINK_L is array (c_PAR_NUMB_COLS-1 downto 0) of t_DATA_ROW0;
--
--  type t_CMD_ROW0    is array (c_PAR_NUMB_ROWS-1 downto 0) of std_logic;
--  type t_CMD_ROW1    is array (c_PAR_NUMB_ROWS   downto 0) of std_logic;  
--  type t_CMD_LINK_X  is array (c_PAR_NUMB_COLS   downto 0) of t_CMD_ROW0;
--  type t_CMD_LINK_Y  is array (c_PAR_NUMB_COLS-1 downto 0) of t_CMD_ROW1;
--  type t_CMD_LINK_L  is array (c_PAR_NUMB_COLS-1 downto 0) of t_CMD_ROW0;
--
--  type t_INT_ROW0    is array (c_PAR_NUMB_ROWS-1 downto 0) of integer;
--  type t_INT_LINK_L  is array (c_PAR_NUMB_COLS-1 downto 0) of t_INT_ROW0;
--  
--  type t_SLV_DATA_ROW0    is array (c_PAR_NUMB_ROWS-1 downto 0) of std_logic_vector(c_PAR_DATA_WIDTH+1 downto 0);
--  type t_SLV_DATA_LINK_L  is array (c_PAR_NUMB_COLS-1 downto 0) of t_SLV_DATA_ROW0;  
--
--  type t_SLV_16BIT_ROW0   is array (c_PAR_NUMB_ROWS-1 downto 0) of std_logic_vector(15 downto 0);
--  type t_SLV_16BIT_LINK_L is array (c_PAR_NUMB_COLS-1 downto 0) of t_SLV_16BIT_ROW0;
--
--  
--  type t_TABLE is array (natural range <>) of integer;
--end socin_package;

library ieee;
library work;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;
use ieee.std_logic_1164.all;
use work.socin_package.all;

----------------------
--------------------
entity socinfp is
--------------------
--------------------
  generic(
    p_ROUTER_TYPE : string  := "PARIS";    -- options: RASOC or PARIS
    p_NUMB_ROWS   : integer := c_PAR_NUMB_ROWS;
    p_NUMB_COLS   : integer := c_PAR_NUMB_COLS;
    
    -- parameters for paris
    p_PARIS_DATA_WIDTH             : integer := c_PAR_DATA_WIDTH; -- options: >= route_width
    p_PARIS_RIB_WIDTH              : integer := 18;               -- options: >=4 (always even)
    p_PARIS_INPUT_FIFO_TYPE        : string  := "RING";          	-- options: NONE, SHIFT, RING or ALTERA
    p_PARIS_INPUT_FIFO_DEPTH       : integer := 4;             	  -- options: >=1
    p_PARIS_INPUT_FIFO_LOG2_DEPTH  : integer := 2;            	  -- options: = log2(FIFO_DEPTH) - used only in altera buffers      
    p_PARIS_OUTPUT_FIFO_TYPE       : string  := "NONE";        	  -- options: NONE, SHIFT, RING OR ALTERA      
    p_PARIS_OUTPUT_FIFO_DEPTH      : integer := 4;             	  -- options: >=1
    p_PARIS_OUTPUT_FIFO_LOG2_DEPTH : integer := 2;             	  -- options: = log2(FIFO_DEPTH) - used only in altera buffers      
    p_PARIS_FC_TYPE                : string  := "CREDIT";      	  -- options: handshake or credit
    p_PARIS_ROUTING_TYPE           : string  := "XY";          	  -- options: XY or WF
    p_PARIS_WF_TYPE                : string  := "Y_BEFORE_E";  	  -- options: E_BEFORE_Y, Y_BEFORE_E
    p_PARIS_ARBITER_TYPE           : string  := "ROUND_ROBIN"; 	  -- options: ROUND_ROBIN
    p_PARIS_SWITCH_TYPE            : string  := "LOGIC"        	  -- options: LOGIC (to be implemented: TRI)
  );
  port(
    i_CLK        : in  std_logic;
    i_RST        : in  std_logic;
    i_LIN_DATA   : in  t_DATA_LINK_L;
    i_LIN_VAL    : in  t_CMD_LINK_L;
    o_LIN_RET    : out t_CMD_LINK_L;  
    o_LOUT_DATA  : out t_DATA_LINK_L;
    o_LOUT_VAL   : out t_CMD_LINK_L;
    i_LOUT_RET   : in  t_CMD_LINK_L
--	 
--	  b_XIN_DATA   : buffer t_DATA_LINK_X;
--    b_XIN_VAL    : buffer t_CMD_LINK_X;
--	  b_XIN_RET    : buffer t_CMD_LINK_X;
--	  b_XOUT_DATA  : buffer t_DATA_LINK_X;
--	  b_XOUT_VAL   : buffer t_CMD_LINK_X;
--	  b_XOUT_RET   : buffer t_CMD_LINK_X;
--
--	  b_YIN_DATA   : buffer t_DATA_LINK_Y;
--	  b_YIN_VAL    : buffer t_CMD_LINK_Y;
--	  b_YIN_RET    : buffer t_CMD_LINK_Y;
--	  b_YOUT_DATA  : buffer t_DATA_LINK_Y;
--	  b_YOUT_VAL   : buffer t_CMD_LINK_Y;
--	  b_YOUT_RET   : buffer t_CMD_LINK_Y
  );  
end socinfp;

------------------------------------
------------------------------------
architecture socin_arch of socinfp is
------------------------------------
------------------------------------
---------------
component paris
---------------
  generic(
    -- address of a paris instance
    p_XID                  : integer := 2;        -- x-coordinate
    p_YID                  : integer := 2;        -- y-coordinate

    -- usage of each communication port
    p_USE_LOCAL            : integer := 1;        -- local port must be implemented
    p_USE_NORTH            : integer := 1;        -- north port must be implemented
    p_USE_EAST             : integer := 1;        -- east  port must be implemented
    p_USE_SOUTH            : integer := 1;        -- south port must be implemented
    p_USE_WEST             : integer := 1;        -- west  port must be implemented

    -- data channel and rib widths
    p_DATA_WIDTH           : integer := 8;        -- width of the data channel 
    p_RIB_WIDTH            : integer := 18;       -- width of the rib field in the header

    -- parameters for the input buffers
    p_XIN_FIFO_TYPE        : string  := "NONE";   -- options: NONE, RING, SHIFT or ALTERA
    p_LIN_FIFO_DEPTH       : integer := 4;        -- depth of the local input buffer
    p_NIN_FIFO_DEPTH       : integer := 4;        -- depth of the north input buffer
    p_EIN_FIFO_DEPTH       : integer := 4;        -- depth of the east  input buffer
    p_SIN_FIFO_DEPTH       : integer := 4;        -- depth of the south input buffer
    p_WIN_FIFO_DEPTH       : integer := 4;        -- depth of the west  input buffer
    p_LIN_FIFO_LOG2_DEPTH  : integer := 2;        -- used only for altera type
    p_NIN_FIFO_LOG2_DEPTH  : integer := 2;        -- used only for altera type
    p_EIN_FIFO_LOG2_DEPTH  : integer := 2;        -- used only for altera type
    p_SIN_FIFO_LOG2_DEPTH  : integer := 2;        -- used only for altera type
    p_WIN_FIFO_LOG2_DEPTH  : integer := 2;        -- used only for altera type

    -- parameters for the output buffers
    p_XOUT_FIFO_TYPE       : string  := "RING";   -- options: NONE, RING, SHIFT or ALTERA
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
    p_FC_TYPE        : string  := "CREDIT";      -- options: CREDIT or HANDSHAKE
    p_LOUT_FC_CREDIT : integer := 4;             -- initial number of credits for lout
    p_NOUT_FC_CREDIT : integer := 4;             -- initial number of credits for nout
    p_EOUT_FC_CREDIT : integer := 4;             -- initial number of credits for eout
    p_SOUT_FC_CREDIT : integer := 4;             -- initial number of credits for sout
    p_WOUT_FC_CREDIT : integer := 4;             -- initial number of credits for wout

    -- parameters for routing circuits, arbiters and switches
    p_ROUTING_TYPE   : string  := "XY";          -- options: XY or WF
    p_WF_TYPE        : string  := "Y_BEFORE_E";  -- options: E_BEFORE_Y, Y_BEFORE_E
    p_ARBITER_TYPE   : string  := "ROUND_ROBIN"; -- options: only ROUND_ROBIN
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
    i_WOUT_RET  : in   std_logic
  );
end component;


---- signals for unconnected ports
--signal w_GND_DATA  : std_logic_vector(c_PAR_DATA_WIDTH+1 downto 0);
--signal w_GND_CMD   : std_logic;
--signal w_INDEX     : integer range c_PAR_DATA_WIDTH+1 downto 0;
--signal I         : integer range p_NUMB_COLS downto 0;
--signal J         : integer range p_NUMB_ROWS downto 0;
--
--begin
--
--  w_GND_DATA <= (others =>'0');
--  w_GND_CMD  <= '0';
--
----for0:
----  for I in 0 to p_NUMB_COLS-1 generate
----    b_YIN_DATA(I)(0)         <= w_GND_DATA;
----    b_YIN_VAL(I)(0)          <= w_GND_CMD;
----    b_YOUT_RET(I)(0)         <= w_GND_CMD;
----    b_YOUT_DATA(I)(p_NUMB_ROWS)<= w_GND_DATA;
----    b_YOUT_VAL(I)(p_NUMB_ROWS) <= w_GND_CMD;
----    b_YIN_RET(I)(p_NUMB_ROWS)  <= w_GND_CMD;
----  end generate;
----
----for1:
----  for J in 0 to p_NUMB_ROWS-1 generate
----    b_XIN_DATA(0)(J)         <= w_GND_DATA;
----    b_XIN_VAL(0)(J)          <= w_GND_CMD;
----    b_XOUT_RET(0)(J)         <= w_GND_CMD;
----    b_XOUT_DATA(p_NUMB_COLS)(J)<= w_GND_DATA;
----    b_XOUT_VAL(p_NUMB_COLS)(J) <= w_GND_CMD;
----    b_XIN_RET(p_NUMB_COLS)(J)  <= w_GND_CMD;
----  end generate;
--
--
--  colomn:
--  for I in 0 to p_NUMB_COLS-1 generate
--    row:
--    for J in 0 to p_NUMB_ROWS-1 generate
--	 
--		 if0: IF (I=0) GENERATE
--        b_XIN_DATA(I)(J)         <= w_GND_DATA;
--        b_XIN_VAL(I)(J)          <= w_GND_CMD;
--        b_XOUT_RET(I)(J)         <= w_GND_CMD;
--      END GENERATE;
--
--      if1: IF (I=p_NUMB_COLS) GENERATE
--        b_XOUT_DATA(I)(J)<= w_GND_DATA;
--        b_XOUT_VAL(I)(J) <= w_GND_CMD;
--        b_XIN_RET(I)(J)  <= w_GND_CMD;
--      END GENERATE;
--
----      if2: IF (j=0) GENERATE
----        b_Yin_data(i)(j)         <= w_GND_DATA;
----        b_Yin_val(i)(j)          <= w_GND_CMD;
----        b_Yout_ret(i)(j)         <= w_GND_CMD;
----      END GENERATE;
--
--      if3: IF (J=p_NUMB_ROWS) GENERATE
--        b_YOUT_DATA(I)(J)<= w_GND_DATA;
--        b_YOUT_VAL(I)(J) <= w_GND_CMD;
--        b_YIN_RET(I)(J)  <= w_GND_CMD;
--      END GENERATE;
--
--    --------
--    u_r: paris
--    --------
--      generic map (
--        -- address of a paris instance
--        p_XID                  => I,
--        p_YID                  => J,
--
--        -- usage of each communication port
--        p_USE_LOCAL            => 1,
--        p_USE_NORTH            => ((J+1) mod p_NUMB_ROWS),
--        p_USE_EAST             => ((I+1) mod p_NUMB_COLS),
--        p_USE_SOUTH            => J,
--        p_USE_WEST             => I,
--
--        -- data channel and rib widths
--        p_DATA_WIDTH           => p_PARIS_DATA_WIDTH,
--        p_RIB_WIDTH            => p_PARIS_RIB_WIDTH,
--
--        -- parameters for the input buffers
--        p_XIN_FIFO_TYPE        => p_PARIS_INPUT_FIFO_TYPE,
--        p_LIN_FIFO_DEPTH       => p_PARIS_INPUT_FIFO_DEPTH,
--        p_NIN_FIFO_DEPTH       => p_PARIS_INPUT_FIFO_DEPTH,
--        p_EIN_FIFO_DEPTH       => p_PARIS_INPUT_FIFO_DEPTH,
--        p_SIN_FIFO_DEPTH       => p_PARIS_INPUT_FIFO_DEPTH,
--        p_WIN_FIFO_DEPTH       => p_PARIS_INPUT_FIFO_DEPTH,
--        p_LIN_FIFO_LOG2_DEPTH  => p_PARIS_INPUT_FIFO_LOG2_DEPTH,
--        p_NIN_FIFO_LOG2_DEPTH  => p_PARIS_INPUT_FIFO_LOG2_DEPTH,
--        p_EIN_FIFO_LOG2_DEPTH  => p_PARIS_INPUT_FIFO_LOG2_DEPTH,
--        p_SIN_FIFO_LOG2_DEPTH  => p_PARIS_INPUT_FIFO_LOG2_DEPTH,
--        p_WIN_FIFO_LOG2_DEPTH  => p_PARIS_INPUT_FIFO_LOG2_DEPTH,
--
--        -- parameters for the output buffers
--        p_XOUT_FIFO_TYPE       => p_PARIS_OUTPUT_FIFO_TYPE,
--        p_LOUT_FIFO_DEPTH      => p_PARIS_OUTPUT_FIFO_DEPTH,
--        p_NOUT_FIFO_DEPTH      => p_PARIS_OUTPUT_FIFO_DEPTH,
--        p_EOUT_FIFO_DEPTH      => p_PARIS_OUTPUT_FIFO_DEPTH,
--        p_SOUT_FIFO_DEPTH      => p_PARIS_OUTPUT_FIFO_DEPTH,
--        p_WOUT_FIFO_DEPTH      => p_PARIS_OUTPUT_FIFO_DEPTH,
--        p_LOUT_FIFO_LOG2_DEPTH => p_PARIS_OUTPUT_FIFO_LOG2_DEPTH,
--        p_NOUT_FIFO_LOG2_DEPTH => p_PARIS_OUTPUT_FIFO_LOG2_DEPTH,
--        p_EOUT_FIFO_LOG2_DEPTH => p_PARIS_OUTPUT_FIFO_LOG2_DEPTH,
--        p_SOUT_FIFO_LOG2_DEPTH => p_PARIS_OUTPUT_FIFO_LOG2_DEPTH,
--        p_WOUT_FIFO_LOG2_DEPTH => p_PARIS_OUTPUT_FIFO_LOG2_DEPTH,
--
--        -- parameters for the flow controllers 
--        p_FC_TYPE              => p_PARIS_FC_TYPE,
--        p_LOUT_FC_CREDIT       => p_PARIS_INPUT_FIFO_DEPTH,
--        p_NOUT_FC_CREDIT       => p_PARIS_INPUT_FIFO_DEPTH,
--        p_EOUT_FC_CREDIT       => p_PARIS_INPUT_FIFO_DEPTH,
--        p_SOUT_FC_CREDIT       => p_PARIS_INPUT_FIFO_DEPTH,
--        p_WOUT_FC_CREDIT       => p_PARIS_INPUT_FIFO_DEPTH,
--
--        -- parameters for routing circuits, arbiters and switches
--        p_ROUTING_TYPE         => p_PARIS_ROUTING_TYPE,
--        p_WF_TYPE              => p_PARIS_WF_TYPE,
--        p_ARBITER_TYPE         => p_PARIS_ARBITER_TYPE,
--        p_SWITCH_TYPE          => p_PARIS_SWITCH_TYPE
--      )
--      port map(
--        -- system interface
--        i_CLK       => i_CLK,
--        i_RST       => i_RST,
--
--        -- local interface 
--        i_LIN_DATA  => i_LIN_DATA(I)(J),
--        i_LIN_VAL   => i_LIN_VAL(I)(J),
--        o_LIN_RET   => o_LIN_RET(I)(J),
--        o_LOUT_DATA => o_LOUT_DATA(I)(J),
--        o_LOUT_VAL  => o_LOUT_VAL(I)(J),
--        i_LOUT_RET  => i_LOUT_RET(I)(J),
--        
--        -- north interface
--        i_NIN_DATA  => b_YIN_DATA(I)(J+1),
--        i_NIN_VAL   => b_YIN_VAL(I)(J+1),
--        o_NIN_RET   => b_YIN_RET(I)(J+1),
--        o_NOUT_DATA => b_YOUT_DATA(I)(J+1),
--        o_NOUT_VAL  => b_YOUT_VAL(I)(J+1),
--        i_NOUT_RET  => b_YOUT_RET(I)(J+1),
--
--        -- east interface
--        i_EIN_DATA  => b_XOUT_DATA(I+1)(J),
--        i_EIN_VAL   => b_XOUT_VAL(I+1)(J),
--        o_EIN_RET   => b_XOUT_RET(I+1)(J),
--        o_EOUT_DATA => b_XIN_DATA(I+1)(J),
--        o_EOUT_VAL  => b_XIN_VAL(I+1)(J),
--        i_EOUT_RET  => b_XIN_RET(I+1)(J),
--
--        -- south interface 
--        i_SIN_DATA  => b_YOUT_DATA(I)(J),
--        i_SIN_VAL   => b_YOUT_VAL(I)(J),
--        o_SIN_RET   => b_YOUT_RET(I)(J),
--        o_SOUT_DATA => b_YIN_DATA(I)(J),
--        o_SOUT_VAL  => b_YIN_VAL(I)(J),
--        i_SOUT_RET  => b_YIN_RET(I)(J),
--
--        -- west interface 
--        i_WIN_DATA  => b_XIN_DATA(I)(J),
--        i_WIN_VAL   => b_XIN_VAL(I)(J),
--        o_WIN_RET   => b_XIN_RET(I)(J),
--        o_WOUT_DATA => b_XOUT_DATA(I)(J),
--        o_WOUT_VAL  => b_XOUT_VAL(I)(J),
--        i_WOUT_RET  => b_XOUT_RET(I)(J)
--      );
--    end generate;
--  end generate;
--  
  
----------
-- signals
----------
signal w_XIN_DATA  : t_DATA_LINK_X;
signal w_XIN_VAL   : t_CMD_LINK_X;
signal w_XIN_RET   : t_CMD_LINK_X;
signal w_XOUT_DATA : t_DATA_LINK_X;
signal w_XOUT_VAL  : t_CMD_LINK_X;
signal w_XOUT_RET  : t_CMD_LINK_X;

signal w_YIN_DATA  : t_DATA_LINK_Y;
signal w_YIN_VAL   : t_CMD_LINK_Y;
signal w_YIN_RET   : t_CMD_LINK_Y;
signal w_YOUT_DATA : t_DATA_LINK_Y;
signal w_YOUT_VAL  : t_CMD_LINK_Y;
signal w_YOUT_RET  : T_CMD_LINK_Y;

-- signals for unconnected ports
signal w_GND_DATA  : std_logic_vector(c_PAR_DATA_WIDTH+1 downto 0);
signal w_GND_CMD   : std_logic;
signal w_INDEX     : integer range c_PAR_DATA_WIDTH+1 downto 0;
--signal w_I         : integer range p_NUMB_COLS downto 0;
--signal w_J         : integer range p_NUMB_ROWS downto 0;

begin

w_GND_DATA <= (others =>'0');
w_GND_CMD  <= '0';

for0:
  for I in 0 to p_NUMB_COLS-1 generate
    w_YIN_DATA(I)(0)         <= w_GND_DATA;
    w_YIN_VAL(I)(0)          <= w_GND_CMD;
    w_YOUT_RET(I)(0)         <= w_GND_CMD;
    w_YOUT_DATA(I)(p_NUMB_ROWS)<= w_GND_DATA;
    w_YOUT_VAL(I)(p_NUMB_ROWS) <= w_GND_CMD;
    w_YIN_RET(I)(p_NUMB_ROWS)  <= w_GND_CMD;
  end generate;

for1:
  for J in 0 to p_NUMB_ROWS-1 generate
    w_XIN_DATA(0)(J)         <= w_GND_DATA;
    w_XIN_VAL(0)(J)          <= w_GND_CMD;
    w_XOUT_RET(0)(J)         <= w_GND_CMD;
    w_XOUT_DATA(p_NUMB_COLS)(J)<= w_GND_DATA;
    w_XOUT_VAL(p_NUMB_COLS)(J) <= w_GND_CMD;
    w_XIN_RET(p_NUMB_COLS)(J)  <= w_GND_CMD;
  end generate;


  colomn:
  for I in 0 to p_NUMB_COLS-1 generate
    row:
    for J in 0 to p_NUMB_ROWS-1 generate
    --------
    r: paris
    --------
      generic map (
        -- address of a paris instance
        p_XID                  => I,
        p_YID                  => J,

        -- usage of each communication port
        p_USE_LOCAL            => 1,
        p_USE_NORTH            => ((J+1) mod p_NUMB_ROWS),
        p_USE_EAST             => ((I+1) mod p_NUMB_COLS),
        p_USE_SOUTH            => J,
        p_USE_WEST             => I,

        -- data channel and rib widths
        p_DATA_WIDTH           => p_PARIS_DATA_WIDTH,
        p_RIB_WIDTH            => p_PARIS_RIB_WIDTH,

        -- parameters for the input buffers
        p_XIN_FIFO_TYPE        => p_PARIS_INPUT_FIFO_TYPE,
        p_LIN_FIFO_DEPTH       => p_PARIS_INPUT_FIFO_DEPTH,
        p_NIN_FIFO_DEPTH       => p_PARIS_INPUT_FIFO_DEPTH,
        p_EIN_FIFO_DEPTH       => p_PARIS_INPUT_FIFO_DEPTH,
        p_SIN_FIFO_DEPTH       => p_PARIS_INPUT_FIFO_DEPTH,
        p_WIN_FIFO_DEPTH       => p_PARIS_INPUT_FIFO_DEPTH,
        p_LIN_FIFO_LOG2_DEPTH  => p_PARIS_INPUT_FIFO_LOG2_DEPTH,
        p_NIN_FIFO_LOG2_DEPTH  => p_PARIS_INPUT_FIFO_LOG2_DEPTH,
        p_EIN_FIFO_LOG2_DEPTH  => p_PARIS_INPUT_FIFO_LOG2_DEPTH,
        p_SIN_FIFO_LOG2_DEPTH  => p_PARIS_INPUT_FIFO_LOG2_DEPTH,
        p_WIN_FIFO_LOG2_DEPTH  => p_PARIS_INPUT_FIFO_LOG2_DEPTH,

        -- parameters for the output buffers
        p_XOUT_FIFO_TYPE       => p_PARIS_OUTPUT_FIFO_TYPE,
        p_LOUT_FIFO_DEPTH      => p_PARIS_OUTPUT_FIFO_DEPTH,
        p_NOUT_FIFO_DEPTH      => p_PARIS_OUTPUT_FIFO_DEPTH,
        p_EOUT_FIFO_DEPTH      => p_PARIS_OUTPUT_FIFO_DEPTH,
        p_SOUT_FIFO_DEPTH      => p_PARIS_OUTPUT_FIFO_DEPTH,
        p_WOUT_FIFO_DEPTH      => p_PARIS_OUTPUT_FIFO_DEPTH,
        p_LOUT_FIFO_LOG2_DEPTH => p_PARIS_OUTPUT_FIFO_LOG2_DEPTH,
        p_NOUT_FIFO_LOG2_DEPTH => p_PARIS_OUTPUT_FIFO_LOG2_DEPTH,
        p_EOUT_FIFO_LOG2_DEPTH => p_PARIS_OUTPUT_FIFO_LOG2_DEPTH,
        p_SOUT_FIFO_LOG2_DEPTH => p_PARIS_OUTPUT_FIFO_LOG2_DEPTH,
        p_WOUT_FIFO_LOG2_DEPTH => p_PARIS_OUTPUT_FIFO_LOG2_DEPTH,

        -- parameters for the flow controllers 
        p_FC_TYPE              => p_PARIS_FC_TYPE,
        p_LOUT_FC_CREDIT       => p_PARIS_INPUT_FIFO_DEPTH,
        p_NOUT_FC_CREDIT       => p_PARIS_INPUT_FIFO_DEPTH,
        p_EOUT_FC_CREDIT       => p_PARIS_INPUT_FIFO_DEPTH,
        p_SOUT_FC_CREDIT       => p_PARIS_INPUT_FIFO_DEPTH,
        p_WOUT_FC_CREDIT       => p_PARIS_INPUT_FIFO_DEPTH,

        -- parameters for routing circuits, arbiters and switches
        p_ROUTING_TYPE         => p_PARIS_ROUTING_TYPE,
        p_WF_TYPE              => p_PARIS_WF_TYPE,
        p_ARBITER_TYPE         => p_PARIS_ARBITER_TYPE,
        p_SWITCH_TYPE          => p_PARIS_SWITCH_TYPE
      )
      port map(
        -- system interface
        i_CLK       => i_CLK,
        i_RST       => i_RST,

        -- local interface 
        i_LIN_DATA  => i_LIN_DATA(I)(J),
        i_LIN_VAL   => i_LIN_VAL(I)(J),
        o_LIN_RET   => o_LIN_RET(I)(J),
        o_LOUT_DATA => o_LOUT_DATA(I)(J),
        o_LOUT_VAL  => o_LOUT_VAL(I)(J),
        i_LOUT_RET  => i_LOUT_RET(I)(J),
        
        -- north interface
        i_NIN_DATA  => w_YIN_DATA(I)(J+1),
        i_NIN_VAL   => w_YIN_VAL(I)(J+1),
        o_NIN_RET   => w_YIN_RET(I)(J+1),
        o_NOUT_DATA => w_YOUT_DATA(I)(J+1),
        o_NOUT_VAL  => w_YOUT_VAL(I)(J+1),
        i_NOUT_RET  => w_YOUT_RET(I)(J+1),

        -- east interface
        i_EIN_DATA  => w_XOUT_DATA(I+1)(J),
        i_EIN_VAL   => w_XOUT_VAL(I+1)(J),
        o_EIN_RET   => w_XOUT_RET(I+1)(J),
        o_EOUT_DATA => w_XIN_DATA(I+1)(J),
        o_EOUT_VAL  => w_XIN_VAL(I+1)(J),
        i_EOUT_RET  => w_XIN_RET(I+1)(J),

        -- south interface 
        i_SIN_DATA  => w_YOUT_DATA(I)(J),
        i_SIN_VAL   => w_YOUT_VAL(I)(J),
        o_SIN_RET   => w_YOUT_RET(I)(J),
        o_SOUT_DATA => w_YIN_DATA(I)(J),
        o_SOUT_VAL  => w_YIN_VAL(I)(J),
        i_SOUT_RET  => w_YIN_RET(I)(J),

        -- west interface 
        i_WIN_DATA  => w_XIN_DATA(I)(J),
        i_WIN_VAL   => w_XIN_VAL(I)(J),
        o_WIN_RET   => w_XIN_RET(I)(J),
        o_WOUT_DATA => w_XOUT_DATA(I)(J),
        o_WOUT_VAL  => w_XOUT_VAL(I)(J),
        i_WOUT_RET  => w_XOUT_RET(I)(J)
      );
    end generate;
  end generate;
end socin_arch;
