///// Simulation Directives for CSI2 Aggregation RD /////

`define SIM
`define VERBOSE

//`define NO_CH0_RX	// skip CH #0
`define NO_CH1_RX	// skip CH #1
//`define NO_CH2_RX	// skip CH #2

`define REF_CLK_PERIOD 37000	// 27 MHz

`define RX0_DPHY_CLK_PERIOD 5556	// 360 Mbps 
`define RX1_DPHY_CLK_PERIOD 5556	// 360 Mbps
`define RX2_DPHY_CLK_PERIOD 5556	// 360 Mbps

// Unused for now:
`define RX3_DPHY_CLK_PERIOD 4542	// 440 Mbps
`define RX4_DPHY_CLK_PERIOD 8334 	// 240 Mbps
`define RX5_DPHY_CLK_PERIOD 1350 	// 1480 Mbps
`define RX6_DPHY_CLK_PERIOD 6250 	// 320 Mbps
`define RX7_DPHY_CLK_PERIOD 7142 	// 280 Mbps

`define RX0_FREQ_TGT 90
`define RX1_FREQ_TGT 90
`define RX2_FREQ_TGT 90

// Unused for now:
`define RX3_FREQ_TGT 55 
`define RX4_FREQ_TGT 30 
`define RX5_FREQ_TGT 185
`define RX6_FREQ_TGT 40
`define RX7_FREQ_TGT 35

//`define TX_FREQ_TGT 156
//`define TX_DPHY_CLK_PERIOD 800	// 2500 Mbps
//`define TX_FREQ_TGT 187.5
//`define TX_DPHY_CLK_PERIOD 1334	// 1500 Mbps
//`define TX_FREQ_TGT 100	// G16
//`define TX_DPHY_CLK_PERIOD 1250	// 1600 Mbps
//`define TX_FREQ_TGT 175	// G8
//`define TX_DPHY_CLK_PERIOD 1428	// 1400 Mbps

//`define TX_FREQ_TGT 150	// G8
//`define TX_DPHY_CLK_PERIOD 1666	// 1200 Mbps

`define TX_FREQ_TGT 100
`define TX_DPHY_CLK_PERIOD 2469	// 810 Mbps

`define TX_WAIT_LESS_15MS
//`define NUM_FRAMES 3

`define VC_CH0 3
`define VC_CH1 2
`define VC_CH2 1
//`define VC_CH3 0
//`define VC_CH4 8
//`define VC_CH5 9
//`define VC_CH6 10 
//`define VC_CH7 15

//`define CH0_FNUM_EMBED	// Embed the frame counter in Fs/FE Short Packets
//`define CH1_FNUM_EMBED
//`define CH2_FNUM_EMBED
//`define CH3_FNUM_EMBED
//`define CH4_FNUM_EMBED
//`define CH5_FNUM_EMBED
//`define CH6_FNUM_EMBED
//`define CH7_FNUM_EMBED

`define CH0_FNUM_MAX 3	// 2 to 65535
`define CH1_FNUM_MAX 3	// 2 to 65535
`define CH2_FNUM_MAX 3	// 2 to 65535
//`define CH3_FNUM_MAX 3	// 2 to 65535
//`define CH4_FNUM_MAX 3	// 2 to 65535
//`define CH5_FNUM_MAX 3	// 2 to 65535
//`define CH6_FNUM_MAX 3	// 2 to 65535
//`define CH7_FNUM_MAX 3	// 2 to 65535

`define CH0_DELAY 11 
`define CH1_DELAY 1
`define CH2_DELAY 9
//`define CH3_DELAY 15
//`define CH4_DELAY 4
//`define CH5_DELAY 6
//`define CH6_DELAY 10
//`define CH7_DELAY 13

`define CH0_DPHY_LPS_GAP 2000000
`define CH1_DPHY_LPS_GAP 3000000
//`define CH2_DPHY_LPS_GAP 4000000
`define CH2_DPHY_LPS_GAP 2000000
`define CH3_DPHY_LPS_GAP 5000000
`define CH4_DPHY_LPS_GAP 5000000
`define CH5_DPHY_LPS_GAP 5000000
`define CH6_DPHY_LPS_GAP 5000000
`define CH7_DPHY_LPS_GAP 5000000

`define CH0_FRAME_GAP 11000000
`define CH1_FRAME_GAP 12000000
//`define CH2_FRAME_GAP 13000000
`define CH2_FRAME_GAP 11000000
`define CH3_FRAME_GAP 14000000
`define CH4_FRAME_GAP 15000000
`define CH5_FRAME_GAP 15000000
`define CH6_FRAME_GAP 15000000
`define CH7_FRAME_GAP 15000000

//`define CH0_NUM_FRAMES 3
`define CH0_NUM_FRAMES 50
`define CH0_NUM_LINES 40
`define CH0_NUM_PIXELS 640
//`define CH0_NUM_PIXELS 260
`define CH0_DT_RAW10

//`define CH1_NUM_FRAMES 3
`define CH1_NUM_FRAMES 19
`define CH1_NUM_LINES 30
`define CH1_NUM_PIXELS 1920
//`define CH1_NUM_PIXELS 301
`define CH1_DT_RAW10

//`define CH2_NUM_FRAMES 3
`define CH2_NUM_FRAMES 20
`define CH2_NUM_LINES 40
`define CH2_NUM_PIXELS 640
//`define CH2_NUM_PIXELS 280
`define CH2_DT_RAW10

//`define CH3_NUM_FRAMES 3
`define CH3_NUM_FRAMES 15
`define CH3_NUM_LINES 40
`define CH3_NUM_PIXELS 1440
//`define CH3_NUM_PIXELS 160
`define CH3_DT_RAW8

`define CH4_NUM_FRAMES 3
`define CH4_NUM_LINES 50
//`define CH4_NUM_PIXELS 128
`define CH4_NUM_PIXELS 1280
`define CH4_DT_RGB888

`define CH5_NUM_FRAMES 17
`define CH5_NUM_LINES 60
//`define CH5_NUM_PIXELS 126
`define CH5_NUM_PIXELS 2048
`define CH5_DT_YUV420_10

`define CH6_NUM_FRAMES 37
`define CH6_NUM_LINES 40
//`define CH6_NUM_PIXELS 144
`define CH6_NUM_PIXELS 640
`define CH6_DT_YUV420_8

`define CH7_NUM_FRAMES 15
`define CH7_NUM_LINES 42
//`define CH7_NUM_PIXELS 125
`define CH7_NUM_PIXELS 800
`define CH7_DT_YUV422_10

`define MISC_ON
//`define MISC_TINITDONE
//`define MISC_TXPLLLOCK
