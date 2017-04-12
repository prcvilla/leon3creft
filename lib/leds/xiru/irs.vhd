------------------------------------------------------------------------------
-- PROJECT: ParIS
-- ENTITY : irs (input_read_switch)
------------------------------------------------------------------------------
-- DESCRIPTION: Implements the read used in the input channels to select
-- a read command received from the granting output channel.
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
entity irs is
-------------
-------------
  generic (
    p_SWITCH_TYPE : string  := "LOGIC"   -- options: LOGIC (to implement: TRI)
  );
  port(
    i_SEL   : in  std_logic_vector(3 downto 0);  -- input selector
    i_RDIN  : in  std_logic_vector(3 downto 0);  -- rd cmd from output channels
    o_RDOUT : out std_logic                      -- selected rd command 
  );
end irs;
	
-----------------------------
-----------------------------
architecture arch_1 of irs is
-----------------------------
-----------------------------
begin 

----------
----------
IRS_LOGIC:
----------
----------
  if (p_SWITCH_TYPE = "LOGIC") generate

    -- OBS: Selects the read command from the granting output channel 
    -- If there is no sel, rdout must be 0.

    ------------------
    process(i_SEL, i_RDIN)
    ------------------
    begin 
      if    (i_SEL(0)='1') then o_RDOUT <= i_RDIN(0);
      elsif (i_SEL(1)='1') then o_RDOUT <= i_RDIN(1);
      elsif (i_SEL(2)='1') then o_RDOUT <= i_RDIN(2);
      elsif (i_SEL(3)='1') then o_RDOUT <= i_RDIN(3);
      else                      o_RDOUT <= '0';
      end if;
    end process;
  end generate;

--------
--------
IRS_TRI:
--------
--------
  if (p_SWITCH_TYPE = "TRI") generate
    ------------------
    process(i_SEL, i_RDIN)
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