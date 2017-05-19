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
    we     : in  std_ulogic;

    rec_waddr  : out  std_logic_vector((abits -1) downto 0);
    rec_wdata  : out  std_logic_vector((dbits -1) downto 0);
    rec_we     : out  std_ulogic;


    chkp   : in  std_ulogic;
    recovn : in  std_ulogic;
    recovdone  : out std_ulogic
  );
end;

architecture beh of chk_regfile is
	type regfile_t is array(0 to (2**abits)-1) of std_logic_vector(dbits-1 downto 0);
	signal regfile_data : regfile_t;
	signal regfile_bkp : regfile_t;

	type states is (sidle, sinit, saddr, scnt, sfin, sdone);
	signal CS, NS : states;

	signal addr : unsigned((abits-1) downto 0);
begin

	process(wclk)
	begin
		if (wclk'event and wclk='1') then
			if (rstn='0') then
				regfile_data <= (others=>(others=>'0'));
				regfile_bkp <= (others=>(others=>'0'));

				CS <= sidle;
			else
				if (we='1') then
					regfile_data(to_integer(unsigned(waddr))) <= wdata;
				end if;

				if (chkp='1') then
					regfile_bkp <= regfile_data;
				end if;

				CS <= NS;
				case(CS) is
					when sidle =>
						addr <= (others=>'1');
					when sinit =>
						addr <= (others=>'1');
					when saddr =>
						
					when scnt =>
						addr <= addr - 1;
					when sfin =>
						
					when sdone =>
						
				end case;
			end if;
		end if;
	end process;


	recovdone <= '1' when (CS=sdone) else '0';
	rec_we <= '1' when CS=saddr else '0';
	rec_waddr <= STD_LOGIC_VECTOR(addr);
	rec_wdata <= regfile_bkp(to_integer(addr));

	process(CS, recovn, addr)
	begin
		case(CS) is
			when sidle =>
				if (recovn='0') then NS <= sinit;
				else NS <= sidle; end if;
			when sinit =>
				NS <= saddr;
			when saddr =>
				NS <= scnt;
			when scnt =>
				NS <= sfin;
			when sfin =>
				if (addr=0) then NS <= sdone;
				else NS <= saddr; end if;
			when sdone =>
				if (recovn='0') then NS <= sdone;
				else NS <= sidle; end if;
			when others =>
				NS <= sidle;
		end case;
	end process;

end architecture;

