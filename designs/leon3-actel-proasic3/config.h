/*
 * Automatically generated C config: don't edit
 */
#define AUTOCONF_INCLUDED
/*
 * Synthesis      
 */
#undef  CONFIG_SYN_INFERRED
#undef  CONFIG_SYN_STRATIX
#undef  CONFIG_SYN_STRATIXII
#undef  CONFIG_SYN_STRATIXIII
#undef  CONFIG_SYN_CYCLONEIII
#undef  CONFIG_SYN_ALTERA
#undef  CONFIG_SYN_AXCEL
#undef  CONFIG_SYN_PROASIC
#undef  CONFIG_SYN_PROASICPLUS
#define CONFIG_SYN_PROASIC3 1
#undef  CONFIG_SYN_UT025CRH
#undef  CONFIG_SYN_ATC18
#undef  CONFIG_SYN_ATC18RHA
#undef  CONFIG_SYN_CUSTOM1
#undef  CONFIG_SYN_EASIC90
#undef  CONFIG_SYN_IHP25
#undef  CONFIG_SYN_IHP25RH
#undef  CONFIG_SYN_LATTICE
#undef  CONFIG_SYN_ECLIPSE
#undef  CONFIG_SYN_PEREGRINE
#undef  CONFIG_SYN_RH_LIB18T
#undef  CONFIG_SYN_RHUMC
#undef  CONFIG_SYN_SMIC13
#undef  CONFIG_SYN_SPARTAN2
#undef  CONFIG_SYN_SPARTAN3
#undef  CONFIG_SYN_SPARTAN3E
#undef  CONFIG_SYN_VIRTEX
#undef  CONFIG_SYN_VIRTEXE
#undef  CONFIG_SYN_VIRTEX2
#undef  CONFIG_SYN_VIRTEX4
#undef  CONFIG_SYN_VIRTEX5
#undef  CONFIG_SYN_UMC
#undef  CONFIG_SYN_TSMC90
#undef  CONFIG_SYN_INFER_RAM
#define CONFIG_SYN_INFER_PADS 1
#undef  CONFIG_SYN_NO_ASYNC
#undef  CONFIG_SYN_SCAN
/*
 * Clock generation
 */
#undef  CONFIG_CLK_INFERRED
#undef  CONFIG_CLK_HCLKBUF
#undef  CONFIG_CLK_ALTDLL
#undef  CONFIG_CLK_LATDLL
#define CONFIG_CLK_PRO3PLL 1
#undef  CONFIG_CLK_LIB18T
#undef  CONFIG_CLK_RHUMC
#undef  CONFIG_CLK_CLKDLL
#undef  CONFIG_CLK_DCM
#define CONFIG_CLK_MUL (45)
#define CONFIG_CLK_DIV (9)
#define CONFIG_OCLK_DIV (8)
#undef  CONFIG_PCI_SYSCLK
#define CONFIG_LEON3 1
#define CONFIG_PROC_NUM (1)
/*
 * Processor            
 */
/*
 * Integer unit                                           
 */
#define CONFIG_IU_NWINDOWS (8)
#undef  CONFIG_IU_V8MULDIV
#define CONFIG_IU_SVT 1
#define CONFIG_IU_LDELAY (1)
#define CONFIG_IU_WATCHPOINTS (0)
#define CONFIG_PWD 1
#define CONFIG_IU_RSTADDR 00000
/*
 * Floating-point unit
 */
#undef  CONFIG_FPU_ENABLE
/*
 * Cache system
 */
#undef  CONFIG_ICACHE_ENABLE
#undef  CONFIG_ICACHE_LRAM
#undef  CONFIG_DCACHE_ENABLE
#define CONFIG_DCACHE_LRAM 1
#undef  CONFIG_DCACHE_LRAM_SZ1
#undef  CONFIG_DCACHE_LRAM_SZ2
#define CONFIG_DCACHE_LRAM_SZ4 1
#undef  CONFIG_DCACHE_LRAM_SZ8
#undef  CONFIG_DCACHE_LRAM_SZ16
#undef  CONFIG_DCACHE_LRAM_SZ32
#undef  CONFIG_DCACHE_LRAM_SZ64
#undef  CONFIG_DCACHE_LRAM_SZ128
#undef  CONFIG_DCACHE_LRAM_SZ256
#define CONFIG_DCACHE_LRSTART 8f
/*
 * MMU
 */
#undef  CONFIG_MMU_ENABLE
/*
 * Debug Support Unit        
 */
#define CONFIG_DSU_ENABLE 1
#undef  CONFIG_DSU_ITRACE
#undef  CONFIG_DSU_ATRACE
/*
 * Fault-tolerance  
 */
/*
 * VHDL debug settings       
 */
#undef  CONFIG_IU_DISAS
#undef  CONFIG_DEBUG_PC32
/*
 * AMBA configuration
 */
#define CONFIG_AHB_DEFMST (0)
#define CONFIG_AHB_RROBIN 1
#undef  CONFIG_AHB_SPLIT
#define CONFIG_AHB_IOADDR FFF
#define CONFIG_APB_HADDR 800
#undef  CONFIG_AHB_MON
/*
 * Debug Link           
 */
#define CONFIG_DSU_UART 1
#undef  CONFIG_DSU_JTAG
/*
 * Memory controllers             
 */
/*
 * Leon2 memory controller        
 */
#undef  CONFIG_MCTRL_LEON2
/*
 * Synchronous SRAM controller   
 */
#undef  CONFIG_SSCTRL
/*
 * Peripherals             
 */
/*
 * On-chip RAM/ROM                 
 */
#define CONFIG_AHBROM_ENABLE 1
#define CONFIG_AHBROM_START 000
#undef  CONFIG_AHBROM_PIPE
#define CONFIG_AHBRAM_ENABLE 1
#undef  CONFIG_AHBRAM_SZ1
#undef  CONFIG_AHBRAM_SZ2
#define CONFIG_AHBRAM_SZ4 1
#undef  CONFIG_AHBRAM_SZ8
#undef  CONFIG_AHBRAM_SZ16
#undef  CONFIG_AHBRAM_SZ32
#undef  CONFIG_AHBRAM_SZ64
#define CONFIG_AHBRAM_START A00
/*
 * Ethernet             
 */
#undef  CONFIG_GRETH_ENABLE
/*
 * CAN                     
 */
#undef  CONFIG_CAN_ENABLE
/*
 * UARTs, timers and irq control         
 */
#define CONFIG_UART1_ENABLE 1
#define CONFIG_UA1_FIFO1 1
#undef  CONFIG_UA1_FIFO2
#undef  CONFIG_UA1_FIFO4
#undef  CONFIG_UA1_FIFO8
#undef  CONFIG_UA1_FIFO16
#undef  CONFIG_UA1_FIFO32
#define CONFIG_IRQ3_ENABLE 1
#undef  CONFIG_IRQ3_SEC
#define CONFIG_GPT_ENABLE 1
#define CONFIG_GPT_NTIM (2)
#define CONFIG_GPT_SW (8)
#define CONFIG_GPT_TW (32)
#define CONFIG_GPT_IRQ (8)
#define CONFIG_GPT_SEPIRQ 1
#undef  CONFIG_GPT_WDOGEN
#define CONFIG_GRGPIO_ENABLE 1
#define CONFIG_GRGPIO_WIDTH (4)
#define CONFIG_GRGPIO_IMASK 0000
/*
 * VHDL Debugging        
 */
#undef  CONFIG_DEBUG_UART
