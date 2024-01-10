//##################################################################################################################
// File Name : Testbench parameter and simulation file
// Purpose   : When user wants to override default TB parameters like number of bytes, lines, frames, etc.
//             
// Type      : This is a verilog file
// Usage     : This file is read via Aldec simulator or any verilog simulator.
//##################################################################################################################

//##################################################################################################################
// Testbench Parameters
// Modify the following testbench directives below if you want to modify simulation settings.
//##################################################################################################################

// SIP_BCLK - Used to set the period of the input byte clock (in ps) 
//`define SIP_BCLK 6000

// SIP_PCLK - Used to override the pixel clock (in ps). By default the
// testbench automatically calculates the pixel clock based from the byte
// clock and other design settings
`ifndef TB_PARAMS
`define TB_PARAMS

//NUM_FRAMES - Number of frames in a test
`define NUM_FRAMES 2

//NUM_LINES - Number of lines in each frame
`define NUM_LINES 3

//NUM_OF_BYTES - Number of Bytes in each line
//`define NUM_OF_BYTES 300


//Extra defines for DSI mode below
// HFP_PAYLOAD - Used to set horizontal front porch (number of byte clock cycles from payload_en_i negation to HSYNC start)
`define HFP_PAYLOAD 10 //110

// HSA_PAYLOAD - Used to set hsync width (number of byte clock cycles from HSYNC start to HSYNC end) 
`define HSA_PAYLOAD 5//40

// HBP_PAYLOAD - Used to set Horizontal back porch (number of byte clock cycles from HSYNC end to payload_en_i rise)
`define HBP_PAYLOAD 220

// VFP_LINES - Used to set vertical front porch (number of hsync pulses before VSYNC for next frame)
`define VFP_LINES 5

// VSA_LINES - Used to set vsync width (number of hsync pulses within vsync)
`define VSA_LINES 5

// VBP_LINES - Used to set vertical back porch (number of hsync pulses after VSYNC)
`define VBP_LINES 2//20

//`define SP2_LP_SIMULTANEOUS
//`define SP_LP2_SIMULTANEOUS


//`define DSI_RESET_DE
//`define DSI_RESET_HSYNC
//`define DSI_RESET_VSYNC
//`define DSI_RESET_DE_NEG
//`define DSI_RESET_HSYNC_NEG
//`define DSI_RESET_VSYNC_NEG
//`define CSI2_RESET_FV
//`define CSI2_RESET_LV
`endif // TB_PARAMS
