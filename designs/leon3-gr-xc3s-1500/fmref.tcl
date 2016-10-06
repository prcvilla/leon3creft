# Formality script to read reference design
read_vhdl -r -libname grlib ../../lib/grlib/stdlib/version.vhd
read_vhdl -r -libname grlib ../../lib/grlib/stdlib/config_types.vhd
read_vhdl -r -libname grlib ../../lib/grlib/stdlib/config.vhd
read_vhdl -r -libname grlib ../../lib/grlib/stdlib/stdlib.vhd
read_vhdl -r -libname grlib ../../lib/grlib/sparc/sparc.vhd
read_vhdl -r -libname grlib ../../lib/grlib/modgen/multlib.vhd
read_vhdl -r -libname grlib ../../lib/grlib/modgen/leaves.vhd
read_vhdl -r -libname grlib ../../lib/grlib/amba/amba.vhd
read_vhdl -r -libname grlib ../../lib/grlib/amba/devices.vhd
read_vhdl -r -libname grlib ../../lib/grlib/amba/defmst.vhd
read_vhdl -r -libname grlib ../../lib/grlib/amba/apbctrl.vhd
read_vhdl -r -libname grlib ../../lib/grlib/amba/apbctrlx.vhd
read_vhdl -r -libname grlib ../../lib/grlib/amba/apbctrldp.vhd
read_vhdl -r -libname grlib ../../lib/grlib/amba/apbctrlsp.vhd
read_vhdl -r -libname grlib ../../lib/grlib/amba/ahbctrl.vhd
read_vhdl -r -libname grlib ../../lib/grlib/amba/dma2ahb_pkg.vhd
read_vhdl -r -libname grlib ../../lib/grlib/amba/dma2ahb.vhd
read_vhdl -r -libname grlib ../../lib/grlib/amba/ahbmst.vhd
read_vhdl -r -libname grlib ../../lib/grlib/dftlib/dftlib.vhd
read_vhdl -r -libname grlib ../../lib/grlib/dftlib/synciotest.vhd
read_vhdl -r -libname techmap ../../lib/techmap/gencomp/gencomp.vhd
read_vhdl -r -libname techmap ../../lib/techmap/gencomp/netcomp.vhd
read_vhdl -r -libname techmap ../../lib/techmap/inferred/memory_inferred.vhd
read_vhdl -r -libname techmap ../../lib/techmap/inferred/ddr_inferred.vhd
read_vhdl -r -libname techmap ../../lib/techmap/inferred/mul_inferred.vhd
read_vhdl -r -libname techmap ../../lib/techmap/inferred/ddr_phy_inferred.vhd
read_vhdl -r -libname techmap ../../lib/techmap/inferred/ddrphy_datapath.vhd
read_vhdl -r -libname techmap ../../lib/techmap/inferred/fifo_inferred.vhd
read_vhdl -r -libname techmap ../../lib/techmap/maps/allclkgen.vhd
read_vhdl -r -libname techmap ../../lib/techmap/maps/techbuf.vhd
read_vhdl -r -libname techmap ../../lib/techmap/maps/allddr.vhd
read_vhdl -r -libname techmap ../../lib/techmap/maps/allmem.vhd
read_vhdl -r -libname techmap ../../lib/techmap/maps/allmul.vhd
read_vhdl -r -libname techmap ../../lib/techmap/maps/allpads.vhd
read_vhdl -r -libname techmap ../../lib/techmap/maps/alltap.vhd
read_vhdl -r -libname techmap ../../lib/techmap/maps/clkgen.vhd
read_vhdl -r -libname techmap ../../lib/techmap/maps/clkmux.vhd
read_vhdl -r -libname techmap ../../lib/techmap/maps/clkinv.vhd
read_vhdl -r -libname techmap ../../lib/techmap/maps/clkand.vhd
read_vhdl -r -libname techmap ../../lib/techmap/maps/grgates.vhd
read_vhdl -r -libname techmap ../../lib/techmap/maps/ddr_ireg.vhd
read_vhdl -r -libname techmap ../../lib/techmap/maps/ddr_oreg.vhd
read_vhdl -r -libname techmap ../../lib/techmap/maps/clkpad.vhd
read_vhdl -r -libname techmap ../../lib/techmap/maps/clkpad_ds.vhd
read_vhdl -r -libname techmap ../../lib/techmap/maps/inpad.vhd
read_vhdl -r -libname techmap ../../lib/techmap/maps/inpad_ds.vhd
read_vhdl -r -libname techmap ../../lib/techmap/maps/iodpad.vhd
read_vhdl -r -libname techmap ../../lib/techmap/maps/iopad.vhd
read_vhdl -r -libname techmap ../../lib/techmap/maps/iopad_ds.vhd
read_vhdl -r -libname techmap ../../lib/techmap/maps/lvds_combo.vhd
read_vhdl -r -libname techmap ../../lib/techmap/maps/odpad.vhd
read_vhdl -r -libname techmap ../../lib/techmap/maps/outpad.vhd
read_vhdl -r -libname techmap ../../lib/techmap/maps/outpad_ds.vhd
read_vhdl -r -libname techmap ../../lib/techmap/maps/toutpad.vhd
read_vhdl -r -libname techmap ../../lib/techmap/maps/toutpad_ds.vhd
read_vhdl -r -libname techmap ../../lib/techmap/maps/skew_outpad.vhd
read_vhdl -r -libname techmap ../../lib/techmap/maps/ddrphy.vhd
read_vhdl -r -libname techmap ../../lib/techmap/maps/syncram.vhd
read_vhdl -r -libname techmap ../../lib/techmap/maps/syncram64.vhd
read_vhdl -r -libname techmap ../../lib/techmap/maps/syncram_2p.vhd
read_vhdl -r -libname techmap ../../lib/techmap/maps/syncram_dp.vhd
read_vhdl -r -libname techmap ../../lib/techmap/maps/syncfifo_2p.vhd
read_vhdl -r -libname techmap ../../lib/techmap/maps/regfile_3p.vhd
read_vhdl -r -libname techmap ../../lib/techmap/maps/tap.vhd
read_vhdl -r -libname techmap ../../lib/techmap/maps/nandtree.vhd
read_vhdl -r -libname techmap ../../lib/techmap/maps/grlfpw_net.vhd
read_vhdl -r -libname techmap ../../lib/techmap/maps/grfpw_net.vhd
read_vhdl -r -libname techmap ../../lib/techmap/maps/leon3_net.vhd
read_vhdl -r -libname techmap ../../lib/techmap/maps/leon4_net.vhd
read_vhdl -r -libname techmap ../../lib/techmap/maps/mul_61x61.vhd
read_vhdl -r -libname techmap ../../lib/techmap/maps/cpu_disas_net.vhd
read_vhdl -r -libname techmap ../../lib/techmap/maps/ringosc.vhd
read_vhdl -r -libname techmap ../../lib/techmap/maps/grpci2_phy_net.vhd
read_vhdl -r -libname techmap ../../lib/techmap/maps/system_monitor.vhd
read_vhdl -r -libname techmap ../../lib/techmap/maps/inpad_ddr.vhd
read_vhdl -r -libname techmap ../../lib/techmap/maps/outpad_ddr.vhd
read_vhdl -r -libname techmap ../../lib/techmap/maps/iopad_ddr.vhd
read_vhdl -r -libname techmap ../../lib/techmap/maps/syncram128bw.vhd
read_vhdl -r -libname techmap ../../lib/techmap/maps/syncram256bw.vhd
read_vhdl -r -libname techmap ../../lib/techmap/maps/syncram128.vhd
read_vhdl -r -libname techmap ../../lib/techmap/maps/syncram156bw.vhd
read_vhdl -r -libname techmap ../../lib/techmap/maps/techmult.vhd
read_vhdl -r -libname techmap ../../lib/techmap/maps/spictrl_net.vhd
read_vhdl -r -libname techmap ../../lib/techmap/maps/scanreg.vhd
read_vhdl -r -libname techmap ../../lib/techmap/maps/syncrambw.vhd
read_vhdl -r -libname techmap ../../lib/techmap/maps/syncram_2pbw.vhd
read_vhdl -r -libname techmap ../../lib/techmap/maps/sdram_phy.vhd
read_vhdl -r -libname techmap ../../lib/techmap/maps/syncreg.vhd
read_vhdl -r -libname techmap ../../lib/techmap/maps/serdes.vhd
read_vhdl -r -libname techmap ../../lib/techmap/maps/iopad_tm.vhd
read_vhdl -r -libname techmap ../../lib/techmap/maps/toutpad_tm.vhd
read_vhdl -r -libname techmap ../../lib/techmap/maps/memrwcol.vhd
read_vhdl -r -libname spw ../../lib/spw/comp/spwcomp.vhd
read_vhdl -r -libname spw ../../lib/spw/wrapper/grspw_gen.vhd
read_vhdl -r -libname spw ../../lib/spw/wrapper/grspw2_gen.vhd
read_vhdl -r -libname spw ../../lib/spw/wrapper/grspw_codec_gen.vhd
read_vhdl -r -libname eth ../../lib/eth/comp/ethcomp.vhd
read_vhdl -r -libname eth ../../lib/eth/core/greth_pkg.vhd
read_vhdl -r -libname eth ../../lib/eth/core/eth_rstgen.vhd
read_vhdl -r -libname eth ../../lib/eth/core/eth_edcl_ahb_mst.vhd
read_vhdl -r -libname eth ../../lib/eth/core/eth_ahb_mst.vhd
read_vhdl -r -libname eth ../../lib/eth/core/greth_tx.vhd
read_vhdl -r -libname eth ../../lib/eth/core/greth_rx.vhd
read_vhdl -r -libname eth ../../lib/eth/core/grethc.vhd
read_vhdl -r -libname eth ../../lib/eth/wrapper/greth_gen.vhd
read_vhdl -r -libname eth ../../lib/eth/wrapper/greth_gbit_gen.vhd
read_vhdl -r -libname opencores ../../lib/opencores/can/cancomp.vhd
read_vhdl -r -libname opencores ../../lib/opencores/can/can_top.vhd
read_vhdl -r -libname opencores ../../lib/opencores/i2c/i2c_master_bit_ctrl.vhd
read_vhdl -r -libname opencores ../../lib/opencores/i2c/i2c_master_byte_ctrl.vhd
read_vhdl -r -libname opencores ../../lib/opencores/i2c/i2coc.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/pvilla/chk_control.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/pvilla/chk_regfile.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/arith/arith.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/arith/mul32.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/arith/div32.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/memctrl/memctrl.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/memctrl/sdctrl.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/memctrl/sdctrl64.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/memctrl/sdmctrl.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/memctrl/srctrl.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/srmmu/mmuconfig.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/srmmu/mmuiface.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/srmmu/libmmu.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/srmmu/mmutlbcam.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/srmmu/mmulrue.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/srmmu/mmulru.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/srmmu/mmutlb.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/srmmu/mmutw.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/srmmu/mmu.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/leon3/leon3.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/leon3/grfpushwx.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/leon3v3/tbufmem.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/leon3v3/tbufmem_2p.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/leon3v3/dsu3x.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/leon3v3/dsu3.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/leon3v3/dsu3_mb.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/leon3v3/libfpu.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/leon3v3/libiu.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/leon3v3/libcache.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/leon3v3/libleon3.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/leon3v3/regfile_3p_l3.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/leon3v3/mmu_acache.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/leon3v3/mmu_icache.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/leon3v3/mmu_dcache.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/leon3v3/cachemem.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/leon3v3/mmu_cache.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/leon3v3/iu3.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/leon3v3/proc3.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/leon3v3/leon3x.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/leon3v3/leon3cg.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/leon3v3/leon3s.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/leon3v3/leon3sh.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/leon3v3/l3stat.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/leon3v3/cmvalidbits.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/leon4/leon4.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/irqmp/irqmp.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/l2cache/pkg/l2cache.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/can/can.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/can/can_mod.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/can/can_oc.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/can/can_mc.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/can/canmux.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/can/can_rd.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/misc/misc.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/misc/rstgen.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/misc/gptimer.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/misc/ahbram.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/misc/ahbdpram.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/misc/ahbtrace_mmb.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/misc/ahbtrace_mb.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/misc/ahbtrace.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/misc/grgpio.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/misc/ahbstat.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/misc/logan.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/misc/apbps2.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/misc/charrom_package.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/misc/charrom.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/misc/apbvga.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/misc/svgactrl.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/misc/grsysmon.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/misc/gracectrl.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/misc/grgpreg.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/misc/ahb_mst_iface.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/misc/grgprbank.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/net/net.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/uart/uart.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/uart/libdcom.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/uart/apbuart.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/uart/dcom.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/uart/dcom_uart.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/uart/ahbuart.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/jtag/jtag.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/jtag/libjtagcom.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/jtag/jtagcom.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/jtag/bscanregs.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/jtag/bscanregsbd.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/jtag/jtagcom2.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/jtag/ahbjtag.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/jtag/ahbjtag_bsd.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/greth/ethernet_mac.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/greth/greth.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/greth/greth_mb.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/greth/greth_gbit.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/greth/greths.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/greth/greth_gbit_mb.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/greth/greths_mb.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/greth/grethm.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/greth/grethm_mb.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/greth/adapters/rgmii.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/greth/adapters/comma_detect.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/greth/adapters/elastic_buffer.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/greth/adapters/gmii_to_mii.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/greth/adapters/word_aligner.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/spacewire/spacewire.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/usb/grusb.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/i2c/i2c.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/i2c/i2cmst.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/i2c/i2cmst_gen.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/i2c/i2cslv.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/i2c/i2c2ahbx.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/i2c/i2c2ahb.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/i2c/i2c2ahb_apb.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/i2c/i2c2ahb_gen.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/i2c/i2c2ahb_apb_gen.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/spi/spi.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/spi/spimctrl.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/spi/spictrlx.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/spi/spictrl.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/spi/spi2ahbx.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/spi/spi2ahb.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/spi/spi2ahb_apb.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/grdmac/grdmac_pkg.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/grdmac/apbmem.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/grdmac/grdmac_ahbmst.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/grdmac/grdmac_alignram.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/grdmac/grdmac.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/grdmac/grdmac_1p.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/subsys/subsys.vhd
read_vhdl -r -libname gaisler ../../lib/gaisler/subsys/leon_dsu_stat_base.vhd
read_vhdl -r -libname esa ../../lib/esa/memoryctrl/memoryctrl.vhd
read_vhdl -r -libname esa ../../lib/esa/memoryctrl/mctrl.vhd
read_vhdl -r -libname work config.vhd
read_vhdl -r -libname work ahbrom.vhd
read_vhdl -r -libname work vga_clkgen.vhd
read_vhdl -r -libname work leon3mp.vhd
