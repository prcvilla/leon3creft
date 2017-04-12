library ieee;
use ieee.std_logic_1164.all;
library work;
use work.xiru_package.all;

entity gen_slv_rcv_dp is
  port (
    i_CLK               : in  std_logic;
    i_RST               : in  std_logic;
    i_FLIT_H1_REG_ENA   : in  std_logic;
    i_FLIT_ADDR_REG_ENA : in  std_logic;
    i_FLIT_DATA_REG_ENA : in  std_logic;
    i_COUNTER_ENA       : in  std_logic; --
	i_SEL_MUX_ADDR		: in  std_logic; --
	i_SEL_MUX_BURST     : in  std_logic_vector(1 downto 0); --
    i_NET_DATA          : in  std_logic_vector(c_DATA_WIDTH+2 downto 0);
    o_SPC_ADDR          : out std_logic_vector(c_ADDR_WIDTH-1 downto 0);
    o_SPC_DATA          : out std_logic_vector(c_DATA_WIDTH-1 downto 0);
    o_SPC_OPC           : out std_logic_vector(c_OPC_WIDTH-1 downto 0);
    o_SPC_BE            : out std_logic_vector(c_BE_WIDTH-1 downto 0);
	o_SPC_BL			: out std_logic_vector(c_BL_WIDTH-1 downto 0); --
	o_SPC_BS			: out std_logic_vector(c_BS_WIDTH-1 downto 0); --
	o_COUNTER    		: out std_logic_vector(3 downto 0); --
    o_DST               : out std_logic_vector(c_X_ADDR_WIDTH+c_Y_ADDR_WIDTH+c_Z_ADDR_WIDTH-1 downto 0)
  );
end gen_slv_rcv_dp;

architecture rtl of gen_slv_rcv_dp is

  signal w_i_MUX_BURST_DATA_B : std_logic_vector(c_ADDR_WIDTH-1 downto 0) := (others => '0');
  signal w_i_MUX_BURST_DATA_C : std_logic_vector(c_ADDR_WIDTH-1 downto 0) := (others => '0');
  signal w_i_MUX_BURST_DATA_D : std_logic_vector(c_ADDR_WIDTH-1 downto 0) := (others => '0');
  signal w_o_MUX_ADDR     : std_logic_vector(c_ADDR_WIDTH-1 downto 0) := (others => '0'); --
  signal w_o_MUX_BURST    : std_logic_vector(c_ADDR_WIDTH-1 downto 0) := (others => '0'); --
  signal w_o_ADDER_INCR   : std_logic_vector(31 downto 0) := (others => '0'); --
  signal w_o_ADDER_WRAP4  : std_logic_vector(3 downto 0) := (others => '0'); --
  signal w_o_ADDER_WRAP8  : std_logic_vector(4 downto 0) := (others => '0'); --
  signal w_o_ADDER_WRAP16 : std_logic_vector(5 downto 0) := (others => '0'); --
  signal w_o_SPC_ADDR     : std_logic_vector(c_ADDR_WIDTH-1 downto 0) := (others => '0');
  signal w_o_SPC_BL       : std_logic_vector(c_BL_WIDTH-1 downto 0) := (others => '0');
  
