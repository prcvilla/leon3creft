------------------------------------------------------------------------------
-- PROJECT: ParIS
-- ENTITY : ows (output_write_switch)
------------------------------------------------------------------------------
-- DESCRIPTION: Implements the switch used in the output channels to select
-- a write command received from the granted input channel.
--
-- IMPLEMENTATION NOTE: This entity is basically a 4-to-1 multiplexer with 
-- selectors based in one-hot encoding. Current version includes only a VHDL
-- description writen to be implemented in ALTERA's FPGAs. Therefore, it 
-- intends a mapping onto 4-input LUTs. A TRI-based implementation is to be 
-- done.
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
entity ows is
-------------
-------------
  generic (
    p_SWITCH_TYPE : string  := "LOGIC"   -- options: LOGIC (to implement: TRI)
  );
  port(
    i_SEL   : in  std_logic_vector(3 downto 0);  -- input selector
    i_WRIN  : in  std_logic_vector(3 downto 0);  -- wr cmd from input channels
    o_WROUT : out std_logic                      -- selected write command 
  );
end ows;
	
-----------------------------
-----------------------------
architecture arch_1 of ows is
-----------------------------
-----------------------------
begin 

----------
----------
OWS_LOGIC:
----------
----------
  if (p_SWITCH_TYPE = "LOGIC") generate

    -- OBS: Selects the write command from the granted input channel 
    -- If there is no sel, wr must be 0.

    ------------------
    process(i_SEL, i_WRIN)
    ------------------
    begin 
      if    (i_SEL(0)='1') then o_WROUT <= i_WRIN(0);
      elsif (i_SEL(1)='1') then o_WROUT <= i_WRIN(1);
      elsif (i_SEL(2)='1') then o_WROUT <= i_WRIN(2);
      elsif (i_SEL(3)='1') then o_WROUT <= i_WRIN(3);
      else                      o_WROUT <= '0';
      end if;
    end process;
  end generate;

--------
--------
OWS_TRI:
--------
--------
  if (p_SWITCH_TYPE = "TRI") generate
    ------------------
    process(i_SEL, i_WRIN)
    ------------------
    begin 

    -- OBS: A tri-state based switch is to be implemented for
    -- the synthesis in technologies offering such kind of
    -- buffer (Altera's FPGAs do not include internal TRI).
    -- It is important to ensure that rd is 0 when there is
    -- is no grant.

    end process;
  end generate;

end arch_1;