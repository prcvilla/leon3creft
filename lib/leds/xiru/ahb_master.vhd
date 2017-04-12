library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library work;

entity ahb_master is
  port (
    i_CLK           : in  std_logic                      := '0';
	i_RST           : in  std_logic                      := '0';
    mst_hbusreq     : out std_logic                      := '0';             --   ahb_master.hbusreq
    mst_hlock       : out std_logic                      := '0';             --             .hlock
    mst_haddr       : out std_logic_vector(31 downto 0)  := (others => '0'); --             .haddr
    mst_htrans      : out std_logic_vector(1 downto 0)   := (others => '0'); --             .htrans
    mst_hwrite      : out std_logic                      := '0';             --             .hwrite
    mst_hsize       : out std_logic_vector(2 downto 0)   := (others => '0'); --             .hsize
    mst_hburst      : out std_logic_vector(2 downto 0)   := (others => '0'); --             .hburst
    mst_hprot       : out std_logic_vector(3 downto 0)   := (others => '0'); --             .hprot
    mst_hwdata      : out std_logic_vector(31 downto 0)  := (others => '0'); --             .hwdata
    mst_hgrant      : in  std_logic_vector(15 downto 0)  := (others => '0'); --             .hgrant
    mst_hready      : in  std_logic				         := '0';             --             .hready
    mst_hresp       : in  std_logic_vector(1 downto 0)   := (others => '0'); --             .hresp
    mst_hrdata      : in  std_logic_vector(31 downto 0)  := (others => '0')  --             .hrdata
  );
end ahb_master;

architecture rtl of ahb_master is

  type t_STATE is (S0, S1, S2, S3, S4);
  signal r_STATE      : t_STATE;
  signal r_NEXT_STATE : t_STATE;

begin

  process (i_CLK, i_RST)
  begin
    if (i_RST='1') then
      r_STATE <= S0;
    elsif (i_CLK'event and i_CLK='1') then
      r_STATE <= r_NEXT_STATE;
    end if;
  end process;
  
  process (r_STATE, mst_hready, mst_hresp)
  begin
    case r_STATE is
	  when S0 => if (mst_hready = '1' and mst_hresp = "00") then
	               r_NEXT_STATE <= S1;
				 else
				   r_NEXT_STATE <= S0;
				 end if;
				
	  when S1 => if (mst_hready = '1' and mst_hresp = "00") then
	               r_NEXT_STATE <= S2;
				 else
				   r_NEXT_STATE <= S1;
				 end if;
				 
	  when S2 => if (mst_hready = '1' and mst_hresp = "00") then
	               r_NEXT_STATE <= S3;
				 else
				   r_NEXT_STATE <= S2;
				 end if;
	
	  when S3 => if (mst_hready = '1' and mst_hresp = "00") then
	               r_NEXT_STATE <= S4;
				 else
				   r_NEXT_STATE <= S3;
				 end if;
				 
	  when S4 => r_NEXT_STATE <= S0;
	end case;
  end process;
  
  mst_haddr <= x"00000000" when r_STATE = S0 else -- endereço zerado
			   x"400FFF08" when r_STATE = S1 else -- endereço 1
               x"400FFF0C" when r_STATE = S2 else -- endereço 2
			   x"400FFF10" when r_STATE = S3 else -- endereço 3
			   x"400FFF14" when r_STATE = S4;     -- endereço 4
			   
			   
  mst_htrans <= "00" when r_STATE = S0 else -- idle
                "10" when r_STATE = S1 else -- transf. nao sequencial
				"11" when (r_STATE = S2 or r_STATE = S3 or r_STATE = S4); -- transf. sequencial
				
  mst_hwrite <= '0' when r_STATE = S0 else
                '1' when (r_STATE = S1 or r_STATE = S2 or r_STATE = S3 or r_STATE = S4); -- escrita
	
  mst_hsize <= "000" when r_STATE = S0 else
               "010" when (r_STATE = S1 or r_STATE = S2 or r_STATE = S3 or r_STATE = S4); -- word 32 bits

  mst_hburst <= "011"; -- rajada INCR4
  
  mst_hwdata <= x"00000000" when r_STATE = S0 else -- dado zerado
                x"FAFAFAFA" when r_STATE = S1 else -- dado 1
				x"BABABABA" when r_STATE = S2 else -- dado 2
				x"DADADADA" when r_STATE = S3 else -- dado 3
				x"CECECECE" when r_STATE = S4;     -- dado 4
end rtl;
				
				
  
  
  