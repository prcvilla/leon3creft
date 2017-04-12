------------------------------------------------------------------------------
-- PROJECT: ParIS
-- ENTITY : ofc (output_flow_controller)
------------------------------------------------------------------------------
-- DESCRIPTION: Controller responsible to regulate the flow of flits at the 
-- output channels. It makes the adapting between the the internal flow 
-- control protocol (FIFO) and the link flow control protocol (eg.credit-based, 
-- handshake).
------------------------------------------------------------------------------
-- AUTHORS: Frederico G. M. do Espirito Santo 
--          Cesar Albenes Zeferino
--
-- CONTACT: zeferino@univali.br OR cesar.zeferino@gmail.com
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

-------------
-------------
entity ofc is
-------------
-------------
  generic (
    p_FC_TYPE   : string  := "CREDIT";    -- options: CREDIT or HANDSHAKE
    p_CREDIT    : integer := 4            -- maximum number of credits
  );
  port(
    -- System interface
    i_RST : in  std_logic;  -- reset        
    i_CLK : in  std_logic;  -- clock  

    -- Link interface
    o_VAL : out std_logic;  -- data validation
    i_RET : in  std_logic;  -- return (credit or acknowledgement)

    -- FIFO interface
    o_RD  : out std_logic;  -- read comand 
    i_ROK : in  std_logic   -- FIFO not empty (it is able to be read)
  );
end ofc;

-----------------------------
-----------------------------
architecture arch_1 of ofc is
-----------------------------
-----------------------------
-- Data type and signals for handshake flow-control
type   STATE is (S0,S1,S2); -- states of the handshake SFM
signal s_STATE_REG  : STATE;  -- current state of the handshake SFM
signal s_NEXT_STATE : STATE;  -- next state of the handshake SFM

-- Signal for credit-based flow control
signal s_COUNTER : integer range p_CREDIT downto 0; -- credit counter
signal s_MOVE    : std_logic; -- command to move a data from the input
                            -- to the output 

begin
  --------------
  --------------
  OFC_HANDSHAKE:
  --------------
  --------------
    if (p_FC_TYPE = "HANDSHAKE") generate
      --------------- next state
      u_NEXT_STATE : process(s_STATE_REG,i_RET,i_ROK)
      --------------------------
      begin
        case s_STATE_REG is

          -- If there is a data to be sent in the selected input channel (rok=1)
          -- and the receiver is not busy (ret=0), goes to the S1 state in order 
          -- to send the data.
          when S0 =>
            if (i_ROK='1') and (i_RET='0') then
              s_NEXT_STATE <= S1;
            else
              s_NEXT_STATE <= S0;
            end if;
          
          -- Sends the data and, when the data is received (ret=1), goes to the 
          -- state S2 in order to notify the sender that the data was delivered.
          when S1 =>
            if (i_RET='1') then
              s_NEXT_STATE <= S2;
            else
              s_NEXT_STATE <= S1;
            end if;

          -- It notifies the sender that the data was delivered and returns to 
          -- S0 or S1 (under the same conditions used in S0).
          when S2 =>
            if (i_ROK='1') and (i_RET='0') then
              s_NEXT_STATE <= S1;
            else
              s_NEXT_STATE <= S0;
            end if;
  
          when others =>
            s_NEXT_STATE <= S0;
        end case;
      end process u_NEXT_STATE;

      ---------- outputs 
      process(s_STATE_REG)
      ------------------
      begin
        case s_STATE_REG is

          -- Do nothing.
          when S0 => 
            o_VAL <= '0';
            o_RD  <= '0';

          -- Validates the outgoing data.
          when S1 =>
            o_VAL <= '1';
            o_RD  <= '0';

          -- Notifies the sender that the data was sent.
          when S2 =>
            o_VAL <= '0';
            o_RD  <= '1';

          when others =>
            o_VAL <= '0';
            o_RD  <= '0'; 
        end case; 
      end process;

  
      -- current state
      u_STATE_REG : process(i_CLK,i_RST)
      ----------------
      begin
        if (i_RST='1') then
          s_STATE_REG <= S0;
        elsif (i_CLK'EVENT and i_CLK='1') then
          s_STATE_REG  <= s_NEXT_STATE;
        end if;
      end process u_STATE_REG;
    end generate;


  -----------------
  -----------------
  OFC_CREDIT_BASED:
  -----------------
  -----------------
    if (p_FC_TYPE = "CREDIT") generate

      -- credit counter
      process(i_RST,i_CLK)
      ----------------
      begin
        -- Counter is intialized with a CREDIT (eg. 4)
        if (i_RST='1') then
          s_COUNTER <= p_CREDIT;

        elsif (i_CLK'event and i_CLK='1') then
          -- If there is no data to be sent (rok=0) and a credit is 
          -- received (ret=1), it increments the number of credits.
          -- On the other hand, if it is sending a data and no
          -- credit is being received, decrements the number of
          -- credits. Otherwise, the number of credits doesn't change.  

          if (i_ROK='0') then
            if ((i_RET='1') and (s_COUNTER/=(p_CREDIT))) then
               s_COUNTER <= s_COUNTER+1;
            end if;
          else
            if ((i_RET='0') and (s_COUNTER/=0)) then
              s_COUNTER <= s_COUNTER-1;          
            end if;
          end if;
        end if;
      end process;
  
      ---------------- outputs
      process(i_ROK,s_COUNTER,i_RET)
      ------------------------
      -- If there is a flit to be sent (rok=1) and the sender still has
      -- at least one credit, the data is sent (val=rd=1). If there is
      -- no credit, but the receiver is returning a new credit (ret=1),
      -- then, it can also send the data, because there is room in the
      -- receiver.
      begin
        if (i_ROK='1') then
          if (s_COUNTER=0) then
            if (i_RET='1') then
              s_MOVE <= '1';
            else
              s_MOVE <= '0';
            end if;
          else
            s_MOVE <= '1';
          end if;
        else
          s_MOVE <= '0';
        end if;
      end process;

      o_VAL <= s_MOVE;
      o_RD  <= s_MOVE;
    end generate;
end arch_1;


