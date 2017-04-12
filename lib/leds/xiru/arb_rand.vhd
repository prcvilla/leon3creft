------------------------------------------------------------------------------
-- PROJECT: ParIS
-- ENTITY : arb_random (random arbiter)
------------------------------------------------------------------------------
-- DESCRIPTION: A randomic arbiter based on a programmable priority encoder
-- and on a lfsr-based priority generator which updates the priorities order at 
-- each arbitration cycle. It ensuring that the request granted at the current 
-- arbitration cycle will have the lowest priority level at the next one.
------------------------------------------------------------------------------
-- AUTHORS: Cesar Albenes Zeferino
-- CONTACT: zeferino@univali.br OR cesar.zeferino@gmail.com
------------------------------------------------------------------------------
 
library ieee;
use ieee.std_logic_1164.all;

--------------------
--------------------
entity arb_rand is
--------------------
--------------------
  generic (
    p_N    	  : integer := 4;    		 -- number of requests
	  p_LOG2_N  : natural := 2;				   -- log2 of the number of requests
    p_SEED    : natural := 16#00#   -- seed for random generation 
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
end arb_rand;

------------------------------------
------------------------------------
architecture arch_1 of arb_rand is
------------------------------------
------------------------------------
signal w_P      :  std_logic_vector(p_N-1 downto 0);-- priorities     
signal w_GRANT  :  std_logic_vector(p_N-1 downto 0);-- grant signals

-------------
component ppe
------------- 
  generic (
    p_N    : integer := 4    -- number of requests
  );
  port (
    -- System signals
    i_CLK  : in  std_logic;  -- clock
    I_RST  : in  std_logic;  -- reset
      
    -- Arbitration signals
    i_R    : in  std_logic_vector(p_N-1 downto 0); -- requests
    i_P    : in  std_logic_vector(p_N-1 downto 0); -- priorities
    o_G    : out std_logic_vector(p_N-1 downto 0); -- grants
    o_IDLE : out std_logic                       -- status
  );
end component;


--------------------
component pg_lfsr is
--------------------
  generic (
	  p_N		    : natural := 4;
	  p_LOG2_N : natural := 2;
    p_SEED   : natural := 16#01#    
  );
  port (
    -- System signals
    i_CLK  : in  		std_logic;  -- clock
    i_RST  : in  		std_logic;  -- reset
    b_P    : buffer std_logic_vector(p_N-1 downto 0)
  );
end component;


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
      o_IDLE  => o_IDLE,
      i_R     => i_R,
      i_P     => w_P,
      o_G     => w_GRANT
    );
  
  -----------
  u_1: pg_lfsr
  -----------
    generic map (
      p_N     	 => p_N,
	    p_LOG2_N 	=> p_LOG2_N,
		  p_SEED   	=> p_SEED
    )
    port map (  
      i_CLK   => i_CLK,
      i_RST   => i_RST,
      b_P     => w_P
    );

  ----------
  -- OUTPUTS
  ----------
  o_G    <= w_GRANT;

end arch_1;