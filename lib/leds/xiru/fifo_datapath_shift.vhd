------------------------------------------------------------------------------
-- project: paris
-- entity : fifo_datapath_shift
------------------------------------------------------------------------------
-- description: a datapath for the fifo based on a shift register with depth
-- cells, each one with width bits. a new data is always written into cell 0
-- and the old ones are shifted to right. the cell to be accessed during a 
-- reading is defined by a pointer, derived from the state provided by the
-- control block.
------------------------------------------------------------------------------
-- authors: Frederico G. M. do Espirito Santo 
--          Cesar Albenes Zeferino
-- contact: zeferino@univali.br or cesar.zeferino@gmail.com
------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
-----------------------------
-----------------------------
entity fifo_datapath_shift is
-----------------------------
-----------------------------
  generic (
    p_WIDTH   : integer := 8;   -- width of each position
    p_DEPTH   : integer := 4    -- number of positions
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

    -- control-to-datapath interface
    i_STATE : in  integer range p_DEPTH downto 0         -- current fifo state    
  );
end fifo_datapath_shift;

---------------------------------------------
---------------------------------------------
architecture arch_1 of fifo_datapath_shift is
---------------------------------------------
---------------------------------------------
-- type and signal to implement the fifo
type fifo_type is array (p_WIDTH-1 downto 0) of std_logic_vector(p_WIDTH-1 downto 0);
signal w_FIFO   : fifo_type;

signal w_RD_PTR : integer range p_DEPTH-1 downto 0; -- read pointer
signal w_WOK  : std_logic;                          -- a temporary signal for wok


begin
---------------
-- read pointer
---------------
  -- the read pointer is derived from the fifo state (defined by the control).  
  with i_STATE select
    w_RD_PTR  <=  0 when 0,
                  i_STATE-1 when others;

-------------- wok
u_WOK:process(i_STATE, i_RD)
------------------
  -- wok equals 1 when fifo is not full
  begin
    if (i_STATE/=p_DEPTH) then
      w_WOK <= '1';
    else
      w_WOK <= '0';      
    end if;
  end process u_WOK;

------ write
u_WR_FIFO:process(i_CLK)
------------
  -- if the fifo is not full, a new data is written into fifo(0), and the old
  -- ones are shifted to right.
  variable index  : integer range p_DEPTH-1 downto 0;
  begin
    if (i_CLK'event and i_CLK='1') then
      if (i_WR='1' and w_WOK='1') then
        w_FIFO(0) <= i_DIN;
        for index in 1 to (p_DEPTH-1) loop 
          w_FIFO(index) <= w_FIFO(index-1);
        end loop;
      end if;
    end if;
  end process u_WR_FIFO;

  ----------
  -- outputs
  ----------
  o_WOK <= w_WOK;
  
  with i_STATE select
    o_ROK  <= '0' when 0,
            '1' when others;

  o_DOUT <= w_FIFO(w_RD_PTR); 

end arch_1;

