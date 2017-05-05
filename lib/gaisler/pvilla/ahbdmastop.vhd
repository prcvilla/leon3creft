------------------------------------------------------------------------------
--  This file is a part of the GRLIB VHDL IP LIBRARY
--  Copyright (C) 2003 - 2008, Gaisler Research
--  Copyright (C) 2008 - 2014, Aeroflex Gaisler
--  Copyright (C) 2015 - 2016, Cobham Gaisler
--
--  This program is free software; you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation; either version 2 of the License, or
--  (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
--  You should have received a copy of the GNU General Public License
--  along with this program; if not, write to the Free Software
--  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA 
-----------------------------------------------------------------------------   

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library grlib;
use grlib.amba.all;
use grlib.stdlib.all;
use grlib.devices.all;
--library gaisler;
--use gaisler.misc.all;


entity ahbdmastop is
  generic (
    hindex  : integer := 0
  );
  port (
    rstn    : in  std_ulogic;
    clk     : in  std_ulogic;
    stp_req : in  std_ulogic;
    holdn   : in  std_ulogic;
    stp_grt : out std_ulogic;
    ahbi    : in  ahb_mst_in_type;
    ahbo    : out ahb_mst_out_type );
end;

architecture rtl of ahbdmastop is

constant REVISION : integer := 0;

type states is (sidle, sahbcntrst, sahbcnt0, sahbcnt1, sahbgrtd, sahbrel);
signal CS, NS : states;

signal cnt : unsigned(7 downto 0);
constant MAX_CNT : unsigned(7 downto 0) := x"0A";

begin

	process(clk)
	begin
	if (clk'event and clk='1') then
		if (rstn = '0') then
			CS <= sidle;
		else
			CS <= NS;
		end if;
	end if;
	end process;

	ahbo.hbusreq <= '0' when (CS=sidle or CS=sahbrel) else '1';
	ahbo.hlock   <= '0' when (CS=sidle or CS=sahbrel) else '1';
	stp_grt <= '1' when (CS=sahbgrtd) else '0';
	process(CS, stp_req, cnt, ahbi.hgrant(hindex), ahbi.hready, holdn)
	begin
		case(CS) is
			when sidle =>
				if (stp_req='0') then
					NS<=sidle;
				else
					NS<=sahbcntrst;
				end if;

			when sahbcntrst=>
				NS<=sahbcnt0;

			when sahbcnt0=>
				if ( (ahbi.hgrant(hindex)='1') and
					 (ahbi.hready='1') and (holdn='0')
					) then
					if (cnt=MAX_CNT) then
						NS<=sahbgrtd;
					else
						NS<=sahbcnt1;
					end if;
				end if;

			when sahbcnt1=>
				NS<=sahbcnt0;

			when sahbgrtd=>
				if (stp_req='1') then
					NS<=sahbgrtd;
				else
					NS<=sahbrel;
				end if;

			when sahbrel=>
				NS<=sidle;

			when others=>
				NS<=sidle;
		end case;
	end process;


	process(clk)
	begin
	if (clk'event and clk='1') then
		case(CS) is
			when sidle =>
				cnt <= (others=>'0');

			when sahbcntrst=>
				cnt <= (others=>'0');

			when sahbcnt0=>
				cnt <= cnt;

			when sahbcnt1=>
				cnt <= cnt + 1;

			when sahbgrtd=>

			when sahbrel=>

			when others=>
				cnt <= (others=>'0');

		end case;
	end if;
	end process;

-- pragma translate_off
    bootmsg : report_version 
    generic map ("ahbdmastop " & tost(hindex) & 
    ": AHB DMA Stopper rev " & tost(REVISION));
-- pragma translate_on

end;

