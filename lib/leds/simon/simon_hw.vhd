-------------------------------------------------------------
--	Interface SIMON APB 
--  Leitura de dados  
-------------------------------------------------------------

library ieee; 
use ieee.std_logic_1164.all;
library grlib; 
use grlib.amba.all; 
use grlib.devices.all;
library gaisler; 
use gaisler.misc.all;
library leds; 
use leds.all;

entity simon_hw is
 generic (
	pindex : integer := 0;
	paddr : integer := 0;
	pmask : integer := 16#fff#);
 port (
	rst : in std_ulogic;
	clk : in std_ulogic;
	apbi : in apb_slv_in_type;
	apbo : out apb_slv_out_type
	);
 
end;
architecture rtl of simon_hw is

signal w_i_SIMON_BLOCK_OUTPUT : std_logic_vector(31 downto 0);
signal w_o_SIMON_BLOCK_INPUT : std_logic_vector(31 downto 0);
signal w_o_SIMON_KEY_INPUT : std_logic_vector(63 downto 0);
signal w_o_SIMON_DIRECTION : std_logic_vector(1 downto 0);
signal w_i_SIMON_BUSY : std_logic;
signal w_clk : std_logic;
signal w_rst : std_logic;
 

begin

--simon_out_in1 : simon_out_in
--  generic map (pindex  => pindex, paddr => paddr, pmask => pmask) --
--   port map (rst => rst, clk => clk, apbi => apbi, apbo => apbo, 
--					o_SIMON_BLOCK_INPUT => w_o_SIMON_BLOCK_INPUT, i_SIMON_BLOCK_OUTPUT => w_i_SIMON_BLOCK_OUTPUT,
--					 o_SIMON_KEY_INPUT => w_o_SIMON_KEY_INPUT, o_SIMON_DIRECTION => w_o_SIMON_DIRECTION,
--					  o_SIMON_RST => w_rst, o_SIMON_CLK => w_clk,i_SIMON_BUSY => w_i_SIMON_BUSY);
--					  
--  SIMON_CIPHER1 : SIMON_CIPHER                    -- 0xCAFECAFE
--  generic map (KEY_SIZE  => 64, BLOCK_SIZE => 32, ROUND_LIMIT => 32) --
--  port map (i_SYS_CLK => w_clk, i_RST => w_rst, i_BLOCK_INPUT => w_o_SIMON_BLOCK_INPUT,  o_BLOCK_OUTPUT => w_i_SIMON_BLOCK_OUTPUT,
--					 i_KEY => w_o_SIMON_KEY_INPUT, i_CONTROL  => w_o_SIMON_DIRECTION, o_BUSY => w_i_SIMON_BUSY );
	
					
end;