# Created by Microsemi Libero Software 11.7.0.119
# Wed Mar 16 15:07:06 2016

# (OPEN DESIGN)

open_design "leon3mp.adb"

# set default back-annotation base-name
set_defvar "BA_NAME" "leon3mp_ba"
set_defvar "IDE_DESIGNERVIEW_NAME" {Impl1}
set_defvar "IDE_DESIGNERVIEW_COUNT" "1"
set_defvar "IDE_DESIGNERVIEW_REV0" {Impl1}
set_defvar "IDE_DESIGNERVIEW_REVNUM0" "1"
set_defvar "IDE_DESIGNERVIEW_ROOTDIR" {/home/pvilla/phd/grlib-gpl-1.5.0-b4164/designs/leon3-actel-proasic3/designer}
set_defvar "IDE_DESIGNERVIEW_LASTREV" "1"


# import of input files
import_source  \
-format "edif" -edif_flavor "GENERIC" -netlist_naming "VHDL" {../../synthesis/leon3mp.edn} -merge_physical "no" -merge_timing "yes"
compile
report -type "status" {leon3mp_compile_report.txt}
report -type "pin" -listby "name" {leon3mp_report_pin_byname.txt}
report -type "pin" -listby "number" {leon3mp_report_pin_bynumber.txt}

save_design
