library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity chk_regfile is
  generic (abits : integer := 8; dbits : integer := 32);
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
	component stack is
	generic (stsize : integer := 63; abits : integer := 8; dbits : integer := 32);
	port(	Clk : in std_logic;  --Clock for the stack.
		Resetn : in std_logic; --Reset signal
		Flush : in std_logic; --Flush the stack
		Enable : in std_logic;	--Enable the stack. Otherwise neither push nor pop will happen.
		Data_In : in std_logic_vector(dbits-1 downto 0);  --Data to be pushed to stack
		Addr_In : in std_logic_vector(abits-1 downto 0);  --Addr to be pushed to stack
		Data_Out : out std_logic_vector(dbits-1 downto 0);	--Data popped from the stack.
		Addr_Out : out std_logic_vector(abits-1 downto 0);	--Addr popped from the stack.
		PUSH_barPOP : in std_logic;  --active low for POP and active high for PUSH.
		Stack_Full : out std_logic;  --Goes high when the stack is full.
		Stack_Empty : out std_logic  --Goes high when the stack is empty.
	);
	end component;

	type states is (sidle, sinit, spop, swrite, sdone);
	signal CS, NS : states;

	signal flush, push_barpop, stack_en, stack_full, stack_empty : std_logic;
	signal pop_en, push_en, stackrstn : std_logic;
    signal waddr_r  : std_logic_vector((abits -1) downto 0);
begin

	stack0 : stack
	  generic map(63, abits, dbits)
	  port map( wclk, stackrstn, flush, stack_en,
	       wdata, waddr_r,
		   rec_wdata, rec_waddr,
		   push_barpop, stack_full, stack_empty
	  );

	stack_en <= pop_en OR push_en;
	flush <= '1' when chkp='1' else '0';
	process(wclk)
	begin
		if (wclk'event and wclk='1') then
			if (rstn='0') then
				CS <= sidle;
				stackrstn <= '0';
			else
				if (we='1') then
					waddr_r <= waddr;
					push_en <= '1';
				else
					push_en <= '0';
				end if;

				if (chkp='1') then
					--flush <= '1';
					stackrstn <= '1';
				else
					--flush <= '0';
				end if;

				CS <= NS;
				case(CS) is
					when sidle =>
						
					when sinit =>
						
					when spop =>
						
					when swrite =>
						
					when sdone =>
						
				end case;
			end if;
		end if;
	end process;


	recovdone <= '1' when (CS=sdone) else '0';
	rec_we <= '1' when (CS=swrite) else '0';
	push_barpop <= '1' when ((CS=sidle)OR(CS=sdone)) else '0';
	pop_en <= '1' when (CS=spop) else '0';

	process(CS, recovn, stack_empty)
	begin
		case(CS) is
			when sidle =>
				if (recovn='0') then NS <= sinit;
				else NS <= sidle; end if;
			when sinit =>
				NS <= spop;
			when spop =>
				NS <= swrite;
			when swrite =>
				if (stack_empty='1') then NS <= sdone;
				else NS <= spop; end if;
			when sdone =>
				if (recovn='0') then NS <= sdone;
				else NS <= sidle; end if;
			when others =>
				NS <= sidle;
		end case;
	end process;

end architecture;

