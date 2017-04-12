library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library work;

entity ahb_slave is
  port (
    i_CLK           : in  std_logic                      := '0';
	i_RST           : in  std_logic                      := '0';
    slv_hbusreq     : in std_logic                       := '0';             --    ahb_slave.hbusreq
    slv_hlock       : in std_logic                       := '0';             --             .hlock
    slv_haddr       : in std_logic_vector(31 downto 0)   := (others => '0'); --             .haddr
    slv_htrans      : in std_logic_vector(1 downto 0)    := (others => '0'); --             .htrans
    slv_hwrite      : in std_logic                       := '0';             --             .hwrite
    slv_hsize       : in std_logic_vector(2 downto 0)    := (others => '0'); --             .hsize
    slv_hburst      : in std_logic_vector(2 downto 0)    := (others => '0'); --             .hburst
    slv_hprot       : in std_logic_vector(3 downto 0)    := (others => '0'); --             .hprot
    slv_hwdata      : in std_logic_vector(31 downto 0)   := (others => '0'); --             .hwdata
    slv_hgrant      : out  std_logic_vector(15 downto 0) := (others => '0'); --             .hgrant
    slv_hready      : out  std_logic				     := '0';             --             .hready
    slv_hresp       : out  std_logic_vector(1 downto 0)  := (others => '0'); --             .hresp
    slv_hrdata      : out  std_logic_vector(31 downto 0) := (others => '0')  --             .hrdata
  );
end ahb_slave;

architecture rtl of ahb_slave is
begin
  slv_hready <= '1';
  slv_hresp <= "00";

end rtl;
	