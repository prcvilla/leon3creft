library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity down_counter is
  port (
    i_CLK         : in std_logic;
    i_RST         : in std_logic;
	i_COUNTER_ENA : in std_logic;
	i_BL_REG      : in std_logic_vector(3 downto 0);
	o_COUNTER	  : out std_logic_vector (3 downto 0)	
  );
end down_counter;

architecture rtl of down_counter is
 
  signal count: std_logic_vector(3 downto 0);

begin
  process (i_CLK, i_RST)
  begin
    if (i_RST = '1') then
	  count <= (others => '0');
	elsif (i_CLK'event and i_CLK = '1') then
	  if (i_COUNTER_ENA = '1') then
	    count <= i_BL_REG;
	  else
	    count <= count - 1;
	  end if;
	end if;
  end process;
  
  o_COUNTER <= count;
end rtl;