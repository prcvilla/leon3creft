------------------------------------------------------------------------------
-- project: paris
-- entity : fifo
------------------------------------------------------------------------------
-- description: a fifo entity offering for alternatives of implementation:
-- (a) none:   to be used when the goal is not implement the fifo, just wires
-- (b) ring:   a ring  fifo architecture based on logic and flip-flops
-- (c) shift:  a shift fifo architecture based on logic and flip-flops
-- (d) altera: a fifo architecture based on an altera's lpm which is mapped 
--             onto embedded sram bits (it saves logic and registers)
------------------------------------------------------------------------------
-- authors: Frederico G. M. do Espirito Santo 
--          Cesar Albenes Zeferino
-- contact: zeferino@univali.br or cesar.zeferino@gmail.com
------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
--------------
--------------
entity fifo is
--------------
--------------
  generic (
    p_FIFO_TYPE  : string  := "NONE";  -- options: NONE, SHIFT, RING and ALTERA
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
end fifo;

------------------------------
------------------------------
architecture arch_1 of fifo is
------------------------------
------------------------------
signal w_STATE : integer range p_DEPTH downto 0;   -- current fifo state 

-------------------------
component fifo_controller
-------------------------
  generic (
    p_WIDTH : integer := 8;   -- width of each position
    p_DEPTH : integer := 4    -- number of positions
  );
  port(
    -- system signals
    i_CLK   : in  std_logic;  -- clock
    i_RST   : in  std_logic;  -- reset

    -- fifo interface
    i_RD    : in  std_logic;  -- command to read  a data from the fifo
    i_WR    : in  std_logic;  -- command to write a data into the fifo

    -- control interface
    o_STATE : out integer range p_DEPTH downto 0      -- current fifo state    
  );
end component;

-----------------------------
component fifo_datapath_shift
-----------------------------
  generic (
    p_WIDTH : integer := 8;   -- width of each position
    p_DEPTH : integer := 4    -- number of positions
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
    o_DOUT  : out std_logic_vector(p_WIDTH-1 downto 0);  -- output data channel

    -- control-to-datapath interface
    i_STATE : in  integer range p_DEPTH downto 0         -- current fifo state    
  );
end component;

----------------------------
component fifo_datapath_ring
----------------------------
  generic (
    p_WIDTH : integer := 8;   -- width of each position
    p_DEPTH : integer := 4    -- number of positions
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
    o_DOUT  : out std_logic_vector(p_WIDTH-1 downto 0);  -- output data channel

    -- control to datapath interface
    i_STATE : in  integer range p_DEPTH downto 0);  -- current fifo state    
end component;

begin
---------
---------
no_fifo :
---------
---------
  if (p_FIFO_TYPE="NONE") generate
    o_ROK  <= i_WR;
    o_WOK  <= i_RD;
    o_DOUT <= i_DIN;
  end generate;

------------
------------
fifo_shift :
------------
------------
  if (p_FIFO_TYPE="SHIFT") generate
    --------------------
    u_0 : fifo_controller
    --------------------
      generic map (
        p_DEPTH => p_DEPTH
      )
      port map(
        i_RST   => i_RST,
        i_CLK   => i_CLK,
        i_WR    => i_WR,
        i_RD    => i_RD,
        o_STATE => w_STATE
      );
    
    ------------------------
    u_1 : fifo_datapath_shift
    ------------------------
      generic map (
        p_WIDTH => p_WIDTH,
        p_DEPTH => p_DEPTH
      )
      port map(
        i_RST   => i_RST,
        i_CLK   => i_CLK,
        i_WR    => i_WR,
        i_RD    => i_RD,
        i_DIN   => i_DIN,
        o_DOUT  => o_DOUT,
        o_WOK   => o_WOK,
        o_ROK   => o_ROK,
        i_STATE => w_STATE
      );
  end generate;

-----------
-----------
fifo_ring :
-----------
-----------
  if (p_FIFO_TYPE="RING") generate
    -------------------
    u_2: fifo_controller
    -------------------
      generic map (
        p_DEPTH => p_DEPTH
      )
      port map(
        i_RST   => i_RST,
        i_CLK   => i_CLK,
        i_WR    => i_WR,
        i_RD    => i_RD,
        o_STATE => w_STATE
      );
    
    -----------------------
    u_3 : fifo_datapath_ring
    -----------------------
      generic map (
        p_WIDTH => p_WIDTH,
        p_DEPTH => p_DEPTH
      )
      port map(
        i_RST   => i_RST,
        i_CLK   => i_CLK,
        i_WR    => i_WR,
        i_RD    => i_RD,
        i_DIN   => i_DIN,
        o_DOUT  => o_DOUT,
        o_WOK   => o_WOK,
        o_ROK   => o_ROK,
        i_STATE => w_STATE
      );
  end generate;
end arch_1;


