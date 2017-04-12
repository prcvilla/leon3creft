------------------------------------------------------------------------------
-- project: paris
-- entity : x (cross_point_matrix)
------------------------------------------------------------------------------
-- description: configuration matrix used to allow quartus ii to generate 
-- the desired router based on the type of routing algorithm to be used.
-- it ensures that only the components related with allowed routes will be
-- implemented.
------------------------------------------------------------------------------
-- authors: Frederico G. M. do Espirito Santo 
--          Cesar Albenes Zeferino
-- contact: zeferino@univali.br or cesar.zeferino@gmail.com
------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;
use ieee.std_logic_1164.all;
-----------
-----------
entity x is
-----------
-----------
  generic (
    p_ROUTING_TYPE : string := "XY"  -- options are XY or WF
  );
  port (
    i_L_REQN  : in  std_logic;
    i_L_REQE  : in  std_logic;
    i_L_REQS  : in  std_logic;
    i_L_REQW  : in  std_logic;
    --------------------------
    o_L_REQN  : out std_logic;
    o_L_REQE  : out std_logic;
    o_L_REQS  : out std_logic;
    o_L_REQW  : out std_logic;
    --------------------------
    i_N_REQL  : in  std_logic;
    i_N_REQE  : in  std_logic;
    i_N_REQS  : in  std_logic;
    i_N_REQW  : in  std_logic;
    --------------------------
    o_N_REQL  : out std_logic;
    o_N_REQE  : out std_logic;
    o_N_REQS  : out std_logic;
    o_N_REQW  : out std_logic;
    --------------------------
    i_E_REQL  : in  std_logic;
    i_E_REQN  : in  std_logic;
    i_E_REQS  : in  std_logic;
    i_E_REQW  : in  std_logic;
    --------------------------
    o_E_REQL  : out std_logic;
    o_E_REQN  : out std_logic;
    o_E_REQS  : out std_logic;
    o_E_REQW  : out std_logic;
    --------------------------
    i_S_REQL  : in  std_logic;
    i_S_REQN  : in  std_logic;
    i_S_REQE  : in  std_logic;
    i_S_REQW  : in  std_logic;
    --------------------------
    o_S_REQL  : out std_logic;  
    o_S_REQN  : out std_logic;  
    o_S_REQE  : out std_logic;  
    o_S_REQW  : out std_logic;
    --------------------------
    i_W_REQL  : in  std_logic;
    i_W_REQN  : in  std_logic;
    i_W_REQE  : in  std_logic;
    i_W_REQS  : in  std_logic;
    --------------------------
    o_W_REQL  : out std_logic;
    o_W_REQN  : out std_logic;
    o_W_REQE  : out std_logic;
    o_W_REQS  : out std_logic;
    --------------------------
    --------------------------
    i_L_GNTN  : in  std_logic;
    i_L_GNTE  : in  std_logic;
    i_L_GNTS  : in  std_logic;
    i_L_GNTW  : in  std_logic;
    --------------------------
    o_L_GNTN  : out std_logic;
    o_L_GNTE  : out std_logic;
    o_L_GNTS  : out std_logic;
    o_L_GNTW  : out std_logic;
    --------------------------
    i_N_GNTL  : in  std_logic;
    i_N_GNTE  : in  std_logic;
    i_N_GNTS  : in  std_logic;
    i_N_GNTW  : in  std_logic;
    --------------------------
    o_N_GNTL  : out std_logic;
    o_N_GNTE  : out std_logic;
    o_N_GNTS  : out std_logic;
    o_N_GNTW  : out std_logic;
    --------------------------
    i_E_GNTL  : in  std_logic;
    i_E_GNTN  : in  std_logic;
    i_E_GNTS  : in  std_logic;
    i_E_GNTW  : in  std_logic;
    --------------------------
    o_E_GNTL  : out std_logic;
    o_E_GNTN  : out std_logic;
    o_E_GNTS  : out std_logic;
    o_E_GNTW  : out std_logic;
    --------------------------
    i_S_GNTL  : in  std_logic;
    i_S_GNTN  : in  std_logic;
    i_S_GNTE  : in  std_logic;
    i_S_GNTW  : in  std_logic;
    --------------------------
    o_S_GNTL  : out std_logic;
    o_S_GNTN  : out std_logic;
    o_S_GNTE  : out std_logic;
    o_S_GNTW  : out std_logic;
    --------------------------
    i_W_GNTL  : in  std_logic;
    i_W_GNTN  : in  std_logic;
    i_W_GNTE  : in  std_logic;
    i_W_GNTS  : in  std_logic;
    --------------------------
    o_W_GNTL  : out std_logic;
    o_W_GNTN  : out std_logic;
    o_W_GNTE  : out std_logic;
    o_W_GNTS  : out std_logic);
    --------------------------
