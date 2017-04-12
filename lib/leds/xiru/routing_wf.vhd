------------------------------------------------------------------------------
-- project: paris
-- entity : routing_wf
------------------------------------------------------------------------------
-- description: implements the west-first routing algorithm, offering two
-- alternatives the implementation when the destination is at east: 
-- (a) selects an y port (n or s) before e port; or 
-- (b) selects e port before an y port (n or s)
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
entity routing_wf is
--------------------
--------------------
  generic(
    p_WF_TYPE   : string  := "Y_BEFORE_E";   -- options: E_BEFORE_Y, Y_BEFORE_E
    p_RIB_WIDTH : integer := 8; -- width of the rib field in the header
    p_XID       : integer := 3; -- x-coordinate  
    p_YID       : integer := 3  -- y-coordinate
  );
  port (
    -- coordinates of the destination node
    i_XDEST : in  std_logic_vector (p_RIB_WIDTH/2-1 downto 0); -- x-coordinate  
    i_YDEST : in  std_logic_vector (p_RIB_WIDTH/2-1 downto 0); -- y-coordinate

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
end routing_wf;

------------------------------------
------------------------------------
architecture arch_1 of routing_wf is
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

-- the following signal receives the result of the routing. that is, it 
-- always equals one of the previous constants.
signal   w_REQUEST : std_logic_vector(4 downto 0); 

begin

----------------
wf_e_before_y :
----------------
  if (p_WF_TYPE = "E_BEFORE_Y") generate
    ----------------------------------------------------------
    process(i_BOP,i_ROK,i_XDEST,i_YDEST,i_LIDLE,i_NIDLE,i_EIDLE,i_SIDLE,i_WIDLE) 
    ----------------------------------------------------------
    variable v_HEADER_PRESENT : boolean; -- notifies if there is a header
    variable v_X : integer;              -- distance to xdest	
    variable v_Y : integer;              -- distance to ydest
    begin
      -- verifies if there is a header to be routed
      v_HEADER_PRESENT := (i_BOP = '1') and (i_ROK = '1');
    
      if (v_HEADER_PRESENT) then
        -- determines the distance to the destination in x and y axis
        v_X := conv_integer('0' & i_XDEST) - p_XID;
        v_Y := conv_integer('0' & i_YDEST) - p_YID;

        ---------------------------------------------------------------------
        -- based on the wf routing algorithm, if the destination is at:
        -- # west , southwest or northwest, requests wout
        -- # southeast, requests eout or sout when the first of them is idle
        -- # northeast, requests eout or nout when the first of them is idle
        -- # east  (at the same row), requests eout
        -- # north (at the sam column), request nout
        -- # south (at the sam column), request sout
        -- # the same position, request lout
        ---------------------------------------------------------------------
        ---------------
        if (v_X < 0) then 
        ---------------
          w_REQUEST <= c_REQ_W;

        ------------------
        elsif (v_X > 0) then 
        ------------------
          if (v_Y < 0) then
            if (i_EIDLE ='1') then
              w_REQUEST <= c_REQ_E;
            else
              if (i_SIDLE = '1') then
                w_REQUEST <= c_REQ_S;
              else  
                w_REQUEST <= c_REQ_NONE;
              end if;
            end if;

          elsif (v_Y > 0) then
            if (i_EIDLE ='1') then
              w_REQUEST <= c_REQ_E;
            else
              if (i_NIDLE = '1') then
                w_REQUEST <= c_REQ_N;
              else  
                w_REQUEST <= c_REQ_NONE;
              end if;
            end if;

          else 
            w_REQUEST <= c_REQ_E;
          end if;

        ----------------------
        else --if (x = 0) then
        ----------------------
          if (v_Y < 0) then
            w_REQUEST <= c_REQ_S;
          elsif (v_Y > 0) then
            w_REQUEST <= c_REQ_N;
          else          
            w_REQUEST <= c_REQ_L;
          end if;          
        end if;

      else  -- header not present
        w_REQUEST <= c_REQ_NONE;
      end if;
    end process;
  end generate;


----------------
wf_y_before_e :
----------------
  if (p_WF_TYPE = "Y_BEFORE_E") generate
    ----------------------------------------------
    process(i_BOP,i_ROK,i_XDEST,i_YDEST,i_NIDLE,i_EIDLE,i_SIDLE) 
    ----------------------------------------------
    variable v_HEADER_PRESENT : boolean; -- notifies if there is a header
    variable v_X : integer;              -- distance to xdest	
    variable v_Y : integer;              -- distance to ydest
  
    begin
      -- verifies if there is a header to be routed
      v_HEADER_PRESENT := (i_BOP = '1') and (i_ROK = '1');
    
      if (v_HEADER_PRESENT) then
        -- determines the distance to the destination in x and y axis
        v_X:= conv_integer('0' & i_XDEST) - p_XID;
        v_Y:= conv_integer('0' & i_YDEST) - p_YID;

        ---------------------------------------------------------------------
        -- if the destination is at:
        -- # west, requests wout. 
        -- # southeast, requests sout or eout when the first of them is idle
        -- # northeast, requests nout or eout when the first of them is idle
        -- # east  (at the same row), requests eout
        -- # north (at the sam column), request nout
        -- # south (at the sam column), request sout
        ---------------------------------------------------------------------

        ---------------
        if (v_X < 0) then
        ---------------
          w_REQUEST<= c_REQ_W;

        ------------------
        elsif (v_X > 0) then 
        ------------------
          if (v_Y < 0) then
            if (i_SIDLE ='1') then
              w_REQUEST <= c_REQ_S;
            else
              if (i_EIDLE = '1') then
                w_REQUEST <= c_REQ_E;
              else  
                w_REQUEST <= c_REQ_NONE;
              end if;
            end if;
          elsif (v_Y > 0) then
            if (i_NIDLE ='1') then
              w_REQUEST <= c_REQ_N;
            else
              if (i_EIDLE = '1') then
                w_REQUEST <= c_REQ_E;
              else  
                w_REQUEST <= c_REQ_NONE;
              end if;
            end if;
          else
            w_REQUEST <= c_REQ_E;
          end if;

        ----------------------
        else --if (x = 0) then
        ----------------------
          if (v_Y < 0) then
            w_REQUEST <= c_REQ_S;
          elsif (v_Y > 0) then
            w_REQUEST <= c_REQ_N;
          else          
            w_REQUEST <= c_REQ_L;
          end if;          
        end if;
      else
        w_REQUEST <= c_REQ_NONE;
      end if;
    end process;
  end generate;


  ----------
  -- outputs
  ----------
  o_REQL <= w_REQUEST(4);
  o_REQN <= w_REQUEST(3);
  o_REQE <= w_REQUEST(2);
  o_REQS <= w_REQUEST(1);
  o_REQW <= w_REQUEST(0);

end arch_1;