begin
  
  w_i_MUX_BURST_DATA_B <= w_o_SPC_ADDR(c_ADDR_WIDTH-1 downto 4) & w_o_ADDER_WRAP4(3 downto 0);
  w_i_MUX_BURST_DATA_C <= w_o_SPC_ADDR(c_ADDR_WIDTH-1 downto 4) & w_o_ADDER_WRAP4(3 downto 0);
  w_i_MUX_BURST_DATA_D <= w_o_SPC_ADDR(c_ADDR_WIDTH-1 downto 4) & w_o_ADDER_WRAP4(3 downto 0);
  -- MUXES:

  u_MUX_ADDR: mux2 --
    generic map (
      p_DATA_WIDTH => c_ADDR_WIDTH
    )
    port map (
      i_SEL    => i_SEL_MUX_ADDR,
      i_DATA_A => i_NET_DATA(c_ADDR_WIDTH-1 downto 0),
      i_DATA_B => w_o_MUX_BURST(c_ADDR_WIDTH-1 downto 0), 
      o_DATA   => w_o_MUX_ADDR
    );

  u_MUX_BURST: mux4 --
    generic map (
      p_DATA_WIDTH => c_ADDR_WIDTH
    )
    port map (
      i_SEL    => i_SEL_MUX_BURST,
      i_DATA_A => w_o_ADDER_INCR(c_ADDR_WIDTH-1 downto 0),
      i_DATA_B => w_i_MUX_BURST_DATA_B,
      i_DATA_C => w_i_MUX_BURST_DATA_C,
      i_DATA_D => w_i_MUX_BURST_DATA_D,
      o_DATA   => w_o_MUX_BURST
    );
	
  -- REGISTERS:

  u_SPC_ADDR_REG: reg
    generic map (
      p_DATA_WIDTH    => c_ADDR_WIDTH,
      p_DEFAULT_VALUE => 0
    )
    port map ( 
      i_CLK  => i_CLK,
      i_RST  => i_RST,
      i_WR   => i_FLIT_ADDR_REG_ENA,
      i_DATA => w_o_MUX_ADDR(c_ADDR_WIDTH-1 downto 0),
      o_DATA => w_o_SPC_ADDR
    );

  u_SPC_DATA_REG: reg
    generic map (
      p_DATA_WIDTH    => c_DATA_WIDTH,
      p_DEFAULT_VALUE => 0
    )
    port map ( 
      i_CLK  => i_CLK,
      i_RST  => i_RST,
      i_WR   => i_FLIT_DATA_REG_ENA,
      i_DATA => i_NET_DATA(c_DATA_WIDTH-1 downto 0),
      o_DATA => o_SPC_DATA
    );

  u_SPC_OPC_REG: reg
    generic map (
      p_DATA_WIDTH    => c_OPC_WIDTH,
      p_DEFAULT_VALUE => 0
    )
    port map ( 
      i_CLK  => i_CLK,
      i_RST  => i_RST,
      i_WR   => i_FLIT_H1_REG_ENA,
      i_DATA => i_NET_DATA(c_X_ADDR_WIDTH+c_Y_ADDR_WIDTH+c_Z_ADDR_WIDTH+c_OPC_WIDTH-1 downto c_X_ADDR_WIDTH+c_Y_ADDR_WIDTH+c_Z_ADDR_WIDTH),
      o_DATA => o_SPC_OPC
    );

  u_SPC_BE_REG: reg
    generic map (
      p_DATA_WIDTH    => c_BE_WIDTH,
      p_DEFAULT_VALUE => 0
    )
    port map ( 
      i_CLK  => i_CLK,
      i_RST  => i_RST,
      i_WR   => i_FLIT_H1_REG_ENA,
      i_DATA => i_NET_DATA(c_X_ADDR_WIDTH+c_Y_ADDR_WIDTH+c_Z_ADDR_WIDTH+c_OPC_WIDTH+c_THID_WIDTH+c_BE_WIDTH-1 downto c_X_ADDR_WIDTH+c_Y_ADDR_WIDTH+c_Z_ADDR_WIDTH+c_OPC_WIDTH+c_THID_WIDTH),
      o_DATA => o_SPC_BE
    );

  u_SPC_BL_REG: reg --
    generic map (
      p_DATA_WIDTH    => c_BL_WIDTH,
      p_DEFAULT_VALUE => 0
    )
    port map ( 
      i_CLK  => i_CLK,
      i_RST  => i_RST,
      i_WR   => i_FLIT_H1_REG_ENA,
      i_DATA => i_NET_DATA(c_X_ADDR_WIDTH+c_Y_ADDR_WIDTH+c_Z_ADDR_WIDTH+c_OPC_WIDTH+c_THID_WIDTH+c_BE_WIDTH+c_BS_WIDTH+c_BL_WIDTH-1 downto c_X_ADDR_WIDTH+c_Y_ADDR_WIDTH+c_Z_ADDR_WIDTH+c_OPC_WIDTH+c_THID_WIDTH+c_BE_WIDTH+c_BS_WIDTH),
      o_DATA => w_o_SPC_BL
    );

  u_SPC_BS_REG: reg --
    generic map (
      p_DATA_WIDTH    => c_BS_WIDTH,
      p_DEFAULT_VALUE => 0
    )
    port map ( 
      i_CLK  => i_CLK,
      i_RST  => i_RST,
      i_WR   => i_FLIT_H1_REG_ENA,
      i_DATA => i_NET_DATA(c_X_ADDR_WIDTH+c_Y_ADDR_WIDTH+c_Z_ADDR_WIDTH+c_OPC_WIDTH+c_THID_WIDTH+c_BE_WIDTH+c_BS_WIDTH-1 downto c_X_ADDR_WIDTH+c_Y_ADDR_WIDTH+c_Z_ADDR_WIDTH+c_OPC_WIDTH+c_THID_WIDTH+c_BE_WIDTH),
      o_DATA => o_SPC_BS
    );


  u_DST_REG: reg
    generic map (
      p_DATA_WIDTH    => c_X_ADDR_WIDTH+c_Y_ADDR_WIDTH+c_Z_ADDR_WIDTH,
      p_DEFAULT_VALUE => 0
    )
    port map ( 
      i_CLK  => i_CLK,
      i_RST  => i_RST,
      i_WR   => i_FLIT_H1_REG_ENA,
      i_DATA => i_NET_DATA(c_X_ADDR_WIDTH+c_Y_ADDR_WIDTH+c_Z_ADDR_WIDTH-1 downto 0),
      o_DATA => o_DST
    );
  
  -- COUNTER:
  
  u_DOWN_COUNTER : down_counter
    port map (
      i_CLK => i_CLK,
      i_RST => i_RST,
	  i_COUNTER_ENA => i_COUNTER_ENA,
	  i_BL_REG => w_o_SPC_BL,
      o_COUNTER => o_COUNTER
  );

  -- ADDERS:
	
  u_ADDER_INCR : adder
    generic map (
	  p_DATA_WIDTH    => c_ADDR_WIDTH	  
	)
	port map (
	  i_DATA_A => w_o_SPC_ADDR,
	  i_DATA_B => "00000000000000000000000000000100",
	  o_DATA   => w_o_ADDER_INCR
	);

  u_ADDER_WRAP4 : adder
    generic map (
	  p_DATA_WIDTH    => 4
	)
	port map (
	  i_DATA_A => w_o_SPC_ADDR(3 downto 0),
	  i_DATA_B => "0100",
	  o_DATA   => w_o_ADDER_WRAP4
	);

  u_ADDER_WRAP8 : adder
    generic map (
	  p_DATA_WIDTH    => 5
	)
	port map (
	  i_DATA_A => w_o_SPC_ADDR(4 downto 0),
	  i_DATA_B => "00100",
	  o_DATA   => w_o_ADDER_WRAP8
	);

  u_ADDER_WRAP16 : adder
    generic map (
	  p_DATA_WIDTH    => 6
	)
	port map (
	  i_DATA_A => w_o_SPC_ADDR(5 downto 0),
	  i_DATA_B => "000100",
	  o_DATA   => w_o_ADDER_WRAP16
	);
	
	o_SPC_ADDR <= w_o_SPC_ADDR;
	o_SPC_BL   <= w_o_SPC_BL;

end rtl;