library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library work;
use work.xiru_package.all;

entity gen_slv_snd_dp is
  generic (
    p_X_SRC          : natural := 0;
    p_Y_SRC          : natural := 0;
    p_Z_SRC          : natural := 0
  );
  port (
    i_CLK               : in  std_logic;
    i_RST               : in  std_logic;
    i_FLIT_SEL          : in  std_logic_vector(1 downto 0);
    i_SPC_WAIT          : in  std_logic;
    i_SPC_OPC           : in  std_logic_vector(c_OPC_WIDTH-1 downto 0);
    i_SPC_BE            : in  std_logic_vector(c_BE_WIDTH-1 downto 0);
    i_SPC_DATA          : in  std_logic_vector(c_DATA_WIDTH-1 downto 0);
    i_DST               : in  std_logic_vector(c_X_ADDR_WIDTH+c_Y_ADDR_WIDTH+c_Z_ADDR_WIDTH-1 downto 0);
    o_NET_DATA          : out std_logic_vector(c_DATA_WIDTH+1 downto 0)
  );
end gen_slv_snd_dp;

architecture rtl of gen_slv_snd_dp is

  signal w_FLIT_SEL  : std_logic_vector(1 downto 0)              := (others => '0');
  signal w_FLIT_H0   : std_logic_vector(c_DATA_WIDTH-1 downto 0) := (others => '0');
  signal w_FLIT_H1   : std_logic_vector(c_DATA_WIDTH-1 downto 0) := (others => '0');
  signal w_FLIT_DATA : std_logic_vector(c_DATA_WIDTH-1 downto 0) := (others => '0');

  signal w_HE    : std_logic_vector(c_HE_WIDTH-1 downto 0)     := (others => '0');
  signal w_RSV   : std_logic_vector(c_RSV_WIDTH-1 downto 0)    := (others => '0');
  signal w_AGE   : std_logic_vector(c_AGE_WIDTH-1 downto 0)    := (others => '0');
  signal w_CLS   : std_logic_vector(c_CLS_WIDTH-1 downto 0)    := (others => '0');
  signal w_CMD   : std_logic_vector(c_CMD_WIDTH-1 downto 0)    := (others => '0');
  signal w_SEQ   : std_logic_vector(c_SEQ_WIDTH-1 downto 0)    := (others => '0');
  signal w_BL     : std_logic_vector(c_BL_WIDTH-1 downto 0)    := (others => '0'); --
  signal w_BS     : std_logic_vector(c_BS_WIDTH-1 downto 0)    := (others => '0'); --
  signal w_BE    : std_logic_vector(c_BE_WIDTH-1 downto 0)     := (others => '0');
  signal w_THID  : std_logic_vector(c_THID_WIDTH-1 downto 0)   := (others => '0');
  signal w_OPC   : std_logic_vector(c_OPC_WIDTH-1 downto 0)    := (others => '0');

  signal w_X_TSV : std_logic_vector(c_X_ADDR_WIDTH-1 downto 0) := (others => '0');
  signal w_Y_TSV : std_logic_vector(c_Y_ADDR_WIDTH-1 downto 0) := (others => '0');
  signal w_X_SRC : std_logic_vector(c_X_ADDR_WIDTH-1 downto 0) := (others => '0');
  signal w_Y_SRC : std_logic_vector(c_Y_ADDR_WIDTH-1 downto 0) := (others => '0');
  signal w_Z_SRC : std_logic_vector(c_Z_ADDR_WIDTH-1 downto 0) := (others => '0');
  signal w_DST   : std_logic_vector(c_X_ADDR_WIDTH+c_Y_ADDR_WIDTH+c_Z_ADDR_WIDTH-1 downto 0) := (others => '0');

  signal w_DATA_A: std_logic_vector(c_DATA_WIDTH+1 downto 0);
  signal w_DATA_B: std_logic_vector(c_DATA_WIDTH+1 downto 0);
  signal w_DATA_C: std_logic_vector(c_DATA_WIDTH+1 downto 0);
  signal w_DATA_D: std_logic_vector(c_DATA_WIDTH+1 downto 0); --
  
begin
  w_HE    <= "1";
  w_RSV   <= (others => '0');
  w_AGE   <= (others => '0');
  w_CLS   <= (others => '0');
  w_CMD   <= (others => '0');
  w_SEQ   <= (others => '0');
  w_THID  <= (others => '0');
  w_X_TSV <= (others => '0');
  w_Y_TSV <= (others => '0');
  w_X_SRC <= conv_std_logic_vector(p_X_SRC, c_X_ADDR_WIDTH);
  w_Y_SRC <= conv_std_logic_vector(p_Y_SRC, c_Y_ADDR_WIDTH);
  w_Z_SRC <= conv_std_logic_vector(p_Z_SRC, c_Z_ADDR_WIDTH);
  w_DST   <= i_DST;

  w_DATA_A <= c_FRAME_BOP & w_FLIT_H0;
  w_DATA_B <= c_FRAME_PL  & w_FLIT_H1;
  w_DATA_C <= c_FRAME_EOP & w_FLIT_DATA; --
  w_DATA_D <= c_FRAME_PL  & w_FLIT_DATA; --

  u_FLIT_SEL: mux4 --
    generic map (
      p_DATA_WIDTH => c_DATA_WIDTH+2
    )
    port map (
      i_DATA_A => w_DATA_A,
      i_DATA_B => w_DATA_B,
      i_DATA_C => w_DATA_C,
	  i_DATA_D => w_DATA_D,
      i_SEL    => i_FLIT_SEL,
      o_DATA   => o_NET_DATA
    );

  u_NOC_OPC_REG: reg
    generic map (
      p_DATA_WIDTH    => c_OPC_WIDTH,
      p_DEFAULT_VALUE => 0
    )
    port map ( 
      i_CLK  => i_CLK,
      i_RST  => i_RST,
      i_WR   => i_SPC_WAIT,
      i_DATA => i_SPC_OPC,
      o_DATA => w_OPC
    );

  u_NOC_BE_REG: reg
    generic map (
      p_DATA_WIDTH    => c_BE_WIDTH,
      p_DEFAULT_VALUE => 0
    )
    port map ( 
      i_CLK  => i_CLK,
      i_RST  => i_RST,
      i_WR   => i_SPC_WAIT,
      i_DATA => i_SPC_BE,
      o_DATA => w_BE
    );

  u_FLIT_DATA_REG: reg
    generic map (
      p_DATA_WIDTH    => c_DATA_WIDTH,
      p_DEFAULT_VALUE => 0
    )
    port map ( 
      i_CLK  => i_CLK,
      i_RST  => i_RST,
      i_WR   => i_SPC_WAIT,
      i_DATA => i_SPC_DATA,
      o_DATA => w_FLIT_DATA(c_DATA_WIDTH-1 downto 0)
    );

  w_FLIT_H0 <= w_HE & w_RSV & w_AGE & w_CLS & w_CMD & w_X_TSV & w_Y_TSV & w_DST;
  w_FLIT_H1 <= not(w_HE) & w_SEQ & w_BL & w_BS & w_BE & w_THID & w_OPC & w_X_SRC & w_Y_SRC & w_Z_SRC; --

end rtl;