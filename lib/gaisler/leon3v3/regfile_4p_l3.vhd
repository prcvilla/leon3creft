-- RODRIGO_BEGIN --

library ieee;
    use ieee.std_logic_1164.all;
library grlib;
library techmap;
    use techmap.gencomp.all;
    use grlib.stdlib.all;
    
entity regfile_4p_l3 is
    generic (tech : integer := 0; abits : integer := 6; dbits : integer := 8;
    wrfst : integer := 0; numregs : integer := 64;
    testen : integer := 0);
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
        testin : in  std_logic_vector(TESTIN_WIDTH-1 downto 0)
    );
    
    
end;

architecture rtl of regfile_4p_l3 is
    
    constant rfinfer : boolean := (regfile_3p_infer(tech) = 1);
    signal wd1, wd2  : std_logic_vector((dbits -1 + 8) downto 0);
    signal e1, e2 : std_logic_vector((dbits-1) downto 0);
    signal we1, we2 : std_ulogic;
    
    signal vcc, gnd : std_ulogic;
    signal vgnd : std_logic_vector(dbits-1 downto 0);
    signal write2, renable2 : std_ulogic;
    
    
begin
    
    vcc <= '1'; gnd <= '0'; vgnd <= (others => '0');
    we1 <= we 
    ;
    we2 <= we
    ;
    
    s0 : if rfinfer generate
        inf : regfile_4p generic map (0, abits, dbits, wrfst, numregs, testen, memtest_vlen)
        port map ( wclk, waddr, wdata, we, rclk, raddr1, re1, rdata1, raddr2, re2, rdata2,
            raddr3, re3, rdata3, testin
        );
    end generate;
    
    s1 : if not rfinfer generate
        rhu : regfile_4p generic map (tech, abits, dbits, wrfst, numregs, testen, memtest_vlen)
        port map ( wclk, waddr, wdata, we, rclk, raddr1, re1, rdata1, raddr2, re2, rdata2,
            raddr3, re3, rdata3, testin
        );
    end generate;
       
end;

-- RODRIGO_END --