------------------------------------------------------------------------------
-- PROJECT: ParIS
-- ENTITY : oc (output_controller)
------------------------------------------------------------------------------
-- DESCRIPTION: Controller responsible to schedule the use of the associated
-- output channel. It is based on an arbiter that receives requests and based
-- on an arbitration algorithm selects one request to be granted. A grant is
-- held at the high level while the request equals 1. 
------------------------------------------------------------------------------
-- AUTHORS: Frederico G. M. do Espirito Santo 
--          Cesar Albenes Zeferino
-- CONTACT: zeferino@univali.br OR cesar.zeferino@gmail.com
------------------------------------------------------------------------------
 
library ieee;
use ieee.std_logic_1164.all;

------------
------------
entity oc is
------------
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
    o_IDLE : out std_logic                        -- status
);
end oc;

----------------------------
----------------------------
architecture arch_1 of oc is
----------------------------
----------------------------

----------------
component arb_rr 
----------------
  generic (
    p_N    : integer := 4    -- number of requests
  );
  port (
    -- System signals
    i_CLK  : in  std_logic;  -- clock
    i_RST  : in  std_logic;  -- reset
      
    -- Arbitration signals
    i_R    : in  std_logic_vector(p_N-1 downto 0); -- request
    o_G    : out std_logic_vector(p_N-1 downto 0); -- grants
    o_IDLE : out std_logic                       -- status
  );
end component;

----------------
component arb_st 
----------------
  generic (
    p_N    : integer := 4    -- number of requests
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

----------------
component arb_random 
----------------
  generic (
    p_N       : integer := 4;       -- number of requests
    p_LOG2_N  : natural := 2;	   -- log2 of the number of requests
    p_SEED    : natural := 16#00#  -- seed for random generation 
  );
  port (
    -- System signals
    i_CLK  : in  std_logic;  -- clock
    i_RST  : in  std_logic;  -- reset
      
    -- Arbitration signals
    i_R    : in  std_logic_vector(p_N-1 downto 0); -- request
    o_G    : out std_logic_vector(p_N-1 downto 0); -- grants
    o_IDLE : out std_logic                       -- status
  );
end component;

signal w_GRANT : std_logic_vector(p_N-1 downto 0);  -- grant signals  


begin
  ----
  ----
  RR :
  ----
  ----
  if (p_ARBITER_TYPE="ROUND_ROBIN") generate
    ----------
    u_0: arb_rr
    ----------
      generic map (
        p_N     => p_N
      )
      port map(
        i_R    => i_R,
        i_CLK  => i_CLK,
        i_RST  => i_RST,
        o_G    => w_GRANT,
        o_IDLE => o_IDLE
      );
  END GENERATE;
  ----
  ----
  ST :
  ----
  ----
  if (p_ARBITER_TYPE="STATIC") generate
    ----------
    u_0: arb_st
    ----------
      generic map (
        p_N     => p_N
      )
      port map(
        i_R    => i_R,
        i_CLK  => i_CLK,
        i_RST  => i_RST,
        o_G    => w_GRANT,
        o_IDLE => o_IDLE
      );
  END GENERATE;
  ----
  ----
  RD :
  ----
  ----
  if (p_ARBITER_TYPE="RANDOM") generate
    ----------
    u_0: arb_random
    ----------
      generic map (
        p_N     => p_N
      )
      port map(
        i_R    => i_R,
        i_CLK  => i_CLK,
        i_RST  => i_RST,
        o_G    => w_GRANT,
        o_IDLE => o_IDLE
      );
  END GENERATE;
  o_G <= w_GRANT AND i_R;   
  
END arch_1;

