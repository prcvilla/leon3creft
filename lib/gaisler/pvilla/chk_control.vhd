library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity chk_control is
  port (
    rstn   : in  std_ulogic;
    wclk   : in  std_ulogic;
    we     : in  std_ulogic;
    chkp_en: out std_ulogic
  );
end;

architecture beh of chk_control is
	type STATES is (sidle, swriteon, schkpen);
	signal CS, NS : STATES;
	signal clk : std_ulogic;
begin

	clk <= wclk;

	chkp_en <= '1' when CS=schkpen else '0';

	process(clk)
	begin
		if (clk'event and clk='1') then
			if (rstn='0') then
				CS <= sidle;
			else
				CS <= NS;
			end if;
		end if;
	end process;

	process(CS, we)
	begin
		case(CS) is
			when sidle =>
				if (we='0') then NS <= sidle;
				else             NS <= swriteon; end if;
			when swriteon =>
				if (we='0') then NS <= schkpen;
				else             NS <= swriteon; end if;
			when schkpen =>
				NS <= sidle;
			when others =>
				NS <= sidle;
		end case;
	end process;

end architecture;

