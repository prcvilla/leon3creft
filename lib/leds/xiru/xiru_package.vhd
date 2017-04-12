library ieee;
use ieee.std_logic_1164.all;

package xiru_package is

  constant c_DATA_WIDTH     : natural := 32;
  constant c_ADDR_WIDTH     : natural := 32; --
  constant c_HE_WIDTH       : natural := 1;
  constant c_RSV_WIDTH      : natural := 5;
  constant c_AGE_WIDTH      : natural := 3;
  constant c_CLS_WIDTH      : natural := 3;
  constant c_CMD_WIDTH      : natural := 2;
  constant c_X_ADDR_WIDTH   : natural := 4;
  constant c_Y_ADDR_WIDTH   : natural := 4;
  constant c_Z_ADDR_WIDTH   : natural := 2;
  constant c_SEQ_WIDTH      : natural := 4;
  constant c_BL_WIDTH       : natural := 4; --
  constant c_BS_WIDTH		: natural := 3; --
  constant c_BE_WIDTH       : natural := 4;
  constant c_THID_WIDTH     : natural := 2;
  constant c_OPC_WIDTH      : natural := 4; --


  constant c_FRAME_BOP : std_logic_vector := "01";
  constant c_FRAME_EOP : std_logic_vector := "10";
  constant c_FRAME_PL  : std_logic_vector := "00";
  constant c_FRAME_NPL : std_logic_vector := "11";
  constant c_FRAME_ERR : std_logic_vector := "11";

  constant c_OPC_IDLE  : std_logic_vector := "0000"; --
  constant c_OPC_WR    : std_logic_vector := "0001"; --
  constant c_OPC_RD    : std_logic_vector := "0010"; --
  constant c_OPC_RDEX  : std_logic_vector := "0011"; --
  constant c_OPC_RDL   : std_logic_vector := "0100"; --
  constant c_OPC_WRNP  : std_logic_vector := "0101"; --
  constant c_OPC_WRC   : std_logic_vector := "0110"; --
  constant c_OPC_BCST  : std_logic_vector := "0111"; --
  constant c_OPC_WRB   : std_logic_vector := "1000"; --
  constant c_OPC_RDB   : std_logic_vector := "1001"; --

  constant c_OPC_NULL  : std_logic_vector := "0000";
  constant c_OPC_DVA   : std_logic_vector := "0001";
  constant c_OPC_FAIL  : std_logic_vector := "0010";
  constant c_OPC_ERR   : std_logic_vector := "0100";
  constant c_OPC_IRQ   : std_logic_vector := "0111";
  
  constant c_BL_ST     : std_logic_vector := "0000"; --
  constant c_BL_NS     : std_logic_vector := "0001"; --
  constant c_BL_4W     : std_logic_vector := "0011"; --
  constant c_BL_8W     : std_logic_vector := "0111"; --
  constant c_BL_16W    : std_logic_vector := "1111"; --
  
  constant c_BS_ST     : std_logic_vector :=  "000"; --
  constant c_BS_NS     : std_logic_vector :=  "001"; --
  constant c_BS_WRAP   : std_logic_vector :=  "010"; --
  constant c_BS_INCR   : std_logic_vector :=  "011"; --
  
  constant c_BE_8BIT   : std_logic_vector := "0001"; --
  constant c_BE_16BIT  : std_logic_vector := "0011"; --
  constant c_BE_32BIT  : std_logic_vector := "1111"; --

  constant c_CLS_REQ   : std_logic_vector := "0";
  constant c_CLS_RESP  : std_logic_vector := "1";
  constant c_CLS_NRT0  : std_logic_vector := "00";
  constant c_CLS_NRT1  : std_logic_vector := "01";
  constant c_CLS_RT0   : std_logic_vector := "10";
  constant c_CLS_RT1   : std_logic_vector := "11";

  component mux2 is
    generic (
      p_DATA_WIDTH : natural := 32
    );
    port (
      i_DATA_A : in  std_logic_vector(p_DATA_WIDTH-1 downto 0);
      i_DATA_B : in  std_logic_vector(p_DATA_WIDTH-1 downto 0);
      i_SEL    : in  std_logic;
      o_DATA   : out std_logic_vector(p_DATA_WIDTH-1 downto 0)
    );
  end component;
  
  component mux2_1 is
    port (
      i_DATA_A : in  std_logic;
      i_DATA_B : in  std_logic;
      i_SEL    : in  std_logic;
      o_DATA   : out std_logic
    );
  end component;

  component mux3 is
    generic (
      p_DATA_WIDTH : natural := 32
    );
    port (
      i_DATA_A : in  std_logic_vector(p_DATA_WIDTH-1 downto 0);
      i_DATA_B : in  std_logic_vector(p_DATA_WIDTH-1 downto 0);
      i_DATA_C : in  std_logic_vector(p_DATA_WIDTH-1 downto 0);
      i_SEL    : in  std_logic_vector(1 downto 0);
      o_DATA   : out std_logic_vector(p_DATA_WIDTH-1 downto 0)
    );
  end component;

  component mux4 is
    generic (
      p_DATA_WIDTH : natural := 32
    );
    port (
      i_DATA_A : in  std_logic_vector(p_DATA_WIDTH-1 downto 0);
      i_DATA_B : in  std_logic_vector(p_DATA_WIDTH-1 downto 0);
      i_DATA_C : in  std_logic_vector(p_DATA_WIDTH-1 downto 0);
      i_DATA_D : in  std_logic_vector(p_DATA_WIDTH-1 downto 0);
      i_SEL    : in  std_logic_vector(1 downto 0);
      o_DATA   : out std_logic_vector(p_DATA_WIDTH-1 downto 0)
    );
  end component;

  component mux5 is
    generic (
      p_DATA_WIDTH : natural := 32
    );
    port (
      i_DATA_A : in  std_logic_vector(p_DATA_WIDTH-1 downto 0);
      i_DATA_B : in  std_logic_vector(p_DATA_WIDTH-1 downto 0);
      i_DATA_C : in  std_logic_vector(p_DATA_WIDTH-1 downto 0);
      i_DATA_D : in  std_logic_vector(p_DATA_WIDTH-1 downto 0);
      i_DATA_E : in  std_logic_vector(p_DATA_WIDTH-1 downto 0);
      i_SEL    : in  std_logic_vector(2 downto 0);
      o_DATA   : out std_logic_vector(p_DATA_WIDTH-1 downto 0)
    );
  end component;

  component mux6 is
    generic (
      p_DATA_WIDTH : natural := 32
    );
    port (
      i_DATA_A : in  std_logic_vector(p_DATA_WIDTH-1 downto 0);
      i_DATA_B : in  std_logic_vector(p_DATA_WIDTH-1 downto 0);
      i_DATA_C : in  std_logic_vector(p_DATA_WIDTH-1 downto 0);
      i_DATA_D : in  std_logic_vector(p_DATA_WIDTH-1 downto 0);
      i_DATA_E : in  std_logic_vector(p_DATA_WIDTH-1 downto 0);
      i_DATA_F : in  std_logic_vector(p_DATA_WIDTH-1 downto 0);
      i_SEL    : in  std_logic_vector(2 downto 0);
      o_DATA   : out std_logic_vector(p_DATA_WIDTH-1 downto 0)
    );
  end component;

  component reg is
    generic (
      p_DATA_WIDTH    : natural := 32;
      p_DEFAULT_VALUE : natural := 0
    );
    port ( 
      i_CLK  : in  std_logic;
      i_RST  : in  std_logic;
      i_WR   : in  std_logic;
      i_DATA : in  std_logic_vector(p_DATA_WIDTH-1 downto 0);
      o_DATA : out std_logic_vector(p_DATA_WIDTH-1 downto 0)
    );
  end component;

  component fifo
    generic (
      p_FIFO_TYPE  : string  := "RING";
      p_WIDTH      : integer := 8;
      p_DEPTH      : integer := 4;
      p_LOG2_DEPTH : integer := 2
    );
    port (
      i_CLK  : in  std_logic;
      i_RST  : in  std_logic;
      o_ROK  : out std_logic;
      o_WOK  : out std_logic;
      i_RD   : in  std_logic;
      i_WR   : in  std_logic;
      i_DIN  : in  std_logic_vector(p_WIDTH - 1 downto 0);
      o_DOUT : out std_logic_vector(p_WIDTH - 1 downto 0)
    );
  end component;

  component ofc is
    generic (
      p_FC_TYPE   : string  := "CREDIT";    -- options: CREDIT or HANDSHAKE
      p_CREDIT    : integer := 4            -- maximum number of credits
    );
    port(
      i_RST : in  std_logic;  -- reset        
      i_CLK : in  std_logic;  -- clock  
      o_VAL : out std_logic;  -- data validation
      i_RET : in  std_logic;  -- return (credit or acknowledgement)
      o_RD  : out std_logic;  -- read comand 
      i_ROK : in  std_logic   -- FIFO not empty (it is able to be read)
    );
  end component;

  component ifc is
    generic (
      p_FC_TYPE   : string  := "CREDIT"     -- options: CREDIT or HANDSHAKE
    );
    port(
      i_CLK   : in  std_logic;  -- clock
      i_RST   : in  std_logic;  -- reset
      i_VAL   : in  std_logic;  -- data validation
      o_RET   : out std_logic;  -- return (credit or acknowledgement)
      o_WR    : out std_logic;  -- command to write a data into de FIFO
      i_WOK   : in  std_logic;  -- FIFO has room to be written (not full)
      i_RD    : in  std_logic;  -- command to read a data from the FIFO
      i_ROK   : in  std_logic   -- FIFO has a data to be read  (not empty)
    );
  end component;
  
  component adder is
    generic (
      p_DATA_WIDTH : integer := 32
    );
    port (
      i_DATA_A : in  std_logic_vector(p_DATA_WIDTH-1 downto 0);
      i_DATA_B : in  std_logic_vector(p_DATA_WIDTH-1 downto 0);
      o_DATA   : out std_logic_vector(p_DATA_WIDTH-1 downto 0);
	  o_CO     : out std_logic
    );
  end component;
  
  component down_counter is
    port (
      i_CLK         : in std_logic;
      i_RST         : in std_logic;
	  i_COUNTER_ENA : in std_logic;
	  i_BL_REG      : in std_logic_vector(3 downto 0);
	  o_COUNTER	    : out std_logic_vector (3 downto 0)	
    );
  end component;

end xiru_package;
