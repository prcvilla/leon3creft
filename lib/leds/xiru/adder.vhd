library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity adder is
  generic (
    p_DATA_WIDTH : integer := 32
  );
  port (
    i_DATA_A : in  std_logic_vector(p_DATA_WIDTH-1 downto 0);
    i_DATA_B : in  std_logic_vector(p_DATA_WIDTH-1 downto 0);
    o_DATA   : out std_logic_vector(p_DATA_WIDTH-1 downto 0);
	  o_CO     : out std_logic
  );
end adder;

architecture rtl of adder is
  signal sum : std_logic_vector(p_DATA_WIDTH downto 0) := (others => '0');

begin
  sum <= ('0' & i_DATA_A) + ('0' & i_DATA_B) ;
  o_DATA <= sum(p_DATA_WIDTH-1 downto 0);
  o_CO   <= sum(p_DATA_WIDTH);
  
end rtl;