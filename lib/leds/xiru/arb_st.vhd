library ieee;
use ieee.std_logic_1164.all;

----------------
----------------
entity arb_st is
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
end arb_st;

--------------------------------
--------------------------------
architecture arch_1 of arb_st is
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
-------------

signal w_P      : std_logic_vector(p_N-1 downto 0):=(others =>'0');-- priorities     
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
	 
  w_p    <= (0 => '1');
  o_G    <= w_GRANT;

END arch_1;
