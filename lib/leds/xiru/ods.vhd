------------------------------------------------------------------------------
-- PROJECT: ParIS
-- ENTITY : ods (output_data_switch)
------------------------------------------------------------------------------
-- DESCRIPTION: Implements the switch used in the output channels to select
-- a data received from the granted input channel.
--
-- IMPLEMENTATION NOTE: This entity is based on 4-to-1 multiplexers with 
-- selectors based in one-hot encoding. Current version includes only a VHDL
-- description writen to be implemented in ALTERA's FPGAs. Therefore, it 
-- intends a mapping into 4-input LUTs. A TRI-based implementation is to be 
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
entity ods is
-------------
-------------
  generic (
    p_SWITCH_TYPE : string  := "LOGIC"; -- options: LOGIC (to implement: TRI)
    p_WIDTH       : integer := 8        -- channels width
  );
  port(
    i_SEL  : in  std_logic_vector(3 downto 0);        -- input selector 
    i_DIN0 : in  std_logic_vector(p_WIDTH-1 downto 0); -- data from input channel 0
    i_DIN1 : in  std_logic_vector(p_WIDTH-1 downto 0); -- data from input channel 1
    i_DIN2 : in  std_logic_vector(p_WIDTH-1 downto 0); -- data from input channel 2
    i_DIN3 : in  std_logic_vector(p_WIDTH-1 downto 0); -- data from input channel 3

    -- selected data channel and framing bits
    o_DOUT : out std_logic_vector(p_WIDTH-1 downto 0)
  );
end ods;

-----------------------------
-----------------------------
architecture arch_1 of ods is
-----------------------------
-----------------------------
begin 

----------
----------
ODS_LOGIC:
----------
----------
  if (p_SWITCH_TYPE = "LOGIC") generate
    ------------------------------------
    process(i_SEL, i_DIN0, i_DIN1, i_DIN2, i_DIN3)
    ------------------------------------
    begin 
      if    (i_SEL(0)='1') then o_DOUT <= i_DIN0;
      elsif (i_SEL(1)='1') then o_DOUT <= i_DIN1;
      elsif (i_SEL(2)='1') then o_DOUT <= i_DIN2;
      elsif (i_SEL(3)='1') then o_DOUT <= i_DIN3;
      else                      o_DOUT <= (others=>'0');
      end if;
    end process;
  end generate;

--------
--------
ODS_TRI:
--------
--------
  if (p_SWITCH_TYPE = "TRI") generate
    ------------------------------------
    process(i_SEL, i_DIN0, i_DIN1, i_DIN2, i_DIN3)
    ------------------------------------
    begin 

    -- OBS: A tri-state based switch is to be implemented for
    -- the synthesis in technologies offering such kind of
    -- buffer (Altera's FPGAs do not include internal TRI).
    -- It is important to ensure that eop and bop are 0.

    end process;
  end generate;

end arch_1;
