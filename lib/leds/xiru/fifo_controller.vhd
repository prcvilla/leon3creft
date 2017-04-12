------------------------------------------------------------------------------
-- PROJECT: ParIS
-- ENTITY : fifo_controller
------------------------------------------------------------------------------
-- DESCRIPTION: Control unit responsible to update the state of the FIFO at
-- each read or write operation. 
------------------------------------------------------------------------------
-- AUTHORS: Frederico G. M. do Espirito Santo 
--          Cesar Albenes Zeferino
-- CONTACT: zeferino@univali.br OR cesar.zeferino@gmail.com
------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
-------------------------
-------------------------
entity fifo_controller is
-------------------------
-------------------------
  generic (
    p_WIDTH : INTEGER := 8;   -- width of each position
    p_DEPTH : integer := 4    -- number of positions
  );
  port(
    -- system signals
    i_CLK   : in  std_logic;  -- clock
    i_RST   : in  std_logic;  -- reset

    -- fifo interface
    i_RD    : in  std_logic;  -- command to read  a data from the fifo
    i_WR    : in  std_logic;  -- command to write a data into the fifo

    -- control interface
    o_STATE : out integer range p_DEPTH downto 0      -- current fifo state    
  );
end fifo_controller;

-----------------------------------------
-----------------------------------------
architecture arch_1 of fifo_controller is
-----------------------------------------
-----------------------------------------
signal w_STATE_REG   : integer range p_DEPTH downto 0; -- current state
signal w_NEXT_STATE  : integer range p_DEPTH downto 0; -- next state
begin
  ------------- next state
  u_NEXT_STATE:process(w_STATE_REG,i_WR,i_RD)
  ------------------------
  -- this process determines the next state of the fifo taking into account
  -- the current state and the write and read commands, as follows:
  begin
    -- fifo empty
    if (w_STATE_REG = 0) then
      if (i_WR='1') then
        w_NEXT_STATE <= w_STATE_REG+1;
      else
        w_NEXT_STATE <= w_STATE_REG;
      end if;

    -- fifo full
    elsif (w_STATE_REG = p_DEPTH) then
      if (i_RD='1') then
        w_NEXT_STATE <= w_STATE_REG-1;
      else
        w_NEXT_STATE <= w_STATE_REG;
      end if;

    -- fifo neither empty, neither full
    else  
      if (i_WR='1') then
        if (i_RD='1') then
          w_NEXT_STATE <= w_STATE_REG;    --  rd &  wr
        else
          w_NEXT_STATE <= w_STATE_REG+1;  -- /rd &  wr
        end if;
      elsif (i_RD='1') then
        w_NEXT_STATE <= w_STATE_REG-1;    --  rd & /wr
      else
        w_NEXT_STATE <= w_STATE_REG;      -- /rd & /wr
      end if;
    end if;
  end process u_NEXT_STATE;

  -- current state
  u_STATE_REG:process(i_CLK,i_RST)
  ----------------
  begin
    if (i_RST='1') then
      w_STATE_REG  <= 0;
    elsif (i_CLK'event and i_CLK='1') then
      w_STATE_REG  <= w_NEXT_STATE;
    end if;
  end process u_STATE_REG;

  ---------
  -- output
  ---------
  o_STATE <= w_STATE_REG;
end arch_1;

