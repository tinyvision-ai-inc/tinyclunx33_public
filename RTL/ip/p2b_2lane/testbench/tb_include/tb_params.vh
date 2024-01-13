// ======================================
// 1. Create new project using Lattice Diamond for Windows.
// 2. Open Active-HDL Lattice Edition GUI tool.
// 3. Click Tools -> Execute macro, then select the do file.
// 4. Wait for simulation to finish.

// ###############
// Testbench Parameters

// Modify the following testbench directives if you want to modify simulation settings.
// SIP_PCLK        - Used to set the period of the input pixel clock (in ps)
//`define SIP_BCLK 12000.0

// SIP_BCLK        - Used to set the period of the input byte clock (in ps) 
`define SIP_PCLK 7500.0

// NUM_FRAMES      - Used to set the number of video frames
`define NUM_FRAMES 3

// NUM_LINES       - Used to set the number of lines per frame
`define NUM_LINES 5

// HFRONT          - Number of cycles before HSYNC signal asserts (Horizontal Front Blanking)
`define HFRONT 528

// HPULSE          - Number of cycles HSYNC signal asserts
`define HPULSE 44

// HBACK           - Number of cycles after HSYNC signal asserts (Horizontal Rear Blanking)
`define HBACK 300

// VFRONT          - Number of cycles before VSYNC signal asserts (Vertical Front Blanking)
`define VFRONT 4

// VPULSE          - Number of cycles VSYNC signal asserts
`define VPULSE 5

// VBACK           - Number of cycles after VSYNC signal asserts (Vertical Rear Blanking)
`define VBACK 36

// NUM_BYTES              - Number of bytes sent per line
`define NUM_BYTES 240
