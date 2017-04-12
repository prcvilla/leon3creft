------------------------------------------------------------------------------
-- PROJECT: ParIS
-- ENTITY : arb_rr (round-robin arbiter)
------------------------------------------------------------------------------
-- DESCRIPTION: A round-robin arbiter based on a programmable priority encoder
-- and on a circular priority generator which updates the priorities order at 
-- each arbitration cycle. It ensuring that the request granted at the current 
-- arbitration cycle will have the lowest priority level at the next one.
------------------------------------------------------------------------------
-- AUTHORS: Frederico G. M. do Espirito Santo 
--          Cesar Albenes Zeferino
-- CONTACT: zeferino@univali.br OR cesar.zeferino@gmail.com
------------------------------------------------------------------------------
 
library ieee;
use ieee.std_logic_1164.all;

----------------
----------------
entity arb_rr is
----------------
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
end arb_rr;

--------------------------------
--------------------------------
architecture arch_1 of arb_rr is
--------------------------------
--------------------------------
-------------
component ppe
------------- 
  generic (
    p_N    : integer := 4    -- number of requests
  );
  port (
    -- System signals
    i_CLK  : in  std_logic;  -- clock
    i_RST  : in  std_logic;  -- reset
    
     -- Arbitration signals
    i_R    : in  std_logic_vector(p_N-1 downto 0); -- request
    i_P    : in  std_logic_vector(p_N-1 downto 0); -- priorities
    o_G    : out std_logic_vector(p_N-1 downto 0); -- grants
    o_IDLE : out std_logic                       -- status
);
end component;

------------
component pg
------------
  generic (
    p_N    : integer := 4    -- number of requests
  );
  port (
     -- System signals
    i_CLK  : in  std_logic;  -- clock
    i_RST  : in  std_logic;  -- reset
      
    -- Arbitration signals
    i_G    : in   std_logic_vector(p_N-1 downto 0); -- grants
    o_P    : out  std_logic_vector(p_N-1 downto 0) -- priorities
);
end component;

signal w_P      : std_logic_vector(p_N-1 downto 0);-- priorities     
signal w_GRANT  : std_logic_vector(p_N-1 downto 0);-- grant signals

begin
  -------
  u_0: ppe
  ------- 
    generic map (
      p_N     => p_N
    )
    port map (  
      i_CLK   => i_CLK,
      i_RST   => i_RST,
      i_R     => i_R,
      i_P     => w_P,
      o_G     => w_GRANT,
      o_IDLE  => o_IDLE
    );
  
  ------
  u_1: pg
  ------
    GENERIC MAP (
      p_N     => p_N
    )
    PORT MAP (  
      i_CLK   => i_CLK,
      i_RST   => i_RST,
      i_G     => w_GRANT,
      o_P     => w_P
    );

  ----------
  -- OUTPUTS
  ----------
  o_G    <= w_GRANT;

END arch_1;