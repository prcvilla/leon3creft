source "/home/pvilla/.local/share/data/Synplicity/scm_perforce.tcl"
history clear
project -load leon3mp_synplify.prj
set_option -result_file /home/pvilla/phd/grlib-gpl-1.5.0-b4164/designs/leon3-actel-proasic3/synplify/leon3mp.edn
set_option -technology ProASIC3E
set_option -report_path 4000
project -run  -bg 
text_select 3 64 3 76
project -run  -bg 
text_select 38 20 38 35
text_select 38 20 38 33
text_select 38 19 38 35
text_select 38 19 38 35
text_select 59 4 59 5
project -run  -bg 
project -save /home/pvilla/phd/grlib-gpl-1.5.0-b4164/designs/leon3-actel-proasic3/leon3mp_synplify.prj 
project -close /home/pvilla/phd/grlib-gpl-1.5.0-b4164/designs/leon3-actel-proasic3/leon3mp_synplify.prj
