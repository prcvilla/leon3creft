library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

------------------------
------------------------
package socin_package is
------------------------
------------------------
  constant c_PAR_DATA_WIDTH : integer := 32;  -- width of the data channel
  constant c_PAR_NUMB_COLS  : integer := 2;   -- number of columns (# routers in x direction)
  constant c_PAR_NUMB_ROWS  : integer := 1;   -- number of rows (# routers in y directions)

  -- 
  type t_DATA_ROW0   is array (c_PAR_NUMB_ROWS-1 downto 0) of std_logic_vector(c_PAR_DATA_WIDTH+1 downto 0);
  type t_DATA_ROW1   is array (c_PAR_NUMB_ROWS   downto 0) of std_logic_vector(c_PAR_DATA_WIDTH+1 downto 0);  
  type t_DATA_LINK_X is array (c_PAR_NUMB_COLS   downto 0) of t_DATA_ROW0;
  type t_DATA_LINK_Y is array (c_PAR_NUMB_COLS-1 downto 0) of t_DATA_ROW1;
  type t_DATA_LINK_L is array (c_PAR_NUMB_COLS-1 downto 0) of t_DATA_ROW0;

  type t_CMD_ROW0    is array (c_PAR_NUMB_ROWS-1 downto 0) of std_logic;
  type t_CMD_ROW1    is array (c_PAR_NUMB_ROWS   downto 0) of std_logic;  
  type t_CMD_LINK_X  is array (c_PAR_NUMB_COLS   downto 0) of t_CMD_ROW0;
  type t_CMD_LINK_Y  is array (c_PAR_NUMB_COLS-1 downto 0) of t_CMD_ROW1;
  type t_CMD_LINK_L  is array (c_PAR_NUMB_COLS-1 downto 0) of t_CMD_ROW0;

  type t_INT_ROW0    is array (c_PAR_NUMB_ROWS-1 downto 0) of integer;
  type t_INT_LINK_L  is array (c_PAR_NUMB_COLS-1 downto 0) of t_INT_ROW0;
  
  type t_SLV_DATA_ROW0    is array (c_PAR_NUMB_ROWS-1 downto 0) of std_logic_vector(c_PAR_DATA_WIDTH+1 downto 0);
  type t_SLV_DATA_LINK_L  is array (c_PAR_NUMB_COLS-1 downto 0) of t_SLV_DATA_ROW0;  

  type t_SLV_16BIT_ROW0   is array (c_PAR_NUMB_ROWS-1 downto 0) of std_logic_vector(15 downto 0);
  type t_SLV_16BIT_LINK_L is array (c_PAR_NUMB_COLS-1 downto 0) of t_SLV_16BIT_ROW0;

  
  type t_TABLE is array (natural range <>) of integer;
end socin_package;

