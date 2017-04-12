library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

--------------
--------------
entity lfsr is
--------------
--------------
  generic (
	  p_WIDTH		    :	 natural := 4;
	  p_LOG2_WIDTH :	 natural := 2;
    p_SEED    	  :  natural := 16#01#    
  );
  port (
    -- System signals
    i_CLK  : in  		 std_logic;  -- clock
    i_RSTN : in  		 std_logic;  -- reset
    b_P    : buffer std_logic_vector(p_WIDTH-1 downto 0)
);
end lfsr;

architecture arch_1 of lfsr is
signal  w_Q : std_logic_vector(7 downto 0);
begin

 process(i_CLK,i_RSTN)
 begin
   if(i_RSTN='0') then 
     w_Q <= conv_std_logic_vector(p_SEED+1,8); -- set seed value on reset
   elsif (i_CLK'event and  i_CLK='1') then    -- clock with rising edge
     w_Q(0) <= w_Q(7);                         -- feedback to ls bit
     w_Q(1) <= w_Q(0);                                
     w_Q(2) <= w_Q(1) xor w_Q(7);              -- tap at stage 1
     w_Q(3) <= w_Q(2) xor w_Q(7);              -- tap at stage 2
     w_Q(4) <= w_Q(3) xor w_Q(7);              -- tap at stage 3
     w_Q(7 downto 5)<= w_Q(6 downto 4);        -- others bits shifted
   end if;
 end process;


	f0:	for i in p_WIDTH-1 downto 0 generate
		b_P(i) <= '1'when (conv_integer(w_Q(p_LOG2_WIDTH-1 downto 0)) = i) else '0';
	end generate;
 
 	
end architecture arch_1;

