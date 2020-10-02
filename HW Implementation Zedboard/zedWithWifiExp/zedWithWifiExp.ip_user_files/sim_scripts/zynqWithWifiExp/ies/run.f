-makelib ies_lib/xil_defaultlib -sv \
  "/home/nazmul/research/xilinx/Vivado/2017.4/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
  "/home/nazmul/research/xilinx/Vivado/2017.4/data/ip/xpm/xpm_fifo/hdl/xpm_fifo.sv" \
  "/home/nazmul/research/xilinx/Vivado/2017.4/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \
-endlib
-makelib ies_lib/xpm \
  "/home/nazmul/research/xilinx/Vivado/2017.4/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib ies_lib/axi_infrastructure_v1_1_0 \
  "../../../../zedWithWifiExp.srcs/sources_1/bd/zynqWithWifiExp/ipshared/ec67/hdl/axi_infrastructure_v1_1_vl_rfs.v" \
-endlib
-makelib ies_lib/smartconnect_v1_0 -sv \
  "../../../../zedWithWifiExp.srcs/sources_1/bd/zynqWithWifiExp/ipshared/02c8/hdl/sc_util_v1_0_vl_rfs.sv" \
-endlib
-makelib ies_lib/axi_protocol_checker_v2_0_1 -sv \
  "../../../../zedWithWifiExp.srcs/sources_1/bd/zynqWithWifiExp/ipshared/3b24/hdl/axi_protocol_checker_v2_0_vl_rfs.sv" \
-endlib
-makelib ies_lib/axi_vip_v1_1_1 -sv \
  "../../../../zedWithWifiExp.srcs/sources_1/bd/zynqWithWifiExp/ipshared/a16a/hdl/axi_vip_v1_1_vl_rfs.sv" \
-endlib
-makelib ies_lib/processing_system7_vip_v1_0_3 -sv \
  "../../../../zedWithWifiExp.srcs/sources_1/bd/zynqWithWifiExp/ipshared/1313/hdl/processing_system7_vip_v1_0_vl_rfs.sv" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../bd/zynqWithWifiExp/ip/zynqWithWifiExp_processing_system7_0_0/sim/zynqWithWifiExp_processing_system7_0_0.v" \
  "../../../bd/zynqWithWifiExp/sim/zynqWithWifiExp.v" \
  "../../../bd/zynqWithWifiExp/ipshared/d53c/src/aes_128.v" \
  "../../../bd/zynqWithWifiExp/ipshared/d53c/src/bcmProcess.v" \
  "../../../bd/zynqWithWifiExp/ipshared/d53c/src/hcmProcess.v" \
  "../../../bd/zynqWithWifiExp/ipshared/d53c/hdl/myipBCM_v1_0_S00_AXI.v" \
  "../../../bd/zynqWithWifiExp/ipshared/d53c/src/round.v" \
  "../../../bd/zynqWithWifiExp/ipshared/d53c/src/table.v" \
  "../../../bd/zynqWithWifiExp/ipshared/d53c/src/timestampProcess.v" \
  "../../../bd/zynqWithWifiExp/ipshared/d53c/hdl/myipBCM_v1_0.v" \
  "../../../bd/zynqWithWifiExp/ip/zynqWithWifiExp_myipBCM_0_0/sim/zynqWithWifiExp_myipBCM_0_0.v" \
-endlib
-makelib ies_lib/lib_cdc_v1_0_2 \
  "../../../../zedWithWifiExp.srcs/sources_1/bd/zynqWithWifiExp/ipshared/ef1e/hdl/lib_cdc_v1_0_rfs.vhd" \
-endlib
-makelib ies_lib/proc_sys_reset_v5_0_12 \
  "../../../../zedWithWifiExp.srcs/sources_1/bd/zynqWithWifiExp/ipshared/f86a/hdl/proc_sys_reset_v5_0_vh_rfs.vhd" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../bd/zynqWithWifiExp/ip/zynqWithWifiExp_rst_ps7_0_100M_1/sim/zynqWithWifiExp_rst_ps7_0_100M_1.vhd" \
-endlib
-makelib ies_lib/generic_baseblocks_v2_1_0 \
  "../../../../zedWithWifiExp.srcs/sources_1/bd/zynqWithWifiExp/ipshared/b752/hdl/generic_baseblocks_v2_1_vl_rfs.v" \
-endlib
-makelib ies_lib/fifo_generator_v13_2_1 \
  "../../../../zedWithWifiExp.srcs/sources_1/bd/zynqWithWifiExp/ipshared/5c35/simulation/fifo_generator_vlog_beh.v" \
-endlib
-makelib ies_lib/fifo_generator_v13_2_1 \
  "../../../../zedWithWifiExp.srcs/sources_1/bd/zynqWithWifiExp/ipshared/5c35/hdl/fifo_generator_v13_2_rfs.vhd" \
-endlib
-makelib ies_lib/fifo_generator_v13_2_1 \
  "../../../../zedWithWifiExp.srcs/sources_1/bd/zynqWithWifiExp/ipshared/5c35/hdl/fifo_generator_v13_2_rfs.v" \
-endlib
-makelib ies_lib/axi_data_fifo_v2_1_14 \
  "../../../../zedWithWifiExp.srcs/sources_1/bd/zynqWithWifiExp/ipshared/9909/hdl/axi_data_fifo_v2_1_vl_rfs.v" \
-endlib
-makelib ies_lib/axi_register_slice_v2_1_15 \
  "../../../../zedWithWifiExp.srcs/sources_1/bd/zynqWithWifiExp/ipshared/3ed1/hdl/axi_register_slice_v2_1_vl_rfs.v" \
-endlib
-makelib ies_lib/axi_protocol_converter_v2_1_15 \
  "../../../../zedWithWifiExp.srcs/sources_1/bd/zynqWithWifiExp/ipshared/ff69/hdl/axi_protocol_converter_v2_1_vl_rfs.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../bd/zynqWithWifiExp/ip/zynqWithWifiExp_auto_pc_0/sim/zynqWithWifiExp_auto_pc_0.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  glbl.v
-endlib

