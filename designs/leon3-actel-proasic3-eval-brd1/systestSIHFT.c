$ grep -riIn gr-pci .
./config.help:873:  board, but not on the GR-PCI-XC2V3000 or Avnet XCV1500E boards.
./designer/impl1/designer.log:26:              C:\grlib-test\boards\gr-pci-xc2v\default.sdc
./designer/impl1/leon3mp.ide_des:15:VALUE "C:\grlib-test\boards\gr-pci-xc2v\default.sdc;sdc"
./leon3mp.ldf:978:        <Source name="../../boards/gr-pci-xc2v/leon3mp.ucf" type="Logic Preference" type_short="LPF">
./leon3mp.ldf:981:        <Source name="../../boards/gr-pci-xc2v/default.sdc" type="Synplify Design Constraints File" type_short="SDC">
./leon3mp.npl:308:DEPASSOC leon3mp ..\..\boards\gr-pci-xc2v\leon3mp.ucf
./leon3mp.xise:17:    <file xil_pn:name="../../boards/gr-pci-xc2v/leon3mp.ucf" xil_pn:type="FILE_UCF">
./leon3mp_ise.tcl:583:xfile add "../../boards/gr-pci-xc2v/leon3mp.ucf"
./leon3mp_libero.prj:86:VALUE "<project>\..\..\boards\gr-pci-xc2v\default.sdc,sdc"
./leon3mp_synplify.npl:12:DEPASSOC leon3mp ..\..\boards\gr-pci-xc2v\leon3mp.ucf
./leon3mp_synplify.prj:285:add_file -constraint "../../boards/gr-pci-xc2v/default.sdc"
./leon3mp_synplify_win32.npl:12:DEPASSOC leon3mp ..\..\boards\gr-pci-xc2v\leon3mp.ucf
./leon3mp_win32.npl:308:DEPASSOC leon3mp ..\..\boards\gr-pci-xc2v\leon3mp.ucf
./libero_syn_files:1707:VALUE "<project>/../../boards/gr-pci-xc2v/default.sdc,sdc"
./Makefile:3:BOARD=gr-pci-xc2v
./synplify/backup/leon3mp.srr:5766:Reading constraint file: C:\grlib-test\boards\gr-pci-xc2v\default.sdc
./synplify/backup/leon3mp.srr:5772:@W: BN331 :"C:/grlib-test/boards/gr-pci-xc2v/default.sdc":14:0:14:0|object list is missing for clock, using clock name as object name : define_clock -name {pci_clk} -period {30.000} -clockgroup {pci_clkgroup} -route {5.000}
./synplify/leon3mp.srr:6898:Constraint File(s):    C:\grlib-test\boards\gr-pci-xc2v\default.sdc
./synplify/leon3mp_scck.rpt:10:Constraint File(s):      "C:\grlib-test\boards\gr-pci-xc2v\default.sdc"
./synplify/run_options.txt:285:add_file -constraint "../../boards/gr-pci-xc2v/default.sdc"
./synplify/scratchproject.prs:285:add_file -constraint "C:/grlib-test/boards/gr-pci-xc2v/default.sdc"
./synplify/synlog/leon3mp_fpga_mapper.srr:873:Constraint File(s):    C:\grlib-test\boards\gr-pci-xc2v\default.sdc
./synplify/synlog/leon3mp_fpga_mapper.srr_Min:15:Constraint File(s):    C:\grlib-test\boards\gr-pci-xc2v\default.sdc
./synplify/synlog/leon3mp_premap.srr:7:Reading constraint file: C:\grlib-test\boards\gr-pci-xc2v\default.sdc
./synplify/synlog/leon3mp_premap.srr:13:@W: BN331 :"C:/grlib-test/boards/gr-pci-xc2v/default.sdc":14:0:14:0|object list is missing for clock, using clock name as object name : define_clock -name {pci_clk} -period {30.000} -clockgroup {pci_clkgroup} -route {5.000}
./synplify/synlog/report/leon3mp_premap_warnings.txt:1:@W: BN331 :"C:/grlib-test/boards/gr-pci-xc2v/default.sdc":14:0:14:0|object list is missing for clock, using clock name as object name : define_clock -name {pci_clk} -period {30.000} -clockgroup {pci_clkgroup} -route {5.000}
./synplify/syntmp/cmdrec_fpga_mapper.log:1:c:\Microsemi\Libero_v11.6\Synopsys\fpga_J-2015.03M-3\bin\m_proasic.exe  -prodtype  synplify_pro  -encrypt  -pro  -rundir  C:\grlib-test\designs\leon3mp\synplify   -part A3PE1500  -package PQFP208-grade -2    -maxfan 24 -globalthreshold 50 -opcond COMWC -report_path 4000 -RWCheckOnRam 0 -ovhdl "leon3mp.vhm" -summaryfile C:\grlib-test\designs\leon3mp\synplify\synlog\report\leon3mp_fpga_mapper.xml  -top_level_module  leon3mp  -licensetype  synplifypro_actel  -flow mapping  -mp  1  -prjfile  C:\grlib-test\designs\leon3mp\synplify\scratchproject.prs  -implementation  synplify  -multisrs  -oedif  C:\grlib-test\designs\leon3mp\synplify\leon3mp.edn   -freq 45.000   -tcl  C:\grlib-test\boards\gr-pci-xc2v\default.sdc  C:\grlib-test\designs\leon3mp\synplify\synwork\leon3mp_prem.srd  -sap  C:\grlib-test\designs\leon3mp\synplify\leon3mp.sap  -otap  C:\grlib-test\designs\leon3mp\synplify\leon3mp.tap  -omap  C:\grlib-test\designs\leon3mp\synplify\leon3mp.map  -devicelib  c:\Microsemi\Libero_v11.6\Synopsys\fpga_J-2015.03M-3\lib\proasic\proasic3e.v  -sap  C:\grlib-test\designs\leon3mp\synplify\leon3mp.sap  -ologparam  C:\grlib-test\designs\leon3mp\synplify\syntmp\leon3mp.plg  -noforwanno  -osyn  C:\grlib-test\designs\leon3mp\synplify\leon3mp.srm  -prjdir  C:\grlib-test\designs\leon3mp\  -prjname  leon3mp_synplify  -log  C:\grlib-test\designs\leon3mp\synplify\synlog\leon3mp_fpga_mapper.srr
./synplify/syntmp/cmdrec_fpga_mapper.log:5:C:\grlib-test\boards\gr-pci-xc2v\default.sdc|i|1430917706|1167
./synplify/syntmp/cmdrec_premap.log:1:c:\Microsemi\Libero_v11.6\Synopsys\fpga_J-2015.03M-3\bin\m_proasic.exe  -mp  1  -prjfile  C:\grlib-test\designs\leon3mp\synplify\scratchproject.prs  -implementation  synplify  -prodtype  synplify_pro  -encrypt  -pro  -rundir  C:\grlib-test\designs\leon3mp\synplify   -part A3PE1500 -package PQFP208  -grade -2    -maxfan 24 -globalthreshold 50 -opcond COMWC -report_path 4000 -RWCheckOnRam 0 -ovhdl "leon3mp.vhm" -summaryfile C:\grlib-test\designs\leon3mp\synplify\synlog\report\leon3mp_premap.xml  -top_level_module  leon3mp  -oedif  C:\grlib-test\designs\leon3mp\synplify\leon3mp.edn  -conchk_prepass  C:\grlib-test\designs\leon3mp\synplify\leon3mp_cck_prepass.rpt   -freq 45.000   -tcl  C:\grlib-test\boards\gr-pci-xc2v\default.sdc  C:\grlib-test\designs\leon3mp\synplify\synwork\leon3mp_mult.srs  -flow prepass  -gcc_prepass  -osrd  C:\grlib-test\designs\leon3mp\synplify\synwork\leon3mp_prem.srd  -qsap  C:\grlib-test\designs\leon3mp\synplify\leon3mp.sap  -devicelib  c:\Microsemi\Libero_v11.6\Synopsys\fpga_J-2015.03M-3\lib\proasic\proasic3e.v  -ologparam  C:\grlib-test\designs\leon3mp\synplify\syntmp\leon3mp.plg  -noforwanno  -osyn  C:\grlib-test\designs\leon3mp\synplify\synwork\leon3mp_prem.srd  -prjdir  C:\grlib-test\designs\leon3mp\  -prjname  leon3mp_synplify  -log  C:\grlib-test\designs\leon3mp\synplify\synlog\leon3mp_premap.srr
./synplify/syntmp/cmdrec_premap.log:6:C:\grlib-test\boards\gr-pci-xc2v\default.sdc|i|1430917706|1167
./synplify/syntmp/leon3mp_premap_srr.htm:9:Reading constraint file: C:\grlib-test\boards\gr-pci-xc2v\default.sdc
./synplify/syntmp/leon3mp_premap_srr.htm:15:<font color=#A52A2A>@W:<a href="@W:BN331:@XP_HELP">BN331</a> : <a href="C:\grlib-test\boards\gr-pci-xc2v\default.sdc:14:0:14:1:@W:BN331:@XP_MSG">default.sdc(14)</a><!@TM:1444845270> | object listis missing for clock, using clock name as object name : define_clock -name {pci_clk} -period {30.000} -clockgroup {pci_clkgroup} -route {5.000}</font>
./synplify/syntmp/leon3mp_srr.htm:6900:Constraint File(s):    C:\grlib-test\boards\gr-pci-xc2v\default.sdc
./synthesis/backup/leon3mp.srr:5862:Reading constraint file: C:\grlib-test\designs\leon3mp\..\..\boards\gr-pci-xc2v\default.sdc
./synthesis/backup/leon3mp.srr:5868:@W: BN331 :"C:/grlib-test/boards/gr-pci-xc2v/default.sdc":14:0:14:0|object list is missing for clock, using clock name as object name : define_clock -name {pci_clk} -period {30.000} -clockgroup {pci_clkgroup} -route {5.000}
./synthesis/leon3mp_syn.prj:143:add_file -constraint "C:/grlib-test/designs/leon3mp/../../boards/gr-pci-xc2v/default.sdc"
./synthesis/run_options.txt:147:add_file -constraint "C:/grlib-test/designs/leon3mp/../../boards/gr-pci-xc2v/default.sdc"
./synthesis/scratchproject.prs:147:add_file -constraint "C:/grlib-test/designs/leon3mp/../../boards/gr-pci-xc2v/default.sdc"
./synthesis/synlog/leon3mp_fpga_mapper.srr_Min:15:Constraint File(s):    C:\grlib-test\designs\leon3mp\..\..\boards\gr-pci-xc2v\default.sdc