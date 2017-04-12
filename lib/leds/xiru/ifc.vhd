------------------------------------------------------------------------------
-- PROJECT: ParIS
-- ENTITY : ifc (input_flow_controller)
------------------------------------------------------------------------------
-- DESCRIPTION: Controller responsible to regulate the flow of flits at the 
-- input channels. It makes the adapting between the link flow control 
-- protocol (eg.credit-based, handshake) and the internal flow control protocol 
-- (FIFO).
------------------------------------------------------------------------------
-- AUTHORS: Frederico G. M. do Espirito Santo 
--          Cesar Albenes Zeferino
--
-- CONTACT: zeferino@univali.br OR cesar.zeferino@gmail.com
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-------------
-------------
entity ifc is
-------------
-------------
  generic (
    p_FC_TYPE   : string  := "HANDSHAKE"     -- options: CREDIT or HANDSHAKE
  );
  port(
    -- System interface
    i_CLK   : in  std_logic;  -- clock
    i_RST   : in  std_logic;  -- reset

    -- Link interface
    i_VAL   : in  std_logic;  -- data validation
    o_RET   : out std_logic;  -- return (credit or acknowledgement)

    -- FIFO interface
    o_WR    : out std_logic;  -- command to write a data into de FIFO
    i_WOK   : in  std_logic;  -- FIFO has room to be written (not full)
    i_RD    : in  std_logic;  -- command to read a data from the FIFO
    i_ROK   : in  std_logic   -- FIFO has a data to be read  (not empty)
  );
end ifc;

-----------------------------
-----------------------------
architecture arch_1 of ifc is
-----------------------------
-----------------------------
-- Data type and signals for handshake flow-control
  type   t_STATE is (S0,S1,S2); -- states of the handshake FSM
  signal s_STATE_REG  : t_STATE;  -- current state of the handshake FSM
  signal s_NEXT_STATE : t_STATE;  -- next state of the handshake FSM

begin
  --------------
  --------------
  IFC_HANDSHAKE:
  --------------
  --------------
    if (p_FC_TYPE = "HANDSHAKE") generate
      ----------------next state
      process(s_STATE_REG,i_VAL,i_WOK)
      --------------------------
      begin
        case s_STATE_REG is

          -- Waits a new incoming data (val=1) and, if the FIFO is not full 
          -- (wok=1), goes to the S1 state in order to receive the data.
          when S0 => 
            if (i_VAL='1') and (i_WOK='1') then
              s_NEXT_STATE <= S1;
            else
              s_NEXT_STATE <= S0;
            end if;
                    
          -- Writes the data into the FIFO and goes back to the S0 state 
          -- if val=0, or, if not, goes to S2 state.
          when S1 =>
            if (i_VAL='0') then
              s_NEXT_STATE <= S0;
            else
              s_NEXT_STATE <= S2;
            end if;

          -- Waits val goes to 0 to complete the data tranfer.
          when S2 =>
            if (i_VAL='0') then
              s_NEXT_STATE <= S0;
            else
              s_NEXT_STATE <= S2;
            end if; 
          
          when others =>
            s_NEXT_STATE <= S0;
        end case;
      end process ;


      ---------- outputs
      process(s_STATE_REG)
      ------------------
      begin
        case s_STATE_REG is
  
          -- Do nothing.
          when S0 =>
            o_RET <= '0';
            o_WR  <= '0';

          -- Acknowledges the data and writes it into the FIFO.
          when S1 =>
            o_RET <= '1'; 
            o_WR  <= '1'; 

          -- Remains the acknowledge high while valid is not low.
          when S2 =>
            o_RET <= '1';  
            o_WR  <= '0';

          when others  =>
            o_RET <= '0';
            o_WR  <= '0';
        end case;
      end process;


      -- current state
      process(i_CLK,i_RST)
      ----------------
      begin
        if (i_RST='1') then
          s_STATE_REG  <= S0;
        elsif (i_CLK'EVENT and i_CLK='1') then
          s_STATE_REG  <= s_NEXT_STATE;
        end if;
      end process;

    end generate;


  -----------------
  -----------------
  IFC_CREDIT_BASED:
  -----------------
  -----------------
    if (p_FC_TYPE = "CREDIT") generate
      o_WR  <= i_VAL; 

      ----------------
      process(i_RST,i_CLK)
      ----------------
      begin
        -- Returns a credit always that a data is read from the FIFO.
        if (i_RST='1') then
          o_RET <= '0';
        elsif (i_CLK'event and i_CLK='1') then
          o_RET <= i_RD and i_ROK;
        end if;
      end process ;
    end generate;


end arch_1;
