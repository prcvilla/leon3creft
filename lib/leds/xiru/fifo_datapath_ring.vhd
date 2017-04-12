------------------------------------------------------------------------------
-- project: paris
-- entity : fifo_datapath_ring
------------------------------------------------------------------------------
-- description: a datapath for the fifo based on a ring of register with depth
-- cells, each one with width bits. a new data is written into a position 
-- defined by a write pointer. in the same way, the cell to be accessed during 
-- a reading is defined by a read pointer. such pointers are updated at a
-- writing or a reading. 
------------------------------------------------------------------------------
-- authors: Frederico G. M. do Espirito Santo 
--          Cesar Albenes Zeferino
-- contact: zeferino@univali.br or cesar.zeferino@gmail.com
------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
----------------------------
----------------------------
entity fifo_datapath_ring is
----------------------------
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
end fifo_datapath_ring;

--------------------------------------------
--------------------------------------------
architecture arch_1 of fifo_datapath_ring is
--------------------------------------------
--------------------------------------------
-- type and signal to implement the fifo
type t_FIFO_TYPE is array (p_DEPTH-1 downto 0) of std_logic_vector(p_WIDTH-1 downto 0);
signal w_FIFO        : t_FIFO_TYPE;

-- pointers
signal w_RD_PTR_REG  : integer range p_DEPTH-1 downto 0; -- read  pointer
signal w_WR_PTR_REG  : integer range p_DEPTH-1 downto 0; -- write pointer
signal w_NEXT_RD_PTR : integer range p_DEPTH-1 downto 0; -- next read  pointer
signal w_NEXT_WR_PTR : integer range p_DEPTH-1 downto 0; -- next write pointer

begin
----------- next write pointer
u_NEXT_WR_PTR:process(i_STATE, i_WR, w_WR_PTR_REG)
------------------------------
  -- determines the next write pointer, by incrementing the current one 
  -- when the fifo is not full and there is a writing into the fifo.
  begin
    if ((i_STATE/=p_DEPTH) and (i_WR='1')) then
      if (w_WR_PTR_REG=(p_DEPTH-1)) then 
        w_NEXT_WR_PTR <= 0;
      else
        w_NEXT_WR_PTR <= w_WR_PTR_REG+1;
      end if;
    else
      w_NEXT_WR_PTR <= w_WR_PTR_REG;
    end if;
  end process u_NEXT_WR_PTR;
 
 
----------- next read pointer
u_NEXT_RD_PTR:process(i_STATE, i_RD, w_RD_PTR_REG)
------------------------------
  -- determines the next read pointer, by decrementing the current one 
  -- when the fifo is not empty and there is a reading from the fifo.
  begin
    if ((i_STATE/=0) and (i_RD='1')) then
      if (w_RD_PTR_REG=(p_DEPTH-1)) then 
        w_NEXT_RD_PTR <= 0;
      else
        w_NEXT_RD_PTR <= w_RD_PTR_REG+1;
      end if;
    else
      w_NEXT_RD_PTR <= w_RD_PTR_REG;
    end if;
  end process u_NEXT_RD_PTR;
  
------ pointers
u_REG:process(i_CLK,i_RST)
----------------
  -- implements the pointer registers
  begin
    if (i_RST='1') then
      w_WR_PTR_REG <= 0;
      w_RD_PTR_REG <= 0;
    elsif (i_CLK'event and i_CLK='1') then
      w_WR_PTR_REG <= w_NEXT_WR_PTR;
      w_RD_PTR_REG <= w_NEXT_RD_PTR;
    end if;
  end process u_REG;

---- wr2fifo
u_WR_FIFO:process(i_CLK)
------------
  -- implements the fifo memory
  variable index  : integer range p_DEPTH-1 downto 0;
  begin
     if (i_CLK'event and i_CLK='1') then
      if ((i_WR='1') and (i_STATE/=p_DEPTH)) then
        for index in 0 to (p_DEPTH-1) loop 
          if (index=w_WR_PTR_REG) then
            w_FIFO(index) <= i_DIN;
          else
            w_FIFO(index) <= w_FIFO(index);
          end if;
        end loop;
      end if;
    end if;
  end process u_WR_FIFO;

----- data
-- outputs
----------
  o_DOUT <= w_FIFO(w_RD_PTR_REG);

-------- status
process (i_STATE)
---------------
  begin
    if (i_STATE=0) then
      o_ROK <= '0';
      o_WOK <= '1';
    elsif (i_STATE=p_DEPTH) then
      o_ROK <= '1';    
      o_WOK <= '0';
    else
      o_ROK <= '1';
      o_WOK <= '1';
    end if;
  end process;
end arch_1;


