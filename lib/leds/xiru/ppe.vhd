------------------------------------------------------------------------------
-- PROJECT: ParIS
-- ENTITY : ppe (programmable priority encoder)
------------------------------------------------------------------------------
-- DESCRIPTION: Programmable priority encoder that receives a set of requests 
-- and priorities, and, based on the current priorities, schedules one of the 
-- pending requests by giving it a grant. It is composed by "N" arbitration  
-- cells interconnected in a ripple loop (wrap-around connection), implemented 
-- by signals which notify the next cell if some of the previous cells has 
-- already granted a request. This entity also include a register which holds
-- the last granting until the granted request return to 0. A new grant can
-- only be given after the arbiter returns to the idle state.
------------------------------------------------------------------------------
-- AUTHORS: Frederico G. M. do Espirito Santo 
--          Cesar Albenes Zeferino
-- CONTACT: zeferino@univali.br OR cesar.zeferino@gmail.com
------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
-------------
-------------
entity ppe is
-------------
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
end ppe;

-----------------------------
-----------------------------
architecture arch_1 of ppe is
-----------------------------
-----------------------------
signal w_IMED_IN   : std_logic_vector(p_N-1 downto 0); -- some of the previous cell granted a request
signal w_IMED_OUT  : std_logic_vector(p_N-1 downto 0); -- a grant was already given
signal w_I         : integer range p_N-1 downto 0;     -- for-generate index
signal w_GRANT     : std_logic_vector(p_N-1 downto 0); -- grant signals  
signal w_GRANT_REG : std_logic_vector(p_N-1 downto 0); -- registered grant signals
signal w_S_IDLE    : std_logic;                      -- signal for the idle output

begin
  --------------- Arbitration cells
  f0:for w_I in p_N-1 downto 0 generate
  ---------------------------------
    -- Status from the previous arbitration cell 
    w_IMED_IN(w_I)   <= w_IMED_OUT((w_I-1) mod p_N);
 
    -- Grant signal sent to the requesting block
    w_GRANT(w_I)     <= i_R(w_I) and (not (w_IMED_IN(w_I) and (not i_P(w_I)))); 

    -- Status to the next arbitration cell 
    w_IMED_OUT(w_I)  <= i_R(w_I) or (w_IMED_IN(w_I) and (not i_P(w_I))); 
  end generate;

  ------------------- Grant register
  f1: for w_I in p_N-1 downto 0 generate
  ----------------------------------
    ----------------
    process(i_CLK,I_RST)
    ----------------
    begin
      if (I_RST='1') then
        w_GRANT_REG(w_I) <= '0';
      elsif (i_CLK'event and i_CLK='1') then
        -- a register bit can be updated when the arbiter is idle
        if (w_S_IDLE='1') then
          w_GRANT_REG(w_I) <= w_GRANT(w_I);
        -- or when a request is low, specially whena granted request is reset
        elsif (i_R(w_I)='0') then
          w_GRANT_REG(w_I) <= '0';
        end if;
      end if;
    end process;
  end generate;

  ------------- idle
  process(w_GRANT_REG)
  ------------------
  variable v_TMP : std_logic;
  begin    
    -- it just implements a parameterizable nor
    v_TMP:='0';
    for i in (p_N-1) downto 0  loop
      v_TMP:= v_TMP or w_GRANT_REG(i);
    end loop;
    w_S_IDLE <= not v_TMP;
  end process;

  ----------
  -- outputs
  ----------
  o_IDLE   <= w_S_IDLE;
  o_G      <= w_GRANT_REG;

end arch_1;
