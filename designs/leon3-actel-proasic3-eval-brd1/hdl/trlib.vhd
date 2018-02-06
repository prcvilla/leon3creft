library ieee; 
use ieee.std_logic_1164.all; 
 
package trlib is 
     
    type tr_out_type is record 
        enabled     : std_ulogic;                       -- tr is enabled 
        wallow      : std_ulogic;                       -- writes can advance to ahb (2nd iteration) 
        hwdata      : std_logic_vector(31 downto 0);    -- write data from 1st iteration 
        holdnproc   : std_ulogic;                       -- hold iu 
        holdnmem    : std_ulogic;                       -- hold mem through overriding amba hready 
        recov       : std_ulogic;                       -- start recovery 
    end record; 
 
    component trctrl 
        port ( 
            rst         : in  std_ulogic; 
            clk         : in  std_ulogic; 
            en          : in  std_ulogic; 
            hwrite      : in  std_ulogic; 
            hwdata      : in  std_logic_vector(31 downto 0); 
            recovdone   : in  std_ulogic; 
            tro         : out tr_out_type 
        ); 
    end component; 
 
end;