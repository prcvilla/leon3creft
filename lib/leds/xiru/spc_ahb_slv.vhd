library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.xiru_package.all;

entity spc_ahb_slv is
  port (
-- Specific signals
	clk           : in  std_logic                     := '0';              --        clock.clk
	reset         : in  std_logic                     := '0';              --   reset_sink.reset
	hbusreq		  : out std_logic					  := '0';		       --    ahb_slave.hbusreq
	hlock		  : out std_logic					  := '0';			   --			  .hlock
	haddr         : out std_logic_vector(31 downto 0) := (others => '0');  --   		  .haddr
	htrans		  : out std_logic_vector(1 downto 0)  := (others => '0');  --			  .htrans
	hwrite		  : out	std_logic					  := '0';			   --			  .hwrite
	hsize		  : out std_logic_vector(2 downto 0)  := (others => '0');  --			  .hsize
	hburst		  : out std_logic_vector(2 downto 0)  := (others => '0');  --			  .hburst
	hprot		  : out	std_logic_vector(3 downto 0)  := (others => '0');  --			  .hprot
	hwdata		  : out	std_logic_vector(31 downto 0) := (others => '0');  --			  .hwdata
	hgrant		  : in  std_logic_vector(15 downto 0) := (others => '0');  --			  .hgrant
	hready		  : in  std_logic					  := '0';			   --			  .hready
	hresp		  : in  std_logic_vector(1 downto 0)  := (others => '0');  --			  .hresp
	hrdata		  : in  std_logic_vector(31 downto 0) := (others => '0');  --			  .hrdata
-- Generic signals
    o_SPC_OPC     : out std_logic_vector(c_OPC_WIDTH-1 downto 0);
    o_SPC_BE      : out std_logic_vector(c_BE_WIDTH-1 downto 0);
    o_SPC_DATA    : out std_logic_vector(c_DATA_WIDTH-1 downto 0);
    o_SPC_WAIT    : out std_logic;
    i_SPC_START   : in  std_logic;
    i_SPC_OPC     : in  std_logic_vector(c_OPC_WIDTH-1 downto 0);
	i_SPC_BL      : in  std_logic_vector(c_BL_WIDTH-1 downto 0);
	i_SPC_BS      : in  std_logic_vector(c_BS_WIDTH-1 downto 0);
    i_SPC_BE      : in  std_logic_vector(c_BE_WIDTH-1 downto 0);
    i_SPC_ADDR    : in  std_logic_vector(c_ADDR_WIDTH-1 downto 0);
    i_SPC_DATA    : in  std_logic_vector(c_DATA_WIDTH-1 downto 0);
	i_SPC_COUNTER : in  std_logic_vector(3 downto 0); --
	i_SPC_FRAME   : in  std_logic_vector(1 downto 0) --
  );
end entity spc_ahb_slv;

architecture rtl of spc_ahb_slv is

  component spc_slv_htrans_ctrl is --
    port (
      i_CLK               : in  std_logic;
      i_RST               : in  std_logic;
      i_SPC_COUNTER       : in  std_logic_vector(3 downto 0);
      i_SPC_FRAME         : in  std_logic_vector(1 downto 0);
      i_SPC_OPC           : in  std_logic_vector(3 downto 0);
	  i_HREADY            : in  std_logic;
      o_HTRANS            : out std_logic_vector(1 downto 0)
    );
  end component;
  
begin

  u_SPC_SLV_HTRANS_CTRL: spc_slv_htrans_ctrl --
    port map (
      i_CLK          => clk,
      i_RST          => reset,
      i_SPC_COUNTER  => i_SPC_COUNTER,
      i_SPC_FRAME    => i_SPC_FRAME,
      i_SPC_OPC      => i_SPC_OPC,
	  i_HREADY       => hready,
      o_HTRANS       => htrans
    );

  o_SPC_OPC  <= c_OPC_DVA when (hresp = "00") else
                c_OPC_FAIL when (hresp = "10") else
				c_OPC_ERR when (hresp = "11") else
				"0000";
  o_SPC_BE      <= i_SPC_BE;
  o_SPC_DATA    <= hrdata;
  o_SPC_WAIT    <= hready;
  
  hwrite        <= '1' when (i_SPC_OPC = c_OPC_WR) or (i_SPC_OPC = c_OPC_WRB) else
                   '0' when (i_SPC_OPC = c_OPC_RD) or (i_SPC_OPC = c_OPC_RDB);
  hburst        <= "000" when (i_SPC_BL = c_BL_ST) and (i_SPC_BS = c_BS_ST) else
                   "001" when (i_SPC_BL = c_BL_NS) and (i_SPC_BS = c_BS_NS) else
				   "010" when (i_SPC_BL = c_BL_4W) and (i_SPC_BS = c_BS_WRAP) else
				   "011" when (i_SPC_BL = c_BL_4W) and (i_SPC_BS = c_BS_INCR) else
				   "100" when (i_SPC_BL = c_BL_8W) and (i_SPC_BS = c_BS_WRAP) else
				   "101" when (i_SPC_BL = c_BL_8W) and (i_SPC_BS = c_BS_INCR) else
				   "110" when (i_SPC_BL = c_BL_16W) and (i_SPC_BS = c_BS_WRAP) else
				   "111" when (i_SPC_BL = c_BL_16W) and (i_SPC_BS = c_BS_INCR) else
				   "000";
  hsize         <= "000" when (i_SPC_BE = c_BE_8BIT) else
                   "010" when (i_SPC_BE = c_BE_16BIT) else
				   "011" when (i_SPC_BE = c_BE_32BIT);
  haddr         <= i_SPC_ADDR;
  hwdata        <= i_SPC_DATA;

end architecture rtl;