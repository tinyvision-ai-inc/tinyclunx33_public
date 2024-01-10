localparam FAMILY = "LIFCL";
localparam RX_TYPE = "CSI2";
localparam DPHY_RX_IP = "LATTICE";
localparam NUM_RX_LANE = 1;
localparam RX_GEAR = 8;
localparam CIL_BYPASS = "CIL_BYPASSED";
localparam LMMI = "OFF";
localparam AXI4 = "OFF";
localparam DESKEW_EN = "DISABLED";
localparam HSEL = "DISABLED";
localparam TEST_PATTERN = "0b10000000001000000000000000000000";
localparam RX_CLK_MODE = "HS_ONLY";
localparam BYTECLK_MHZ = 45.000000;
localparam SYNCCLK_MHZ = 96.000000;
localparam DATA_SETTLE_CYC = 4;
localparam T_DATA_SETTLE = "0b001011";
localparam T_CLK_SETTLE = "0b001110";
localparam PARSER = "ON";
localparam LANE_ALIGN = "OFF";
localparam FIFO_DEPTH = 4;
localparam FIFO_TYPE = "EBR";
localparam RX_FIFO = "ON";
localparam RX_FIFO_IMPL = "LUT";
localparam RX_FIFO_DEPTH = 16;
localparam NUM_QUE_ENT = 4;
localparam RX_FIFO_TYPE = "SINGLE";
localparam RX_FIFO_PKT_DLY = 4;
localparam RX_FIFO_CTR_WIDTH = 3;
localparam FR_FIFO_CLKMODE = "DC";
localparam FIFO_IF = "ALIGNED";
localparam RX_FIFO_MISC = "OFF";
`define LIFCL
`define je5d00
`define LIFCL-40
