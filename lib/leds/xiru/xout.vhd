------------------------------------------------------------------------------
-- project: paris
-- entity : xout (output_channel)
------------------------------------------------------------------------------
-- description: output channel module
------------------------------------------------------------------------------
-- authors: Frederico G. M. do Espirito Santo 
--          Cesar Albenes Zeferino
-- contact: zeferino@univali.br or cesar.zeferino@gmail.com
------------------------------------------------------------------------------
 
library ieee;
use ieee.std_logic_1164.all; library ieee;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;
use ieee.std_logic_1164.all;
--------------
--------------
entity xout is
--------------
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
    o_VAL   : out std_logic;                                 -- data validation
    i_RET   : in  std_logic;                                 -- return (cr/ack) 

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
end xout;

------------------------------
------------------------------
architecture arch_1 of xout is
------------------------------
------------------------------

------------
component oc
------------
  generic (
    p_ARBITER_TYPE : string  := "ROUND_ROBIN"; -- options: "ROUND_ROBIN"
    p_N            : integer := 4              -- number of requests
  );
  port (
    -- System signals
    i_CLK  : in  std_logic;  -- clock
    i_RST  : in  std_logic;  -- reset
      
    -- Arbitration signals
    i_R    : in  std_logic_vector(p_N-1 downto 0); -- request
    o_G    : out std_logic_vector(p_N-1 downto 0); -- grants
    o_IDLE : out std_logic                         -- status
);
end component;

-------------
component ods
-------------
  generic (
    p_SWITCH_TYPE : string  := "LOGIC"; -- options: LOGIC (to implement: TRI)
    p_WIDTH       : integer := 8        -- channels width
  );
  port(
    i_SEL  : in  std_logic_vector(3 downto 0);         -- input selector 
    i_DIN0 : in  std_logic_vector(p_WIDTH-1 downto 0); -- data from input channel 0
    i_DIN1 : in  std_logic_vector(p_WIDTH-1 downto 0); -- data from input channel 1
    i_DIN2 : in  std_logic_vector(p_WIDTH-1 downto 0); -- data from input channel 2
    i_DIN3 : in  std_logic_vector(p_WIDTH-1 downto 0); -- data from input channel 3

    -- selected data channel and framing bits
    o_DOUT : out std_logic_vector(p_WIDTH-1 downto 0)
  );
end component;

-------------
component ows
-------------
  generic (
    p_SWITCH_TYPE : string  := "LOGIC"   -- options: LOGIC (to implement: TRI)
  );
  port(
    i_SEL   : in  std_logic_vector(3 downto 0);  -- input selector
    i_WRIN  : in  std_logic_vector(3 downto 0);  -- wr cmd from input channels
    o_WROUT : out std_logic                      -- selected write command 
  );
end component;

-------------
component ofc
-------------
  generic (
    p_FC_TYPE   : string  := "CREDIT";    -- options: CREDIT or HANDSHAKE
    p_CREDIT    : integer := 4            -- maximum number of credits
  );
  port(
    -- System interface
    i_RST : in  std_logic;  -- reset        
    i_CLK : in  std_logic;  -- clock  

    -- Link interface
    o_VAL : out std_logic;  -- data validation
    i_RET : in  std_logic;  -- return (credit or acknowledgement)

    -- FIFO interface
    o_RD  : out std_logic;  -- read comand 
    i_ROK : in  std_logic   -- FIFO not empty (it is able to be read)
  );
end component;

--------------
component fifo
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
end component;

----------
-- signals
----------
signal w_GNT   : std_logic_vector(3 downto 0);
signal w_VAL   : std_logic;
signal w_RET   : std_logic;
signal w_RD    : std_logic;
signal w_ROK   : std_logic;
signal w_IDLE  : std_logic;
signal w_DIN   : std_logic_vector(p_DATA_WIDTH+1 downto 0);
signal w_DOUT  : std_logic_vector(p_DATA_WIDTH+1 downto 0);
signal w_WR    : std_logic;
signal w_WOK   : std_logic;

begin

  ---------------
  empty_channel :
  ---------------
    if (p_USE_THIS=0) generate
      o_VAL  <= '0';
      o_DATA <= (others => '0');
      o_X_RD     <= '0';
      o_X_GNT    <= (others => '0');
      o_X_IDLE   <= '0';
    end generate;

  --------------
  full_channel :
  --------------
    if (p_USE_THIS/=0) generate
      ------
      u_0: oc
      ------
        generic map (
          p_ARBITER_TYPE => p_ARBITER_TYPE,
          p_N            => 4             
        )
        port map(
          i_RST   => i_RST,
          i_CLK   => i_CLK,
          i_R     => i_X_REQ,
          o_G     => w_GNT,
          o_IDLE  => w_IDLE
        );
    
    -------
    u_1: ods
    -------
      generic map(
        p_SWITCH_TYPE => p_SWITCH_TYPE,
        p_WIDTH       => p_DATA_WIDTH+2
      )
      port map(
        i_SEL  => w_GNT,
        i_DIN0 => i_X_DIN0,
        i_DIN1 => i_X_DIN1,
        i_DIN2 => i_X_DIN2,
        i_DIN3 => i_X_DIN3,  
        o_DOUT => w_DIN
      );      
      
    -------
    u_2: ows
    -------
      generic map(
        p_SWITCH_TYPE => p_SWITCH_TYPE
      )
      port map(
        i_SEL   => w_GNT,
        i_WRIN  => i_X_ROK,
        o_WROUT => w_WR  
      );
    
    --------
    u_3: fifo
    --------
      generic map (
        p_FIFO_TYPE  => p_FIFO_TYPE,
        p_WIDTH      => p_DATA_WIDTH+2,
        p_DEPTH      => p_FIFO_DEPTH,
        p_LOG2_DEPTH => p_FIFO_LOG2_DEPTH  
      )
      port map (
        i_RST  => i_RST,
        i_CLK  => i_CLK,
        i_WR   => w_WR,
        i_RD   => w_RD,
        i_DIN  => w_DIN,
        o_DOUT => w_DOUT,
        o_WOK  => w_WOK,
        o_ROK  => w_ROK
      );
    
    -------
    u_4: ofc
    -------
      generic map (
        p_FC_TYPE => p_FC_TYPE,
        p_CREDIT  => p_FC_CREDIT
      )  
      port map(
        i_RST   => i_RST, 
        i_CLK   => i_CLK,
        o_VAL   => o_VAL,
        i_RET   => i_RET,
        o_RD    => w_RD,
        i_ROK   => w_ROK
      );

    ----------
    -- outputs
    ----------
    o_DATA     <= w_DOUT;
    o_X_RD     <= w_WOK;    
    o_X_GNT    <= w_GNT;
    o_X_IDLE   <= w_IDLE;

  end generate;

end arch_1;

