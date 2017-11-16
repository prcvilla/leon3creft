--Source: http://vhdlguru.blogspot.com.br/2011/01/implementation-of-stack-in-vhdl.html
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity stack is
generic (stsize : integer := 31; abits : integer := 8; dbits : integer := 32);
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
end stack;

architecture Behavioral of stack is

type mem_type is array (stsize downto 0) of std_logic_vector(dbits-1 downto 0);
type addr_type is array (stsize downto 0) of std_logic_vector(abits-1 downto 0);
signal stack_mem : mem_type := (others => (others => '0'));
signal stack_addr : addr_type := (others => (others => '0'));
signal stack_ptr : integer := stsize;
signal full,empty : std_logic := '0';

begin

Stack_Full <= full; 
Stack_Empty <= empty;
process(stack_ptr)
begin
if(stack_ptr = 0) then
	full <= '1';
	empty <= '0';
elsif(stack_ptr = stsize) then
	full <= '0';
	empty <= '1';
else
	full <= '0';
	empty <= '0';
end if;
end process;

--PUSH and POP process for the stack.
PUSH : process(Clk,PUSH_barPOP,Enable,full,empty)
begin
	if(rising_edge(Clk)) then
		if (Resetn = '0') then
			stack_mem <= (others=>(others=>'0'));
			stack_addr <= (others=>(others=>'0'));
			stack_ptr <= stsize;
			--full <= '0';
			--empty <= '1';
			Data_Out <= (others=>'0');
			Addr_Out <= (others=>'0');
		else
			if (Flush = '1') then
				stack_mem <= (others=>(others=>'0'));
				stack_addr <= (others=>(others=>'0'));
				stack_ptr <= stsize;
				--full <= '0';
				--empty <= '1';
				Data_Out <= (others=>'0');
				Addr_Out <= (others=>'0');
			else
				--setting full and empty flags
--				if(stack_ptr = 0) then
--					full <= '1';
--					empty <= '0';
--				elsif(stack_ptr = stsize) then
--					full <= '0';
--					empty <= '1';
--				else
--					full <= '0';
--					empty <= '0';
--				end if;
				--PUSH section.
				if (Enable = '1' and PUSH_barPOP = '1' and full = '0') then
					 --Data pushed to the current address.
					stack_mem(stack_ptr) <= Data_In; 
					stack_addr(stack_ptr) <= Addr_In; 
					if(stack_ptr /= 0) then
						stack_ptr <= stack_ptr - 1;
					end if; 
				end if;
				--POP section.
				if (Enable = '1' and PUSH_barPOP = '0' and empty = '0') then
					--Data has to be taken from the next highest address(empty descending type stack).
					if(stack_ptr /= stsize) then   
						Data_Out <= stack_mem(stack_ptr+1); 
						Addr_Out <= stack_addr(stack_ptr+1); 
						stack_ptr <= stack_ptr + 1;
					end if; 
				end if;
			end if;
		end if;
	end if; 
end process;

end Behavioral;
