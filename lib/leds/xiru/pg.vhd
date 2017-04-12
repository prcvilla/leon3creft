------------------------------------------------------------------------------
-- PROJECT: ParIS
-- ENTITY : pg (priority_generator)
------------------------------------------------------------------------------
-- DESCRIPTION: That is a function which determines the next priority levels
-- by implementing a round-robin algorithm. At each clock cycle, defined by
-- a new grant to a pending request, it rotates left the current granting
-- status and ensures that the request being granted will have the lowest
-- priority level at the next arbitration cycle.
------------------------------------------------------------------------------
-- AUTHORS: Frederico G. M. do Espirito Santo 
--          Cesar Albenes Zeferino
-- CONTACT: zeferino@univali.br OR cesar.zeferino@gmail.com
------------------------------------------------------------------------------
 
library ieee;
use ieee.std_logic_1164.all;
------------
------------
entity pg is
------------
------------
  generic (
    p_N    : integer := 4    -- number of requests
  );
  port (
    -- system signals
    i_CLK  : in  std_logic;  -- clock
    i_RST  : in  std_logic;  -- reset
      
    -- arbitration signals
    i_G    : in  std_logic_vector(p_N-1 downto 0); -- grants
    o_P    : out std_logic_vector(p_N-1 downto 0)  -- priorities
);
end pg;

----------------------------
----------------------------
architecture arch_1 of pg is
----------------------------
----------------------------
signal w_UPDATE_REGISTER : std_logic;
signal w_GRANTING : std_logic_vector(p_N-1 downto 0); -- a request was granted
signal w_GDELAYED : std_logic_vector(p_N-1 downto 0); -- g delayed in 1 cycle 
signal w_NEXTP    : std_logic_vector(p_N-1 downto 0); -- next priorities values     
signal w_PREG     : std_logic_vector(p_N-1 downto 0); -- priorities register 
signal w_I        : integer range p_N-1 downto 0;     -- for-generate index

begin

  -----------------
  process (i_CLK,i_RST)
  -----------------
  -- it is just a flip-flop always enabled to hold the state of g for one 
  -- clock cycle.
  variable v_I: integer range p_N-1 downto 0;
  begin 
    if (i_RST='1') then
      w_GDELAYED <= (others => '0');
    elsif (i_CLK'event and i_CLK='1') then
      w_GDELAYED <= i_G;
    end if;
  end process;

  -- it determines if there exists any request that was granted in the last 
  -- cycle. this occurs when g(i)= 1 and gdelayed(i) = 0, for any i.
  ---------------------------------
  w_GRANTING <= i_G and (not w_GDELAYED);
  ---------------------------------

  -----------------
  process(w_GRANTING)
  -----------------
  variable v_TMP : std_logic;
  begin
    -- it just implements a parameterizable or which detect if any request
    -- was granted in the last cycle. in this case, it enables the priority 
    -- register to update its state.
    v_TMP:='0';
    for i in (p_N-1) downto 0  loop
      v_TMP:= v_TMP or w_GRANTING(i);
    end loop;
      w_UPDATE_REGISTER <= v_TMP;
  end process;


  -- it determines the next priority order by rotating 1x left the current 
  -- granting status. ex. if g="0001", then, nextp="0010". such rotation
  -- will ensure that the current granted request (e.g. r(0)) will have the 
  -- lowest priority level at the next arbitration cycle (e.g. p(1)>p(2)>
  -- p(3)>p(0)).

  f: for w_I in p_N-1 downto 0 generate
       w_NEXTP(w_I) <= i_G((w_I-1) mod p_N);
     end generate;

  --- priority reg
  process(i_CLK,i_RST)
  ----------------
  begin
    -- it is reset with bit 0 in 1 and the others in 0, and is updated at each
    -- arbitration cycle (after a request is grant) with the value determined
    -- for nextp. 
    if (i_RST='1') then
      w_PREG(0)            <= '1';
      w_PREG(p_N-1 downto 1) <= (others => '0');

    elsif (i_CLK'event and i_CLK='1') then
      if (w_UPDATE_REGISTER = '1') then
        w_PREG <= w_NEXTP;  
      end if;
    end if;
  end process;

  ----------
  -- outputs
  ----------
  o_P <= w_PREG;

end arch_1;

