`define LATTICE_FAMILY "EC"
`define LATTICE_FAMILY_EC
`define LATTICE_DEVICE "All"
`ifndef SYSTEM_CONF
`define SYSTEM_CONF
`timescale 1ns / 100 ps
`define CFG_EBA_RESET 32'h0
`define CFG_DISTRAM_POSEDGE_REGISTER_FILE
`define SHIFT_ENABLE
`define CFG_MC_BARREL_SHIFT_ENABLED
`define LM32_I_PC_WIDTH 31
`define ADDRESS_LOCK
`define ebrEBR_WB_DAT_WIDTH 32
`define ebrINIT_FILE_NAME "none"
`define ebrINIT_FILE_FORMAT "hex"
`define gpioGPIO_WB_DAT_WIDTH 32
`define gpioGPIO_WB_ADR_WIDTH 4
`define ADDRESS_LOCK
`define gpioOUTPUT_PORTS_ONLY
`define gpioDATA_WIDTH 32'h8
`define ADDRESS_LOCK
`define memory_passthruMEM_WB_DAT_WIDTH 32
`define MEM_WB_SEL_WIDTH 4
`define memory_passthruMEM_WB_ADR_WIDTH 32
`define master_passthruM_WB_DAT_WIDTH 32
`define M_WB_SEL_WIDTH 4
`define master_passthruM_WB_ADR_WIDTH 32
`endif // SYSTEM_CONF
