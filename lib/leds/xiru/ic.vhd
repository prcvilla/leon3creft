------------------------------------------------------------------------------
-- project: paris
-- entity : ic (input_controller)
------------------------------------------------------------------------------
-- description: controller responsible to detect the header of an incoming
-- packet, schedule an output channel to be requested (routing), and hold the
-- request until the packet trailer is delivered.
------------------------------------------------------------------------------
-- authors: Frederico G. M. do Espirito Santo 
--          Cesar Albenes Zeferino
-- contact: zeferino@univali.br or cesar.zeferino@gmail.com
------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

------------
------------
entity ic is
------------
------------
  generic (
    p_XID          : integer := 3;           -- x-coordinate  
    p_YID          : integer := 3;           -- y-coordinate
    p_MODULE_ID    : string  := "L";         -- identifier of the port in the router
    p_RIB_WIDTH    : integer := 18;          -- width of the rib field in the header
    p_ROUTING_TYPE : string  := "WF";        -- type of routing algorithm
    p_WF_TYPE      : string  := "Y_BEFORE_E" -- options: E_BEFORE_Y, Y_BEFORE_E
  );
  port(
    -- system signals
    i_CLK   : in  std_logic;  -- clock
    i_RST   : in  std_logic;  -- reset

    -- coordinates of the destination node
    i_XDEST : in  std_logic_vector (p_RIB_WIDTH-9  DOWNTO p_RIB_WIDTH-12); -- x-coordinate  
    i_YDEST : in  std_logic_vector (p_RIB_WIDTH-13 DOWNTO p_RIB_WIDTH-16); -- y-coordinate

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
end ic;

----------------------------
----------------------------
architecture arch_1 of ic is
----------------------------
----------------------------
-- signals to connect the routing function to the request register.
signal w_REQL : std_logic;  -- request to lout
signal w_REQN : std_logic;  -- request to nout
signal w_REQE : std_logic;  -- request to eout
signal w_REQS : std_logic;  -- request to sout
signal w_REQW : std_logic;  -- request to wout

--------------------
component routing_wf
--------------------
  generic(
    p_WF_TYPE   : string  := "Y_BEFORE_E";   -- options: E_BEFORE_Y, Y_BEFORE_E
    p_RIB_WIDTH : integer := 8; -- width of the rib field in the header
    p_XID       : integer := 3; -- x-coordinate  
    p_YID       : integer := 3  -- y-coordinate
  );
  port (
    -- coordinates of the destination node
    i_XDEST : in  std_logic_vector (p_RIB_WIDTH-9  DOWNTO p_RIB_WIDTH-12); -- x-coordinate  
    i_YDEST : in  std_logic_vector (p_RIB_WIDTH-13  DOWNTO p_RIB_WIDTH-16); -- y-coordinate

    -- framing bits
    i_BOP   : in  std_logic;  -- packet framing bit: begin of packet

    -- fifo interface
    i_ROK   : in  std_logic;  -- fifo has a data to be read  (not empty)

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

--------------------
component routing_xy
--------------------
 generic(
    p_RIB_WIDTH : integer := 8; -- width of the rib field in the header
    p_XID       : integer := 3; -- x-coordinate  
    p_YID       : integer := 3  -- y-coordinate
  );
  port (
    -- coordinates of the destination node
    i_XDEST : in  std_logic_vector (p_RIB_WIDTH-9  DOWNTO p_RIB_WIDTH-12); -- x-coordinate  
    i_YDEST : in  std_logic_vector (p_RIB_WIDTH-13  DOWNTO p_RIB_WIDTH-16); -- y-coordinate

    -- framing bits
    i_BOP   : in  std_logic;  -- packet framing bit: begin of packet

    -- fifo interface
    i_ROK   : in  std_logic;  -- fifo has a data to be read  (not empty)

    -- requests
    o_REQL  : out std_logic;  -- request to lout
    o_REQN  : out std_logic;  -- request to nout
    o_REQE  : out std_logic;  -- request to eout
    o_REQS  : out std_logic;  -- request to sout
    o_REQW  : out std_logic   -- request to wout
  );
end component;

-----------------
component req_reg
-----------------
  generic (
    p_MODULE_ID    : string := "L";  -- identifier of the port in the router
    p_ROUTING_TYPE : string := "WF"  -- type of routing algorithm
  );
  port(
    -- system signals
    i_CLK      : in  std_logic;  -- clock
    i_RST      : in  std_logic;  -- reset

    -- fifo interface
    i_ROK      : in  std_logic;  -- fifo has a data to be read (not empty)
    i_RD       : in  std_logic;  -- command to read a data from the fifo

    -- framing bits
    i_BOP      : in  std_logic;  -- packet framing bit: begin of packet
    i_EOP      : in  std_logic;  -- packet framing bit: end   of packet

    -- requests
    i_REQL  : in  std_logic;  -- request to lout (input)
    i_REQN  : in  std_logic;  -- request to nout (input)
    i_REQE  : in  std_logic;  -- request to eout (input)
    i_REQS  : in  std_logic;  -- request to sout (input)
    i_REQW  : in  std_logic;  -- request to wout (input)
    o_REQL  : out std_logic;  -- request to lout (output)
    o_REQN  : out std_logic;  -- request to nout (output)
    o_REQE  : out std_logic;  -- request to eout (output)
    o_REQS  : out std_logic;  -- request to sout (output)
    o_REQW  : out std_logic   -- request to wout (output)
  );
end component;


begin
  -------
  ic_xy :
  -------
  if (p_ROUTING_TYPE = "XY") generate
    ---------------
    u_0 : routing_xy
    ---------------
      generic map (
        p_RIB_WIDTH => p_RIB_WIDTH,
        p_XID       => p_XID,
        p_YID       => p_YID
      )  
      port map(
        i_XDEST => i_XDEST,
        i_YDEST => i_YDEST,
        i_BOP   => i_BOP,
        i_ROK   => i_ROK,
        o_REQL  => w_REQL,
        o_REQN  => w_REQN,
        o_REQE  => w_REQE,
        o_REQS  => w_REQS,
        o_REQW  => w_REQW
      );
    end generate;

  -------
  ic_wf :
  -------
  if (p_ROUTING_TYPE = "WF") generate
    ---------------
    u_1 : routing_wf
    ---------------
     generic map (
       p_WF_TYPE   => p_WF_TYPE,
       p_RIB_WIDTH => p_RIB_WIDTH,
       p_XID       => p_XID,
       p_YID       => p_YID
     )  
     port map(
       i_XDEST => i_XDEST,
       i_YDEST => i_YDEST,
       i_BOP   => i_BOP,
       i_ROK   => i_ROK,
       i_LIDLE => i_LIDLE,
       i_NIDLE => i_NIDLE,
       i_EIDLE => i_EIDLE,
       i_SIDLE => i_SIDLE,
       i_WIDLE => i_WIDLE,
       o_REQL  => w_REQL,
       o_REQN  => w_REQN,
       o_REQE  => w_REQE,
       o_REQS  => w_REQS,
       o_REQW  => w_REQW
     );
  end generate;

  ------------
  u_2 : req_reg
  ------------
    generic map(
      p_MODULE_ID    => p_MODULE_ID,
      p_ROUTING_TYPE => p_ROUTING_TYPE
    )
    port map(
      i_CLK      => i_CLK,
      i_RST      => i_RST,
      i_ROK      => i_ROK,
      i_RD       => i_RD,
      i_BOP      => i_BOP,
      i_EOP      => i_EOP,
      i_REQL  => w_REQL,
      i_REQN  => w_REQN,
      i_REQE  => w_REQE,
      i_REQS  => w_REQS,
      i_REQW  => w_REQW,
      o_REQL => o_REQL,
      o_REQN => o_REQN,
      o_REQE => o_REQE,
      o_REQS => o_REQS,
      o_REQW => o_REQW
    );
end arch_1;


