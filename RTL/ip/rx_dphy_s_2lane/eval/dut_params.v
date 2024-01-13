localparam FAMILY = "LIFCL";
localparam RX_TYPE = "CSI2";
localparam DPHY_RX_IP = "MIXEL";
localparam NUM_RX_LANE = 2;
localparam RX_GEAR = 8;
localparam CIL_BYPASS = "CIL_BYPASSED";
localparam LMMI = "OFF";
localparam AXI4 = "OFF";
localparam DESKEW_EN = "DISABLED";
localparam HSEL = "DISABLED";
localparam TEST_PATTERN = "0b10000000001000000000000000000000";
localparam RX_CLK_MODE = "HS_LP";
localparam BYTECLK_MHZ = 50;
localparam BYTECLK_MHZ_FLOAT = 50.000000;
localparam SYNCCLK_MHZ = 100.000000;
localparam DATA_SETTLE_CYC = 6;
localparam T_DATA_SETTLE = "0b001100";
localparam T_CLK_SETTLE = "0b001111";
localparam PARSER = "ON";
localparam LANE_ALIGN = "ON";
localparam FIFO_DEPTH = 4;
localparam FIFO_TYPE = "EBR";
localparam RX_FIFO = "ON";
localparam RX_FIFO_IMPL = "LUT";
localparam RX_FIFO_DEPTH = 32;
localparam NUM_QUE_ENT = 4;
localparam RX_FIFO_TYPE = "SINGLE";
localparam RX_FIFO_PKT_DLY = 16;
localparam RX_FIFO_CTR_WIDTH = 5;
localparam FR_FIFO_CLKMODE = "DC";
localparam FIFO_IF = "CENTERED";
localparam RX_FIFO_MISC = "ON";
`define LIFCL
`define je5d00
`define LIFCL_33U