end x;

---------------------------
---------------------------
architecture arch_1 of x is
---------------------------
---------------------------
begin

  ------------
  xy_routing :
  ------------
    if (p_ROUTING_TYPE = "XY") generate
      
      o_L_REQN <= i_L_REQN;
      o_L_REQE <= i_L_REQE;
      o_L_REQS <= i_L_REQS;
      o_L_REQW <= i_L_REQW;
      ----------------------
      o_N_REQL <= i_N_REQL;
      o_N_REQE <= '0';
      o_N_REQS <= i_N_REQS;
      o_N_REQW <= '0';
      ----------------------
      o_E_REQL <= i_E_REQL;
      o_E_REQN <= i_E_REQN;
      o_E_REQS <= i_E_REQS;
      o_E_REQW <= i_E_REQW;
      ----------------------
      o_S_REQL <= i_S_REQL;
      o_S_REQN <= i_S_REQN;
      o_S_REQE <= '0';
      o_S_REQW <= '0';
      ----------------------
      o_W_REQL <= i_W_REQL;
      o_W_REQN <= i_W_REQN;
      o_W_REQE <= i_W_REQE;
      o_W_REQS <= i_W_REQS;
      ----------------------
      o_L_GNTN <= i_L_GNTN;
      o_L_GNTE <= i_L_GNTE;
      o_L_GNTS <= i_L_GNTS;
      o_L_GNTW <= i_L_GNTW;
      ----------------------
      o_N_GNTL <= i_N_GNTL;
      o_N_GNTE <= i_N_GNTE;
      o_N_GNTS <= i_N_GNTS;
      o_N_GNTW <= i_N_GNTW;
      ----------------------
      o_E_GNTL <= i_E_GNTL; 
      o_E_GNTN <= '0';
      o_E_GNTS <= '0';
      o_E_GNTW <= i_E_GNTW;
      ----------------------
      o_S_GNTL <= i_S_GNTL;
      o_S_GNTN <= i_S_GNTN;
      o_S_GNTE <= i_S_GNTE;
      o_S_GNTW <= i_S_GNTW;
      ----------------------
      o_W_GNTL <= i_W_GNTL;
      o_W_GNTN <= '0';
      o_W_GNTE <= i_W_GNTE;
      o_W_GNTS <= '0';
      
    end generate;

  ------------
  wf_routing :
  ------------
    if (p_ROUTING_TYPE = "WF") generate
      
      o_L_REQN <= i_L_REQN;
      o_L_REQE <= i_L_REQE;
      o_L_REQS <= i_L_REQS;
      o_L_REQW <= i_L_REQW;
      ----------------------
      o_N_REQL <= i_N_REQL;
      o_N_REQE <= i_N_REQE;
      o_N_REQS <= i_N_REQS;
      o_N_REQW <= '0';
      ----------------------
      o_E_REQL <= i_E_REQL;
      o_E_REQN <= i_E_REQN;
      o_E_REQS <= i_E_REQS;
      o_E_REQW <= i_E_REQW;
      ----------------------
      o_S_REQL <= i_S_REQL;
      o_S_REQN <= i_S_REQN;
      o_S_REQE <= i_S_REQE;
      o_S_REQW <= '0';
      ----------------------
      o_W_REQL <= i_W_REQL;
      o_W_REQN <= i_W_REQN;
      o_W_REQE <= i_W_REQE;
      o_W_REQS <= i_W_REQS;
      ----------------------
      o_L_GNTN <= i_L_GNTN;
      o_L_GNTE <= i_L_GNTE;
      o_L_GNTS <= i_L_GNTS;
      o_L_GNTW <= i_L_GNTW;
      ----------------------
      o_N_GNTL <= i_N_GNTL;
      o_N_GNTE <= i_N_GNTE;
      o_N_GNTS <= i_N_GNTS;
      o_N_GNTW <= i_N_GNTW;
      ----------------------
      o_E_GNTL <= i_E_GNTL; 
      o_E_GNTN <= i_E_GNTN;
      o_E_GNTS <= i_E_GNTS;
      o_E_GNTW <= i_E_GNTW;
      ----------------------
      o_S_GNTL <= i_S_GNTL;
      o_S_GNTN <= i_S_GNTN;
      o_S_GNTE <= i_S_GNTE;
      o_S_GNTW <= i_S_GNTW;
      ----------------------
      o_W_GNTL <= i_W_GNTL;
      o_W_GNTN <= '0';
      o_W_GNTE <= i_W_GNTE;
      o_W_GNTS <= '0';

    end generate;

end arch_1;

