library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity chk_regfile is
  generic (abits : integer := 6; dbits : integer := 8);
  port (
    rstn   : in  std_ulogic;
    wclk   : in  std_ulogic;
    waddr  : in  std_logic_vector((abits -1) downto 0);
    wdata  : in  std_logic_vector((dbits -1) downto 0);
    we     : in  std_ulogic
  );
end;

architecture beh of chk_regfile is
	type regfile_t is array(0 to (2**abits)-1) of std_logic_vector(dbits-1 downto 0);
	signal regfile_data : regfile_t;
begin

	process(wclk)
	begin
		if (wclk'event and wclk='1') then
			if (rstn='0') then
				regfile_data <= (others=>(others=>'0'));
			else
				if (we='1') then
					regfile_data(to_integer(unsigned(waddr))) <= wdata;
				end if;
			end if;
		end if;
	end process;

end architecture;

