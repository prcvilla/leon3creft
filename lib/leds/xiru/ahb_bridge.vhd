------------------------------------------------------------------------------

-----------------------------------------------------------------------------   
-- Entity:      ahb_bridge
-- File:        ahb_bridge.vhd
-- Author:      Lucas Martins :)
-- Description: AMBA AHB/AHB bridge shell
------------------------------------------------------------------------------ 
library ieee;
use ieee.std_logic_1164.all;
library grlib;
use grlib.amba.all;
use work.all;

entity ahb_bridge is
	generic (
		hindex : integer := 0;
		haddr : integer := 0);
	port (
		rst : in std_ulogic;
		clk : in std_ulogic;
		-- Slave Interface
		ahbsi : in ahb_slv_in_type;
		ahbso : out ahb_slv_out_type;
		-- Master Interface
		ahbmi : in ahb_mst_in_type;
		ahbmo : out ahb_mst_out_type;
		
		o_trigger : out std_logic);
end;

architecture rtl of ahb_bridge is

 -- plug&play configuration
	constant HCONFIG: ahb_config_type := (
--	   0 =>ahb_device_reg (16#01#, 16#006#, 0, 0, 0), -- Gaisler
		0 => ahb_device_reg (16#007#, 16#EB#, 0, 0, 0), -- mine
		4 => ahb_membar(haddr, '1', '1', 16#FFF#), others => X"00000000"); -- Base addr
	begin
	ahbso.hconfig <= HCONFIG; -- Plug&play configuration
	ahbso.hirq <= (others => '0'); -- No interrupt line used
	wrap_ahb: wrapper_ahb
    port map(  
		clk             => clk,  --    clock_sink.clk
		reset           => not(rst), --    reset_sink.reset
		                   
		slv_hbusreq     => ahbmo.hbusreq, -- o  ahb_MASTER.hbusreq
		slv_hlock       => ahbmo.hlock, -- o           .hlock
		slv_haddr       => ahbmo.haddr, --             .haddr
		slv_htrans      => ahbmo.htrans, --           .htrans
		slv_hwrite      => ahbmo.hwrite, --             .hwrite
		slv_hsize       => ahbmo.hsize, --            .hsize
		slv_hburst      => ahbmo.hburst, --             .hburst
		slv_hprot       => ahbmo.hprot, --             .hprot
		slv_hwdata      => ahbmo.hwdata, --             .hwdata
		slv_hgrant      => ahbmi.hgrant, --             .hgrant
		slv_hready      => ahbmi.hready,    --             .hready
		slv_hresp       => ahbmi.hresp, --             .hresp
		slv_hrdata      => ahbmi.hrdata, --             .hrdata
		                 
--		mst_hbusreq     => ahbsi.hbusreq, --   ahb_SLAVE.hbusreq
--		mst_hlock       => ahbsi.hlock,  --             .hlock
		mst_haddr       => ahbsi.haddr,  --             .haddr
		mst_htrans      => ahbsi.htrans, --             .htrans
		mst_hwrite      => ahbsi.hwrite, --             .hwrite
		mst_hsize       => ahbsi.hsize,  --             .hsize
		mst_hburst      => ahbsi.hburst, --             .hburst
		mst_hprot       => ahbsi.hprot,  --             .hprot
		mst_hwdata      => ahbsi.hwdata, --             .hwdata
 --             .hgrant
		mst_hready      => ahbso.hready,    --             .hready
		mst_hresp       => ahbso.hresp,  --             .hresp
		mst_hrdata      => ahbso.hrdata --             .hrdata
	);
	
--	 -- Incoming data from bus one
--	 ahbmo.haddr <= ahbsi.haddr;
--	 ahbmo.hwrite <= ahbsi.hwrite;
--	 ahbmo.htrans <= ahbsi.htrans;
--	 ahbmo.hsize <= ahbsi.hsize;
--	 ahbmo.hburst <= ahbsi.hburst;
--	 ahbmo.hwdata <= ahbsi.hwdata;
--	 ahbmo.hprot <= "0000";
--	
--	 -- Incoming data from bus two
--	 ahbso.hready <= ahbmi.hready;
--	 ahbso.hresp <= ahbmi.hresp;
--	 ahbso.hrdata <= ahbmi.hrdata;
--	 o_trigger <= '1';
	
end;