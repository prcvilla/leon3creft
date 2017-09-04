library ieee; 
use ieee.std_logic_1164.all; 
library gaisler; 
use gaisler.trlib.all; 
 
entity trctrl is 
    port ( 
        rst         : in  std_ulogic; 
        clk         : in  std_ulogic; 
        en          : in  std_ulogic; 
        hwrite      : in  std_ulogic; 
        hwdata      : in  std_logic_vector(31 downto 0); 
        recovdone   : in  std_ulogic; 
        tro         : out tr_out_type 
    ); 
end; 
 
architecture behaviour of trctrl is 
     
    type STATES is (IDLE, FSTRUN, PREPARING, SNDRUN); 
    type reg_type is record 
        state   : STATES;  
        hwdata  : std_logic_vector(31 downto 0);
    end record; 
     
    constant RRES : reg_type := ( 
        state   => IDLE, 
        hwdata  => (others => '0')
    ); 
 
    signal r, rin : reg_type; 
 
begin 
     
    comb : process(rst, en, r, hwrite, hwdata, recovdone) 
        variable v      : reg_type; 
        variable holdn  : std_ulogic;
        variable recov  : std_ulogic;
        variable wallow : std_ulogic;
    begin 
        -- Initialization 
        v := r; 
        holdn := '1'; 
        recov := '1'; 
        wallow := '0'; 
 
        -- Main state machine 
        case(r.state) is
            when IDLE =>
                if en = '1' then
                    v.state := FSTRUN;
                end if;
            when FSTRUN => 
                if hwrite = '1' then 
                    v.state := PREPARING;
                    v.hwdata := hwdata;
                end if;
            when PREPARING => 
                holdn := '0';
                recov := '0';
                if recovdone = '1' then 
                    v.state := SNDRUN; 
                end if; 
            when SNDRUN => 
                wallow := '1'; 
                if hwrite = '1' then 
                    v.state := FSTRUN; 
                end if;
            when others => 
                v.state := IDLE; 
        end case; 
 
        -- Outputs 
        tro.enabled     <= en; 
        tro.wallow      <= wallow; 
        tro.hwdata      <= r.hwdata;
        tro.holdnproc   <= holdn; 
        tro.holdnmem    <= holdn; 
        tro.recov       <= recov; 
 
        rin <= v; 
    end process; 
 
    reg : process(clk) 
    begin 
      if rising_edge(clk) then 
        r <= rin; 
        if (rst = '0') or (en = '0') then r <= RRES; end if; 
      end if; 
    end process; 
 
end architecture;