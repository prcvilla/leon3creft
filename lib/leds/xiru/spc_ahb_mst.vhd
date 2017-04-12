library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.xiru_package.all;

entity spc_ahb_mst is
  port (
-- Specific signals
	clk           : in  std_logic                     := '0';              --        clock.clk
	reset         : in  std_logic                     := '0';              --   reset_sink.reset
	hbusreq		  : in  std_logic					  := '0';		       --   ahb_master.hbusreq
	hlock		  : in  std_logic					  := '0';			   --			  .hlock
	haddr         : in  std_logic_vector(31 downto 0) := (others => '0');  --   		  .haddr
	htrans		  : in  std_logic_vector(1 downto 0)  := (others => '0');  --			  .htrans
	hwrite		  : in	std_logic					  := '0';			   --			  .hwrite
	hsize		  : in  std_logic_vector(2 downto 0)  := (others => '0');  --			  .hsize
	hburst		  : in  std_logic_vector(2 downto 0)  := (others => '0');  --			  .hburst
	hprot		  : in	std_logic_vector(3 downto 0)  := (others => '0');  --			  .hprot
	hwdata		  : in	std_logic_vector(31 downto 0) := (others => '0');  --			  .hwdata
	hgrant		  : out std_logic_vector(15 downto 0) := (others => '0');  --			  .hgrant
	hready		  : out std_logic					  := '0';			   --			  .hready
	hresp		  : out std_logic_vector(1 downto 0)  := (others => '0');  --			  .hresp
	hrdata		  : out std_logic_vector(31 downto 0) := (others => '0');  --			  .hrdata
-- Generic signals
	i_SPC_WAIT_SND      : in  std_logic;
    i_SPC_OPC           : in  std_logic_vector(c_OPC_WIDTH-1 downto 0);
    i_SPC_DATA          : in  std_logic_vector(c_DATA_WIDTH-1 downto 0);
    i_SPC_BE            : in  std_logic_vector(c_BE_WIDTH-1 downto 0);
    o_SPC_ADDR          : out std_logic_vector(c_ADDR_WIDTH-1 downto 0);
    o_SPC_DATA          : out std_logic_vector(c_DATA_WIDTH-1 downto 0);
    o_SPC_OPC           : out std_logic_vector(c_OPC_WIDTH-1 downto 0);
	o_SPC_ENA_REG_DATA  : out std_logic; --
	o_SPC_START         : out std_logic;
	o_SPC_BL		    : out std_logic_vector(c_BL_WIDTH-1 downto 0); --
	o_SPC_BS	        : out std_logic_vector(c_BS_WIDTH-1 downto 0); --
    o_SPC_BE            : out std_logic_vector(c_BE_WIDTH-1 downto 0)
  );
end entity spc_ahb_mst;

architecture rtl of spc_ahb_mst is

  component spc_mst_reg_ctrl is --
    port (
      i_CLK               : in  std_logic;
      i_RST               : in  std_logic;
      i_HWRITE            : in  std_logic;
	  i_HTRANS            : in  std_logic_vector(1 downto 0);
      i_HBURST            : in  std_logic_vector(2 downto 0);
      o_ENA_REG_DATA      : out std_logic;
      o_START             : out std_logic
    );
  end component;
  
begin

  u_SPC_MST_REG_CTRL: spc_mst_reg_ctrl --
    port map (
      i_CLK          => clk,
      i_RST          => reset,
      i_HWRITE       => hwrite,
	  i_HTRANS       => htrans,
      i_HBURST       => hburst,
      o_ENA_REG_DATA => o_SPC_ENA_REG_DATA,
      o_START        => o_SPC_START
    );

  o_SPC_ADDR         <= haddr;
  o_SPC_DATA         <= hwdata;
  o_SPC_OPC          <= c_OPC_WR when (hwrite = '1') and (htrans = "10") else
                        c_OPC_RD when (hwrite = '0') and (htrans = "10") else
                        c_OPC_WRB when (hwrite = '1') and (htrans = "11") else
				        c_OPC_RDB when (hwrite = '0') and (htrans = "11") else
					    c_OPC_IDLE;
  o_SPC_BL           <= c_BL_NS when (hburst = "001") else
						c_BL_4W when (hburst = "010") or (hburst = "011") else
						c_BL_8W when (hburst = "100") or (hburst = "101") else
						c_BL_16W when (hburst = "110") or (hburst = "111") else
						c_BL_ST;
  o_SPC_BS           <= c_BS_NS when (hburst = "001") else
						c_BS_WRAP when (hburst = "010") or (hburst = "100") or (hburst = "110") else
						c_BS_INCR when (hburst = "011") or (hburst = "101") or (hburst = "111") else
						c_BS_ST;
  o_SPC_BE           <= c_BE_8BIT when (hsize = "000") else
	                    c_BE_16BIT when (hsize = "010") else
				        c_BE_32BIT when (hsize = "011");
				   
  hrdata             <= i_SPC_DATA;
  hresp              <= "00" when (i_SPC_OPC = c_OPC_DVA) else
                        "10" when (i_SPC_OPC = c_OPC_FAIL) else
						"11" when (i_SPC_OPC = c_OPC_ERR) else
						"00";
   hready             <= i_SPC_WAIT_SND;
   
end architecture rtl;