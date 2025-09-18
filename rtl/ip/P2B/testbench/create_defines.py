# =============================================================================
# >>>>>>>>>>>>>>>>>>>>>>>>> COPYRIGHT NOTICE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
# -----------------------------------------------------------------------------
#   Copyright (c) 2018 by Lattice Semiconductor Corporation
#   ALL RIGHTS RESERVED
# -----------------------------------------------------------------------------
#
#   Permission:
#
#      Lattice SG Pte. Ltd. grants permission to use this code
#      pursuant to the terms of the Lattice Reference Design License Agreement.
#
#
#   Disclaimer:
#
#      This VHDL or Verilog source code is intended as a design reference
#      which illustrates how these types of functions can be implemented.
#      It is the user's responsibility to verify their design for
#      consistency and functionality through the use of formal
#      verification methods.  Lattice provides no warranty
#      regarding the use or functionality of this code.
#
# ------------------------------------------------------------------------------
#
#                  Lattice SG Pte. Ltd.
#                  101 Thomson Road, United Square #07-02
#                  Singapore 307591
#
#
#                  TEL: 1-800-Lattice (USA and Canada)
#                       +65-6631-2000 (Singapore)
#                       +1-503-268-8001 (other locations)
#
#                  web: http://www.latticesemi.com/
#                  email: techsupport@latticesemi.com
#
# ------------------------------------------------------------------------------
#
# ==============================================================================
#                         FILE DETAILS
# Project               : LIFCL
# File                  : create_defines.py
# Title                 :
# Dependencies          : 1.
#                       : 2.
# Description           :
# ==============================================================================
#                        REVISION HISTORY
# Version               : 1.0.0
# Author(s)             :
# Mod. Date             :
# Changes Made          : Initial release.
# ==============================================================================

import os
import math

def create_defines():
    line = f_params.readline()
    defines_file.write("`ifndef pixel2byte_params \n`define pixel2byte_params\n\n")
    while line:
        line_rep = line.replace(";\n","")
        a = line_rep.split(" ")
        if (a[1] == 'DSI_FORMAT'):
            if(a[3] == '1' ):
                defines_file.write("`define    TX_DSI\n")
            else:
                defines_file.write("`define    TX_CSI2\n")
        elif (a[1] == 'DATA_TYPE'):
            if (a[3] == '"RGB888"'):
                defines_file.write("`define    RGB888\n")
            elif (a[3] == '"RGB666"'):
                defines_file.write("`define    RGB666\n")
            elif (a[3] == '"RAW8"'):
                defines_file.write("`define    RAW8\n")
            elif (a[3] == '"RAW10"'):
                defines_file.write("`define    RAW10\n")
            elif (a[3] == '"RAW12"'):
                defines_file.write("`define    RAW12\n")
            elif (a[3] == '"RAW14"'):
                defines_file.write("`define    RAW14\n")
            elif (a[3] == '"RAW16"'):
                defines_file.write("`define    RAW16\n")
            elif (a[3] == '"YUV420_8"'):
                defines_file.write("`define    YUV420_8\n")
            elif (a[3] == '"YUV420_10"'):
                defines_file.write("`define    YUV420_10\n")
            elif (a[3] == '"YUV422_8"'):
                defines_file.write("`define    YUV422_8\n")
            elif (a[3] == '"YUV422_10"'):
                defines_file.write("`define    YUV422_10\n")
        elif (a[1] == 'NUM_TX_LANE'):
            if (a[3] == '1'):
                defines_file.write("`define    NUM_TX_LANE_1\n")
            elif (a[3] == '2'):
                defines_file.write("`define    NUM_TX_LANE_2\n")
            elif (a[3] == '4'):
                defines_file.write("`define    NUM_TX_LANE_4\n")        
        elif (a[1] == 'MISCON'):
            if(a[3] == '1'):
                defines_file.write("`define    MISC_ON\n")
        elif (a[1] == 'TX_GEAR'):
            if (a[3] == '16'):
                defines_file.write("`define    TX_GEAR_16\n")
            else:
                defines_file.write("`define    TX_GEAR_8\n")                
        elif (a[1] == 'NUM_PIX_LANE'):
            if (a[3] == '1'):
                defines_file.write("`define    NUM_PIX_LANE_1\n")
            elif (a[3] == '2'):
                defines_file.write("`define    NUM_PIX_LANE_2\n")
            elif (a[3] == '4'):
                defines_file.write("`define    NUM_PIX_LANE_4\n")
            elif (a[3] == '6'):
                defines_file.write("`define    NUM_PIX_LANE_6\n")
            elif (a[3] == '8'):
                defines_file.write("`define    NUM_PIX_LANE_8\n")
            elif (a[3] == '10'):
                defines_file.write("`define    NUM_PIX_LANE_10\n")
        line = f_params.readline()
    defines_file.write("`define    TXFR_SIG\n")
    defines_file.write("\n`endif")            



f_params           = open('testbench/dut_params.v', 'r')
defines_file       = open('testbench/dut_defines.v', 'w')
create_defines()
defines_file.close()
