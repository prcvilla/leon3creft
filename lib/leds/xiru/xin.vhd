------------------------------------------------------------------------------
-- project: paris
-- entity : xin (input_channel)
------------------------------------------------------------------------------
-- description: input channel module
------------------------------------------------------------------------------
-- authors: Frederico G. M. do Espirito Santo 
--          Cesar Albenes Zeferino
-- contact: zeferino@univali.br or cesar.zeferino@gmail.com
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
-------------
-------------
entity xin is
-------------
-------------
  generic(
    p_XID             : integer:= 2;           -- x-coordinate  
    p_YID             : integer:= 2;           -- y-coordinate
    p_USE_THIS        : integer:= 1;           -- defines if the module must be used
    p_MODULE_ID       : string := "l";         -- identifier of the port in the router
    p_DATA_WIDTH      : integer:= 8;           -- width of data channel 
    p_RIB_WIDTH       : integer:= 18;           -- width of the rib field in the header
    p_ROUTING_TYPE    : string := "XY";        -- type of routing algorithm
    p_WF_TYPE         : string := "Y_BEFORE_E";-- options: E_BEFORE_Y, Y_BEFORE_E
    p_FC_TYPE         : string := "CREDIT";    -- options: CREDIT OR HANDSHAKE
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
    i_DATA : in std_logic_vector(p_DATA_WIDTH+1 downto 0); -- input channel
    i_VAL  : in  std_logic;                       -- data validation
    o_RET  : out std_logic;                       -- return (cr/ack)

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
end xin;

-----------------------------
-----------------------------
architecture arch_1 of xin is
-----------------------------
-----------------------------

-------------
component ifc
-------------
  generic (
    p_FC_TYPE   : string  := "HANDSHAKE"     -- options: CREDIT or HANDSHAKE
  );
  port(
    -- System interface
    i_CLK   : in  std_logic;  -- clock
    i_RST   : in  std_logic;  -- reset

    -- Link interface
    i_VAL   : in  std_logic;  -- data validation
    o_RET   : out std_logic;  -- return (credit or acknowledgement)

    -- FIFO interface
    o_WR    : out std_logic;  -- command to write a data into de FIFO
    i_WOK   : in  std_logic;  -- FIFO has room to be written (not full)
    i_RD    : in  std_logic;  -- command to read a data from the FIFO
    i_ROK   : in  std_logic   -- FIFO has a data to be read  (not empty)
  );
end component;

--------------
component fifo
--------------
  generic (
    p_FIFO_TYPE  : string  := "NONE"; -- options: NONE, SHIFT, RING and ALTERA
    p_WIDTH      : integer := 8;       -- width of each position
    p_DEPTH      : integer := 4;       -- number of positions
    p_LOG2_DEPTH : integer := 2        -- log2 of the number of positions 
  );
  port(
    -- system signals
    i_CLK   : in  std_logic;  -- clock
    i_RST   : in  std_logic;  -- reset

    -- fifo interface
    o_ROK   : out std_logic;  -- fifo has a data to be read  (not empty)
    o_WOK   : out std_logic;  -- fifo has room to be written (not full)
    i_RD    : in  std_logic;  -- command to read a data from the fifo
    i_WR    : in  std_logic;  -- command to write a data into de fifo
    i_DIN   : in  std_logic_vector(p_WIDTH-1 downto 0);  -- input  data channel
    o_DOUT  : out std_logic_vector(p_WIDTH-1 downto 0)   -- output data channel
  );
end component;

------------
component ic
------------
generic (
    p_XID          : integer := 3;    -- x-coordinate  
    p_YID          : integer := 3;    -- y-coordinate
    p_MODULE_ID    : string  := "L";  -- identifier of the port in the router
    p_RIB_WIDTH    : integer := 18;   -- width of the rib field in the header
    p_ROUTING_TYPE : string  := "WF"; -- type of routing algorithm
    p_WF_TYPE      : string  := "Y_BEFORE_E" -- options: E_BEFORE_Y, Y_BEFORE_E
  );
  port(
    -- system signals
    i_CLK   : in  std_logic;  -- clock
    i_RST   : in  std_logic;  -- reset

    -- coordinates of the destination node
    i_XDEST : in  std_logic_vector (p_RIB_WIDTH-9  DOWNTO p_RIB_WIDTH-12); -- x-coordinate  
    i_YDEST : in  std_logic_vector (p_RIB_WIDTH-13  DOWNTO p_RIB_WIDTH-16); -- y-coordinate

    -- fifo interface
    i_ROK   : in  std_logic;  -- fifo has a data to be read (not empty)
    i_RD    : in  std_logic;  -- command to read a data from the fifo

    -- framing bits
    i_BOP   : in  std_logic;  -- packet framing bit: begin of packet
    i_EOP   : in  std_logic;  -- packet framing bit: end   of packet

    -- status of the output channels
    i_LIDLE : in  std_logic;  -- lout is idle
    i_NIDLE : in  std_logic;  -- nout is idle
    i_EIDLE : in  std_logic;  -- eout is idle
    i_SIDLE : in  std_logic;  -- sout is idle
    i_WIDLE : in  std_logic;  -- wout is idle

    -- requests
    o_REQL  : out std_logic;  -- request to lout
    o_REQN  : out std_logic;  -- request to nout
    o_REQE  : out std_logic;  -- request to eout
    o_REQS  : out std_logic;  -- request to sout
    o_REQW  : out std_logic   -- request to wout
  );
end component;


-------------
component irs
-------------
  generic (
    p_SWITCH_TYPE : string  := "LOGIC"   -- options: LOGIC (to implement: TRI)
  );
  port(
    i_SEL   : in  std_logic_vector(3 downto 0);  -- input selector
    i_RDIN  : in  std_logic_vector(3 downto 0);  -- rd cmd from output channels
    o_RDOUT : out std_logic                      -- selected rd command 
  );
end component;


----------
-- signals
----------
SIGNAL w_BOP  : STD_LOGIC;  
SIGNAL w_EOP  : STD_LOGIC; 
signal w_WR   : std_logic;  
signal w_WOK  : std_logic;  
signal w_RD   : std_logic;  
signal w_ROK  : std_logic;  
signal w_SEL  : std_logic_vector(3 downto 0); 
signal w_DOUT : std_logic_vector(p_DATA_WIDTH+1 downto 0);

begin
--????---
w_BOP <= (not w_DOUT(p_DATA_WIDTH+1)) and w_DOUT(p_DATA_WIDTH); 
w_EOP <= w_DOUT(p_DATA_WIDTH+1) and not (w_DOUT(p_DATA_WIDTH)); 
--????---
---------------
empty_channel :
---------------
  if (p_USE_THIS=0) generate
    o_RET <= '0';
    o_X_DOUT <= (others => '0');
    o_X_REQL <= '0';
    o_X_REQN <= '0';
    o_X_REQE <= '0';
    o_X_REQS <= '0';
    o_X_REQW <= '0';
    o_X_ROK  <= '0';
  end generate;

--------------
full_channel :
--------------
  if (p_USE_THIS/=0) generate
    --------
    u_0 : ifc
    --------
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
        i_RD  => w_RD,
        i_ROK => w_ROK
      );

    ---------
    u_1 : fifo
    ---------
      generic map (
        p_FIFO_TYPE  => p_FIFO_TYPE,
        p_WIDTH      => p_DATA_WIDTH+2,
        p_DEPTH      => p_FIFO_DEPTH,
        p_LOG2_DEPTH => p_FIFO_LOG2_DEPTH 
      )
      port map (
        i_CLK  => i_CLK,
        i_RST  => i_RST,
        o_WOK  => w_WOK,
        o_ROK  => w_ROK,
        i_RD   => w_RD,
        i_WR   => w_WR,
        i_DIN  => i_DATA,
        o_DOUT => w_DOUT
      );

    -------
    u_2 : ic
    -------
      generic map(
        p_XID          => p_XID,
        p_YID          => p_YID,
        p_MODULE_ID    => p_MODULE_ID,
        p_RIB_WIDTH    => p_RIB_WIDTH,
        p_ROUTING_TYPE => p_ROUTING_TYPE,
        p_WF_TYPE      => p_WF_TYPE
      )
      port map(
        i_CLK   => i_CLK,
        i_RST   => i_RST,
        i_XDEST => w_DOUT(p_RIB_WIDTH-9  DOWNTO p_RIB_WIDTH-12),
        i_YDEST => w_DOUT(p_RIB_WIDTH-13 DOWNTO p_RIB_WIDTH-16),
        i_ROK   => w_ROK,
        i_RD    => w_RD,
        i_BOP   => w_BOP,
        i_EOP   => w_EOP,
        i_LIDLE => i_X_LIDLE,
        i_NIDLE => i_X_NIDLE,
        i_EIDLE => i_X_EIDLE,
        i_SIDLE => i_X_SIDLE,
        i_WIDLE => i_X_WIDLE,
        o_REQL  => o_X_REQL,
        o_REQN  => o_X_REQN,
        o_REQE  => o_X_REQE,
        o_REQS  => o_X_REQS,
        o_REQW  => o_X_REQW
      );

    --------
    u_3 : irs
    --------
      generic map (
        p_SWITCH_TYPE => p_SWITCH_TYPE 
      )
      port map(
        i_SEL   => i_X_GNT,
        i_RDIN  => i_X_RD,
        o_RDOUT => w_RD  
     );

    ----------
    -- outputs
    ----------
    o_X_ROK  <= w_ROK;
    o_X_DOUT <= w_DOUT;
  end generate;

end arch_1;


