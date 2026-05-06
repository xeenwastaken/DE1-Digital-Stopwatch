## ============================================================================
## Constraints file pro projekt STOPWATCH na desce Nexys A7-50T
## Top-level entita: stopwatch_top
##
## Mapovani na porty top-level:
##   CLK100MHZ                            -> 100 MHz hodiny
##   BTNC, BTNU, BTND, BTNL, BTNR         -> krizovy ovladac (5 tlacitek)
##   SEG[6:0]  (a..g, active-low)         -> segmenty CA..CG (sdilene)
##   DP                                   -> desetinna tecka
##   AN[7:0]   (active-low)               -> anody jednotlivych cislic
##   LED[15:0]                            -> stav pameti mezicasu (lap_led_status)
##
## Pin assignments prevzaty z Nexys-A7-50T-Master.xdc (Digilent).
## ============================================================================

## --------------------------------- Hodiny -----------------------------------
set_property -dict { PACKAGE_PIN E3   IOSTANDARD LVCMOS33 } [get_ports { CLK100MHZ }];
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports { CLK100MHZ }];

## --------------------------------- Tlacitka ---------------------------------
set_property -dict { PACKAGE_PIN N17  IOSTANDARD LVCMOS33 } [get_ports { BTNC }];
set_property -dict { PACKAGE_PIN M18  IOSTANDARD LVCMOS33 } [get_ports { BTNU }];
set_property -dict { PACKAGE_PIN P18  IOSTANDARD LVCMOS33 } [get_ports { BTND }];
set_property -dict { PACKAGE_PIN P17  IOSTANDARD LVCMOS33 } [get_ports { BTNL }];
set_property -dict { PACKAGE_PIN M17  IOSTANDARD LVCMOS33 } [get_ports { BTNR }];

## --------------------- 7-segment displej: katody (active-low) ---------------
## Pozor: bin2seg pouziva poradi bitu "a b c d e f g", tj. SEG[6]=a, SEG[0]=g
set_property -dict { PACKAGE_PIN T10  IOSTANDARD LVCMOS33 } [get_ports { SEG[6] }]; ## CA = a
set_property -dict { PACKAGE_PIN R10  IOSTANDARD LVCMOS33 } [get_ports { SEG[5] }]; ## CB = b
set_property -dict { PACKAGE_PIN K16  IOSTANDARD LVCMOS33 } [get_ports { SEG[4] }]; ## CC = c
set_property -dict { PACKAGE_PIN K13  IOSTANDARD LVCMOS33 } [get_ports { SEG[3] }]; ## CD = d
set_property -dict { PACKAGE_PIN P15  IOSTANDARD LVCMOS33 } [get_ports { SEG[2] }]; ## CE = e
set_property -dict { PACKAGE_PIN T11  IOSTANDARD LVCMOS33 } [get_ports { SEG[1] }]; ## CF = f
set_property -dict { PACKAGE_PIN L18  IOSTANDARD LVCMOS33 } [get_ports { SEG[0] }]; ## CG = g

## Desetinna tecka
set_property -dict { PACKAGE_PIN H15  IOSTANDARD LVCMOS33 } [get_ports { DP }];

## --------------------- 7-segment displej: anody (active-low) ----------------
## AN[0] = nejvice vpravo (jednotky setin sekundy)
## AN[7] = nejvice vlevo  (desitky hodin)
set_property -dict { PACKAGE_PIN J17  IOSTANDARD LVCMOS33 } [get_ports { AN[0] }];
set_property -dict { PACKAGE_PIN J18  IOSTANDARD LVCMOS33 } [get_ports { AN[1] }];
set_property -dict { PACKAGE_PIN T9   IOSTANDARD LVCMOS33 } [get_ports { AN[2] }];
set_property -dict { PACKAGE_PIN J14  IOSTANDARD LVCMOS33 } [get_ports { AN[3] }];
set_property -dict { PACKAGE_PIN P14  IOSTANDARD LVCMOS33 } [get_ports { AN[4] }];
set_property -dict { PACKAGE_PIN T14  IOSTANDARD LVCMOS33 } [get_ports { AN[5] }];
set_property -dict { PACKAGE_PIN K2   IOSTANDARD LVCMOS33 } [get_ports { AN[6] }];
set_property -dict { PACKAGE_PIN U13  IOSTANDARD LVCMOS33 } [get_ports { AN[7] }];

## --------------------------------- LED diody --------------------------------
## LED[i] = '1' znamena ze slot i v pameti mezicasu je obsazen
set_property -dict { PACKAGE_PIN H17  IOSTANDARD LVCMOS33 } [get_ports { LED[0] }];
set_property -dict { PACKAGE_PIN K15  IOSTANDARD LVCMOS33 } [get_ports { LED[1] }];
set_property -dict { PACKAGE_PIN J13  IOSTANDARD LVCMOS33 } [get_ports { LED[2] }];
set_property -dict { PACKAGE_PIN N14  IOSTANDARD LVCMOS33 } [get_ports { LED[3] }];
set_property -dict { PACKAGE_PIN R18  IOSTANDARD LVCMOS33 } [get_ports { LED[4] }];
set_property -dict { PACKAGE_PIN V17  IOSTANDARD LVCMOS33 } [get_ports { LED[5] }];
set_property -dict { PACKAGE_PIN U17  IOSTANDARD LVCMOS33 } [get_ports { LED[6] }];
set_property -dict { PACKAGE_PIN U16  IOSTANDARD LVCMOS33 } [get_ports { LED[7] }];
set_property -dict { PACKAGE_PIN V16  IOSTANDARD LVCMOS33 } [get_ports { LED[8] }];
set_property -dict { PACKAGE_PIN T15  IOSTANDARD LVCMOS33 } [get_ports { LED[9] }];
set_property -dict { PACKAGE_PIN U14  IOSTANDARD LVCMOS33 } [get_ports { LED[10] }];
set_property -dict { PACKAGE_PIN T16  IOSTANDARD LVCMOS33 } [get_ports { LED[11] }];
set_property -dict { PACKAGE_PIN V15  IOSTANDARD LVCMOS33 } [get_ports { LED[12] }];
set_property -dict { PACKAGE_PIN V14  IOSTANDARD LVCMOS33 } [get_ports { LED[13] }];
set_property -dict { PACKAGE_PIN V12  IOSTANDARD LVCMOS33 } [get_ports { LED[14] }];
set_property -dict { PACKAGE_PIN V11  IOSTANDARD LVCMOS33 } [get_ports { LED[15] }];

## ============================================================================
## Konfiguracni nastaveni bitstreamu
## ============================================================================
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO     [current_design]