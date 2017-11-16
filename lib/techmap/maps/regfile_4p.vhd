-- RODRIGO_BEGIN --

library ieee;
library techmap;
use ieee.std_logic_1164.all;
use techmap.gencomp.all;
use techmap.allmem.all;

entity regfile_4p is
  generic (tech : integer := 0; abits : integer := 6; dbits : integer := 8;
           wrfst : integer := 0; numregs : integer := 64; testen : integer := 0;
           custombits : integer := 1);
  port (
    wclk   : in  std_ulogic;
    waddr  : in  std_logic_vector((abits -1) downto 0);
    wdata  : in  std_logic_vector((dbits -1) downto 0);
    we     : in  std_ulogic;
    rclk   : in  std_ulogic;
    raddr1 : in  std_logic_vector((abits -1) downto 0);
    re1    : in  std_ulogic;
    rdata1 : out std_logic_vector((dbits -1) downto 0);
    raddr2 : in  std_logic_vector((abits -1) downto 0);
    re2    : in  std_ulogic;
    rdata2 : out std_logic_vector((dbits -1) downto 0);
    raddr3 : in  std_logic_vector((abits -1) downto 0);
    re3    : in  std_ulogic;
    rdata3 : out std_logic_vector((dbits -1) downto 0);
    testin   : in std_logic_vector(TESTIN_WIDTH-1 downto 0) := testin_none
    );
end;

architecture rtl of regfile_4p is
  constant rfinfer : boolean := (regfile_3p_infer(tech) = 1) or
	(((is_unisim(tech) = 1)) and (abits <= 5));
  signal xwe,xre1,xre2 : std_ulogic;

  signal custominx,customoutx: std_logic_vector(syncram_customif_maxwidth downto 0);
  
begin
  xwe <= we and not testin(TESTIN_WIDTH-2) when testen/=0 else we;
  xre1 <= re1 and not testin(TESTIN_WIDTH-2) when testen/=0 else re1;
  xre2 <= re2 and not testin(TESTIN_WIDTH-2) when testen/=0 else re2;
  
      s0 : generic_regfile_4p generic map (tech, abits, dbits, wrfst, numregs)
        port map ( wclk, waddr, wdata, we, rclk, raddr1, re1, rdata1, raddr2, re2, rdata2, raddr3, re3, rdata3);
    

  
    custominx <= (others => '0');
  nocust: if syncram_has_customif(tech)=0 or rfinfer generate
    customoutx <= (others => '0');
  end generate;
end;

-- RODRIGO_END --

