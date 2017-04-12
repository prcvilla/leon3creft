------------------------------------------------------------------------------
-- project: paris
-- entity : routing_xy
------------------------------------------------------------------------------
-- description: implements the xy routing algorithm
------------------------------------------------------------------------------
-- authors: Frederico G. M. do Espirito Santo 
--          Cesar Albenes Zeferino
-- contact: zeferino@univali.br or cesar.zeferino@gmail.com
------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;

--------------------
--------------------
entity routing_xy is
--------------------
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
end routing_xy;

------------------------------------
------------------------------------
architecture arch_1 of routing_xy is
------------------------------------
------------------------------------
-- the following constants defines one-hot codes for the the possible 
-- requests. it is allowed to request only one output channel (lout,
-- nout, eout, sout or wout), or none. 
constant c_REQ_L   : std_logic_vector(4 downto 0) := "10000"; -- request lout 
constant c_REQ_N   : std_logic_vector(4 downto 0) := "01000"; -- request nout 
constant c_REQ_E   : std_logic_vector(4 downto 0) := "00100"; -- request eout 
constant c_REQ_S   : std_logic_vector(4 downto 0) := "00010"; -- request sout 
constant c_REQ_W   : std_logic_vector(4 downto 0) := "00001"; -- request wout 
constant c_REQ_NONE: std_logic_vector(4 downto 0) := "00000"; -- request nothing  

-- the following signal receives the result of the routing.
-- that is, it always equals one of the previous constants.
signal   w_REQUEST : std_logic_vector(4 downto 0);

begin
  -----------------------------------
  u_REQ: process(i_BOP,i_ROK,i_XDEST,i_YDEST) 
  -----------------------------------
  variable v_HEADER_PRESENT : boolean;
  variable v_X              : integer;
  variable v_Y              : integer;
  
  begin
    v_HEADER_PRESENT := (i_BOP = '1') and (i_ROK = '1');
    
    if (v_HEADER_PRESENT) then
      v_X := conv_integer('0' & i_XDEST) - p_XID;
      v_Y := conv_integer('0' & i_YDEST) - p_YID;

      ---------------------------------------------------------------------
      -- based on the xy routing algorithm, if the destination is at:
      -- # east , southeast or northwest, requests eout
      -- # west , southwest or northwest, requests wout
      -- # north, request nout
      -- # south, request sout
      -- # the same position, request lout
      ---------------------------------------------------------------------

      ----------------
      if (v_X /= 0) then
      ----------------
        if (v_X >0) then
          w_REQUEST <= c_REQ_E;
        else
          w_REQUEST <= c_REQ_W;
        end if;

      -------------------
      elsif (v_Y /= 0) then
      -------------------
        if (v_Y > 0) then
          w_REQUEST <= c_REQ_N;
        else
          w_REQUEST <= c_REQ_S;
        end if;

      ------------------
      else  -- x = y = 0
      ------------------
          w_REQUEST <= c_REQ_L;
      end if;

    else
      w_REQUEST <= c_REQ_NONE; 
    end if;
  end process u_REQ; 

  ----------
  -- outputs
  ----------
  o_REQL <= w_REQUEST(4);
  o_REQN <= w_REQUEST(3);
  o_REQE <= w_REQUEST(2);
  o_REQS <= w_REQUEST(1);
  o_REQW <= w_REQUEST(0);

end arch_1;

