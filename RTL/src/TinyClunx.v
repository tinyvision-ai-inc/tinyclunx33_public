// Generator : SpinalHDL dev    git head : 52d9b32a6a2de3ec4e75109d7f147f72f0237d2b
// Component : TinyClunx
// Git hash  : 6a42558e109ab2caa93e811f05a6a5f45bb2def7

`timescale 1ns/1ps

module TinyClunx (
  input  wire          clk,
  input  wire          reset,
  output wire          usb_irq,
  inout  wire [0:0]    usb23_VBUS,
  input  wire [0:0]    usb23_REFINCLKEXTP,
  input  wire [0:0]    usb23_REFINCLKEXTM,
  inout  wire [0:0]    usb23_RESEXTUSB2,
  inout  wire [0:0]    usb23_DP,
  inout  wire [0:0]    usb23_DM,
  input  wire [0:0]    usb23_RXM,
  input  wire [0:0]    usb23_RXP,
  output wire [0:0]    usb23_TXM,
  output wire [0:0]    usb23_TXP,
  input  wire          clk_60m,
  input  wire          wb_CYC,
  input  wire          wb_STB,
  output wire          wb_ACK,
  input  wire          wb_WE,
  input  wire [27:0]   wb_ADR,
  output wire [31:0]   wb_DAT_MISO,
  input  wire [31:0]   wb_DAT_MOSI,
  input  wire [3:0]    wb_SEL
);

  wire       [11:0]   ram1_io_axi_arbiter_io_readInputs_0_ar_payload_addr;
  wire       [11:0]   ram1_io_axi_arbiter_io_readInputs_1_ar_payload_addr;
  wire       [11:0]   ram1_io_axi_arbiter_io_writeInputs_0_aw_payload_addr;
  wire       [11:0]   ram1_io_axi_arbiter_io_writeInputs_1_aw_payload_addr;
  wire       [0:0]    usbCore_io_usbIO_TXM;
  wire       [0:0]    usbCore_io_usbIO_TXP;
  wire                usbCore_io_irq;
  wire                usbCore_axi_arvalid;
  wire       [31:0]   usbCore_axi_araddr;
  wire       [7:0]    usbCore_axi_arid;
  wire       [7:0]    usbCore_axi_arlen;
  wire       [2:0]    usbCore_axi_arsize;
  wire       [1:0]    usbCore_axi_arburst;
  wire       [0:0]    usbCore_axi_arlock;
  wire       [3:0]    usbCore_axi_arcache;
  wire       [2:0]    usbCore_axi_arprot;
  wire                usbCore_axi_awvalid;
  wire       [31:0]   usbCore_axi_awaddr;
  wire       [7:0]    usbCore_axi_awid;
  wire       [7:0]    usbCore_axi_awlen;
  wire       [2:0]    usbCore_axi_awsize;
  wire       [1:0]    usbCore_axi_awburst;
  wire       [0:0]    usbCore_axi_awlock;
  wire       [3:0]    usbCore_axi_awcache;
  wire       [2:0]    usbCore_axi_awprot;
  wire                usbCore_axi_wvalid;
  wire       [63:0]   usbCore_axi_wdata;
  wire       [7:0]    usbCore_axi_wstrb;
  wire                usbCore_axi_wlast;
  wire                usbCore_axi_rready;
  wire                usbCore_axi_bready;
  wire       [31:0]   usbCore_io_wb_DAT_MISO;
  wire                usbCore_io_wb_ACK;
  wire       [31:0]   wb2axi4_1_io_wb_DAT_MISO;
  wire                wb2axi4_1_io_wb_ACK;
  wire                wb2axi4_1_io_axi_ar_valid;
  wire       [31:0]   wb2axi4_1_io_axi_ar_payload_addr;
  wire       [7:0]    wb2axi4_1_io_axi_ar_payload_id;
  wire       [7:0]    wb2axi4_1_io_axi_ar_payload_len;
  wire       [2:0]    wb2axi4_1_io_axi_ar_payload_size;
  wire       [1:0]    wb2axi4_1_io_axi_ar_payload_burst;
  wire       [0:0]    wb2axi4_1_io_axi_ar_payload_lock;
  wire       [3:0]    wb2axi4_1_io_axi_ar_payload_cache;
  wire       [2:0]    wb2axi4_1_io_axi_ar_payload_prot;
  wire                wb2axi4_1_io_axi_aw_valid;
  wire       [31:0]   wb2axi4_1_io_axi_aw_payload_addr;
  wire       [7:0]    wb2axi4_1_io_axi_aw_payload_id;
  wire       [7:0]    wb2axi4_1_io_axi_aw_payload_len;
  wire       [2:0]    wb2axi4_1_io_axi_aw_payload_size;
  wire       [1:0]    wb2axi4_1_io_axi_aw_payload_burst;
  wire       [0:0]    wb2axi4_1_io_axi_aw_payload_lock;
  wire       [3:0]    wb2axi4_1_io_axi_aw_payload_cache;
  wire       [2:0]    wb2axi4_1_io_axi_aw_payload_prot;
  wire                wb2axi4_1_io_axi_w_valid;
  wire       [63:0]   wb2axi4_1_io_axi_w_payload_data;
  wire       [7:0]    wb2axi4_1_io_axi_w_payload_strb;
  wire                wb2axi4_1_io_axi_w_payload_last;
  wire                wb2axi4_1_io_axi_r_ready;
  wire                wb2axi4_1_io_axi_b_ready;
  wire       [31:0]   wbIntcon_io_busMasters_0_DAT_MISO;
  wire                wbIntcon_io_busMasters_0_ACK;
  wire       [31:0]   wbIntcon_io_busSlaves_0_DAT_MOSI;
  wire       [27:0]   wbIntcon_io_busSlaves_0_ADR;
  wire                wbIntcon_io_busSlaves_0_CYC;
  wire       [3:0]    wbIntcon_io_busSlaves_0_SEL;
  wire                wbIntcon_io_busSlaves_0_STB;
  wire                wbIntcon_io_busSlaves_0_WE;
  wire       [31:0]   wbIntcon_io_busSlaves_1_DAT_MOSI;
  wire       [27:0]   wbIntcon_io_busSlaves_1_ADR;
  wire                wbIntcon_io_busSlaves_1_CYC;
  wire       [3:0]    wbIntcon_io_busSlaves_1_SEL;
  wire                wbIntcon_io_busSlaves_1_STB;
  wire                wbIntcon_io_busSlaves_1_WE;
  wire                ram1_io_axi_arw_ready;
  wire                ram1_io_axi_w_ready;
  wire                ram1_io_axi_b_valid;
  wire       [8:0]    ram1_io_axi_b_payload_id;
  wire       [1:0]    ram1_io_axi_b_payload_resp;
  wire                ram1_io_axi_r_valid;
  wire       [63:0]   ram1_io_axi_r_payload_data;
  wire       [8:0]    ram1_io_axi_r_payload_id;
  wire       [1:0]    ram1_io_axi_r_payload_resp;
  wire                ram1_io_axi_r_payload_last;
  wire                usbPiped_readOnly_decoder_io_input_ar_ready;
  wire                usbPiped_readOnly_decoder_io_input_r_valid;
  wire       [63:0]   usbPiped_readOnly_decoder_io_input_r_payload_data;
  wire       [7:0]    usbPiped_readOnly_decoder_io_input_r_payload_id;
  wire       [1:0]    usbPiped_readOnly_decoder_io_input_r_payload_resp;
  wire                usbPiped_readOnly_decoder_io_input_r_payload_last;
  wire                usbPiped_readOnly_decoder_io_outputs_0_ar_valid;
  wire       [31:0]   usbPiped_readOnly_decoder_io_outputs_0_ar_payload_addr;
  wire       [7:0]    usbPiped_readOnly_decoder_io_outputs_0_ar_payload_id;
  wire       [7:0]    usbPiped_readOnly_decoder_io_outputs_0_ar_payload_len;
  wire       [2:0]    usbPiped_readOnly_decoder_io_outputs_0_ar_payload_size;
  wire       [1:0]    usbPiped_readOnly_decoder_io_outputs_0_ar_payload_burst;
  wire       [0:0]    usbPiped_readOnly_decoder_io_outputs_0_ar_payload_lock;
  wire       [3:0]    usbPiped_readOnly_decoder_io_outputs_0_ar_payload_cache;
  wire       [2:0]    usbPiped_readOnly_decoder_io_outputs_0_ar_payload_prot;
  wire                usbPiped_readOnly_decoder_io_outputs_0_r_ready;
  wire                usbPiped_writeOnly_decoder_io_input_aw_ready;
  wire                usbPiped_writeOnly_decoder_io_input_w_ready;
  wire                usbPiped_writeOnly_decoder_io_input_b_valid;
  wire       [7:0]    usbPiped_writeOnly_decoder_io_input_b_payload_id;
  wire       [1:0]    usbPiped_writeOnly_decoder_io_input_b_payload_resp;
  wire                usbPiped_writeOnly_decoder_io_outputs_0_aw_valid;
  wire       [31:0]   usbPiped_writeOnly_decoder_io_outputs_0_aw_payload_addr;
  wire       [7:0]    usbPiped_writeOnly_decoder_io_outputs_0_aw_payload_id;
  wire       [7:0]    usbPiped_writeOnly_decoder_io_outputs_0_aw_payload_len;
  wire       [2:0]    usbPiped_writeOnly_decoder_io_outputs_0_aw_payload_size;
  wire       [1:0]    usbPiped_writeOnly_decoder_io_outputs_0_aw_payload_burst;
  wire       [0:0]    usbPiped_writeOnly_decoder_io_outputs_0_aw_payload_lock;
  wire       [3:0]    usbPiped_writeOnly_decoder_io_outputs_0_aw_payload_cache;
  wire       [2:0]    usbPiped_writeOnly_decoder_io_outputs_0_aw_payload_prot;
  wire                usbPiped_writeOnly_decoder_io_outputs_0_w_valid;
  wire       [63:0]   usbPiped_writeOnly_decoder_io_outputs_0_w_payload_data;
  wire       [7:0]    usbPiped_writeOnly_decoder_io_outputs_0_w_payload_strb;
  wire                usbPiped_writeOnly_decoder_io_outputs_0_w_payload_last;
  wire                usbPiped_writeOnly_decoder_io_outputs_0_b_ready;
  wire                toplevel_wb2axi4_1_io_axi_readOnly_decoder_io_input_ar_ready;
  wire                toplevel_wb2axi4_1_io_axi_readOnly_decoder_io_input_r_valid;
  wire       [63:0]   toplevel_wb2axi4_1_io_axi_readOnly_decoder_io_input_r_payload_data;
  wire       [7:0]    toplevel_wb2axi4_1_io_axi_readOnly_decoder_io_input_r_payload_id;
  wire       [1:0]    toplevel_wb2axi4_1_io_axi_readOnly_decoder_io_input_r_payload_resp;
  wire                toplevel_wb2axi4_1_io_axi_readOnly_decoder_io_input_r_payload_last;
  wire                toplevel_wb2axi4_1_io_axi_readOnly_decoder_io_outputs_0_ar_valid;
  wire       [31:0]   toplevel_wb2axi4_1_io_axi_readOnly_decoder_io_outputs_0_ar_payload_addr;
  wire       [7:0]    toplevel_wb2axi4_1_io_axi_readOnly_decoder_io_outputs_0_ar_payload_id;
  wire       [7:0]    toplevel_wb2axi4_1_io_axi_readOnly_decoder_io_outputs_0_ar_payload_len;
  wire       [2:0]    toplevel_wb2axi4_1_io_axi_readOnly_decoder_io_outputs_0_ar_payload_size;
  wire       [1:0]    toplevel_wb2axi4_1_io_axi_readOnly_decoder_io_outputs_0_ar_payload_burst;
  wire       [0:0]    toplevel_wb2axi4_1_io_axi_readOnly_decoder_io_outputs_0_ar_payload_lock;
  wire       [3:0]    toplevel_wb2axi4_1_io_axi_readOnly_decoder_io_outputs_0_ar_payload_cache;
  wire       [2:0]    toplevel_wb2axi4_1_io_axi_readOnly_decoder_io_outputs_0_ar_payload_prot;
  wire                toplevel_wb2axi4_1_io_axi_readOnly_decoder_io_outputs_0_r_ready;
  wire                toplevel_wb2axi4_1_io_axi_writeOnly_decoder_io_input_aw_ready;
  wire                toplevel_wb2axi4_1_io_axi_writeOnly_decoder_io_input_w_ready;
  wire                toplevel_wb2axi4_1_io_axi_writeOnly_decoder_io_input_b_valid;
  wire       [7:0]    toplevel_wb2axi4_1_io_axi_writeOnly_decoder_io_input_b_payload_id;
  wire       [1:0]    toplevel_wb2axi4_1_io_axi_writeOnly_decoder_io_input_b_payload_resp;
  wire                toplevel_wb2axi4_1_io_axi_writeOnly_decoder_io_outputs_0_aw_valid;
  wire       [31:0]   toplevel_wb2axi4_1_io_axi_writeOnly_decoder_io_outputs_0_aw_payload_addr;
  wire       [7:0]    toplevel_wb2axi4_1_io_axi_writeOnly_decoder_io_outputs_0_aw_payload_id;
  wire       [7:0]    toplevel_wb2axi4_1_io_axi_writeOnly_decoder_io_outputs_0_aw_payload_len;
  wire       [2:0]    toplevel_wb2axi4_1_io_axi_writeOnly_decoder_io_outputs_0_aw_payload_size;
  wire       [1:0]    toplevel_wb2axi4_1_io_axi_writeOnly_decoder_io_outputs_0_aw_payload_burst;
  wire       [0:0]    toplevel_wb2axi4_1_io_axi_writeOnly_decoder_io_outputs_0_aw_payload_lock;
  wire       [3:0]    toplevel_wb2axi4_1_io_axi_writeOnly_decoder_io_outputs_0_aw_payload_cache;
  wire       [2:0]    toplevel_wb2axi4_1_io_axi_writeOnly_decoder_io_outputs_0_aw_payload_prot;
  wire                toplevel_wb2axi4_1_io_axi_writeOnly_decoder_io_outputs_0_w_valid;
  wire       [63:0]   toplevel_wb2axi4_1_io_axi_writeOnly_decoder_io_outputs_0_w_payload_data;
  wire       [7:0]    toplevel_wb2axi4_1_io_axi_writeOnly_decoder_io_outputs_0_w_payload_strb;
  wire                toplevel_wb2axi4_1_io_axi_writeOnly_decoder_io_outputs_0_w_payload_last;
  wire                toplevel_wb2axi4_1_io_axi_writeOnly_decoder_io_outputs_0_b_ready;
  wire                ram1_io_axi_arbiter_io_readInputs_0_ar_ready;
  wire                ram1_io_axi_arbiter_io_readInputs_0_r_valid;
  wire       [63:0]   ram1_io_axi_arbiter_io_readInputs_0_r_payload_data;
  wire       [7:0]    ram1_io_axi_arbiter_io_readInputs_0_r_payload_id;
  wire       [1:0]    ram1_io_axi_arbiter_io_readInputs_0_r_payload_resp;
  wire                ram1_io_axi_arbiter_io_readInputs_0_r_payload_last;
  wire                ram1_io_axi_arbiter_io_readInputs_1_ar_ready;
  wire                ram1_io_axi_arbiter_io_readInputs_1_r_valid;
  wire       [63:0]   ram1_io_axi_arbiter_io_readInputs_1_r_payload_data;
  wire       [7:0]    ram1_io_axi_arbiter_io_readInputs_1_r_payload_id;
  wire       [1:0]    ram1_io_axi_arbiter_io_readInputs_1_r_payload_resp;
  wire                ram1_io_axi_arbiter_io_readInputs_1_r_payload_last;
  wire                ram1_io_axi_arbiter_io_writeInputs_0_aw_ready;
  wire                ram1_io_axi_arbiter_io_writeInputs_0_w_ready;
  wire                ram1_io_axi_arbiter_io_writeInputs_0_b_valid;
  wire       [7:0]    ram1_io_axi_arbiter_io_writeInputs_0_b_payload_id;
  wire       [1:0]    ram1_io_axi_arbiter_io_writeInputs_0_b_payload_resp;
  wire                ram1_io_axi_arbiter_io_writeInputs_1_aw_ready;
  wire                ram1_io_axi_arbiter_io_writeInputs_1_w_ready;
  wire                ram1_io_axi_arbiter_io_writeInputs_1_b_valid;
  wire       [7:0]    ram1_io_axi_arbiter_io_writeInputs_1_b_payload_id;
  wire       [1:0]    ram1_io_axi_arbiter_io_writeInputs_1_b_payload_resp;
  wire                ram1_io_axi_arbiter_io_output_arw_valid;
  wire       [11:0]   ram1_io_axi_arbiter_io_output_arw_payload_addr;
  wire       [8:0]    ram1_io_axi_arbiter_io_output_arw_payload_id;
  wire       [7:0]    ram1_io_axi_arbiter_io_output_arw_payload_len;
  wire       [2:0]    ram1_io_axi_arbiter_io_output_arw_payload_size;
  wire       [1:0]    ram1_io_axi_arbiter_io_output_arw_payload_burst;
  wire                ram1_io_axi_arbiter_io_output_arw_payload_write;
  wire                ram1_io_axi_arbiter_io_output_w_valid;
  wire       [63:0]   ram1_io_axi_arbiter_io_output_w_payload_data;
  wire       [7:0]    ram1_io_axi_arbiter_io_output_w_payload_strb;
  wire                ram1_io_axi_arbiter_io_output_w_payload_last;
  wire                ram1_io_axi_arbiter_io_output_b_ready;
  wire                ram1_io_axi_arbiter_io_output_r_ready;
  wire                usbPiped_aw_valid;
  wire                usbPiped_aw_ready;
  wire       [31:0]   usbPiped_aw_payload_addr;
  wire       [7:0]    usbPiped_aw_payload_id;
  wire       [7:0]    usbPiped_aw_payload_len;
  wire       [2:0]    usbPiped_aw_payload_size;
  wire       [1:0]    usbPiped_aw_payload_burst;
  wire       [0:0]    usbPiped_aw_payload_lock;
  wire       [3:0]    usbPiped_aw_payload_cache;
  wire       [2:0]    usbPiped_aw_payload_prot;
  wire                usbPiped_w_valid;
  wire                usbPiped_w_ready;
  wire       [63:0]   usbPiped_w_payload_data;
  wire       [7:0]    usbPiped_w_payload_strb;
  wire                usbPiped_w_payload_last;
  wire                usbPiped_b_valid;
  wire                usbPiped_b_ready;
  wire       [7:0]    usbPiped_b_payload_id;
  wire       [1:0]    usbPiped_b_payload_resp;
  wire                usbPiped_ar_valid;
  wire                usbPiped_ar_ready;
  wire       [31:0]   usbPiped_ar_payload_addr;
  wire       [7:0]    usbPiped_ar_payload_id;
  wire       [7:0]    usbPiped_ar_payload_len;
  wire       [2:0]    usbPiped_ar_payload_size;
  wire       [1:0]    usbPiped_ar_payload_burst;
  wire       [0:0]    usbPiped_ar_payload_lock;
  wire       [3:0]    usbPiped_ar_payload_cache;
  wire       [2:0]    usbPiped_ar_payload_prot;
  wire                usbPiped_r_valid;
  wire                usbPiped_r_ready;
  wire       [63:0]   usbPiped_r_payload_data;
  wire       [7:0]    usbPiped_r_payload_id;
  wire       [1:0]    usbPiped_r_payload_resp;
  wire                usbPiped_r_payload_last;
  wire                toplevel_usbCore_io_axi_aw_s2mPipe_valid;
  reg                 toplevel_usbCore_io_axi_aw_s2mPipe_ready;
  wire       [31:0]   toplevel_usbCore_io_axi_aw_s2mPipe_payload_addr;
  wire       [7:0]    toplevel_usbCore_io_axi_aw_s2mPipe_payload_id;
  wire       [7:0]    toplevel_usbCore_io_axi_aw_s2mPipe_payload_len;
  wire       [2:0]    toplevel_usbCore_io_axi_aw_s2mPipe_payload_size;
  wire       [1:0]    toplevel_usbCore_io_axi_aw_s2mPipe_payload_burst;
  wire       [0:0]    toplevel_usbCore_io_axi_aw_s2mPipe_payload_lock;
  wire       [3:0]    toplevel_usbCore_io_axi_aw_s2mPipe_payload_cache;
  wire       [2:0]    toplevel_usbCore_io_axi_aw_s2mPipe_payload_prot;
  reg                 toplevel_usbCore_io_axi_aw_rValidN;
  reg        [31:0]   toplevel_usbCore_io_axi_aw_rData_addr;
  reg        [7:0]    toplevel_usbCore_io_axi_aw_rData_id;
  reg        [7:0]    toplevel_usbCore_io_axi_aw_rData_len;
  reg        [2:0]    toplevel_usbCore_io_axi_aw_rData_size;
  reg        [1:0]    toplevel_usbCore_io_axi_aw_rData_burst;
  reg        [0:0]    toplevel_usbCore_io_axi_aw_rData_lock;
  reg        [3:0]    toplevel_usbCore_io_axi_aw_rData_cache;
  reg        [2:0]    toplevel_usbCore_io_axi_aw_rData_prot;
  wire                toplevel_usbCore_io_axi_aw_s2mPipe_m2sPipe_valid;
  wire                toplevel_usbCore_io_axi_aw_s2mPipe_m2sPipe_ready;
  wire       [31:0]   toplevel_usbCore_io_axi_aw_s2mPipe_m2sPipe_payload_addr;
  wire       [7:0]    toplevel_usbCore_io_axi_aw_s2mPipe_m2sPipe_payload_id;
  wire       [7:0]    toplevel_usbCore_io_axi_aw_s2mPipe_m2sPipe_payload_len;
  wire       [2:0]    toplevel_usbCore_io_axi_aw_s2mPipe_m2sPipe_payload_size;
  wire       [1:0]    toplevel_usbCore_io_axi_aw_s2mPipe_m2sPipe_payload_burst;
  wire       [0:0]    toplevel_usbCore_io_axi_aw_s2mPipe_m2sPipe_payload_lock;
  wire       [3:0]    toplevel_usbCore_io_axi_aw_s2mPipe_m2sPipe_payload_cache;
  wire       [2:0]    toplevel_usbCore_io_axi_aw_s2mPipe_m2sPipe_payload_prot;
  reg                 toplevel_usbCore_io_axi_aw_s2mPipe_rValid;
  reg        [31:0]   toplevel_usbCore_io_axi_aw_s2mPipe_rData_addr;
  reg        [7:0]    toplevel_usbCore_io_axi_aw_s2mPipe_rData_id;
  reg        [7:0]    toplevel_usbCore_io_axi_aw_s2mPipe_rData_len;
  reg        [2:0]    toplevel_usbCore_io_axi_aw_s2mPipe_rData_size;
  reg        [1:0]    toplevel_usbCore_io_axi_aw_s2mPipe_rData_burst;
  reg        [0:0]    toplevel_usbCore_io_axi_aw_s2mPipe_rData_lock;
  reg        [3:0]    toplevel_usbCore_io_axi_aw_s2mPipe_rData_cache;
  reg        [2:0]    toplevel_usbCore_io_axi_aw_s2mPipe_rData_prot;
  wire                when_Stream_l369;
  wire                toplevel_usbCore_io_axi_w_combStage_valid;
  wire                toplevel_usbCore_io_axi_w_combStage_ready;
  wire       [63:0]   toplevel_usbCore_io_axi_w_combStage_payload_data;
  wire       [7:0]    toplevel_usbCore_io_axi_w_combStage_payload_strb;
  wire                toplevel_usbCore_io_axi_w_combStage_payload_last;
  wire                usbPiped_b_combStage_valid;
  wire                usbPiped_b_combStage_ready;
  wire       [7:0]    usbPiped_b_combStage_payload_id;
  wire       [1:0]    usbPiped_b_combStage_payload_resp;
  wire                toplevel_usbCore_io_axi_ar_s2mPipe_valid;
  reg                 toplevel_usbCore_io_axi_ar_s2mPipe_ready;
  wire       [31:0]   toplevel_usbCore_io_axi_ar_s2mPipe_payload_addr;
  wire       [7:0]    toplevel_usbCore_io_axi_ar_s2mPipe_payload_id;
  wire       [7:0]    toplevel_usbCore_io_axi_ar_s2mPipe_payload_len;
  wire       [2:0]    toplevel_usbCore_io_axi_ar_s2mPipe_payload_size;
  wire       [1:0]    toplevel_usbCore_io_axi_ar_s2mPipe_payload_burst;
  wire       [0:0]    toplevel_usbCore_io_axi_ar_s2mPipe_payload_lock;
  wire       [3:0]    toplevel_usbCore_io_axi_ar_s2mPipe_payload_cache;
  wire       [2:0]    toplevel_usbCore_io_axi_ar_s2mPipe_payload_prot;
  reg                 toplevel_usbCore_io_axi_ar_rValidN;
  reg        [31:0]   toplevel_usbCore_io_axi_ar_rData_addr;
  reg        [7:0]    toplevel_usbCore_io_axi_ar_rData_id;
  reg        [7:0]    toplevel_usbCore_io_axi_ar_rData_len;
  reg        [2:0]    toplevel_usbCore_io_axi_ar_rData_size;
  reg        [1:0]    toplevel_usbCore_io_axi_ar_rData_burst;
  reg        [0:0]    toplevel_usbCore_io_axi_ar_rData_lock;
  reg        [3:0]    toplevel_usbCore_io_axi_ar_rData_cache;
  reg        [2:0]    toplevel_usbCore_io_axi_ar_rData_prot;
  wire                toplevel_usbCore_io_axi_ar_s2mPipe_m2sPipe_valid;
  wire                toplevel_usbCore_io_axi_ar_s2mPipe_m2sPipe_ready;
  wire       [31:0]   toplevel_usbCore_io_axi_ar_s2mPipe_m2sPipe_payload_addr;
  wire       [7:0]    toplevel_usbCore_io_axi_ar_s2mPipe_m2sPipe_payload_id;
  wire       [7:0]    toplevel_usbCore_io_axi_ar_s2mPipe_m2sPipe_payload_len;
  wire       [2:0]    toplevel_usbCore_io_axi_ar_s2mPipe_m2sPipe_payload_size;
  wire       [1:0]    toplevel_usbCore_io_axi_ar_s2mPipe_m2sPipe_payload_burst;
  wire       [0:0]    toplevel_usbCore_io_axi_ar_s2mPipe_m2sPipe_payload_lock;
  wire       [3:0]    toplevel_usbCore_io_axi_ar_s2mPipe_m2sPipe_payload_cache;
  wire       [2:0]    toplevel_usbCore_io_axi_ar_s2mPipe_m2sPipe_payload_prot;
  reg                 toplevel_usbCore_io_axi_ar_s2mPipe_rValid;
  reg        [31:0]   toplevel_usbCore_io_axi_ar_s2mPipe_rData_addr;
  reg        [7:0]    toplevel_usbCore_io_axi_ar_s2mPipe_rData_id;
  reg        [7:0]    toplevel_usbCore_io_axi_ar_s2mPipe_rData_len;
  reg        [2:0]    toplevel_usbCore_io_axi_ar_s2mPipe_rData_size;
  reg        [1:0]    toplevel_usbCore_io_axi_ar_s2mPipe_rData_burst;
  reg        [0:0]    toplevel_usbCore_io_axi_ar_s2mPipe_rData_lock;
  reg        [3:0]    toplevel_usbCore_io_axi_ar_s2mPipe_rData_cache;
  reg        [2:0]    toplevel_usbCore_io_axi_ar_s2mPipe_rData_prot;
  wire                when_Stream_l369_1;
  wire                usbPiped_r_combStage_valid;
  wire                usbPiped_r_combStage_ready;
  wire       [63:0]   usbPiped_r_combStage_payload_data;
  wire       [7:0]    usbPiped_r_combStage_payload_id;
  wire       [1:0]    usbPiped_r_combStage_payload_resp;
  wire                usbPiped_r_combStage_payload_last;
  wire                usbPiped_readOnly_ar_valid;
  wire                usbPiped_readOnly_ar_ready;
  wire       [31:0]   usbPiped_readOnly_ar_payload_addr;
  wire       [7:0]    usbPiped_readOnly_ar_payload_id;
  wire       [7:0]    usbPiped_readOnly_ar_payload_len;
  wire       [2:0]    usbPiped_readOnly_ar_payload_size;
  wire       [1:0]    usbPiped_readOnly_ar_payload_burst;
  wire       [0:0]    usbPiped_readOnly_ar_payload_lock;
  wire       [3:0]    usbPiped_readOnly_ar_payload_cache;
  wire       [2:0]    usbPiped_readOnly_ar_payload_prot;
  wire                usbPiped_readOnly_r_valid;
  wire                usbPiped_readOnly_r_ready;
  wire       [63:0]   usbPiped_readOnly_r_payload_data;
  wire       [7:0]    usbPiped_readOnly_r_payload_id;
  wire       [1:0]    usbPiped_readOnly_r_payload_resp;
  wire                usbPiped_readOnly_r_payload_last;
  wire                usbPiped_writeOnly_aw_valid;
  wire                usbPiped_writeOnly_aw_ready;
  wire       [31:0]   usbPiped_writeOnly_aw_payload_addr;
  wire       [7:0]    usbPiped_writeOnly_aw_payload_id;
  wire       [7:0]    usbPiped_writeOnly_aw_payload_len;
  wire       [2:0]    usbPiped_writeOnly_aw_payload_size;
  wire       [1:0]    usbPiped_writeOnly_aw_payload_burst;
  wire       [0:0]    usbPiped_writeOnly_aw_payload_lock;
  wire       [3:0]    usbPiped_writeOnly_aw_payload_cache;
  wire       [2:0]    usbPiped_writeOnly_aw_payload_prot;
  wire                usbPiped_writeOnly_w_valid;
  wire                usbPiped_writeOnly_w_ready;
  wire       [63:0]   usbPiped_writeOnly_w_payload_data;
  wire       [7:0]    usbPiped_writeOnly_w_payload_strb;
  wire                usbPiped_writeOnly_w_payload_last;
  wire                usbPiped_writeOnly_b_valid;
  wire                usbPiped_writeOnly_b_ready;
  wire       [7:0]    usbPiped_writeOnly_b_payload_id;
  wire       [1:0]    usbPiped_writeOnly_b_payload_resp;
  wire                toplevel_wb2axi4_1_io_axi_readOnly_ar_valid;
  wire                toplevel_wb2axi4_1_io_axi_readOnly_ar_ready;
  wire       [31:0]   toplevel_wb2axi4_1_io_axi_readOnly_ar_payload_addr;
  wire       [7:0]    toplevel_wb2axi4_1_io_axi_readOnly_ar_payload_id;
  wire       [7:0]    toplevel_wb2axi4_1_io_axi_readOnly_ar_payload_len;
  wire       [2:0]    toplevel_wb2axi4_1_io_axi_readOnly_ar_payload_size;
  wire       [1:0]    toplevel_wb2axi4_1_io_axi_readOnly_ar_payload_burst;
  wire       [0:0]    toplevel_wb2axi4_1_io_axi_readOnly_ar_payload_lock;
  wire       [3:0]    toplevel_wb2axi4_1_io_axi_readOnly_ar_payload_cache;
  wire       [2:0]    toplevel_wb2axi4_1_io_axi_readOnly_ar_payload_prot;
  wire                toplevel_wb2axi4_1_io_axi_readOnly_r_valid;
  wire                toplevel_wb2axi4_1_io_axi_readOnly_r_ready;
  wire       [63:0]   toplevel_wb2axi4_1_io_axi_readOnly_r_payload_data;
  wire       [7:0]    toplevel_wb2axi4_1_io_axi_readOnly_r_payload_id;
  wire       [1:0]    toplevel_wb2axi4_1_io_axi_readOnly_r_payload_resp;
  wire                toplevel_wb2axi4_1_io_axi_readOnly_r_payload_last;
  wire                toplevel_wb2axi4_1_io_axi_writeOnly_aw_valid;
  wire                toplevel_wb2axi4_1_io_axi_writeOnly_aw_ready;
  wire       [31:0]   toplevel_wb2axi4_1_io_axi_writeOnly_aw_payload_addr;
  wire       [7:0]    toplevel_wb2axi4_1_io_axi_writeOnly_aw_payload_id;
  wire       [7:0]    toplevel_wb2axi4_1_io_axi_writeOnly_aw_payload_len;
  wire       [2:0]    toplevel_wb2axi4_1_io_axi_writeOnly_aw_payload_size;
  wire       [1:0]    toplevel_wb2axi4_1_io_axi_writeOnly_aw_payload_burst;
  wire       [0:0]    toplevel_wb2axi4_1_io_axi_writeOnly_aw_payload_lock;
  wire       [3:0]    toplevel_wb2axi4_1_io_axi_writeOnly_aw_payload_cache;
  wire       [2:0]    toplevel_wb2axi4_1_io_axi_writeOnly_aw_payload_prot;
  wire                toplevel_wb2axi4_1_io_axi_writeOnly_w_valid;
  wire                toplevel_wb2axi4_1_io_axi_writeOnly_w_ready;
  wire       [63:0]   toplevel_wb2axi4_1_io_axi_writeOnly_w_payload_data;
  wire       [7:0]    toplevel_wb2axi4_1_io_axi_writeOnly_w_payload_strb;
  wire                toplevel_wb2axi4_1_io_axi_writeOnly_w_payload_last;
  wire                toplevel_wb2axi4_1_io_axi_writeOnly_b_valid;
  wire                toplevel_wb2axi4_1_io_axi_writeOnly_b_ready;
  wire       [7:0]    toplevel_wb2axi4_1_io_axi_writeOnly_b_payload_id;
  wire       [1:0]    toplevel_wb2axi4_1_io_axi_writeOnly_b_payload_resp;
  wire                toplevel_usbPiped_readOnly_decoder_io_outputs_0_ar_validPipe_valid;
  wire                toplevel_usbPiped_readOnly_decoder_io_outputs_0_ar_validPipe_ready;
  wire       [31:0]   toplevel_usbPiped_readOnly_decoder_io_outputs_0_ar_validPipe_payload_addr;
  wire       [7:0]    toplevel_usbPiped_readOnly_decoder_io_outputs_0_ar_validPipe_payload_id;
  wire       [7:0]    toplevel_usbPiped_readOnly_decoder_io_outputs_0_ar_validPipe_payload_len;
  wire       [2:0]    toplevel_usbPiped_readOnly_decoder_io_outputs_0_ar_validPipe_payload_size;
  wire       [1:0]    toplevel_usbPiped_readOnly_decoder_io_outputs_0_ar_validPipe_payload_burst;
  wire       [0:0]    toplevel_usbPiped_readOnly_decoder_io_outputs_0_ar_validPipe_payload_lock;
  wire       [3:0]    toplevel_usbPiped_readOnly_decoder_io_outputs_0_ar_validPipe_payload_cache;
  wire       [2:0]    toplevel_usbPiped_readOnly_decoder_io_outputs_0_ar_validPipe_payload_prot;
  reg                 toplevel_usbPiped_readOnly_decoder_io_outputs_0_ar_rValid;
  wire                toplevel_usbPiped_readOnly_decoder_io_outputs_0_ar_validPipe_fire;
  wire                toplevel_usbPiped_writeOnly_decoder_io_outputs_0_aw_validPipe_valid;
  wire                toplevel_usbPiped_writeOnly_decoder_io_outputs_0_aw_validPipe_ready;
  wire       [31:0]   toplevel_usbPiped_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_addr;
  wire       [7:0]    toplevel_usbPiped_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_id;
  wire       [7:0]    toplevel_usbPiped_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_len;
  wire       [2:0]    toplevel_usbPiped_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_size;
  wire       [1:0]    toplevel_usbPiped_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_burst;
  wire       [0:0]    toplevel_usbPiped_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_lock;
  wire       [3:0]    toplevel_usbPiped_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_cache;
  wire       [2:0]    toplevel_usbPiped_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_prot;
  reg                 toplevel_usbPiped_writeOnly_decoder_io_outputs_0_aw_rValid;
  wire                toplevel_usbPiped_writeOnly_decoder_io_outputs_0_aw_validPipe_fire;
  wire                toplevel_toplevel_wb2axi4_1_io_axi_readOnly_decoder_io_outputs_0_ar_validPipe_valid;
  wire                toplevel_toplevel_wb2axi4_1_io_axi_readOnly_decoder_io_outputs_0_ar_validPipe_ready;
  wire       [31:0]   toplevel_toplevel_wb2axi4_1_io_axi_readOnly_decoder_io_outputs_0_ar_validPipe_payload_addr;
  wire       [7:0]    toplevel_toplevel_wb2axi4_1_io_axi_readOnly_decoder_io_outputs_0_ar_validPipe_payload_id;
  wire       [7:0]    toplevel_toplevel_wb2axi4_1_io_axi_readOnly_decoder_io_outputs_0_ar_validPipe_payload_len;
  wire       [2:0]    toplevel_toplevel_wb2axi4_1_io_axi_readOnly_decoder_io_outputs_0_ar_validPipe_payload_size;
  wire       [1:0]    toplevel_toplevel_wb2axi4_1_io_axi_readOnly_decoder_io_outputs_0_ar_validPipe_payload_burst;
  wire       [0:0]    toplevel_toplevel_wb2axi4_1_io_axi_readOnly_decoder_io_outputs_0_ar_validPipe_payload_lock;
  wire       [3:0]    toplevel_toplevel_wb2axi4_1_io_axi_readOnly_decoder_io_outputs_0_ar_validPipe_payload_cache;
  wire       [2:0]    toplevel_toplevel_wb2axi4_1_io_axi_readOnly_decoder_io_outputs_0_ar_validPipe_payload_prot;
  reg                 toplevel_toplevel_wb2axi4_1_io_axi_readOnly_decoder_io_outputs_0_ar_rValid;
  wire                toplevel_toplevel_wb2axi4_1_io_axi_readOnly_decoder_io_outputs_0_ar_validPipe_fire;
  wire                toplevel_toplevel_wb2axi4_1_io_axi_writeOnly_decoder_io_outputs_0_aw_validPipe_valid;
  wire                toplevel_toplevel_wb2axi4_1_io_axi_writeOnly_decoder_io_outputs_0_aw_validPipe_ready;
  wire       [31:0]   toplevel_toplevel_wb2axi4_1_io_axi_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_addr;
  wire       [7:0]    toplevel_toplevel_wb2axi4_1_io_axi_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_id;
  wire       [7:0]    toplevel_toplevel_wb2axi4_1_io_axi_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_len;
  wire       [2:0]    toplevel_toplevel_wb2axi4_1_io_axi_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_size;
  wire       [1:0]    toplevel_toplevel_wb2axi4_1_io_axi_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_burst;
  wire       [0:0]    toplevel_toplevel_wb2axi4_1_io_axi_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_lock;
  wire       [3:0]    toplevel_toplevel_wb2axi4_1_io_axi_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_cache;
  wire       [2:0]    toplevel_toplevel_wb2axi4_1_io_axi_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_prot;
  reg                 toplevel_toplevel_wb2axi4_1_io_axi_writeOnly_decoder_io_outputs_0_aw_rValid;
  wire                toplevel_toplevel_wb2axi4_1_io_axi_writeOnly_decoder_io_outputs_0_aw_validPipe_fire;

  USB23Wrapper usbCore (
    .io_usbIO_VBUS         ({usb23_VBUS}),
    .io_usbIO_REFINCLKEXTP (usb23_REFINCLKEXTP                       ), //i
    .io_usbIO_REFINCLKEXTM (usb23_REFINCLKEXTM                       ), //i
    .io_usbIO_RESEXTUSB2   ({usb23_RESEXTUSB2}),
    .io_usbIO_DP           ({usb23_DP}),
    .io_usbIO_DM           ({usb23_DM}),
    .io_usbIO_RXM          (usb23_RXM                                ), //i
    .io_usbIO_RXP          (usb23_RXP                                ), //i
    .io_usbIO_TXM          (usbCore_io_usbIO_TXM                     ), //o
    .io_usbIO_TXP          (usbCore_io_usbIO_TXP                     ), //o
    .io_clk_60m            (clk_60m                                  ), //i
    .io_irq                (usbCore_io_irq                           ), //o
    .axi_awvalid           (usbCore_axi_awvalid                      ), //o
    .axi_awready           (toplevel_usbCore_io_axi_aw_rValidN       ), //i
    .axi_awaddr            (usbCore_axi_awaddr[31:0]                 ), //o
    .axi_awid              (usbCore_axi_awid[7:0]                    ), //o
    .axi_awlen             (usbCore_axi_awlen[7:0]                   ), //o
    .axi_awsize            (usbCore_axi_awsize[2:0]                  ), //o
    .axi_awburst           (usbCore_axi_awburst[1:0]                 ), //o
    .axi_awlock            (usbCore_axi_awlock                       ), //o
    .axi_awcache           (usbCore_axi_awcache[3:0]                 ), //o
    .axi_awprot            (usbCore_axi_awprot[2:0]                  ), //o
    .axi_wvalid            (usbCore_axi_wvalid                       ), //o
    .axi_wready            (toplevel_usbCore_io_axi_w_combStage_ready), //i
    .axi_wdata             (usbCore_axi_wdata[63:0]                  ), //o
    .axi_wstrb             (usbCore_axi_wstrb[7:0]                   ), //o
    .axi_wlast             (usbCore_axi_wlast                        ), //o
    .axi_bvalid            (usbPiped_b_combStage_valid               ), //i
    .axi_bready            (usbCore_axi_bready                       ), //o
    .axi_bid               (usbPiped_b_combStage_payload_id[7:0]     ), //i
    .axi_bresp             (usbPiped_b_combStage_payload_resp[1:0]   ), //i
    .axi_arvalid           (usbCore_axi_arvalid                      ), //o
    .axi_arready           (toplevel_usbCore_io_axi_ar_rValidN       ), //i
    .axi_araddr            (usbCore_axi_araddr[31:0]                 ), //o
    .axi_arid              (usbCore_axi_arid[7:0]                    ), //o
    .axi_arlen             (usbCore_axi_arlen[7:0]                   ), //o
    .axi_arsize            (usbCore_axi_arsize[2:0]                  ), //o
    .axi_arburst           (usbCore_axi_arburst[1:0]                 ), //o
    .axi_arlock            (usbCore_axi_arlock                       ), //o
    .axi_arcache           (usbCore_axi_arcache[3:0]                 ), //o
    .axi_arprot            (usbCore_axi_arprot[2:0]                  ), //o
    .axi_rvalid            (usbPiped_r_combStage_valid               ), //i
    .axi_rready            (usbCore_axi_rready                       ), //o
    .axi_rdata             (usbPiped_r_combStage_payload_data[63:0]  ), //i
    .axi_rid               (usbPiped_r_combStage_payload_id[7:0]     ), //i
    .axi_rresp             (usbPiped_r_combStage_payload_resp[1:0]   ), //i
    .axi_rlast             (usbPiped_r_combStage_payload_last        ), //i
    .io_wb_CYC             (wbIntcon_io_busSlaves_0_CYC              ), //i
    .io_wb_STB             (wbIntcon_io_busSlaves_0_STB              ), //i
    .io_wb_ACK             (usbCore_io_wb_ACK                        ), //o
    .io_wb_WE              (wbIntcon_io_busSlaves_0_WE               ), //i
    .io_wb_ADR             (wbIntcon_io_busSlaves_0_ADR[27:0]        ), //i
    .io_wb_DAT_MISO        (usbCore_io_wb_DAT_MISO[31:0]             ), //o
    .io_wb_DAT_MOSI        (wbIntcon_io_busSlaves_0_DAT_MOSI[31:0]   ), //i
    .io_wb_SEL             (wbIntcon_io_busSlaves_0_SEL[3:0]         ), //i
    .clk                   (clk                                      ), //i
    .reset                 (reset                                    )  //i
  );
  Wb2Axi4 wb2axi4_1 (
    .io_wb_CYC               (wbIntcon_io_busSlaves_1_CYC                            ), //i
    .io_wb_STB               (wbIntcon_io_busSlaves_1_STB                            ), //i
    .io_wb_ACK               (wb2axi4_1_io_wb_ACK                                    ), //o
    .io_wb_WE                (wbIntcon_io_busSlaves_1_WE                             ), //i
    .io_wb_ADR               (wbIntcon_io_busSlaves_1_ADR[27:0]                      ), //i
    .io_wb_DAT_MISO          (wb2axi4_1_io_wb_DAT_MISO[31:0]                         ), //o
    .io_wb_DAT_MOSI          (wbIntcon_io_busSlaves_1_DAT_MOSI[31:0]                 ), //i
    .io_wb_SEL               (wbIntcon_io_busSlaves_1_SEL[3:0]                       ), //i
    .io_axi_aw_valid         (wb2axi4_1_io_axi_aw_valid                              ), //o
    .io_axi_aw_ready         (toplevel_wb2axi4_1_io_axi_writeOnly_aw_ready           ), //i
    .io_axi_aw_payload_addr  (wb2axi4_1_io_axi_aw_payload_addr[31:0]                 ), //o
    .io_axi_aw_payload_id    (wb2axi4_1_io_axi_aw_payload_id[7:0]                    ), //o
    .io_axi_aw_payload_len   (wb2axi4_1_io_axi_aw_payload_len[7:0]                   ), //o
    .io_axi_aw_payload_size  (wb2axi4_1_io_axi_aw_payload_size[2:0]                  ), //o
    .io_axi_aw_payload_burst (wb2axi4_1_io_axi_aw_payload_burst[1:0]                 ), //o
    .io_axi_aw_payload_lock  (wb2axi4_1_io_axi_aw_payload_lock                       ), //o
    .io_axi_aw_payload_cache (wb2axi4_1_io_axi_aw_payload_cache[3:0]                 ), //o
    .io_axi_aw_payload_prot  (wb2axi4_1_io_axi_aw_payload_prot[2:0]                  ), //o
    .io_axi_w_valid          (wb2axi4_1_io_axi_w_valid                               ), //o
    .io_axi_w_ready          (toplevel_wb2axi4_1_io_axi_writeOnly_w_ready            ), //i
    .io_axi_w_payload_data   (wb2axi4_1_io_axi_w_payload_data[63:0]                  ), //o
    .io_axi_w_payload_strb   (wb2axi4_1_io_axi_w_payload_strb[7:0]                   ), //o
    .io_axi_w_payload_last   (wb2axi4_1_io_axi_w_payload_last                        ), //o
    .io_axi_b_valid          (toplevel_wb2axi4_1_io_axi_writeOnly_b_valid            ), //i
    .io_axi_b_ready          (wb2axi4_1_io_axi_b_ready                               ), //o
    .io_axi_b_payload_id     (toplevel_wb2axi4_1_io_axi_writeOnly_b_payload_id[7:0]  ), //i
    .io_axi_b_payload_resp   (toplevel_wb2axi4_1_io_axi_writeOnly_b_payload_resp[1:0]), //i
    .io_axi_ar_valid         (wb2axi4_1_io_axi_ar_valid                              ), //o
    .io_axi_ar_ready         (toplevel_wb2axi4_1_io_axi_readOnly_ar_ready            ), //i
    .io_axi_ar_payload_addr  (wb2axi4_1_io_axi_ar_payload_addr[31:0]                 ), //o
    .io_axi_ar_payload_id    (wb2axi4_1_io_axi_ar_payload_id[7:0]                    ), //o
    .io_axi_ar_payload_len   (wb2axi4_1_io_axi_ar_payload_len[7:0]                   ), //o
    .io_axi_ar_payload_size  (wb2axi4_1_io_axi_ar_payload_size[2:0]                  ), //o
    .io_axi_ar_payload_burst (wb2axi4_1_io_axi_ar_payload_burst[1:0]                 ), //o
    .io_axi_ar_payload_lock  (wb2axi4_1_io_axi_ar_payload_lock                       ), //o
    .io_axi_ar_payload_cache (wb2axi4_1_io_axi_ar_payload_cache[3:0]                 ), //o
    .io_axi_ar_payload_prot  (wb2axi4_1_io_axi_ar_payload_prot[2:0]                  ), //o
    .io_axi_r_valid          (toplevel_wb2axi4_1_io_axi_readOnly_r_valid             ), //i
    .io_axi_r_ready          (wb2axi4_1_io_axi_r_ready                               ), //o
    .io_axi_r_payload_data   (toplevel_wb2axi4_1_io_axi_readOnly_r_payload_data[63:0]), //i
    .io_axi_r_payload_id     (toplevel_wb2axi4_1_io_axi_readOnly_r_payload_id[7:0]   ), //i
    .io_axi_r_payload_resp   (toplevel_wb2axi4_1_io_axi_readOnly_r_payload_resp[1:0] ), //i
    .io_axi_r_payload_last   (toplevel_wb2axi4_1_io_axi_readOnly_r_payload_last      ), //i
    .clk                     (clk                                                    ), //i
    .reset                   (reset                                                  )  //i
  );
  WishboneInterconComponent wbIntcon (
    .io_busMasters_0_CYC      (wb_CYC                                 ), //i
    .io_busMasters_0_STB      (wb_STB                                 ), //i
    .io_busMasters_0_ACK      (wbIntcon_io_busMasters_0_ACK           ), //o
    .io_busMasters_0_WE       (wb_WE                                  ), //i
    .io_busMasters_0_ADR      (wb_ADR[27:0]                           ), //i
    .io_busMasters_0_DAT_MISO (wbIntcon_io_busMasters_0_DAT_MISO[31:0]), //o
    .io_busMasters_0_DAT_MOSI (wb_DAT_MOSI[31:0]                      ), //i
    .io_busMasters_0_SEL      (wb_SEL[3:0]                            ), //i
    .io_busSlaves_0_CYC       (wbIntcon_io_busSlaves_0_CYC            ), //o
    .io_busSlaves_0_STB       (wbIntcon_io_busSlaves_0_STB            ), //o
    .io_busSlaves_0_ACK       (usbCore_io_wb_ACK                      ), //i
    .io_busSlaves_0_WE        (wbIntcon_io_busSlaves_0_WE             ), //o
    .io_busSlaves_0_ADR       (wbIntcon_io_busSlaves_0_ADR[27:0]      ), //o
    .io_busSlaves_0_DAT_MISO  (usbCore_io_wb_DAT_MISO[31:0]           ), //i
    .io_busSlaves_0_DAT_MOSI  (wbIntcon_io_busSlaves_0_DAT_MOSI[31:0] ), //o
    .io_busSlaves_0_SEL       (wbIntcon_io_busSlaves_0_SEL[3:0]       ), //o
    .io_busSlaves_1_CYC       (wbIntcon_io_busSlaves_1_CYC            ), //o
    .io_busSlaves_1_STB       (wbIntcon_io_busSlaves_1_STB            ), //o
    .io_busSlaves_1_ACK       (wb2axi4_1_io_wb_ACK                    ), //i
    .io_busSlaves_1_WE        (wbIntcon_io_busSlaves_1_WE             ), //o
    .io_busSlaves_1_ADR       (wbIntcon_io_busSlaves_1_ADR[27:0]      ), //o
    .io_busSlaves_1_DAT_MISO  (wb2axi4_1_io_wb_DAT_MISO[31:0]         ), //i
    .io_busSlaves_1_DAT_MOSI  (wbIntcon_io_busSlaves_1_DAT_MOSI[31:0] ), //o
    .io_busSlaves_1_SEL       (wbIntcon_io_busSlaves_1_SEL[3:0]       )  //o
  );
  Axi4SharedOnChipRam ram1 (
    .io_axi_arw_valid         (ram1_io_axi_arbiter_io_output_arw_valid             ), //i
    .io_axi_arw_ready         (ram1_io_axi_arw_ready                               ), //o
    .io_axi_arw_payload_addr  (ram1_io_axi_arbiter_io_output_arw_payload_addr[11:0]), //i
    .io_axi_arw_payload_id    (ram1_io_axi_arbiter_io_output_arw_payload_id[8:0]   ), //i
    .io_axi_arw_payload_len   (ram1_io_axi_arbiter_io_output_arw_payload_len[7:0]  ), //i
    .io_axi_arw_payload_size  (ram1_io_axi_arbiter_io_output_arw_payload_size[2:0] ), //i
    .io_axi_arw_payload_burst (ram1_io_axi_arbiter_io_output_arw_payload_burst[1:0]), //i
    .io_axi_arw_payload_write (ram1_io_axi_arbiter_io_output_arw_payload_write     ), //i
    .io_axi_w_valid           (ram1_io_axi_arbiter_io_output_w_valid               ), //i
    .io_axi_w_ready           (ram1_io_axi_w_ready                                 ), //o
    .io_axi_w_payload_data    (ram1_io_axi_arbiter_io_output_w_payload_data[63:0]  ), //i
    .io_axi_w_payload_strb    (ram1_io_axi_arbiter_io_output_w_payload_strb[7:0]   ), //i
    .io_axi_w_payload_last    (ram1_io_axi_arbiter_io_output_w_payload_last        ), //i
    .io_axi_b_valid           (ram1_io_axi_b_valid                                 ), //o
    .io_axi_b_ready           (ram1_io_axi_arbiter_io_output_b_ready               ), //i
    .io_axi_b_payload_id      (ram1_io_axi_b_payload_id[8:0]                       ), //o
    .io_axi_b_payload_resp    (ram1_io_axi_b_payload_resp[1:0]                     ), //o
    .io_axi_r_valid           (ram1_io_axi_r_valid                                 ), //o
    .io_axi_r_ready           (ram1_io_axi_arbiter_io_output_r_ready               ), //i
    .io_axi_r_payload_data    (ram1_io_axi_r_payload_data[63:0]                    ), //o
    .io_axi_r_payload_id      (ram1_io_axi_r_payload_id[8:0]                       ), //o
    .io_axi_r_payload_resp    (ram1_io_axi_r_payload_resp[1:0]                     ), //o
    .io_axi_r_payload_last    (ram1_io_axi_r_payload_last                          ), //o
    .clk                      (clk                                                 ), //i
    .reset                    (reset                                               )  //i
  );
  Axi4ReadOnlyDecoder usbPiped_readOnly_decoder (
    .io_input_ar_valid             (usbPiped_readOnly_ar_valid                                       ), //i
    .io_input_ar_ready             (usbPiped_readOnly_decoder_io_input_ar_ready                      ), //o
    .io_input_ar_payload_addr      (usbPiped_readOnly_ar_payload_addr[31:0]                          ), //i
    .io_input_ar_payload_id        (usbPiped_readOnly_ar_payload_id[7:0]                             ), //i
    .io_input_ar_payload_len       (usbPiped_readOnly_ar_payload_len[7:0]                            ), //i
    .io_input_ar_payload_size      (usbPiped_readOnly_ar_payload_size[2:0]                           ), //i
    .io_input_ar_payload_burst     (usbPiped_readOnly_ar_payload_burst[1:0]                          ), //i
    .io_input_ar_payload_lock      (usbPiped_readOnly_ar_payload_lock                                ), //i
    .io_input_ar_payload_cache     (usbPiped_readOnly_ar_payload_cache[3:0]                          ), //i
    .io_input_ar_payload_prot      (usbPiped_readOnly_ar_payload_prot[2:0]                           ), //i
    .io_input_r_valid              (usbPiped_readOnly_decoder_io_input_r_valid                       ), //o
    .io_input_r_ready              (usbPiped_readOnly_r_ready                                        ), //i
    .io_input_r_payload_data       (usbPiped_readOnly_decoder_io_input_r_payload_data[63:0]          ), //o
    .io_input_r_payload_id         (usbPiped_readOnly_decoder_io_input_r_payload_id[7:0]             ), //o
    .io_input_r_payload_resp       (usbPiped_readOnly_decoder_io_input_r_payload_resp[1:0]           ), //o
    .io_input_r_payload_last       (usbPiped_readOnly_decoder_io_input_r_payload_last                ), //o
    .io_outputs_0_ar_valid         (usbPiped_readOnly_decoder_io_outputs_0_ar_valid                  ), //o
    .io_outputs_0_ar_ready         (toplevel_usbPiped_readOnly_decoder_io_outputs_0_ar_validPipe_fire), //i
    .io_outputs_0_ar_payload_addr  (usbPiped_readOnly_decoder_io_outputs_0_ar_payload_addr[31:0]     ), //o
    .io_outputs_0_ar_payload_id    (usbPiped_readOnly_decoder_io_outputs_0_ar_payload_id[7:0]        ), //o
    .io_outputs_0_ar_payload_len   (usbPiped_readOnly_decoder_io_outputs_0_ar_payload_len[7:0]       ), //o
    .io_outputs_0_ar_payload_size  (usbPiped_readOnly_decoder_io_outputs_0_ar_payload_size[2:0]      ), //o
    .io_outputs_0_ar_payload_burst (usbPiped_readOnly_decoder_io_outputs_0_ar_payload_burst[1:0]     ), //o
    .io_outputs_0_ar_payload_lock  (usbPiped_readOnly_decoder_io_outputs_0_ar_payload_lock           ), //o
    .io_outputs_0_ar_payload_cache (usbPiped_readOnly_decoder_io_outputs_0_ar_payload_cache[3:0]     ), //o
    .io_outputs_0_ar_payload_prot  (usbPiped_readOnly_decoder_io_outputs_0_ar_payload_prot[2:0]      ), //o
    .io_outputs_0_r_valid          (ram1_io_axi_arbiter_io_readInputs_0_r_valid                      ), //i
    .io_outputs_0_r_ready          (usbPiped_readOnly_decoder_io_outputs_0_r_ready                   ), //o
    .io_outputs_0_r_payload_data   (ram1_io_axi_arbiter_io_readInputs_0_r_payload_data[63:0]         ), //i
    .io_outputs_0_r_payload_id     (ram1_io_axi_arbiter_io_readInputs_0_r_payload_id[7:0]            ), //i
    .io_outputs_0_r_payload_resp   (ram1_io_axi_arbiter_io_readInputs_0_r_payload_resp[1:0]          ), //i
    .io_outputs_0_r_payload_last   (ram1_io_axi_arbiter_io_readInputs_0_r_payload_last               ), //i
    .clk                           (clk                                                              ), //i
    .reset                         (reset                                                            )  //i
  );
  Axi4WriteOnlyDecoder usbPiped_writeOnly_decoder (
    .io_input_aw_valid             (usbPiped_writeOnly_aw_valid                                       ), //i
    .io_input_aw_ready             (usbPiped_writeOnly_decoder_io_input_aw_ready                      ), //o
    .io_input_aw_payload_addr      (usbPiped_writeOnly_aw_payload_addr[31:0]                          ), //i
    .io_input_aw_payload_id        (usbPiped_writeOnly_aw_payload_id[7:0]                             ), //i
    .io_input_aw_payload_len       (usbPiped_writeOnly_aw_payload_len[7:0]                            ), //i
    .io_input_aw_payload_size      (usbPiped_writeOnly_aw_payload_size[2:0]                           ), //i
    .io_input_aw_payload_burst     (usbPiped_writeOnly_aw_payload_burst[1:0]                          ), //i
    .io_input_aw_payload_lock      (usbPiped_writeOnly_aw_payload_lock                                ), //i
    .io_input_aw_payload_cache     (usbPiped_writeOnly_aw_payload_cache[3:0]                          ), //i
    .io_input_aw_payload_prot      (usbPiped_writeOnly_aw_payload_prot[2:0]                           ), //i
    .io_input_w_valid              (usbPiped_writeOnly_w_valid                                        ), //i
    .io_input_w_ready              (usbPiped_writeOnly_decoder_io_input_w_ready                       ), //o
    .io_input_w_payload_data       (usbPiped_writeOnly_w_payload_data[63:0]                           ), //i
    .io_input_w_payload_strb       (usbPiped_writeOnly_w_payload_strb[7:0]                            ), //i
    .io_input_w_payload_last       (usbPiped_writeOnly_w_payload_last                                 ), //i
    .io_input_b_valid              (usbPiped_writeOnly_decoder_io_input_b_valid                       ), //o
    .io_input_b_ready              (usbPiped_writeOnly_b_ready                                        ), //i
    .io_input_b_payload_id         (usbPiped_writeOnly_decoder_io_input_b_payload_id[7:0]             ), //o
    .io_input_b_payload_resp       (usbPiped_writeOnly_decoder_io_input_b_payload_resp[1:0]           ), //o
    .io_outputs_0_aw_valid         (usbPiped_writeOnly_decoder_io_outputs_0_aw_valid                  ), //o
    .io_outputs_0_aw_ready         (toplevel_usbPiped_writeOnly_decoder_io_outputs_0_aw_validPipe_fire), //i
    .io_outputs_0_aw_payload_addr  (usbPiped_writeOnly_decoder_io_outputs_0_aw_payload_addr[31:0]     ), //o
    .io_outputs_0_aw_payload_id    (usbPiped_writeOnly_decoder_io_outputs_0_aw_payload_id[7:0]        ), //o
    .io_outputs_0_aw_payload_len   (usbPiped_writeOnly_decoder_io_outputs_0_aw_payload_len[7:0]       ), //o
    .io_outputs_0_aw_payload_size  (usbPiped_writeOnly_decoder_io_outputs_0_aw_payload_size[2:0]      ), //o
    .io_outputs_0_aw_payload_burst (usbPiped_writeOnly_decoder_io_outputs_0_aw_payload_burst[1:0]     ), //o
    .io_outputs_0_aw_payload_lock  (usbPiped_writeOnly_decoder_io_outputs_0_aw_payload_lock           ), //o
    .io_outputs_0_aw_payload_cache (usbPiped_writeOnly_decoder_io_outputs_0_aw_payload_cache[3:0]     ), //o
    .io_outputs_0_aw_payload_prot  (usbPiped_writeOnly_decoder_io_outputs_0_aw_payload_prot[2:0]      ), //o
    .io_outputs_0_w_valid          (usbPiped_writeOnly_decoder_io_outputs_0_w_valid                   ), //o
    .io_outputs_0_w_ready          (ram1_io_axi_arbiter_io_writeInputs_0_w_ready                      ), //i
    .io_outputs_0_w_payload_data   (usbPiped_writeOnly_decoder_io_outputs_0_w_payload_data[63:0]      ), //o
    .io_outputs_0_w_payload_strb   (usbPiped_writeOnly_decoder_io_outputs_0_w_payload_strb[7:0]       ), //o
    .io_outputs_0_w_payload_last   (usbPiped_writeOnly_decoder_io_outputs_0_w_payload_last            ), //o
    .io_outputs_0_b_valid          (ram1_io_axi_arbiter_io_writeInputs_0_b_valid                      ), //i
    .io_outputs_0_b_ready          (usbPiped_writeOnly_decoder_io_outputs_0_b_ready                   ), //o
    .io_outputs_0_b_payload_id     (ram1_io_axi_arbiter_io_writeInputs_0_b_payload_id[7:0]            ), //i
    .io_outputs_0_b_payload_resp   (ram1_io_axi_arbiter_io_writeInputs_0_b_payload_resp[1:0]          ), //i
    .clk                           (clk                                                               ), //i
    .reset                         (reset                                                             )  //i
  );
  Axi4ReadOnlyDecoder toplevel_wb2axi4_1_io_axi_readOnly_decoder (
    .io_input_ar_valid             (toplevel_wb2axi4_1_io_axi_readOnly_ar_valid                                       ), //i
    .io_input_ar_ready             (toplevel_wb2axi4_1_io_axi_readOnly_decoder_io_input_ar_ready                      ), //o
    .io_input_ar_payload_addr      (toplevel_wb2axi4_1_io_axi_readOnly_ar_payload_addr[31:0]                          ), //i
    .io_input_ar_payload_id        (toplevel_wb2axi4_1_io_axi_readOnly_ar_payload_id[7:0]                             ), //i
    .io_input_ar_payload_len       (toplevel_wb2axi4_1_io_axi_readOnly_ar_payload_len[7:0]                            ), //i
    .io_input_ar_payload_size      (toplevel_wb2axi4_1_io_axi_readOnly_ar_payload_size[2:0]                           ), //i
    .io_input_ar_payload_burst     (toplevel_wb2axi4_1_io_axi_readOnly_ar_payload_burst[1:0]                          ), //i
    .io_input_ar_payload_lock      (toplevel_wb2axi4_1_io_axi_readOnly_ar_payload_lock                                ), //i
    .io_input_ar_payload_cache     (toplevel_wb2axi4_1_io_axi_readOnly_ar_payload_cache[3:0]                          ), //i
    .io_input_ar_payload_prot      (toplevel_wb2axi4_1_io_axi_readOnly_ar_payload_prot[2:0]                           ), //i
    .io_input_r_valid              (toplevel_wb2axi4_1_io_axi_readOnly_decoder_io_input_r_valid                       ), //o
    .io_input_r_ready              (toplevel_wb2axi4_1_io_axi_readOnly_r_ready                                        ), //i
    .io_input_r_payload_data       (toplevel_wb2axi4_1_io_axi_readOnly_decoder_io_input_r_payload_data[63:0]          ), //o
    .io_input_r_payload_id         (toplevel_wb2axi4_1_io_axi_readOnly_decoder_io_input_r_payload_id[7:0]             ), //o
    .io_input_r_payload_resp       (toplevel_wb2axi4_1_io_axi_readOnly_decoder_io_input_r_payload_resp[1:0]           ), //o
    .io_input_r_payload_last       (toplevel_wb2axi4_1_io_axi_readOnly_decoder_io_input_r_payload_last                ), //o
    .io_outputs_0_ar_valid         (toplevel_wb2axi4_1_io_axi_readOnly_decoder_io_outputs_0_ar_valid                  ), //o
    .io_outputs_0_ar_ready         (toplevel_toplevel_wb2axi4_1_io_axi_readOnly_decoder_io_outputs_0_ar_validPipe_fire), //i
    .io_outputs_0_ar_payload_addr  (toplevel_wb2axi4_1_io_axi_readOnly_decoder_io_outputs_0_ar_payload_addr[31:0]     ), //o
    .io_outputs_0_ar_payload_id    (toplevel_wb2axi4_1_io_axi_readOnly_decoder_io_outputs_0_ar_payload_id[7:0]        ), //o
    .io_outputs_0_ar_payload_len   (toplevel_wb2axi4_1_io_axi_readOnly_decoder_io_outputs_0_ar_payload_len[7:0]       ), //o
    .io_outputs_0_ar_payload_size  (toplevel_wb2axi4_1_io_axi_readOnly_decoder_io_outputs_0_ar_payload_size[2:0]      ), //o
    .io_outputs_0_ar_payload_burst (toplevel_wb2axi4_1_io_axi_readOnly_decoder_io_outputs_0_ar_payload_burst[1:0]     ), //o
    .io_outputs_0_ar_payload_lock  (toplevel_wb2axi4_1_io_axi_readOnly_decoder_io_outputs_0_ar_payload_lock           ), //o
    .io_outputs_0_ar_payload_cache (toplevel_wb2axi4_1_io_axi_readOnly_decoder_io_outputs_0_ar_payload_cache[3:0]     ), //o
    .io_outputs_0_ar_payload_prot  (toplevel_wb2axi4_1_io_axi_readOnly_decoder_io_outputs_0_ar_payload_prot[2:0]      ), //o
    .io_outputs_0_r_valid          (ram1_io_axi_arbiter_io_readInputs_1_r_valid                                       ), //i
    .io_outputs_0_r_ready          (toplevel_wb2axi4_1_io_axi_readOnly_decoder_io_outputs_0_r_ready                   ), //o
    .io_outputs_0_r_payload_data   (ram1_io_axi_arbiter_io_readInputs_1_r_payload_data[63:0]                          ), //i
    .io_outputs_0_r_payload_id     (ram1_io_axi_arbiter_io_readInputs_1_r_payload_id[7:0]                             ), //i
    .io_outputs_0_r_payload_resp   (ram1_io_axi_arbiter_io_readInputs_1_r_payload_resp[1:0]                           ), //i
    .io_outputs_0_r_payload_last   (ram1_io_axi_arbiter_io_readInputs_1_r_payload_last                                ), //i
    .clk                           (clk                                                                               ), //i
    .reset                         (reset                                                                             )  //i
  );
  Axi4WriteOnlyDecoder toplevel_wb2axi4_1_io_axi_writeOnly_decoder (
    .io_input_aw_valid             (toplevel_wb2axi4_1_io_axi_writeOnly_aw_valid                                       ), //i
    .io_input_aw_ready             (toplevel_wb2axi4_1_io_axi_writeOnly_decoder_io_input_aw_ready                      ), //o
    .io_input_aw_payload_addr      (toplevel_wb2axi4_1_io_axi_writeOnly_aw_payload_addr[31:0]                          ), //i
    .io_input_aw_payload_id        (toplevel_wb2axi4_1_io_axi_writeOnly_aw_payload_id[7:0]                             ), //i
    .io_input_aw_payload_len       (toplevel_wb2axi4_1_io_axi_writeOnly_aw_payload_len[7:0]                            ), //i
    .io_input_aw_payload_size      (toplevel_wb2axi4_1_io_axi_writeOnly_aw_payload_size[2:0]                           ), //i
    .io_input_aw_payload_burst     (toplevel_wb2axi4_1_io_axi_writeOnly_aw_payload_burst[1:0]                          ), //i
    .io_input_aw_payload_lock      (toplevel_wb2axi4_1_io_axi_writeOnly_aw_payload_lock                                ), //i
    .io_input_aw_payload_cache     (toplevel_wb2axi4_1_io_axi_writeOnly_aw_payload_cache[3:0]                          ), //i
    .io_input_aw_payload_prot      (toplevel_wb2axi4_1_io_axi_writeOnly_aw_payload_prot[2:0]                           ), //i
    .io_input_w_valid              (toplevel_wb2axi4_1_io_axi_writeOnly_w_valid                                        ), //i
    .io_input_w_ready              (toplevel_wb2axi4_1_io_axi_writeOnly_decoder_io_input_w_ready                       ), //o
    .io_input_w_payload_data       (toplevel_wb2axi4_1_io_axi_writeOnly_w_payload_data[63:0]                           ), //i
    .io_input_w_payload_strb       (toplevel_wb2axi4_1_io_axi_writeOnly_w_payload_strb[7:0]                            ), //i
    .io_input_w_payload_last       (toplevel_wb2axi4_1_io_axi_writeOnly_w_payload_last                                 ), //i
    .io_input_b_valid              (toplevel_wb2axi4_1_io_axi_writeOnly_decoder_io_input_b_valid                       ), //o
    .io_input_b_ready              (toplevel_wb2axi4_1_io_axi_writeOnly_b_ready                                        ), //i
    .io_input_b_payload_id         (toplevel_wb2axi4_1_io_axi_writeOnly_decoder_io_input_b_payload_id[7:0]             ), //o
    .io_input_b_payload_resp       (toplevel_wb2axi4_1_io_axi_writeOnly_decoder_io_input_b_payload_resp[1:0]           ), //o
    .io_outputs_0_aw_valid         (toplevel_wb2axi4_1_io_axi_writeOnly_decoder_io_outputs_0_aw_valid                  ), //o
    .io_outputs_0_aw_ready         (toplevel_toplevel_wb2axi4_1_io_axi_writeOnly_decoder_io_outputs_0_aw_validPipe_fire), //i
    .io_outputs_0_aw_payload_addr  (toplevel_wb2axi4_1_io_axi_writeOnly_decoder_io_outputs_0_aw_payload_addr[31:0]     ), //o
    .io_outputs_0_aw_payload_id    (toplevel_wb2axi4_1_io_axi_writeOnly_decoder_io_outputs_0_aw_payload_id[7:0]        ), //o
    .io_outputs_0_aw_payload_len   (toplevel_wb2axi4_1_io_axi_writeOnly_decoder_io_outputs_0_aw_payload_len[7:0]       ), //o
    .io_outputs_0_aw_payload_size  (toplevel_wb2axi4_1_io_axi_writeOnly_decoder_io_outputs_0_aw_payload_size[2:0]      ), //o
    .io_outputs_0_aw_payload_burst (toplevel_wb2axi4_1_io_axi_writeOnly_decoder_io_outputs_0_aw_payload_burst[1:0]     ), //o
    .io_outputs_0_aw_payload_lock  (toplevel_wb2axi4_1_io_axi_writeOnly_decoder_io_outputs_0_aw_payload_lock           ), //o
    .io_outputs_0_aw_payload_cache (toplevel_wb2axi4_1_io_axi_writeOnly_decoder_io_outputs_0_aw_payload_cache[3:0]     ), //o
    .io_outputs_0_aw_payload_prot  (toplevel_wb2axi4_1_io_axi_writeOnly_decoder_io_outputs_0_aw_payload_prot[2:0]      ), //o
    .io_outputs_0_w_valid          (toplevel_wb2axi4_1_io_axi_writeOnly_decoder_io_outputs_0_w_valid                   ), //o
    .io_outputs_0_w_ready          (ram1_io_axi_arbiter_io_writeInputs_1_w_ready                                       ), //i
    .io_outputs_0_w_payload_data   (toplevel_wb2axi4_1_io_axi_writeOnly_decoder_io_outputs_0_w_payload_data[63:0]      ), //o
    .io_outputs_0_w_payload_strb   (toplevel_wb2axi4_1_io_axi_writeOnly_decoder_io_outputs_0_w_payload_strb[7:0]       ), //o
    .io_outputs_0_w_payload_last   (toplevel_wb2axi4_1_io_axi_writeOnly_decoder_io_outputs_0_w_payload_last            ), //o
    .io_outputs_0_b_valid          (ram1_io_axi_arbiter_io_writeInputs_1_b_valid                                       ), //i
    .io_outputs_0_b_ready          (toplevel_wb2axi4_1_io_axi_writeOnly_decoder_io_outputs_0_b_ready                   ), //o
    .io_outputs_0_b_payload_id     (ram1_io_axi_arbiter_io_writeInputs_1_b_payload_id[7:0]                             ), //i
    .io_outputs_0_b_payload_resp   (ram1_io_axi_arbiter_io_writeInputs_1_b_payload_resp[1:0]                           ), //i
    .clk                           (clk                                                                                ), //i
    .reset                         (reset                                                                              )  //i
  );
  Axi4SharedArbiter ram1_io_axi_arbiter (
    .io_readInputs_0_ar_valid          (toplevel_usbPiped_readOnly_decoder_io_outputs_0_ar_validPipe_valid                               ), //i
    .io_readInputs_0_ar_ready          (ram1_io_axi_arbiter_io_readInputs_0_ar_ready                                                     ), //o
    .io_readInputs_0_ar_payload_addr   (ram1_io_axi_arbiter_io_readInputs_0_ar_payload_addr[11:0]                                        ), //i
    .io_readInputs_0_ar_payload_id     (toplevel_usbPiped_readOnly_decoder_io_outputs_0_ar_validPipe_payload_id[7:0]                     ), //i
    .io_readInputs_0_ar_payload_len    (toplevel_usbPiped_readOnly_decoder_io_outputs_0_ar_validPipe_payload_len[7:0]                    ), //i
    .io_readInputs_0_ar_payload_size   (toplevel_usbPiped_readOnly_decoder_io_outputs_0_ar_validPipe_payload_size[2:0]                   ), //i
    .io_readInputs_0_ar_payload_burst  (toplevel_usbPiped_readOnly_decoder_io_outputs_0_ar_validPipe_payload_burst[1:0]                  ), //i
    .io_readInputs_0_r_valid           (ram1_io_axi_arbiter_io_readInputs_0_r_valid                                                      ), //o
    .io_readInputs_0_r_ready           (usbPiped_readOnly_decoder_io_outputs_0_r_ready                                                   ), //i
    .io_readInputs_0_r_payload_data    (ram1_io_axi_arbiter_io_readInputs_0_r_payload_data[63:0]                                         ), //o
    .io_readInputs_0_r_payload_id      (ram1_io_axi_arbiter_io_readInputs_0_r_payload_id[7:0]                                            ), //o
    .io_readInputs_0_r_payload_resp    (ram1_io_axi_arbiter_io_readInputs_0_r_payload_resp[1:0]                                          ), //o
    .io_readInputs_0_r_payload_last    (ram1_io_axi_arbiter_io_readInputs_0_r_payload_last                                               ), //o
    .io_readInputs_1_ar_valid          (toplevel_toplevel_wb2axi4_1_io_axi_readOnly_decoder_io_outputs_0_ar_validPipe_valid              ), //i
    .io_readInputs_1_ar_ready          (ram1_io_axi_arbiter_io_readInputs_1_ar_ready                                                     ), //o
    .io_readInputs_1_ar_payload_addr   (ram1_io_axi_arbiter_io_readInputs_1_ar_payload_addr[11:0]                                        ), //i
    .io_readInputs_1_ar_payload_id     (toplevel_toplevel_wb2axi4_1_io_axi_readOnly_decoder_io_outputs_0_ar_validPipe_payload_id[7:0]    ), //i
    .io_readInputs_1_ar_payload_len    (toplevel_toplevel_wb2axi4_1_io_axi_readOnly_decoder_io_outputs_0_ar_validPipe_payload_len[7:0]   ), //i
    .io_readInputs_1_ar_payload_size   (toplevel_toplevel_wb2axi4_1_io_axi_readOnly_decoder_io_outputs_0_ar_validPipe_payload_size[2:0]  ), //i
    .io_readInputs_1_ar_payload_burst  (toplevel_toplevel_wb2axi4_1_io_axi_readOnly_decoder_io_outputs_0_ar_validPipe_payload_burst[1:0] ), //i
    .io_readInputs_1_r_valid           (ram1_io_axi_arbiter_io_readInputs_1_r_valid                                                      ), //o
    .io_readInputs_1_r_ready           (toplevel_wb2axi4_1_io_axi_readOnly_decoder_io_outputs_0_r_ready                                  ), //i
    .io_readInputs_1_r_payload_data    (ram1_io_axi_arbiter_io_readInputs_1_r_payload_data[63:0]                                         ), //o
    .io_readInputs_1_r_payload_id      (ram1_io_axi_arbiter_io_readInputs_1_r_payload_id[7:0]                                            ), //o
    .io_readInputs_1_r_payload_resp    (ram1_io_axi_arbiter_io_readInputs_1_r_payload_resp[1:0]                                          ), //o
    .io_readInputs_1_r_payload_last    (ram1_io_axi_arbiter_io_readInputs_1_r_payload_last                                               ), //o
    .io_writeInputs_0_aw_valid         (toplevel_usbPiped_writeOnly_decoder_io_outputs_0_aw_validPipe_valid                              ), //i
    .io_writeInputs_0_aw_ready         (ram1_io_axi_arbiter_io_writeInputs_0_aw_ready                                                    ), //o
    .io_writeInputs_0_aw_payload_addr  (ram1_io_axi_arbiter_io_writeInputs_0_aw_payload_addr[11:0]                                       ), //i
    .io_writeInputs_0_aw_payload_id    (toplevel_usbPiped_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_id[7:0]                    ), //i
    .io_writeInputs_0_aw_payload_len   (toplevel_usbPiped_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_len[7:0]                   ), //i
    .io_writeInputs_0_aw_payload_size  (toplevel_usbPiped_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_size[2:0]                  ), //i
    .io_writeInputs_0_aw_payload_burst (toplevel_usbPiped_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_burst[1:0]                 ), //i
    .io_writeInputs_0_w_valid          (usbPiped_writeOnly_decoder_io_outputs_0_w_valid                                                  ), //i
    .io_writeInputs_0_w_ready          (ram1_io_axi_arbiter_io_writeInputs_0_w_ready                                                     ), //o
    .io_writeInputs_0_w_payload_data   (usbPiped_writeOnly_decoder_io_outputs_0_w_payload_data[63:0]                                     ), //i
    .io_writeInputs_0_w_payload_strb   (usbPiped_writeOnly_decoder_io_outputs_0_w_payload_strb[7:0]                                      ), //i
    .io_writeInputs_0_w_payload_last   (usbPiped_writeOnly_decoder_io_outputs_0_w_payload_last                                           ), //i
    .io_writeInputs_0_b_valid          (ram1_io_axi_arbiter_io_writeInputs_0_b_valid                                                     ), //o
    .io_writeInputs_0_b_ready          (usbPiped_writeOnly_decoder_io_outputs_0_b_ready                                                  ), //i
    .io_writeInputs_0_b_payload_id     (ram1_io_axi_arbiter_io_writeInputs_0_b_payload_id[7:0]                                           ), //o
    .io_writeInputs_0_b_payload_resp   (ram1_io_axi_arbiter_io_writeInputs_0_b_payload_resp[1:0]                                         ), //o
    .io_writeInputs_1_aw_valid         (toplevel_toplevel_wb2axi4_1_io_axi_writeOnly_decoder_io_outputs_0_aw_validPipe_valid             ), //i
    .io_writeInputs_1_aw_ready         (ram1_io_axi_arbiter_io_writeInputs_1_aw_ready                                                    ), //o
    .io_writeInputs_1_aw_payload_addr  (ram1_io_axi_arbiter_io_writeInputs_1_aw_payload_addr[11:0]                                       ), //i
    .io_writeInputs_1_aw_payload_id    (toplevel_toplevel_wb2axi4_1_io_axi_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_id[7:0]   ), //i
    .io_writeInputs_1_aw_payload_len   (toplevel_toplevel_wb2axi4_1_io_axi_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_len[7:0]  ), //i
    .io_writeInputs_1_aw_payload_size  (toplevel_toplevel_wb2axi4_1_io_axi_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_size[2:0] ), //i
    .io_writeInputs_1_aw_payload_burst (toplevel_toplevel_wb2axi4_1_io_axi_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_burst[1:0]), //i
    .io_writeInputs_1_w_valid          (toplevel_wb2axi4_1_io_axi_writeOnly_decoder_io_outputs_0_w_valid                                 ), //i
    .io_writeInputs_1_w_ready          (ram1_io_axi_arbiter_io_writeInputs_1_w_ready                                                     ), //o
    .io_writeInputs_1_w_payload_data   (toplevel_wb2axi4_1_io_axi_writeOnly_decoder_io_outputs_0_w_payload_data[63:0]                    ), //i
    .io_writeInputs_1_w_payload_strb   (toplevel_wb2axi4_1_io_axi_writeOnly_decoder_io_outputs_0_w_payload_strb[7:0]                     ), //i
    .io_writeInputs_1_w_payload_last   (toplevel_wb2axi4_1_io_axi_writeOnly_decoder_io_outputs_0_w_payload_last                          ), //i
    .io_writeInputs_1_b_valid          (ram1_io_axi_arbiter_io_writeInputs_1_b_valid                                                     ), //o
    .io_writeInputs_1_b_ready          (toplevel_wb2axi4_1_io_axi_writeOnly_decoder_io_outputs_0_b_ready                                 ), //i
    .io_writeInputs_1_b_payload_id     (ram1_io_axi_arbiter_io_writeInputs_1_b_payload_id[7:0]                                           ), //o
    .io_writeInputs_1_b_payload_resp   (ram1_io_axi_arbiter_io_writeInputs_1_b_payload_resp[1:0]                                         ), //o
    .io_output_arw_valid               (ram1_io_axi_arbiter_io_output_arw_valid                                                          ), //o
    .io_output_arw_ready               (ram1_io_axi_arw_ready                                                                            ), //i
    .io_output_arw_payload_addr        (ram1_io_axi_arbiter_io_output_arw_payload_addr[11:0]                                             ), //o
    .io_output_arw_payload_id          (ram1_io_axi_arbiter_io_output_arw_payload_id[8:0]                                                ), //o
    .io_output_arw_payload_len         (ram1_io_axi_arbiter_io_output_arw_payload_len[7:0]                                               ), //o
    .io_output_arw_payload_size        (ram1_io_axi_arbiter_io_output_arw_payload_size[2:0]                                              ), //o
    .io_output_arw_payload_burst       (ram1_io_axi_arbiter_io_output_arw_payload_burst[1:0]                                             ), //o
    .io_output_arw_payload_write       (ram1_io_axi_arbiter_io_output_arw_payload_write                                                  ), //o
    .io_output_w_valid                 (ram1_io_axi_arbiter_io_output_w_valid                                                            ), //o
    .io_output_w_ready                 (ram1_io_axi_w_ready                                                                              ), //i
    .io_output_w_payload_data          (ram1_io_axi_arbiter_io_output_w_payload_data[63:0]                                               ), //o
    .io_output_w_payload_strb          (ram1_io_axi_arbiter_io_output_w_payload_strb[7:0]                                                ), //o
    .io_output_w_payload_last          (ram1_io_axi_arbiter_io_output_w_payload_last                                                     ), //o
    .io_output_b_valid                 (ram1_io_axi_b_valid                                                                              ), //i
    .io_output_b_ready                 (ram1_io_axi_arbiter_io_output_b_ready                                                            ), //o
    .io_output_b_payload_id            (ram1_io_axi_b_payload_id[8:0]                                                                    ), //i
    .io_output_b_payload_resp          (ram1_io_axi_b_payload_resp[1:0]                                                                  ), //i
    .io_output_r_valid                 (ram1_io_axi_r_valid                                                                              ), //i
    .io_output_r_ready                 (ram1_io_axi_arbiter_io_output_r_ready                                                            ), //o
    .io_output_r_payload_data          (ram1_io_axi_r_payload_data[63:0]                                                                 ), //i
    .io_output_r_payload_id            (ram1_io_axi_r_payload_id[8:0]                                                                    ), //i
    .io_output_r_payload_resp          (ram1_io_axi_r_payload_resp[1:0]                                                                  ), //i
    .io_output_r_payload_last          (ram1_io_axi_r_payload_last                                                                       ), //i
    .clk                               (clk                                                                                              ), //i
    .reset                             (reset                                                                                            )  //i
  );
  assign usb23_TXM = usbCore_io_usbIO_TXM;
  assign usb23_TXP = usbCore_io_usbIO_TXP;
  assign usb_irq = usbCore_io_irq;
  assign wb_ACK = wbIntcon_io_busMasters_0_ACK;
  assign wb_DAT_MISO = wbIntcon_io_busMasters_0_DAT_MISO;
  assign toplevel_usbCore_io_axi_aw_s2mPipe_valid = (usbCore_axi_awvalid || (! toplevel_usbCore_io_axi_aw_rValidN));
  assign toplevel_usbCore_io_axi_aw_s2mPipe_payload_addr = (toplevel_usbCore_io_axi_aw_rValidN ? usbCore_axi_awaddr : toplevel_usbCore_io_axi_aw_rData_addr);
  assign toplevel_usbCore_io_axi_aw_s2mPipe_payload_id = (toplevel_usbCore_io_axi_aw_rValidN ? usbCore_axi_awid : toplevel_usbCore_io_axi_aw_rData_id);
  assign toplevel_usbCore_io_axi_aw_s2mPipe_payload_len = (toplevel_usbCore_io_axi_aw_rValidN ? usbCore_axi_awlen : toplevel_usbCore_io_axi_aw_rData_len);
  assign toplevel_usbCore_io_axi_aw_s2mPipe_payload_size = (toplevel_usbCore_io_axi_aw_rValidN ? usbCore_axi_awsize : toplevel_usbCore_io_axi_aw_rData_size);
  assign toplevel_usbCore_io_axi_aw_s2mPipe_payload_burst = (toplevel_usbCore_io_axi_aw_rValidN ? usbCore_axi_awburst : toplevel_usbCore_io_axi_aw_rData_burst);
  assign toplevel_usbCore_io_axi_aw_s2mPipe_payload_lock = (toplevel_usbCore_io_axi_aw_rValidN ? usbCore_axi_awlock : toplevel_usbCore_io_axi_aw_rData_lock);
  assign toplevel_usbCore_io_axi_aw_s2mPipe_payload_cache = (toplevel_usbCore_io_axi_aw_rValidN ? usbCore_axi_awcache : toplevel_usbCore_io_axi_aw_rData_cache);
  assign toplevel_usbCore_io_axi_aw_s2mPipe_payload_prot = (toplevel_usbCore_io_axi_aw_rValidN ? usbCore_axi_awprot : toplevel_usbCore_io_axi_aw_rData_prot);
  always @(*) begin
    toplevel_usbCore_io_axi_aw_s2mPipe_ready = toplevel_usbCore_io_axi_aw_s2mPipe_m2sPipe_ready;
    if(when_Stream_l369) begin
      toplevel_usbCore_io_axi_aw_s2mPipe_ready = 1'b1;
    end
  end

  assign when_Stream_l369 = (! toplevel_usbCore_io_axi_aw_s2mPipe_m2sPipe_valid);
  assign toplevel_usbCore_io_axi_aw_s2mPipe_m2sPipe_valid = toplevel_usbCore_io_axi_aw_s2mPipe_rValid;
  assign toplevel_usbCore_io_axi_aw_s2mPipe_m2sPipe_payload_addr = toplevel_usbCore_io_axi_aw_s2mPipe_rData_addr;
  assign toplevel_usbCore_io_axi_aw_s2mPipe_m2sPipe_payload_id = toplevel_usbCore_io_axi_aw_s2mPipe_rData_id;
  assign toplevel_usbCore_io_axi_aw_s2mPipe_m2sPipe_payload_len = toplevel_usbCore_io_axi_aw_s2mPipe_rData_len;
  assign toplevel_usbCore_io_axi_aw_s2mPipe_m2sPipe_payload_size = toplevel_usbCore_io_axi_aw_s2mPipe_rData_size;
  assign toplevel_usbCore_io_axi_aw_s2mPipe_m2sPipe_payload_burst = toplevel_usbCore_io_axi_aw_s2mPipe_rData_burst;
  assign toplevel_usbCore_io_axi_aw_s2mPipe_m2sPipe_payload_lock = toplevel_usbCore_io_axi_aw_s2mPipe_rData_lock;
  assign toplevel_usbCore_io_axi_aw_s2mPipe_m2sPipe_payload_cache = toplevel_usbCore_io_axi_aw_s2mPipe_rData_cache;
  assign toplevel_usbCore_io_axi_aw_s2mPipe_m2sPipe_payload_prot = toplevel_usbCore_io_axi_aw_s2mPipe_rData_prot;
  assign usbPiped_aw_valid = toplevel_usbCore_io_axi_aw_s2mPipe_m2sPipe_valid;
  assign toplevel_usbCore_io_axi_aw_s2mPipe_m2sPipe_ready = usbPiped_aw_ready;
  assign usbPiped_aw_payload_addr = toplevel_usbCore_io_axi_aw_s2mPipe_m2sPipe_payload_addr;
  assign usbPiped_aw_payload_id = toplevel_usbCore_io_axi_aw_s2mPipe_m2sPipe_payload_id;
  assign usbPiped_aw_payload_len = toplevel_usbCore_io_axi_aw_s2mPipe_m2sPipe_payload_len;
  assign usbPiped_aw_payload_size = toplevel_usbCore_io_axi_aw_s2mPipe_m2sPipe_payload_size;
  assign usbPiped_aw_payload_burst = toplevel_usbCore_io_axi_aw_s2mPipe_m2sPipe_payload_burst;
  assign usbPiped_aw_payload_lock = toplevel_usbCore_io_axi_aw_s2mPipe_m2sPipe_payload_lock;
  assign usbPiped_aw_payload_cache = toplevel_usbCore_io_axi_aw_s2mPipe_m2sPipe_payload_cache;
  assign usbPiped_aw_payload_prot = toplevel_usbCore_io_axi_aw_s2mPipe_m2sPipe_payload_prot;
  assign toplevel_usbCore_io_axi_w_combStage_valid = usbCore_axi_wvalid;
  assign toplevel_usbCore_io_axi_w_combStage_payload_data = usbCore_axi_wdata;
  assign toplevel_usbCore_io_axi_w_combStage_payload_strb = usbCore_axi_wstrb;
  assign toplevel_usbCore_io_axi_w_combStage_payload_last = usbCore_axi_wlast;
  assign usbPiped_w_valid = toplevel_usbCore_io_axi_w_combStage_valid;
  assign toplevel_usbCore_io_axi_w_combStage_ready = usbPiped_w_ready;
  assign usbPiped_w_payload_data = toplevel_usbCore_io_axi_w_combStage_payload_data;
  assign usbPiped_w_payload_strb = toplevel_usbCore_io_axi_w_combStage_payload_strb;
  assign usbPiped_w_payload_last = toplevel_usbCore_io_axi_w_combStage_payload_last;
  assign usbPiped_b_combStage_valid = usbPiped_b_valid;
  assign usbPiped_b_ready = usbPiped_b_combStage_ready;
  assign usbPiped_b_combStage_payload_id = usbPiped_b_payload_id;
  assign usbPiped_b_combStage_payload_resp = usbPiped_b_payload_resp;
  assign usbPiped_b_combStage_ready = usbCore_axi_bready;
  assign toplevel_usbCore_io_axi_ar_s2mPipe_valid = (usbCore_axi_arvalid || (! toplevel_usbCore_io_axi_ar_rValidN));
  assign toplevel_usbCore_io_axi_ar_s2mPipe_payload_addr = (toplevel_usbCore_io_axi_ar_rValidN ? usbCore_axi_araddr : toplevel_usbCore_io_axi_ar_rData_addr);
  assign toplevel_usbCore_io_axi_ar_s2mPipe_payload_id = (toplevel_usbCore_io_axi_ar_rValidN ? usbCore_axi_arid : toplevel_usbCore_io_axi_ar_rData_id);
  assign toplevel_usbCore_io_axi_ar_s2mPipe_payload_len = (toplevel_usbCore_io_axi_ar_rValidN ? usbCore_axi_arlen : toplevel_usbCore_io_axi_ar_rData_len);
  assign toplevel_usbCore_io_axi_ar_s2mPipe_payload_size = (toplevel_usbCore_io_axi_ar_rValidN ? usbCore_axi_arsize : toplevel_usbCore_io_axi_ar_rData_size);
  assign toplevel_usbCore_io_axi_ar_s2mPipe_payload_burst = (toplevel_usbCore_io_axi_ar_rValidN ? usbCore_axi_arburst : toplevel_usbCore_io_axi_ar_rData_burst);
  assign toplevel_usbCore_io_axi_ar_s2mPipe_payload_lock = (toplevel_usbCore_io_axi_ar_rValidN ? usbCore_axi_arlock : toplevel_usbCore_io_axi_ar_rData_lock);
  assign toplevel_usbCore_io_axi_ar_s2mPipe_payload_cache = (toplevel_usbCore_io_axi_ar_rValidN ? usbCore_axi_arcache : toplevel_usbCore_io_axi_ar_rData_cache);
  assign toplevel_usbCore_io_axi_ar_s2mPipe_payload_prot = (toplevel_usbCore_io_axi_ar_rValidN ? usbCore_axi_arprot : toplevel_usbCore_io_axi_ar_rData_prot);
  always @(*) begin
    toplevel_usbCore_io_axi_ar_s2mPipe_ready = toplevel_usbCore_io_axi_ar_s2mPipe_m2sPipe_ready;
    if(when_Stream_l369_1) begin
      toplevel_usbCore_io_axi_ar_s2mPipe_ready = 1'b1;
    end
  end

  assign when_Stream_l369_1 = (! toplevel_usbCore_io_axi_ar_s2mPipe_m2sPipe_valid);
  assign toplevel_usbCore_io_axi_ar_s2mPipe_m2sPipe_valid = toplevel_usbCore_io_axi_ar_s2mPipe_rValid;
  assign toplevel_usbCore_io_axi_ar_s2mPipe_m2sPipe_payload_addr = toplevel_usbCore_io_axi_ar_s2mPipe_rData_addr;
  assign toplevel_usbCore_io_axi_ar_s2mPipe_m2sPipe_payload_id = toplevel_usbCore_io_axi_ar_s2mPipe_rData_id;
  assign toplevel_usbCore_io_axi_ar_s2mPipe_m2sPipe_payload_len = toplevel_usbCore_io_axi_ar_s2mPipe_rData_len;
  assign toplevel_usbCore_io_axi_ar_s2mPipe_m2sPipe_payload_size = toplevel_usbCore_io_axi_ar_s2mPipe_rData_size;
  assign toplevel_usbCore_io_axi_ar_s2mPipe_m2sPipe_payload_burst = toplevel_usbCore_io_axi_ar_s2mPipe_rData_burst;
  assign toplevel_usbCore_io_axi_ar_s2mPipe_m2sPipe_payload_lock = toplevel_usbCore_io_axi_ar_s2mPipe_rData_lock;
  assign toplevel_usbCore_io_axi_ar_s2mPipe_m2sPipe_payload_cache = toplevel_usbCore_io_axi_ar_s2mPipe_rData_cache;
  assign toplevel_usbCore_io_axi_ar_s2mPipe_m2sPipe_payload_prot = toplevel_usbCore_io_axi_ar_s2mPipe_rData_prot;
  assign usbPiped_ar_valid = toplevel_usbCore_io_axi_ar_s2mPipe_m2sPipe_valid;
  assign toplevel_usbCore_io_axi_ar_s2mPipe_m2sPipe_ready = usbPiped_ar_ready;
  assign usbPiped_ar_payload_addr = toplevel_usbCore_io_axi_ar_s2mPipe_m2sPipe_payload_addr;
  assign usbPiped_ar_payload_id = toplevel_usbCore_io_axi_ar_s2mPipe_m2sPipe_payload_id;
  assign usbPiped_ar_payload_len = toplevel_usbCore_io_axi_ar_s2mPipe_m2sPipe_payload_len;
  assign usbPiped_ar_payload_size = toplevel_usbCore_io_axi_ar_s2mPipe_m2sPipe_payload_size;
  assign usbPiped_ar_payload_burst = toplevel_usbCore_io_axi_ar_s2mPipe_m2sPipe_payload_burst;
  assign usbPiped_ar_payload_lock = toplevel_usbCore_io_axi_ar_s2mPipe_m2sPipe_payload_lock;
  assign usbPiped_ar_payload_cache = toplevel_usbCore_io_axi_ar_s2mPipe_m2sPipe_payload_cache;
  assign usbPiped_ar_payload_prot = toplevel_usbCore_io_axi_ar_s2mPipe_m2sPipe_payload_prot;
  assign usbPiped_r_combStage_valid = usbPiped_r_valid;
  assign usbPiped_r_ready = usbPiped_r_combStage_ready;
  assign usbPiped_r_combStage_payload_data = usbPiped_r_payload_data;
  assign usbPiped_r_combStage_payload_id = usbPiped_r_payload_id;
  assign usbPiped_r_combStage_payload_resp = usbPiped_r_payload_resp;
  assign usbPiped_r_combStage_payload_last = usbPiped_r_payload_last;
  assign usbPiped_r_combStage_ready = usbCore_axi_rready;
  assign usbPiped_readOnly_ar_valid = usbPiped_ar_valid;
  assign usbPiped_ar_ready = usbPiped_readOnly_ar_ready;
  assign usbPiped_readOnly_ar_payload_addr = usbPiped_ar_payload_addr;
  assign usbPiped_readOnly_ar_payload_id = usbPiped_ar_payload_id;
  assign usbPiped_readOnly_ar_payload_len = usbPiped_ar_payload_len;
  assign usbPiped_readOnly_ar_payload_size = usbPiped_ar_payload_size;
  assign usbPiped_readOnly_ar_payload_burst = usbPiped_ar_payload_burst;
  assign usbPiped_readOnly_ar_payload_lock = usbPiped_ar_payload_lock;
  assign usbPiped_readOnly_ar_payload_cache = usbPiped_ar_payload_cache;
  assign usbPiped_readOnly_ar_payload_prot = usbPiped_ar_payload_prot;
  assign usbPiped_r_valid = usbPiped_readOnly_r_valid;
  assign usbPiped_readOnly_r_ready = usbPiped_r_ready;
  assign usbPiped_r_payload_data = usbPiped_readOnly_r_payload_data;
  assign usbPiped_r_payload_last = usbPiped_readOnly_r_payload_last;
  assign usbPiped_r_payload_id = usbPiped_readOnly_r_payload_id;
  assign usbPiped_r_payload_resp = usbPiped_readOnly_r_payload_resp;
  assign usbPiped_writeOnly_aw_valid = usbPiped_aw_valid;
  assign usbPiped_aw_ready = usbPiped_writeOnly_aw_ready;
  assign usbPiped_writeOnly_aw_payload_addr = usbPiped_aw_payload_addr;
  assign usbPiped_writeOnly_aw_payload_id = usbPiped_aw_payload_id;
  assign usbPiped_writeOnly_aw_payload_len = usbPiped_aw_payload_len;
  assign usbPiped_writeOnly_aw_payload_size = usbPiped_aw_payload_size;
  assign usbPiped_writeOnly_aw_payload_burst = usbPiped_aw_payload_burst;
  assign usbPiped_writeOnly_aw_payload_lock = usbPiped_aw_payload_lock;
  assign usbPiped_writeOnly_aw_payload_cache = usbPiped_aw_payload_cache;
  assign usbPiped_writeOnly_aw_payload_prot = usbPiped_aw_payload_prot;
  assign usbPiped_writeOnly_w_valid = usbPiped_w_valid;
  assign usbPiped_w_ready = usbPiped_writeOnly_w_ready;
  assign usbPiped_writeOnly_w_payload_data = usbPiped_w_payload_data;
  assign usbPiped_writeOnly_w_payload_strb = usbPiped_w_payload_strb;
  assign usbPiped_writeOnly_w_payload_last = usbPiped_w_payload_last;
  assign usbPiped_b_valid = usbPiped_writeOnly_b_valid;
  assign usbPiped_writeOnly_b_ready = usbPiped_b_ready;
  assign usbPiped_b_payload_id = usbPiped_writeOnly_b_payload_id;
  assign usbPiped_b_payload_resp = usbPiped_writeOnly_b_payload_resp;
  assign toplevel_wb2axi4_1_io_axi_readOnly_ar_valid = wb2axi4_1_io_axi_ar_valid;
  assign toplevel_wb2axi4_1_io_axi_readOnly_ar_payload_addr = wb2axi4_1_io_axi_ar_payload_addr;
  assign toplevel_wb2axi4_1_io_axi_readOnly_ar_payload_id = wb2axi4_1_io_axi_ar_payload_id;
  assign toplevel_wb2axi4_1_io_axi_readOnly_ar_payload_len = wb2axi4_1_io_axi_ar_payload_len;
  assign toplevel_wb2axi4_1_io_axi_readOnly_ar_payload_size = wb2axi4_1_io_axi_ar_payload_size;
  assign toplevel_wb2axi4_1_io_axi_readOnly_ar_payload_burst = wb2axi4_1_io_axi_ar_payload_burst;
  assign toplevel_wb2axi4_1_io_axi_readOnly_ar_payload_lock = wb2axi4_1_io_axi_ar_payload_lock;
  assign toplevel_wb2axi4_1_io_axi_readOnly_ar_payload_cache = wb2axi4_1_io_axi_ar_payload_cache;
  assign toplevel_wb2axi4_1_io_axi_readOnly_ar_payload_prot = wb2axi4_1_io_axi_ar_payload_prot;
  assign toplevel_wb2axi4_1_io_axi_readOnly_r_ready = wb2axi4_1_io_axi_r_ready;
  assign toplevel_wb2axi4_1_io_axi_writeOnly_aw_valid = wb2axi4_1_io_axi_aw_valid;
  assign toplevel_wb2axi4_1_io_axi_writeOnly_aw_payload_addr = wb2axi4_1_io_axi_aw_payload_addr;
  assign toplevel_wb2axi4_1_io_axi_writeOnly_aw_payload_id = wb2axi4_1_io_axi_aw_payload_id;
  assign toplevel_wb2axi4_1_io_axi_writeOnly_aw_payload_len = wb2axi4_1_io_axi_aw_payload_len;
  assign toplevel_wb2axi4_1_io_axi_writeOnly_aw_payload_size = wb2axi4_1_io_axi_aw_payload_size;
  assign toplevel_wb2axi4_1_io_axi_writeOnly_aw_payload_burst = wb2axi4_1_io_axi_aw_payload_burst;
  assign toplevel_wb2axi4_1_io_axi_writeOnly_aw_payload_lock = wb2axi4_1_io_axi_aw_payload_lock;
  assign toplevel_wb2axi4_1_io_axi_writeOnly_aw_payload_cache = wb2axi4_1_io_axi_aw_payload_cache;
  assign toplevel_wb2axi4_1_io_axi_writeOnly_aw_payload_prot = wb2axi4_1_io_axi_aw_payload_prot;
  assign toplevel_wb2axi4_1_io_axi_writeOnly_w_valid = wb2axi4_1_io_axi_w_valid;
  assign toplevel_wb2axi4_1_io_axi_writeOnly_w_payload_data = wb2axi4_1_io_axi_w_payload_data;
  assign toplevel_wb2axi4_1_io_axi_writeOnly_w_payload_strb = wb2axi4_1_io_axi_w_payload_strb;
  assign toplevel_wb2axi4_1_io_axi_writeOnly_w_payload_last = wb2axi4_1_io_axi_w_payload_last;
  assign toplevel_wb2axi4_1_io_axi_writeOnly_b_ready = wb2axi4_1_io_axi_b_ready;
  assign toplevel_usbPiped_readOnly_decoder_io_outputs_0_ar_validPipe_fire = (toplevel_usbPiped_readOnly_decoder_io_outputs_0_ar_validPipe_valid && toplevel_usbPiped_readOnly_decoder_io_outputs_0_ar_validPipe_ready);
  assign toplevel_usbPiped_readOnly_decoder_io_outputs_0_ar_validPipe_valid = toplevel_usbPiped_readOnly_decoder_io_outputs_0_ar_rValid;
  assign toplevel_usbPiped_readOnly_decoder_io_outputs_0_ar_validPipe_payload_addr = usbPiped_readOnly_decoder_io_outputs_0_ar_payload_addr;
  assign toplevel_usbPiped_readOnly_decoder_io_outputs_0_ar_validPipe_payload_id = usbPiped_readOnly_decoder_io_outputs_0_ar_payload_id;
  assign toplevel_usbPiped_readOnly_decoder_io_outputs_0_ar_validPipe_payload_len = usbPiped_readOnly_decoder_io_outputs_0_ar_payload_len;
  assign toplevel_usbPiped_readOnly_decoder_io_outputs_0_ar_validPipe_payload_size = usbPiped_readOnly_decoder_io_outputs_0_ar_payload_size;
  assign toplevel_usbPiped_readOnly_decoder_io_outputs_0_ar_validPipe_payload_burst = usbPiped_readOnly_decoder_io_outputs_0_ar_payload_burst;
  assign toplevel_usbPiped_readOnly_decoder_io_outputs_0_ar_validPipe_payload_lock = usbPiped_readOnly_decoder_io_outputs_0_ar_payload_lock;
  assign toplevel_usbPiped_readOnly_decoder_io_outputs_0_ar_validPipe_payload_cache = usbPiped_readOnly_decoder_io_outputs_0_ar_payload_cache;
  assign toplevel_usbPiped_readOnly_decoder_io_outputs_0_ar_validPipe_payload_prot = usbPiped_readOnly_decoder_io_outputs_0_ar_payload_prot;
  assign toplevel_usbPiped_readOnly_decoder_io_outputs_0_ar_validPipe_ready = ram1_io_axi_arbiter_io_readInputs_0_ar_ready;
  assign usbPiped_readOnly_ar_ready = usbPiped_readOnly_decoder_io_input_ar_ready;
  assign usbPiped_readOnly_r_valid = usbPiped_readOnly_decoder_io_input_r_valid;
  assign usbPiped_readOnly_r_payload_data = usbPiped_readOnly_decoder_io_input_r_payload_data;
  assign usbPiped_readOnly_r_payload_last = usbPiped_readOnly_decoder_io_input_r_payload_last;
  assign usbPiped_readOnly_r_payload_id = usbPiped_readOnly_decoder_io_input_r_payload_id;
  assign usbPiped_readOnly_r_payload_resp = usbPiped_readOnly_decoder_io_input_r_payload_resp;
  assign toplevel_usbPiped_writeOnly_decoder_io_outputs_0_aw_validPipe_fire = (toplevel_usbPiped_writeOnly_decoder_io_outputs_0_aw_validPipe_valid && toplevel_usbPiped_writeOnly_decoder_io_outputs_0_aw_validPipe_ready);
  assign toplevel_usbPiped_writeOnly_decoder_io_outputs_0_aw_validPipe_valid = toplevel_usbPiped_writeOnly_decoder_io_outputs_0_aw_rValid;
  assign toplevel_usbPiped_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_addr = usbPiped_writeOnly_decoder_io_outputs_0_aw_payload_addr;
  assign toplevel_usbPiped_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_id = usbPiped_writeOnly_decoder_io_outputs_0_aw_payload_id;
  assign toplevel_usbPiped_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_len = usbPiped_writeOnly_decoder_io_outputs_0_aw_payload_len;
  assign toplevel_usbPiped_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_size = usbPiped_writeOnly_decoder_io_outputs_0_aw_payload_size;
  assign toplevel_usbPiped_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_burst = usbPiped_writeOnly_decoder_io_outputs_0_aw_payload_burst;
  assign toplevel_usbPiped_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_lock = usbPiped_writeOnly_decoder_io_outputs_0_aw_payload_lock;
  assign toplevel_usbPiped_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_cache = usbPiped_writeOnly_decoder_io_outputs_0_aw_payload_cache;
  assign toplevel_usbPiped_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_prot = usbPiped_writeOnly_decoder_io_outputs_0_aw_payload_prot;
  assign toplevel_usbPiped_writeOnly_decoder_io_outputs_0_aw_validPipe_ready = ram1_io_axi_arbiter_io_writeInputs_0_aw_ready;
  assign usbPiped_writeOnly_aw_ready = usbPiped_writeOnly_decoder_io_input_aw_ready;
  assign usbPiped_writeOnly_w_ready = usbPiped_writeOnly_decoder_io_input_w_ready;
  assign usbPiped_writeOnly_b_valid = usbPiped_writeOnly_decoder_io_input_b_valid;
  assign usbPiped_writeOnly_b_payload_id = usbPiped_writeOnly_decoder_io_input_b_payload_id;
  assign usbPiped_writeOnly_b_payload_resp = usbPiped_writeOnly_decoder_io_input_b_payload_resp;
  assign toplevel_toplevel_wb2axi4_1_io_axi_readOnly_decoder_io_outputs_0_ar_validPipe_fire = (toplevel_toplevel_wb2axi4_1_io_axi_readOnly_decoder_io_outputs_0_ar_validPipe_valid && toplevel_toplevel_wb2axi4_1_io_axi_readOnly_decoder_io_outputs_0_ar_validPipe_ready);
  assign toplevel_toplevel_wb2axi4_1_io_axi_readOnly_decoder_io_outputs_0_ar_validPipe_valid = toplevel_toplevel_wb2axi4_1_io_axi_readOnly_decoder_io_outputs_0_ar_rValid;
  assign toplevel_toplevel_wb2axi4_1_io_axi_readOnly_decoder_io_outputs_0_ar_validPipe_payload_addr = toplevel_wb2axi4_1_io_axi_readOnly_decoder_io_outputs_0_ar_payload_addr;
  assign toplevel_toplevel_wb2axi4_1_io_axi_readOnly_decoder_io_outputs_0_ar_validPipe_payload_id = toplevel_wb2axi4_1_io_axi_readOnly_decoder_io_outputs_0_ar_payload_id;
  assign toplevel_toplevel_wb2axi4_1_io_axi_readOnly_decoder_io_outputs_0_ar_validPipe_payload_len = toplevel_wb2axi4_1_io_axi_readOnly_decoder_io_outputs_0_ar_payload_len;
  assign toplevel_toplevel_wb2axi4_1_io_axi_readOnly_decoder_io_outputs_0_ar_validPipe_payload_size = toplevel_wb2axi4_1_io_axi_readOnly_decoder_io_outputs_0_ar_payload_size;
  assign toplevel_toplevel_wb2axi4_1_io_axi_readOnly_decoder_io_outputs_0_ar_validPipe_payload_burst = toplevel_wb2axi4_1_io_axi_readOnly_decoder_io_outputs_0_ar_payload_burst;
  assign toplevel_toplevel_wb2axi4_1_io_axi_readOnly_decoder_io_outputs_0_ar_validPipe_payload_lock = toplevel_wb2axi4_1_io_axi_readOnly_decoder_io_outputs_0_ar_payload_lock;
  assign toplevel_toplevel_wb2axi4_1_io_axi_readOnly_decoder_io_outputs_0_ar_validPipe_payload_cache = toplevel_wb2axi4_1_io_axi_readOnly_decoder_io_outputs_0_ar_payload_cache;
  assign toplevel_toplevel_wb2axi4_1_io_axi_readOnly_decoder_io_outputs_0_ar_validPipe_payload_prot = toplevel_wb2axi4_1_io_axi_readOnly_decoder_io_outputs_0_ar_payload_prot;
  assign toplevel_toplevel_wb2axi4_1_io_axi_readOnly_decoder_io_outputs_0_ar_validPipe_ready = ram1_io_axi_arbiter_io_readInputs_1_ar_ready;
  assign toplevel_wb2axi4_1_io_axi_readOnly_ar_ready = toplevel_wb2axi4_1_io_axi_readOnly_decoder_io_input_ar_ready;
  assign toplevel_wb2axi4_1_io_axi_readOnly_r_valid = toplevel_wb2axi4_1_io_axi_readOnly_decoder_io_input_r_valid;
  assign toplevel_wb2axi4_1_io_axi_readOnly_r_payload_data = toplevel_wb2axi4_1_io_axi_readOnly_decoder_io_input_r_payload_data;
  assign toplevel_wb2axi4_1_io_axi_readOnly_r_payload_last = toplevel_wb2axi4_1_io_axi_readOnly_decoder_io_input_r_payload_last;
  assign toplevel_wb2axi4_1_io_axi_readOnly_r_payload_id = toplevel_wb2axi4_1_io_axi_readOnly_decoder_io_input_r_payload_id;
  assign toplevel_wb2axi4_1_io_axi_readOnly_r_payload_resp = toplevel_wb2axi4_1_io_axi_readOnly_decoder_io_input_r_payload_resp;
  assign toplevel_toplevel_wb2axi4_1_io_axi_writeOnly_decoder_io_outputs_0_aw_validPipe_fire = (toplevel_toplevel_wb2axi4_1_io_axi_writeOnly_decoder_io_outputs_0_aw_validPipe_valid && toplevel_toplevel_wb2axi4_1_io_axi_writeOnly_decoder_io_outputs_0_aw_validPipe_ready);
  assign toplevel_toplevel_wb2axi4_1_io_axi_writeOnly_decoder_io_outputs_0_aw_validPipe_valid = toplevel_toplevel_wb2axi4_1_io_axi_writeOnly_decoder_io_outputs_0_aw_rValid;
  assign toplevel_toplevel_wb2axi4_1_io_axi_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_addr = toplevel_wb2axi4_1_io_axi_writeOnly_decoder_io_outputs_0_aw_payload_addr;
  assign toplevel_toplevel_wb2axi4_1_io_axi_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_id = toplevel_wb2axi4_1_io_axi_writeOnly_decoder_io_outputs_0_aw_payload_id;
  assign toplevel_toplevel_wb2axi4_1_io_axi_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_len = toplevel_wb2axi4_1_io_axi_writeOnly_decoder_io_outputs_0_aw_payload_len;
  assign toplevel_toplevel_wb2axi4_1_io_axi_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_size = toplevel_wb2axi4_1_io_axi_writeOnly_decoder_io_outputs_0_aw_payload_size;
  assign toplevel_toplevel_wb2axi4_1_io_axi_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_burst = toplevel_wb2axi4_1_io_axi_writeOnly_decoder_io_outputs_0_aw_payload_burst;
  assign toplevel_toplevel_wb2axi4_1_io_axi_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_lock = toplevel_wb2axi4_1_io_axi_writeOnly_decoder_io_outputs_0_aw_payload_lock;
  assign toplevel_toplevel_wb2axi4_1_io_axi_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_cache = toplevel_wb2axi4_1_io_axi_writeOnly_decoder_io_outputs_0_aw_payload_cache;
  assign toplevel_toplevel_wb2axi4_1_io_axi_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_prot = toplevel_wb2axi4_1_io_axi_writeOnly_decoder_io_outputs_0_aw_payload_prot;
  assign toplevel_toplevel_wb2axi4_1_io_axi_writeOnly_decoder_io_outputs_0_aw_validPipe_ready = ram1_io_axi_arbiter_io_writeInputs_1_aw_ready;
  assign toplevel_wb2axi4_1_io_axi_writeOnly_aw_ready = toplevel_wb2axi4_1_io_axi_writeOnly_decoder_io_input_aw_ready;
  assign toplevel_wb2axi4_1_io_axi_writeOnly_w_ready = toplevel_wb2axi4_1_io_axi_writeOnly_decoder_io_input_w_ready;
  assign toplevel_wb2axi4_1_io_axi_writeOnly_b_valid = toplevel_wb2axi4_1_io_axi_writeOnly_decoder_io_input_b_valid;
  assign toplevel_wb2axi4_1_io_axi_writeOnly_b_payload_id = toplevel_wb2axi4_1_io_axi_writeOnly_decoder_io_input_b_payload_id;
  assign toplevel_wb2axi4_1_io_axi_writeOnly_b_payload_resp = toplevel_wb2axi4_1_io_axi_writeOnly_decoder_io_input_b_payload_resp;
  assign ram1_io_axi_arbiter_io_readInputs_0_ar_payload_addr = toplevel_usbPiped_readOnly_decoder_io_outputs_0_ar_validPipe_payload_addr[11:0];
  assign ram1_io_axi_arbiter_io_readInputs_1_ar_payload_addr = toplevel_toplevel_wb2axi4_1_io_axi_readOnly_decoder_io_outputs_0_ar_validPipe_payload_addr[11:0];
  assign ram1_io_axi_arbiter_io_writeInputs_0_aw_payload_addr = toplevel_usbPiped_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_addr[11:0];
  assign ram1_io_axi_arbiter_io_writeInputs_1_aw_payload_addr = toplevel_toplevel_wb2axi4_1_io_axi_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_addr[11:0];
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      toplevel_usbCore_io_axi_aw_rValidN <= 1'b1;
      toplevel_usbCore_io_axi_aw_s2mPipe_rValid <= 1'b0;
      toplevel_usbCore_io_axi_ar_rValidN <= 1'b1;
      toplevel_usbCore_io_axi_ar_s2mPipe_rValid <= 1'b0;
      toplevel_usbPiped_readOnly_decoder_io_outputs_0_ar_rValid <= 1'b0;
      toplevel_usbPiped_writeOnly_decoder_io_outputs_0_aw_rValid <= 1'b0;
      toplevel_toplevel_wb2axi4_1_io_axi_readOnly_decoder_io_outputs_0_ar_rValid <= 1'b0;
      toplevel_toplevel_wb2axi4_1_io_axi_writeOnly_decoder_io_outputs_0_aw_rValid <= 1'b0;
    end else begin
      if(usbCore_axi_awvalid) begin
        toplevel_usbCore_io_axi_aw_rValidN <= 1'b0;
      end
      if(toplevel_usbCore_io_axi_aw_s2mPipe_ready) begin
        toplevel_usbCore_io_axi_aw_rValidN <= 1'b1;
      end
      if(toplevel_usbCore_io_axi_aw_s2mPipe_ready) begin
        toplevel_usbCore_io_axi_aw_s2mPipe_rValid <= toplevel_usbCore_io_axi_aw_s2mPipe_valid;
      end
      if(usbCore_axi_arvalid) begin
        toplevel_usbCore_io_axi_ar_rValidN <= 1'b0;
      end
      if(toplevel_usbCore_io_axi_ar_s2mPipe_ready) begin
        toplevel_usbCore_io_axi_ar_rValidN <= 1'b1;
      end
      if(toplevel_usbCore_io_axi_ar_s2mPipe_ready) begin
        toplevel_usbCore_io_axi_ar_s2mPipe_rValid <= toplevel_usbCore_io_axi_ar_s2mPipe_valid;
      end
      if(usbPiped_readOnly_decoder_io_outputs_0_ar_valid) begin
        toplevel_usbPiped_readOnly_decoder_io_outputs_0_ar_rValid <= 1'b1;
      end
      if(toplevel_usbPiped_readOnly_decoder_io_outputs_0_ar_validPipe_fire) begin
        toplevel_usbPiped_readOnly_decoder_io_outputs_0_ar_rValid <= 1'b0;
      end
      if(usbPiped_writeOnly_decoder_io_outputs_0_aw_valid) begin
        toplevel_usbPiped_writeOnly_decoder_io_outputs_0_aw_rValid <= 1'b1;
      end
      if(toplevel_usbPiped_writeOnly_decoder_io_outputs_0_aw_validPipe_fire) begin
        toplevel_usbPiped_writeOnly_decoder_io_outputs_0_aw_rValid <= 1'b0;
      end
      if(toplevel_wb2axi4_1_io_axi_readOnly_decoder_io_outputs_0_ar_valid) begin
        toplevel_toplevel_wb2axi4_1_io_axi_readOnly_decoder_io_outputs_0_ar_rValid <= 1'b1;
      end
      if(toplevel_toplevel_wb2axi4_1_io_axi_readOnly_decoder_io_outputs_0_ar_validPipe_fire) begin
        toplevel_toplevel_wb2axi4_1_io_axi_readOnly_decoder_io_outputs_0_ar_rValid <= 1'b0;
      end
      if(toplevel_wb2axi4_1_io_axi_writeOnly_decoder_io_outputs_0_aw_valid) begin
        toplevel_toplevel_wb2axi4_1_io_axi_writeOnly_decoder_io_outputs_0_aw_rValid <= 1'b1;
      end
      if(toplevel_toplevel_wb2axi4_1_io_axi_writeOnly_decoder_io_outputs_0_aw_validPipe_fire) begin
        toplevel_toplevel_wb2axi4_1_io_axi_writeOnly_decoder_io_outputs_0_aw_rValid <= 1'b0;
      end
    end
  end

  always @(posedge clk) begin
    if(toplevel_usbCore_io_axi_aw_rValidN) begin
      toplevel_usbCore_io_axi_aw_rData_addr <= usbCore_axi_awaddr;
      toplevel_usbCore_io_axi_aw_rData_id <= usbCore_axi_awid;
      toplevel_usbCore_io_axi_aw_rData_len <= usbCore_axi_awlen;
      toplevel_usbCore_io_axi_aw_rData_size <= usbCore_axi_awsize;
      toplevel_usbCore_io_axi_aw_rData_burst <= usbCore_axi_awburst;
      toplevel_usbCore_io_axi_aw_rData_lock <= usbCore_axi_awlock;
      toplevel_usbCore_io_axi_aw_rData_cache <= usbCore_axi_awcache;
      toplevel_usbCore_io_axi_aw_rData_prot <= usbCore_axi_awprot;
    end
    if(toplevel_usbCore_io_axi_aw_s2mPipe_ready) begin
      toplevel_usbCore_io_axi_aw_s2mPipe_rData_addr <= toplevel_usbCore_io_axi_aw_s2mPipe_payload_addr;
      toplevel_usbCore_io_axi_aw_s2mPipe_rData_id <= toplevel_usbCore_io_axi_aw_s2mPipe_payload_id;
      toplevel_usbCore_io_axi_aw_s2mPipe_rData_len <= toplevel_usbCore_io_axi_aw_s2mPipe_payload_len;
      toplevel_usbCore_io_axi_aw_s2mPipe_rData_size <= toplevel_usbCore_io_axi_aw_s2mPipe_payload_size;
      toplevel_usbCore_io_axi_aw_s2mPipe_rData_burst <= toplevel_usbCore_io_axi_aw_s2mPipe_payload_burst;
      toplevel_usbCore_io_axi_aw_s2mPipe_rData_lock <= toplevel_usbCore_io_axi_aw_s2mPipe_payload_lock;
      toplevel_usbCore_io_axi_aw_s2mPipe_rData_cache <= toplevel_usbCore_io_axi_aw_s2mPipe_payload_cache;
      toplevel_usbCore_io_axi_aw_s2mPipe_rData_prot <= toplevel_usbCore_io_axi_aw_s2mPipe_payload_prot;
    end
    if(toplevel_usbCore_io_axi_ar_rValidN) begin
      toplevel_usbCore_io_axi_ar_rData_addr <= usbCore_axi_araddr;
      toplevel_usbCore_io_axi_ar_rData_id <= usbCore_axi_arid;
      toplevel_usbCore_io_axi_ar_rData_len <= usbCore_axi_arlen;
      toplevel_usbCore_io_axi_ar_rData_size <= usbCore_axi_arsize;
      toplevel_usbCore_io_axi_ar_rData_burst <= usbCore_axi_arburst;
      toplevel_usbCore_io_axi_ar_rData_lock <= usbCore_axi_arlock;
      toplevel_usbCore_io_axi_ar_rData_cache <= usbCore_axi_arcache;
      toplevel_usbCore_io_axi_ar_rData_prot <= usbCore_axi_arprot;
    end
    if(toplevel_usbCore_io_axi_ar_s2mPipe_ready) begin
      toplevel_usbCore_io_axi_ar_s2mPipe_rData_addr <= toplevel_usbCore_io_axi_ar_s2mPipe_payload_addr;
      toplevel_usbCore_io_axi_ar_s2mPipe_rData_id <= toplevel_usbCore_io_axi_ar_s2mPipe_payload_id;
      toplevel_usbCore_io_axi_ar_s2mPipe_rData_len <= toplevel_usbCore_io_axi_ar_s2mPipe_payload_len;
      toplevel_usbCore_io_axi_ar_s2mPipe_rData_size <= toplevel_usbCore_io_axi_ar_s2mPipe_payload_size;
      toplevel_usbCore_io_axi_ar_s2mPipe_rData_burst <= toplevel_usbCore_io_axi_ar_s2mPipe_payload_burst;
      toplevel_usbCore_io_axi_ar_s2mPipe_rData_lock <= toplevel_usbCore_io_axi_ar_s2mPipe_payload_lock;
      toplevel_usbCore_io_axi_ar_s2mPipe_rData_cache <= toplevel_usbCore_io_axi_ar_s2mPipe_payload_cache;
      toplevel_usbCore_io_axi_ar_s2mPipe_rData_prot <= toplevel_usbCore_io_axi_ar_s2mPipe_payload_prot;
    end
  end


endmodule

module Axi4SharedArbiter (
  input  wire          io_readInputs_0_ar_valid,
  output wire          io_readInputs_0_ar_ready,
  input  wire [11:0]   io_readInputs_0_ar_payload_addr,
  input  wire [7:0]    io_readInputs_0_ar_payload_id,
  input  wire [7:0]    io_readInputs_0_ar_payload_len,
  input  wire [2:0]    io_readInputs_0_ar_payload_size,
  input  wire [1:0]    io_readInputs_0_ar_payload_burst,
  output wire          io_readInputs_0_r_valid,
  input  wire          io_readInputs_0_r_ready,
  output wire [63:0]   io_readInputs_0_r_payload_data,
  output wire [7:0]    io_readInputs_0_r_payload_id,
  output wire [1:0]    io_readInputs_0_r_payload_resp,
  output wire          io_readInputs_0_r_payload_last,
  input  wire          io_readInputs_1_ar_valid,
  output wire          io_readInputs_1_ar_ready,
  input  wire [11:0]   io_readInputs_1_ar_payload_addr,
  input  wire [7:0]    io_readInputs_1_ar_payload_id,
  input  wire [7:0]    io_readInputs_1_ar_payload_len,
  input  wire [2:0]    io_readInputs_1_ar_payload_size,
  input  wire [1:0]    io_readInputs_1_ar_payload_burst,
  output wire          io_readInputs_1_r_valid,
  input  wire          io_readInputs_1_r_ready,
  output wire [63:0]   io_readInputs_1_r_payload_data,
  output wire [7:0]    io_readInputs_1_r_payload_id,
  output wire [1:0]    io_readInputs_1_r_payload_resp,
  output wire          io_readInputs_1_r_payload_last,
  input  wire          io_writeInputs_0_aw_valid,
  output wire          io_writeInputs_0_aw_ready,
  input  wire [11:0]   io_writeInputs_0_aw_payload_addr,
  input  wire [7:0]    io_writeInputs_0_aw_payload_id,
  input  wire [7:0]    io_writeInputs_0_aw_payload_len,
  input  wire [2:0]    io_writeInputs_0_aw_payload_size,
  input  wire [1:0]    io_writeInputs_0_aw_payload_burst,
  input  wire          io_writeInputs_0_w_valid,
  output wire          io_writeInputs_0_w_ready,
  input  wire [63:0]   io_writeInputs_0_w_payload_data,
  input  wire [7:0]    io_writeInputs_0_w_payload_strb,
  input  wire          io_writeInputs_0_w_payload_last,
  output wire          io_writeInputs_0_b_valid,
  input  wire          io_writeInputs_0_b_ready,
  output wire [7:0]    io_writeInputs_0_b_payload_id,
  output wire [1:0]    io_writeInputs_0_b_payload_resp,
  input  wire          io_writeInputs_1_aw_valid,
  output wire          io_writeInputs_1_aw_ready,
  input  wire [11:0]   io_writeInputs_1_aw_payload_addr,
  input  wire [7:0]    io_writeInputs_1_aw_payload_id,
  input  wire [7:0]    io_writeInputs_1_aw_payload_len,
  input  wire [2:0]    io_writeInputs_1_aw_payload_size,
  input  wire [1:0]    io_writeInputs_1_aw_payload_burst,
  input  wire          io_writeInputs_1_w_valid,
  output wire          io_writeInputs_1_w_ready,
  input  wire [63:0]   io_writeInputs_1_w_payload_data,
  input  wire [7:0]    io_writeInputs_1_w_payload_strb,
  input  wire          io_writeInputs_1_w_payload_last,
  output wire          io_writeInputs_1_b_valid,
  input  wire          io_writeInputs_1_b_ready,
  output wire [7:0]    io_writeInputs_1_b_payload_id,
  output wire [1:0]    io_writeInputs_1_b_payload_resp,
  output wire          io_output_arw_valid,
  input  wire          io_output_arw_ready,
  output wire [11:0]   io_output_arw_payload_addr,
  output wire [8:0]    io_output_arw_payload_id,
  output wire [7:0]    io_output_arw_payload_len,
  output wire [2:0]    io_output_arw_payload_size,
  output wire [1:0]    io_output_arw_payload_burst,
  output wire          io_output_arw_payload_write,
  output wire          io_output_w_valid,
  input  wire          io_output_w_ready,
  output wire [63:0]   io_output_w_payload_data,
  output wire [7:0]    io_output_w_payload_strb,
  output wire          io_output_w_payload_last,
  input  wire          io_output_b_valid,
  output wire          io_output_b_ready,
  input  wire [8:0]    io_output_b_payload_id,
  input  wire [1:0]    io_output_b_payload_resp,
  input  wire          io_output_r_valid,
  output wire          io_output_r_ready,
  input  wire [63:0]   io_output_r_payload_data,
  input  wire [8:0]    io_output_r_payload_id,
  input  wire [1:0]    io_output_r_payload_resp,
  input  wire          io_output_r_payload_last,
  input  wire          clk,
  input  wire          reset
);

  reg                 cmdArbiter_io_output_ready;
  wire                cmdRouteFork_thrown_translated_fifo_io_pop_ready;
  wire                cmdRouteFork_thrown_translated_fifo_io_flush;
  wire                cmdArbiter_io_inputs_0_ready;
  wire                cmdArbiter_io_inputs_1_ready;
  wire                cmdArbiter_io_inputs_2_ready;
  wire                cmdArbiter_io_inputs_3_ready;
  wire                cmdArbiter_io_output_valid;
  wire       [11:0]   cmdArbiter_io_output_payload_addr;
  wire       [7:0]    cmdArbiter_io_output_payload_id;
  wire       [7:0]    cmdArbiter_io_output_payload_len;
  wire       [2:0]    cmdArbiter_io_output_payload_size;
  wire       [1:0]    cmdArbiter_io_output_payload_burst;
  wire                cmdArbiter_io_output_payload_write;
  wire       [1:0]    cmdArbiter_io_chosen;
  wire       [3:0]    cmdArbiter_io_chosenOH;
  wire                cmdRouteFork_thrown_translated_fifo_io_push_ready;
  wire                cmdRouteFork_thrown_translated_fifo_io_pop_valid;
  wire       [0:0]    cmdRouteFork_thrown_translated_fifo_io_pop_payload;
  wire       [2:0]    cmdRouteFork_thrown_translated_fifo_io_occupancy;
  wire       [2:0]    cmdRouteFork_thrown_translated_fifo_io_availability;
  wire       [1:0]    _zz__zz_io_output_arw_payload_id;
  wire       [1:0]    _zz__zz_io_output_arw_payload_id_1;
  wire       [1:0]    _zz__zz_cmdRouteFork_thrown_translated_payload;
  reg                 _zz_writeLogic_routeDataInput_valid;
  reg                 _zz_writeLogic_routeDataInput_ready;
  reg        [63:0]   _zz_writeLogic_routeDataInput_payload_data;
  reg        [7:0]    _zz_writeLogic_routeDataInput_payload_strb;
  reg                 _zz_writeLogic_routeDataInput_payload_last;
  reg                 _zz_io_output_b_ready;
  reg                 _zz_io_output_r_ready;
  wire                inputsCmd_0_valid;
  wire                inputsCmd_0_ready;
  wire       [11:0]   inputsCmd_0_payload_addr;
  wire       [7:0]    inputsCmd_0_payload_id;
  wire       [7:0]    inputsCmd_0_payload_len;
  wire       [2:0]    inputsCmd_0_payload_size;
  wire       [1:0]    inputsCmd_0_payload_burst;
  wire                inputsCmd_0_payload_write;
  wire                inputsCmd_1_valid;
  wire                inputsCmd_1_ready;
  wire       [11:0]   inputsCmd_1_payload_addr;
  wire       [7:0]    inputsCmd_1_payload_id;
  wire       [7:0]    inputsCmd_1_payload_len;
  wire       [2:0]    inputsCmd_1_payload_size;
  wire       [1:0]    inputsCmd_1_payload_burst;
  wire                inputsCmd_1_payload_write;
  wire                inputsCmd_2_valid;
  wire                inputsCmd_2_ready;
  wire       [11:0]   inputsCmd_2_payload_addr;
  wire       [7:0]    inputsCmd_2_payload_id;
  wire       [7:0]    inputsCmd_2_payload_len;
  wire       [2:0]    inputsCmd_2_payload_size;
  wire       [1:0]    inputsCmd_2_payload_burst;
  wire                inputsCmd_2_payload_write;
  wire                inputsCmd_3_valid;
  wire                inputsCmd_3_ready;
  wire       [11:0]   inputsCmd_3_payload_addr;
  wire       [7:0]    inputsCmd_3_payload_id;
  wire       [7:0]    inputsCmd_3_payload_len;
  wire       [2:0]    inputsCmd_3_payload_size;
  wire       [1:0]    inputsCmd_3_payload_burst;
  wire                inputsCmd_3_payload_write;
  wire                cmdOutputFork_valid;
  wire                cmdOutputFork_ready;
  wire       [11:0]   cmdOutputFork_payload_addr;
  wire       [7:0]    cmdOutputFork_payload_id;
  wire       [7:0]    cmdOutputFork_payload_len;
  wire       [2:0]    cmdOutputFork_payload_size;
  wire       [1:0]    cmdOutputFork_payload_burst;
  wire                cmdOutputFork_payload_write;
  wire                cmdRouteFork_valid;
  reg                 cmdRouteFork_ready;
  wire       [11:0]   cmdRouteFork_payload_addr;
  wire       [7:0]    cmdRouteFork_payload_id;
  wire       [7:0]    cmdRouteFork_payload_len;
  wire       [2:0]    cmdRouteFork_payload_size;
  wire       [1:0]    cmdRouteFork_payload_burst;
  wire                cmdRouteFork_payload_write;
  reg                 ram1_io_axi_arbiter_cmdArbiter_io_output_fork2_logic_linkEnable_0;
  reg                 ram1_io_axi_arbiter_cmdArbiter_io_output_fork2_logic_linkEnable_1;
  wire                when_Stream_l1020;
  wire                when_Stream_l1020_1;
  wire                cmdOutputFork_fire;
  wire                cmdRouteFork_fire;
  wire                _zz_io_output_arw_payload_id;
  wire                _zz_io_output_arw_payload_id_1;
  wire                when_Stream_l439;
  reg                 cmdRouteFork_thrown_valid;
  wire                cmdRouteFork_thrown_ready;
  wire       [11:0]   cmdRouteFork_thrown_payload_addr;
  wire       [7:0]    cmdRouteFork_thrown_payload_id;
  wire       [7:0]    cmdRouteFork_thrown_payload_len;
  wire       [2:0]    cmdRouteFork_thrown_payload_size;
  wire       [1:0]    cmdRouteFork_thrown_payload_burst;
  wire                cmdRouteFork_thrown_payload_write;
  wire                _zz_cmdRouteFork_thrown_translated_payload;
  wire                cmdRouteFork_thrown_translated_valid;
  wire                cmdRouteFork_thrown_translated_ready;
  wire       [0:0]    cmdRouteFork_thrown_translated_payload;
  wire                writeLogic_routeDataInput_valid;
  wire                writeLogic_routeDataInput_ready;
  wire       [63:0]   writeLogic_routeDataInput_payload_data;
  wire       [7:0]    writeLogic_routeDataInput_payload_strb;
  wire                writeLogic_routeDataInput_payload_last;
  wire                io_output_w_fire;
  wire       [0:0]    writeLogic_writeRspIndex;
  wire                writeLogic_writeRspSels_0;
  wire                writeLogic_writeRspSels_1;
  wire       [0:0]    readRspIndex;
  wire                readRspSels_0;
  wire                readRspSels_1;

  assign _zz__zz_io_output_arw_payload_id = cmdArbiter_io_chosenOH[3 : 2];
  assign _zz__zz_io_output_arw_payload_id_1 = cmdArbiter_io_chosenOH[1 : 0];
  assign _zz__zz_cmdRouteFork_thrown_translated_payload = cmdArbiter_io_chosenOH[3 : 2];
  StreamArbiter cmdArbiter (
    .io_inputs_0_valid         (inputsCmd_0_valid                      ), //i
    .io_inputs_0_ready         (cmdArbiter_io_inputs_0_ready           ), //o
    .io_inputs_0_payload_addr  (inputsCmd_0_payload_addr[11:0]         ), //i
    .io_inputs_0_payload_id    (inputsCmd_0_payload_id[7:0]            ), //i
    .io_inputs_0_payload_len   (inputsCmd_0_payload_len[7:0]           ), //i
    .io_inputs_0_payload_size  (inputsCmd_0_payload_size[2:0]          ), //i
    .io_inputs_0_payload_burst (inputsCmd_0_payload_burst[1:0]         ), //i
    .io_inputs_0_payload_write (inputsCmd_0_payload_write              ), //i
    .io_inputs_1_valid         (inputsCmd_1_valid                      ), //i
    .io_inputs_1_ready         (cmdArbiter_io_inputs_1_ready           ), //o
    .io_inputs_1_payload_addr  (inputsCmd_1_payload_addr[11:0]         ), //i
    .io_inputs_1_payload_id    (inputsCmd_1_payload_id[7:0]            ), //i
    .io_inputs_1_payload_len   (inputsCmd_1_payload_len[7:0]           ), //i
    .io_inputs_1_payload_size  (inputsCmd_1_payload_size[2:0]          ), //i
    .io_inputs_1_payload_burst (inputsCmd_1_payload_burst[1:0]         ), //i
    .io_inputs_1_payload_write (inputsCmd_1_payload_write              ), //i
    .io_inputs_2_valid         (inputsCmd_2_valid                      ), //i
    .io_inputs_2_ready         (cmdArbiter_io_inputs_2_ready           ), //o
    .io_inputs_2_payload_addr  (inputsCmd_2_payload_addr[11:0]         ), //i
    .io_inputs_2_payload_id    (inputsCmd_2_payload_id[7:0]            ), //i
    .io_inputs_2_payload_len   (inputsCmd_2_payload_len[7:0]           ), //i
    .io_inputs_2_payload_size  (inputsCmd_2_payload_size[2:0]          ), //i
    .io_inputs_2_payload_burst (inputsCmd_2_payload_burst[1:0]         ), //i
    .io_inputs_2_payload_write (inputsCmd_2_payload_write              ), //i
    .io_inputs_3_valid         (inputsCmd_3_valid                      ), //i
    .io_inputs_3_ready         (cmdArbiter_io_inputs_3_ready           ), //o
    .io_inputs_3_payload_addr  (inputsCmd_3_payload_addr[11:0]         ), //i
    .io_inputs_3_payload_id    (inputsCmd_3_payload_id[7:0]            ), //i
    .io_inputs_3_payload_len   (inputsCmd_3_payload_len[7:0]           ), //i
    .io_inputs_3_payload_size  (inputsCmd_3_payload_size[2:0]          ), //i
    .io_inputs_3_payload_burst (inputsCmd_3_payload_burst[1:0]         ), //i
    .io_inputs_3_payload_write (inputsCmd_3_payload_write              ), //i
    .io_output_valid           (cmdArbiter_io_output_valid             ), //o
    .io_output_ready           (cmdArbiter_io_output_ready             ), //i
    .io_output_payload_addr    (cmdArbiter_io_output_payload_addr[11:0]), //o
    .io_output_payload_id      (cmdArbiter_io_output_payload_id[7:0]   ), //o
    .io_output_payload_len     (cmdArbiter_io_output_payload_len[7:0]  ), //o
    .io_output_payload_size    (cmdArbiter_io_output_payload_size[2:0] ), //o
    .io_output_payload_burst   (cmdArbiter_io_output_payload_burst[1:0]), //o
    .io_output_payload_write   (cmdArbiter_io_output_payload_write     ), //o
    .io_chosen                 (cmdArbiter_io_chosen[1:0]              ), //o
    .io_chosenOH               (cmdArbiter_io_chosenOH[3:0]            ), //o
    .clk                       (clk                                    ), //i
    .reset                     (reset                                  )  //i
  );
  StreamFifoLowLatency cmdRouteFork_thrown_translated_fifo (
    .io_push_valid   (cmdRouteFork_thrown_translated_valid                    ), //i
    .io_push_ready   (cmdRouteFork_thrown_translated_fifo_io_push_ready       ), //o
    .io_push_payload (cmdRouteFork_thrown_translated_payload                  ), //i
    .io_pop_valid    (cmdRouteFork_thrown_translated_fifo_io_pop_valid        ), //o
    .io_pop_ready    (cmdRouteFork_thrown_translated_fifo_io_pop_ready        ), //i
    .io_pop_payload  (cmdRouteFork_thrown_translated_fifo_io_pop_payload      ), //o
    .io_flush        (cmdRouteFork_thrown_translated_fifo_io_flush            ), //i
    .io_occupancy    (cmdRouteFork_thrown_translated_fifo_io_occupancy[2:0]   ), //o
    .io_availability (cmdRouteFork_thrown_translated_fifo_io_availability[2:0]), //o
    .clk             (clk                                                     ), //i
    .reset           (reset                                                   )  //i
  );
  always @(*) begin
    case(cmdRouteFork_thrown_translated_fifo_io_pop_payload)
      1'b0 : begin
        _zz_writeLogic_routeDataInput_valid = io_writeInputs_0_w_valid;
        _zz_writeLogic_routeDataInput_ready = io_writeInputs_0_w_ready;
        _zz_writeLogic_routeDataInput_payload_data = io_writeInputs_0_w_payload_data;
        _zz_writeLogic_routeDataInput_payload_strb = io_writeInputs_0_w_payload_strb;
        _zz_writeLogic_routeDataInput_payload_last = io_writeInputs_0_w_payload_last;
      end
      default : begin
        _zz_writeLogic_routeDataInput_valid = io_writeInputs_1_w_valid;
        _zz_writeLogic_routeDataInput_ready = io_writeInputs_1_w_ready;
        _zz_writeLogic_routeDataInput_payload_data = io_writeInputs_1_w_payload_data;
        _zz_writeLogic_routeDataInput_payload_strb = io_writeInputs_1_w_payload_strb;
        _zz_writeLogic_routeDataInput_payload_last = io_writeInputs_1_w_payload_last;
      end
    endcase
  end

  always @(*) begin
    case(writeLogic_writeRspIndex)
      1'b0 : _zz_io_output_b_ready = io_writeInputs_0_b_ready;
      default : _zz_io_output_b_ready = io_writeInputs_1_b_ready;
    endcase
  end

  always @(*) begin
    case(readRspIndex)
      1'b0 : _zz_io_output_r_ready = io_readInputs_0_r_ready;
      default : _zz_io_output_r_ready = io_readInputs_1_r_ready;
    endcase
  end

  assign inputsCmd_0_valid = io_readInputs_0_ar_valid;
  assign io_readInputs_0_ar_ready = inputsCmd_0_ready;
  assign inputsCmd_0_payload_addr = io_readInputs_0_ar_payload_addr;
  assign inputsCmd_0_payload_id = io_readInputs_0_ar_payload_id;
  assign inputsCmd_0_payload_len = io_readInputs_0_ar_payload_len;
  assign inputsCmd_0_payload_size = io_readInputs_0_ar_payload_size;
  assign inputsCmd_0_payload_burst = io_readInputs_0_ar_payload_burst;
  assign inputsCmd_0_payload_write = 1'b0;
  assign inputsCmd_1_valid = io_readInputs_1_ar_valid;
  assign io_readInputs_1_ar_ready = inputsCmd_1_ready;
  assign inputsCmd_1_payload_addr = io_readInputs_1_ar_payload_addr;
  assign inputsCmd_1_payload_id = io_readInputs_1_ar_payload_id;
  assign inputsCmd_1_payload_len = io_readInputs_1_ar_payload_len;
  assign inputsCmd_1_payload_size = io_readInputs_1_ar_payload_size;
  assign inputsCmd_1_payload_burst = io_readInputs_1_ar_payload_burst;
  assign inputsCmd_1_payload_write = 1'b0;
  assign inputsCmd_2_valid = io_writeInputs_0_aw_valid;
  assign io_writeInputs_0_aw_ready = inputsCmd_2_ready;
  assign inputsCmd_2_payload_addr = io_writeInputs_0_aw_payload_addr;
  assign inputsCmd_2_payload_id = io_writeInputs_0_aw_payload_id;
  assign inputsCmd_2_payload_len = io_writeInputs_0_aw_payload_len;
  assign inputsCmd_2_payload_size = io_writeInputs_0_aw_payload_size;
  assign inputsCmd_2_payload_burst = io_writeInputs_0_aw_payload_burst;
  assign inputsCmd_2_payload_write = 1'b1;
  assign inputsCmd_3_valid = io_writeInputs_1_aw_valid;
  assign io_writeInputs_1_aw_ready = inputsCmd_3_ready;
  assign inputsCmd_3_payload_addr = io_writeInputs_1_aw_payload_addr;
  assign inputsCmd_3_payload_id = io_writeInputs_1_aw_payload_id;
  assign inputsCmd_3_payload_len = io_writeInputs_1_aw_payload_len;
  assign inputsCmd_3_payload_size = io_writeInputs_1_aw_payload_size;
  assign inputsCmd_3_payload_burst = io_writeInputs_1_aw_payload_burst;
  assign inputsCmd_3_payload_write = 1'b1;
  assign inputsCmd_0_ready = cmdArbiter_io_inputs_0_ready;
  assign inputsCmd_1_ready = cmdArbiter_io_inputs_1_ready;
  assign inputsCmd_2_ready = cmdArbiter_io_inputs_2_ready;
  assign inputsCmd_3_ready = cmdArbiter_io_inputs_3_ready;
  always @(*) begin
    cmdArbiter_io_output_ready = 1'b1;
    if(when_Stream_l1020) begin
      cmdArbiter_io_output_ready = 1'b0;
    end
    if(when_Stream_l1020_1) begin
      cmdArbiter_io_output_ready = 1'b0;
    end
  end

  assign when_Stream_l1020 = ((! cmdOutputFork_ready) && ram1_io_axi_arbiter_cmdArbiter_io_output_fork2_logic_linkEnable_0);
  assign when_Stream_l1020_1 = ((! cmdRouteFork_ready) && ram1_io_axi_arbiter_cmdArbiter_io_output_fork2_logic_linkEnable_1);
  assign cmdOutputFork_valid = (cmdArbiter_io_output_valid && ram1_io_axi_arbiter_cmdArbiter_io_output_fork2_logic_linkEnable_0);
  assign cmdOutputFork_payload_addr = cmdArbiter_io_output_payload_addr;
  assign cmdOutputFork_payload_id = cmdArbiter_io_output_payload_id;
  assign cmdOutputFork_payload_len = cmdArbiter_io_output_payload_len;
  assign cmdOutputFork_payload_size = cmdArbiter_io_output_payload_size;
  assign cmdOutputFork_payload_burst = cmdArbiter_io_output_payload_burst;
  assign cmdOutputFork_payload_write = cmdArbiter_io_output_payload_write;
  assign cmdOutputFork_fire = (cmdOutputFork_valid && cmdOutputFork_ready);
  assign cmdRouteFork_valid = (cmdArbiter_io_output_valid && ram1_io_axi_arbiter_cmdArbiter_io_output_fork2_logic_linkEnable_1);
  assign cmdRouteFork_payload_addr = cmdArbiter_io_output_payload_addr;
  assign cmdRouteFork_payload_id = cmdArbiter_io_output_payload_id;
  assign cmdRouteFork_payload_len = cmdArbiter_io_output_payload_len;
  assign cmdRouteFork_payload_size = cmdArbiter_io_output_payload_size;
  assign cmdRouteFork_payload_burst = cmdArbiter_io_output_payload_burst;
  assign cmdRouteFork_payload_write = cmdArbiter_io_output_payload_write;
  assign cmdRouteFork_fire = (cmdRouteFork_valid && cmdRouteFork_ready);
  assign io_output_arw_valid = cmdOutputFork_valid;
  assign cmdOutputFork_ready = io_output_arw_ready;
  assign io_output_arw_payload_addr = cmdOutputFork_payload_addr;
  assign io_output_arw_payload_len = cmdOutputFork_payload_len;
  assign io_output_arw_payload_size = cmdOutputFork_payload_size;
  assign io_output_arw_payload_burst = cmdOutputFork_payload_burst;
  assign io_output_arw_payload_write = cmdOutputFork_payload_write;
  assign _zz_io_output_arw_payload_id = _zz__zz_io_output_arw_payload_id[1];
  assign _zz_io_output_arw_payload_id_1 = _zz__zz_io_output_arw_payload_id_1[1];
  assign io_output_arw_payload_id = (cmdOutputFork_payload_write ? {_zz_io_output_arw_payload_id,cmdOutputFork_payload_id} : {_zz_io_output_arw_payload_id_1,cmdOutputFork_payload_id});
  assign when_Stream_l439 = (! cmdRouteFork_payload_write);
  always @(*) begin
    cmdRouteFork_thrown_valid = cmdRouteFork_valid;
    if(when_Stream_l439) begin
      cmdRouteFork_thrown_valid = 1'b0;
    end
  end

  always @(*) begin
    cmdRouteFork_ready = cmdRouteFork_thrown_ready;
    if(when_Stream_l439) begin
      cmdRouteFork_ready = 1'b1;
    end
  end

  assign cmdRouteFork_thrown_payload_addr = cmdRouteFork_payload_addr;
  assign cmdRouteFork_thrown_payload_id = cmdRouteFork_payload_id;
  assign cmdRouteFork_thrown_payload_len = cmdRouteFork_payload_len;
  assign cmdRouteFork_thrown_payload_size = cmdRouteFork_payload_size;
  assign cmdRouteFork_thrown_payload_burst = cmdRouteFork_payload_burst;
  assign cmdRouteFork_thrown_payload_write = cmdRouteFork_payload_write;
  assign _zz_cmdRouteFork_thrown_translated_payload = _zz__zz_cmdRouteFork_thrown_translated_payload[1];
  assign cmdRouteFork_thrown_translated_valid = cmdRouteFork_thrown_valid;
  assign cmdRouteFork_thrown_ready = cmdRouteFork_thrown_translated_ready;
  assign cmdRouteFork_thrown_translated_payload = _zz_cmdRouteFork_thrown_translated_payload;
  assign cmdRouteFork_thrown_translated_ready = cmdRouteFork_thrown_translated_fifo_io_push_ready;
  assign writeLogic_routeDataInput_valid = _zz_writeLogic_routeDataInput_valid;
  assign writeLogic_routeDataInput_ready = _zz_writeLogic_routeDataInput_ready;
  assign writeLogic_routeDataInput_payload_data = _zz_writeLogic_routeDataInput_payload_data;
  assign writeLogic_routeDataInput_payload_strb = _zz_writeLogic_routeDataInput_payload_strb;
  assign writeLogic_routeDataInput_payload_last = _zz_writeLogic_routeDataInput_payload_last;
  assign io_output_w_valid = (cmdRouteFork_thrown_translated_fifo_io_pop_valid && writeLogic_routeDataInput_valid);
  assign io_output_w_payload_data = writeLogic_routeDataInput_payload_data;
  assign io_output_w_payload_strb = writeLogic_routeDataInput_payload_strb;
  assign io_output_w_payload_last = writeLogic_routeDataInput_payload_last;
  assign io_writeInputs_0_w_ready = ((cmdRouteFork_thrown_translated_fifo_io_pop_valid && io_output_w_ready) && (cmdRouteFork_thrown_translated_fifo_io_pop_payload == 1'b0));
  assign io_writeInputs_1_w_ready = ((cmdRouteFork_thrown_translated_fifo_io_pop_valid && io_output_w_ready) && (cmdRouteFork_thrown_translated_fifo_io_pop_payload == 1'b1));
  assign io_output_w_fire = (io_output_w_valid && io_output_w_ready);
  assign cmdRouteFork_thrown_translated_fifo_io_pop_ready = (io_output_w_fire && io_output_w_payload_last);
  assign writeLogic_writeRspIndex = io_output_b_payload_id[8 : 8];
  assign writeLogic_writeRspSels_0 = (writeLogic_writeRspIndex == 1'b0);
  assign writeLogic_writeRspSels_1 = (writeLogic_writeRspIndex == 1'b1);
  assign io_writeInputs_0_b_valid = (io_output_b_valid && writeLogic_writeRspSels_0);
  assign io_writeInputs_0_b_payload_resp = io_output_b_payload_resp;
  assign io_writeInputs_0_b_payload_id = io_output_b_payload_id[7:0];
  assign io_writeInputs_1_b_valid = (io_output_b_valid && writeLogic_writeRspSels_1);
  assign io_writeInputs_1_b_payload_resp = io_output_b_payload_resp;
  assign io_writeInputs_1_b_payload_id = io_output_b_payload_id[7:0];
  assign io_output_b_ready = _zz_io_output_b_ready;
  assign readRspIndex = io_output_r_payload_id[8 : 8];
  assign readRspSels_0 = (readRspIndex == 1'b0);
  assign readRspSels_1 = (readRspIndex == 1'b1);
  assign io_readInputs_0_r_valid = (io_output_r_valid && readRspSels_0);
  assign io_readInputs_0_r_payload_data = io_output_r_payload_data;
  assign io_readInputs_0_r_payload_resp = io_output_r_payload_resp;
  assign io_readInputs_0_r_payload_last = io_output_r_payload_last;
  assign io_readInputs_0_r_payload_id = io_output_r_payload_id[7:0];
  assign io_readInputs_1_r_valid = (io_output_r_valid && readRspSels_1);
  assign io_readInputs_1_r_payload_data = io_output_r_payload_data;
  assign io_readInputs_1_r_payload_resp = io_output_r_payload_resp;
  assign io_readInputs_1_r_payload_last = io_output_r_payload_last;
  assign io_readInputs_1_r_payload_id = io_output_r_payload_id[7:0];
  assign io_output_r_ready = _zz_io_output_r_ready;
  assign cmdRouteFork_thrown_translated_fifo_io_flush = 1'b0;
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      ram1_io_axi_arbiter_cmdArbiter_io_output_fork2_logic_linkEnable_0 <= 1'b1;
      ram1_io_axi_arbiter_cmdArbiter_io_output_fork2_logic_linkEnable_1 <= 1'b1;
    end else begin
      if(cmdOutputFork_fire) begin
        ram1_io_axi_arbiter_cmdArbiter_io_output_fork2_logic_linkEnable_0 <= 1'b0;
      end
      if(cmdRouteFork_fire) begin
        ram1_io_axi_arbiter_cmdArbiter_io_output_fork2_logic_linkEnable_1 <= 1'b0;
      end
      if(cmdArbiter_io_output_ready) begin
        ram1_io_axi_arbiter_cmdArbiter_io_output_fork2_logic_linkEnable_0 <= 1'b1;
        ram1_io_axi_arbiter_cmdArbiter_io_output_fork2_logic_linkEnable_1 <= 1'b1;
      end
    end
  end


endmodule

//Axi4WriteOnlyDecoder_1 replaced by Axi4WriteOnlyDecoder

//Axi4ReadOnlyDecoder_1 replaced by Axi4ReadOnlyDecoder

module Axi4WriteOnlyDecoder (
  input  wire          io_input_aw_valid,
  output wire          io_input_aw_ready,
  input  wire [31:0]   io_input_aw_payload_addr,
  input  wire [7:0]    io_input_aw_payload_id,
  input  wire [7:0]    io_input_aw_payload_len,
  input  wire [2:0]    io_input_aw_payload_size,
  input  wire [1:0]    io_input_aw_payload_burst,
  input  wire [0:0]    io_input_aw_payload_lock,
  input  wire [3:0]    io_input_aw_payload_cache,
  input  wire [2:0]    io_input_aw_payload_prot,
  input  wire          io_input_w_valid,
  output wire          io_input_w_ready,
  input  wire [63:0]   io_input_w_payload_data,
  input  wire [7:0]    io_input_w_payload_strb,
  input  wire          io_input_w_payload_last,
  output wire          io_input_b_valid,
  input  wire          io_input_b_ready,
  output reg  [7:0]    io_input_b_payload_id,
  output reg  [1:0]    io_input_b_payload_resp,
  output wire          io_outputs_0_aw_valid,
  input  wire          io_outputs_0_aw_ready,
  output wire [31:0]   io_outputs_0_aw_payload_addr,
  output wire [7:0]    io_outputs_0_aw_payload_id,
  output wire [7:0]    io_outputs_0_aw_payload_len,
  output wire [2:0]    io_outputs_0_aw_payload_size,
  output wire [1:0]    io_outputs_0_aw_payload_burst,
  output wire [0:0]    io_outputs_0_aw_payload_lock,
  output wire [3:0]    io_outputs_0_aw_payload_cache,
  output wire [2:0]    io_outputs_0_aw_payload_prot,
  output wire          io_outputs_0_w_valid,
  input  wire          io_outputs_0_w_ready,
  output wire [63:0]   io_outputs_0_w_payload_data,
  output wire [7:0]    io_outputs_0_w_payload_strb,
  output wire          io_outputs_0_w_payload_last,
  input  wire          io_outputs_0_b_valid,
  output wire          io_outputs_0_b_ready,
  input  wire [7:0]    io_outputs_0_b_payload_id,
  input  wire [1:0]    io_outputs_0_b_payload_resp,
  input  wire          clk,
  input  wire          reset
);

  wire                errorSlave_io_axi_aw_valid;
  wire                errorSlave_io_axi_w_valid;
  wire                errorSlave_io_axi_aw_ready;
  wire                errorSlave_io_axi_w_ready;
  wire                errorSlave_io_axi_b_valid;
  wire       [7:0]    errorSlave_io_axi_b_payload_id;
  wire       [1:0]    errorSlave_io_axi_b_payload_resp;
  wire                cmdAllowedStart;
  wire                io_input_aw_fire;
  wire                io_input_b_fire;
  reg                 pendingCmdCounter_incrementIt;
  reg                 pendingCmdCounter_decrementIt;
  wire       [2:0]    pendingCmdCounter_valueNext;
  reg        [2:0]    pendingCmdCounter_value;
  wire                pendingCmdCounter_mayOverflow;
  wire                pendingCmdCounter_willOverflowIfInc;
  wire                pendingCmdCounter_willOverflow;
  reg        [2:0]    pendingCmdCounter_finalIncrement;
  wire                when_Utils_l723;
  wire                when_Utils_l725;
  wire                io_input_w_fire;
  wire                when_Utils_l697;
  reg                 pendingDataCounter_incrementIt;
  reg                 pendingDataCounter_decrementIt;
  wire       [2:0]    pendingDataCounter_valueNext;
  reg        [2:0]    pendingDataCounter_value;
  wire                pendingDataCounter_mayOverflow;
  wire                pendingDataCounter_willOverflowIfInc;
  wire                pendingDataCounter_willOverflow;
  reg        [2:0]    pendingDataCounter_finalIncrement;
  wire                when_Utils_l723_1;
  wire                when_Utils_l725_1;
  wire       [0:0]    decodedCmdSels;
  wire                decodedCmdError;
  reg        [0:0]    pendingSels;
  reg                 pendingError;
  wire                allowCmd;
  wire                allowData;
  reg                 _zz_cmdAllowedStart;

  Axi4WriteOnlyErrorSlave_1 errorSlave (
    .io_axi_aw_valid         (errorSlave_io_axi_aw_valid           ), //i
    .io_axi_aw_ready         (errorSlave_io_axi_aw_ready           ), //o
    .io_axi_aw_payload_addr  (io_input_aw_payload_addr[31:0]       ), //i
    .io_axi_aw_payload_id    (io_input_aw_payload_id[7:0]          ), //i
    .io_axi_aw_payload_len   (io_input_aw_payload_len[7:0]         ), //i
    .io_axi_aw_payload_size  (io_input_aw_payload_size[2:0]        ), //i
    .io_axi_aw_payload_burst (io_input_aw_payload_burst[1:0]       ), //i
    .io_axi_aw_payload_lock  (io_input_aw_payload_lock             ), //i
    .io_axi_aw_payload_cache (io_input_aw_payload_cache[3:0]       ), //i
    .io_axi_aw_payload_prot  (io_input_aw_payload_prot[2:0]        ), //i
    .io_axi_w_valid          (errorSlave_io_axi_w_valid            ), //i
    .io_axi_w_ready          (errorSlave_io_axi_w_ready            ), //o
    .io_axi_w_payload_data   (io_input_w_payload_data[63:0]        ), //i
    .io_axi_w_payload_strb   (io_input_w_payload_strb[7:0]         ), //i
    .io_axi_w_payload_last   (io_input_w_payload_last              ), //i
    .io_axi_b_valid          (errorSlave_io_axi_b_valid            ), //o
    .io_axi_b_ready          (io_input_b_ready                     ), //i
    .io_axi_b_payload_id     (errorSlave_io_axi_b_payload_id[7:0]  ), //o
    .io_axi_b_payload_resp   (errorSlave_io_axi_b_payload_resp[1:0]), //o
    .clk                     (clk                                  ), //i
    .reset                   (reset                                )  //i
  );
  assign io_input_aw_fire = (io_input_aw_valid && io_input_aw_ready);
  assign io_input_b_fire = (io_input_b_valid && io_input_b_ready);
  always @(*) begin
    pendingCmdCounter_incrementIt = 1'b0;
    if(io_input_aw_fire) begin
      pendingCmdCounter_incrementIt = 1'b1;
    end
  end

  always @(*) begin
    pendingCmdCounter_decrementIt = 1'b0;
    if(io_input_b_fire) begin
      pendingCmdCounter_decrementIt = 1'b1;
    end
  end

  assign pendingCmdCounter_mayOverflow = (pendingCmdCounter_value == 3'b111);
  assign pendingCmdCounter_willOverflowIfInc = (pendingCmdCounter_mayOverflow && (! pendingCmdCounter_decrementIt));
  assign pendingCmdCounter_willOverflow = (pendingCmdCounter_willOverflowIfInc && pendingCmdCounter_incrementIt);
  assign when_Utils_l723 = (pendingCmdCounter_incrementIt && (! pendingCmdCounter_decrementIt));
  always @(*) begin
    if(when_Utils_l723) begin
      pendingCmdCounter_finalIncrement = 3'b001;
    end else begin
      if(when_Utils_l725) begin
        pendingCmdCounter_finalIncrement = 3'b111;
      end else begin
        pendingCmdCounter_finalIncrement = 3'b000;
      end
    end
  end

  assign when_Utils_l725 = ((! pendingCmdCounter_incrementIt) && pendingCmdCounter_decrementIt);
  assign pendingCmdCounter_valueNext = (pendingCmdCounter_value + pendingCmdCounter_finalIncrement);
  assign io_input_w_fire = (io_input_w_valid && io_input_w_ready);
  assign when_Utils_l697 = (io_input_w_fire && io_input_w_payload_last);
  always @(*) begin
    pendingDataCounter_incrementIt = 1'b0;
    if(cmdAllowedStart) begin
      pendingDataCounter_incrementIt = 1'b1;
    end
  end

  always @(*) begin
    pendingDataCounter_decrementIt = 1'b0;
    if(when_Utils_l697) begin
      pendingDataCounter_decrementIt = 1'b1;
    end
  end

  assign pendingDataCounter_mayOverflow = (pendingDataCounter_value == 3'b111);
  assign pendingDataCounter_willOverflowIfInc = (pendingDataCounter_mayOverflow && (! pendingDataCounter_decrementIt));
  assign pendingDataCounter_willOverflow = (pendingDataCounter_willOverflowIfInc && pendingDataCounter_incrementIt);
  assign when_Utils_l723_1 = (pendingDataCounter_incrementIt && (! pendingDataCounter_decrementIt));
  always @(*) begin
    if(when_Utils_l723_1) begin
      pendingDataCounter_finalIncrement = 3'b001;
    end else begin
      if(when_Utils_l725_1) begin
        pendingDataCounter_finalIncrement = 3'b111;
      end else begin
        pendingDataCounter_finalIncrement = 3'b000;
      end
    end
  end

  assign when_Utils_l725_1 = ((! pendingDataCounter_incrementIt) && pendingDataCounter_decrementIt);
  assign pendingDataCounter_valueNext = (pendingDataCounter_value + pendingDataCounter_finalIncrement);
  assign decodedCmdSels = (((io_input_aw_payload_addr & (~ 32'h00000fff)) == 32'h00000000) && io_input_aw_valid);
  assign decodedCmdError = (decodedCmdSels == 1'b0);
  assign allowCmd = ((pendingCmdCounter_value == 3'b000) || ((pendingCmdCounter_value != 3'b111) && (pendingSels == decodedCmdSels)));
  assign allowData = (pendingDataCounter_value != 3'b000);
  assign cmdAllowedStart = ((io_input_aw_valid && allowCmd) && _zz_cmdAllowedStart);
  assign io_input_aw_ready = (((|(decodedCmdSels & io_outputs_0_aw_ready)) || (decodedCmdError && errorSlave_io_axi_aw_ready)) && allowCmd);
  assign errorSlave_io_axi_aw_valid = ((io_input_aw_valid && decodedCmdError) && allowCmd);
  assign io_outputs_0_aw_valid = ((io_input_aw_valid && decodedCmdSels[0]) && allowCmd);
  assign io_outputs_0_aw_payload_addr = io_input_aw_payload_addr;
  assign io_outputs_0_aw_payload_id = io_input_aw_payload_id;
  assign io_outputs_0_aw_payload_len = io_input_aw_payload_len;
  assign io_outputs_0_aw_payload_size = io_input_aw_payload_size;
  assign io_outputs_0_aw_payload_burst = io_input_aw_payload_burst;
  assign io_outputs_0_aw_payload_lock = io_input_aw_payload_lock;
  assign io_outputs_0_aw_payload_cache = io_input_aw_payload_cache;
  assign io_outputs_0_aw_payload_prot = io_input_aw_payload_prot;
  assign io_input_w_ready = (((|(pendingSels & io_outputs_0_w_ready)) || (pendingError && errorSlave_io_axi_w_ready)) && allowData);
  assign errorSlave_io_axi_w_valid = ((io_input_w_valid && pendingError) && allowData);
  assign io_outputs_0_w_valid = ((io_input_w_valid && pendingSels[0]) && allowData);
  assign io_outputs_0_w_payload_data = io_input_w_payload_data;
  assign io_outputs_0_w_payload_strb = io_input_w_payload_strb;
  assign io_outputs_0_w_payload_last = io_input_w_payload_last;
  assign io_input_b_valid = ((|io_outputs_0_b_valid) || errorSlave_io_axi_b_valid);
  always @(*) begin
    io_input_b_payload_id = io_outputs_0_b_payload_id;
    if(pendingError) begin
      io_input_b_payload_id = errorSlave_io_axi_b_payload_id;
    end
  end

  always @(*) begin
    io_input_b_payload_resp = io_outputs_0_b_payload_resp;
    if(pendingError) begin
      io_input_b_payload_resp = errorSlave_io_axi_b_payload_resp;
    end
  end

  assign io_outputs_0_b_ready = io_input_b_ready;
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      pendingCmdCounter_value <= 3'b000;
      pendingDataCounter_value <= 3'b000;
      pendingSels <= 1'b0;
      pendingError <= 1'b0;
      _zz_cmdAllowedStart <= 1'b1;
    end else begin
      pendingCmdCounter_value <= pendingCmdCounter_valueNext;
      pendingDataCounter_value <= pendingDataCounter_valueNext;
      if(cmdAllowedStart) begin
        pendingSels <= decodedCmdSels;
      end
      if(cmdAllowedStart) begin
        pendingError <= decodedCmdError;
      end
      if(cmdAllowedStart) begin
        _zz_cmdAllowedStart <= 1'b0;
      end
      if(io_input_aw_ready) begin
        _zz_cmdAllowedStart <= 1'b1;
      end
    end
  end


endmodule

module Axi4ReadOnlyDecoder (
  input  wire          io_input_ar_valid,
  output wire          io_input_ar_ready,
  input  wire [31:0]   io_input_ar_payload_addr,
  input  wire [7:0]    io_input_ar_payload_id,
  input  wire [7:0]    io_input_ar_payload_len,
  input  wire [2:0]    io_input_ar_payload_size,
  input  wire [1:0]    io_input_ar_payload_burst,
  input  wire [0:0]    io_input_ar_payload_lock,
  input  wire [3:0]    io_input_ar_payload_cache,
  input  wire [2:0]    io_input_ar_payload_prot,
  output reg           io_input_r_valid,
  input  wire          io_input_r_ready,
  output wire [63:0]   io_input_r_payload_data,
  output reg  [7:0]    io_input_r_payload_id,
  output reg  [1:0]    io_input_r_payload_resp,
  output reg           io_input_r_payload_last,
  output wire          io_outputs_0_ar_valid,
  input  wire          io_outputs_0_ar_ready,
  output wire [31:0]   io_outputs_0_ar_payload_addr,
  output wire [7:0]    io_outputs_0_ar_payload_id,
  output wire [7:0]    io_outputs_0_ar_payload_len,
  output wire [2:0]    io_outputs_0_ar_payload_size,
  output wire [1:0]    io_outputs_0_ar_payload_burst,
  output wire [0:0]    io_outputs_0_ar_payload_lock,
  output wire [3:0]    io_outputs_0_ar_payload_cache,
  output wire [2:0]    io_outputs_0_ar_payload_prot,
  input  wire          io_outputs_0_r_valid,
  output wire          io_outputs_0_r_ready,
  input  wire [63:0]   io_outputs_0_r_payload_data,
  input  wire [7:0]    io_outputs_0_r_payload_id,
  input  wire [1:0]    io_outputs_0_r_payload_resp,
  input  wire          io_outputs_0_r_payload_last,
  input  wire          clk,
  input  wire          reset
);

  wire                errorSlave_io_axi_ar_valid;
  wire                errorSlave_io_axi_ar_ready;
  wire                errorSlave_io_axi_r_valid;
  wire       [63:0]   errorSlave_io_axi_r_payload_data;
  wire       [7:0]    errorSlave_io_axi_r_payload_id;
  wire       [1:0]    errorSlave_io_axi_r_payload_resp;
  wire                errorSlave_io_axi_r_payload_last;
  wire                io_input_ar_fire;
  wire                io_input_r_fire;
  wire                when_Utils_l697;
  reg                 pendingCmdCounter_incrementIt;
  reg                 pendingCmdCounter_decrementIt;
  wire       [2:0]    pendingCmdCounter_valueNext;
  reg        [2:0]    pendingCmdCounter_value;
  wire                pendingCmdCounter_mayOverflow;
  wire                pendingCmdCounter_willOverflowIfInc;
  wire                pendingCmdCounter_willOverflow;
  reg        [2:0]    pendingCmdCounter_finalIncrement;
  wire                when_Utils_l723;
  wire                when_Utils_l725;
  wire       [0:0]    decodedCmdSels;
  wire                decodedCmdError;
  reg        [0:0]    pendingSels;
  reg                 pendingError;
  wire                allowCmd;

  Axi4ReadOnlyErrorSlave_1 errorSlave (
    .io_axi_ar_valid         (errorSlave_io_axi_ar_valid            ), //i
    .io_axi_ar_ready         (errorSlave_io_axi_ar_ready            ), //o
    .io_axi_ar_payload_addr  (io_input_ar_payload_addr[31:0]        ), //i
    .io_axi_ar_payload_id    (io_input_ar_payload_id[7:0]           ), //i
    .io_axi_ar_payload_len   (io_input_ar_payload_len[7:0]          ), //i
    .io_axi_ar_payload_size  (io_input_ar_payload_size[2:0]         ), //i
    .io_axi_ar_payload_burst (io_input_ar_payload_burst[1:0]        ), //i
    .io_axi_ar_payload_lock  (io_input_ar_payload_lock              ), //i
    .io_axi_ar_payload_cache (io_input_ar_payload_cache[3:0]        ), //i
    .io_axi_ar_payload_prot  (io_input_ar_payload_prot[2:0]         ), //i
    .io_axi_r_valid          (errorSlave_io_axi_r_valid             ), //o
    .io_axi_r_ready          (io_input_r_ready                      ), //i
    .io_axi_r_payload_data   (errorSlave_io_axi_r_payload_data[63:0]), //o
    .io_axi_r_payload_id     (errorSlave_io_axi_r_payload_id[7:0]   ), //o
    .io_axi_r_payload_resp   (errorSlave_io_axi_r_payload_resp[1:0] ), //o
    .io_axi_r_payload_last   (errorSlave_io_axi_r_payload_last      ), //o
    .clk                     (clk                                   ), //i
    .reset                   (reset                                 )  //i
  );
  assign io_input_ar_fire = (io_input_ar_valid && io_input_ar_ready);
  assign io_input_r_fire = (io_input_r_valid && io_input_r_ready);
  assign when_Utils_l697 = (io_input_r_fire && io_input_r_payload_last);
  always @(*) begin
    pendingCmdCounter_incrementIt = 1'b0;
    if(io_input_ar_fire) begin
      pendingCmdCounter_incrementIt = 1'b1;
    end
  end

  always @(*) begin
    pendingCmdCounter_decrementIt = 1'b0;
    if(when_Utils_l697) begin
      pendingCmdCounter_decrementIt = 1'b1;
    end
  end

  assign pendingCmdCounter_mayOverflow = (pendingCmdCounter_value == 3'b111);
  assign pendingCmdCounter_willOverflowIfInc = (pendingCmdCounter_mayOverflow && (! pendingCmdCounter_decrementIt));
  assign pendingCmdCounter_willOverflow = (pendingCmdCounter_willOverflowIfInc && pendingCmdCounter_incrementIt);
  assign when_Utils_l723 = (pendingCmdCounter_incrementIt && (! pendingCmdCounter_decrementIt));
  always @(*) begin
    if(when_Utils_l723) begin
      pendingCmdCounter_finalIncrement = 3'b001;
    end else begin
      if(when_Utils_l725) begin
        pendingCmdCounter_finalIncrement = 3'b111;
      end else begin
        pendingCmdCounter_finalIncrement = 3'b000;
      end
    end
  end

  assign when_Utils_l725 = ((! pendingCmdCounter_incrementIt) && pendingCmdCounter_decrementIt);
  assign pendingCmdCounter_valueNext = (pendingCmdCounter_value + pendingCmdCounter_finalIncrement);
  assign decodedCmdSels = (((io_input_ar_payload_addr & (~ 32'h00000fff)) == 32'h00000000) && io_input_ar_valid);
  assign decodedCmdError = (decodedCmdSels == 1'b0);
  assign allowCmd = ((pendingCmdCounter_value == 3'b000) || ((pendingCmdCounter_value != 3'b111) && (pendingSels == decodedCmdSels)));
  assign io_input_ar_ready = (((|(decodedCmdSels & io_outputs_0_ar_ready)) || (decodedCmdError && errorSlave_io_axi_ar_ready)) && allowCmd);
  assign errorSlave_io_axi_ar_valid = ((io_input_ar_valid && decodedCmdError) && allowCmd);
  assign io_outputs_0_ar_valid = ((io_input_ar_valid && decodedCmdSels[0]) && allowCmd);
  assign io_outputs_0_ar_payload_addr = io_input_ar_payload_addr;
  assign io_outputs_0_ar_payload_id = io_input_ar_payload_id;
  assign io_outputs_0_ar_payload_len = io_input_ar_payload_len;
  assign io_outputs_0_ar_payload_size = io_input_ar_payload_size;
  assign io_outputs_0_ar_payload_burst = io_input_ar_payload_burst;
  assign io_outputs_0_ar_payload_lock = io_input_ar_payload_lock;
  assign io_outputs_0_ar_payload_cache = io_input_ar_payload_cache;
  assign io_outputs_0_ar_payload_prot = io_input_ar_payload_prot;
  always @(*) begin
    io_input_r_valid = (|io_outputs_0_r_valid);
    if(errorSlave_io_axi_r_valid) begin
      io_input_r_valid = 1'b1;
    end
  end

  assign io_input_r_payload_data = io_outputs_0_r_payload_data;
  always @(*) begin
    io_input_r_payload_id = io_outputs_0_r_payload_id;
    if(pendingError) begin
      io_input_r_payload_id = errorSlave_io_axi_r_payload_id;
    end
  end

  always @(*) begin
    io_input_r_payload_resp = io_outputs_0_r_payload_resp;
    if(pendingError) begin
      io_input_r_payload_resp = errorSlave_io_axi_r_payload_resp;
    end
  end

  always @(*) begin
    io_input_r_payload_last = io_outputs_0_r_payload_last;
    if(pendingError) begin
      io_input_r_payload_last = errorSlave_io_axi_r_payload_last;
    end
  end

  assign io_outputs_0_r_ready = io_input_r_ready;
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      pendingCmdCounter_value <= 3'b000;
      pendingSels <= 1'b0;
      pendingError <= 1'b0;
    end else begin
      pendingCmdCounter_value <= pendingCmdCounter_valueNext;
      if(io_input_ar_ready) begin
        pendingSels <= decodedCmdSels;
      end
      if(io_input_ar_ready) begin
        pendingError <= decodedCmdError;
      end
    end
  end


endmodule

module Axi4SharedOnChipRam (
  input  wire          io_axi_arw_valid,
  output reg           io_axi_arw_ready,
  input  wire [11:0]   io_axi_arw_payload_addr,
  input  wire [8:0]    io_axi_arw_payload_id,
  input  wire [7:0]    io_axi_arw_payload_len,
  input  wire [2:0]    io_axi_arw_payload_size,
  input  wire [1:0]    io_axi_arw_payload_burst,
  input  wire          io_axi_arw_payload_write,
  input  wire          io_axi_w_valid,
  output wire          io_axi_w_ready,
  input  wire [63:0]   io_axi_w_payload_data,
  input  wire [7:0]    io_axi_w_payload_strb,
  input  wire          io_axi_w_payload_last,
  output wire          io_axi_b_valid,
  input  wire          io_axi_b_ready,
  output wire [8:0]    io_axi_b_payload_id,
  output wire [1:0]    io_axi_b_payload_resp,
  output wire          io_axi_r_valid,
  input  wire          io_axi_r_ready,
  output wire [63:0]   io_axi_r_payload_data,
  output wire [8:0]    io_axi_r_payload_id,
  output wire [1:0]    io_axi_r_payload_resp,
  output wire          io_axi_r_payload_last,
  input  wire          clk,
  input  wire          reset
);

  reg        [63:0]   _zz_ram_port0;
  wire       [2:0]    _zz_Axi4Incr_alignMask;
  wire       [11:0]   _zz_Axi4Incr_baseIncr;
  wire       [2:0]    _zz_Axi4Incr_wrapCase_1;
  wire       [2:0]    _zz_Axi4Incr_wrapCase_2;
  reg        [11:0]   _zz_Axi4Incr_result;
  wire       [10:0]   _zz_Axi4Incr_result_1;
  wire       [0:0]    _zz_Axi4Incr_result_2;
  wire       [9:0]    _zz_Axi4Incr_result_3;
  wire       [1:0]    _zz_Axi4Incr_result_4;
  wire       [8:0]    _zz_Axi4Incr_result_5;
  wire       [2:0]    _zz_Axi4Incr_result_6;
  wire       [7:0]    _zz_Axi4Incr_result_7;
  wire       [3:0]    _zz_Axi4Incr_result_8;
  wire       [6:0]    _zz_Axi4Incr_result_9;
  wire       [4:0]    _zz_Axi4Incr_result_10;
  wire       [5:0]    _zz_Axi4Incr_result_11;
  wire       [5:0]    _zz_Axi4Incr_result_12;
  wire       [4:0]    _zz_Axi4Incr_result_13;
  wire       [6:0]    _zz_Axi4Incr_result_14;
  reg                 unburstify_result_valid;
  wire                unburstify_result_ready;
  reg                 unburstify_result_payload_last;
  reg        [11:0]   unburstify_result_payload_fragment_addr;
  reg        [8:0]    unburstify_result_payload_fragment_id;
  reg        [2:0]    unburstify_result_payload_fragment_size;
  reg        [1:0]    unburstify_result_payload_fragment_burst;
  reg                 unburstify_result_payload_fragment_write;
  wire                unburstify_doResult;
  reg                 unburstify_buffer_valid;
  reg        [7:0]    unburstify_buffer_len;
  reg        [7:0]    unburstify_buffer_beat;
  reg        [11:0]   unburstify_buffer_transaction_addr;
  reg        [8:0]    unburstify_buffer_transaction_id;
  reg        [2:0]    unburstify_buffer_transaction_size;
  reg        [1:0]    unburstify_buffer_transaction_burst;
  reg                 unburstify_buffer_transaction_write;
  wire                unburstify_buffer_last;
  wire       [1:0]    Axi4Incr_validSize;
  reg        [11:0]   Axi4Incr_result;
  wire       [3:0]    Axi4Incr_sizeValue;
  wire       [11:0]   Axi4Incr_alignMask;
  wire       [11:0]   Axi4Incr_base;
  wire       [11:0]   Axi4Incr_baseIncr;
  reg        [1:0]    _zz_Axi4Incr_wrapCase;
  wire       [2:0]    Axi4Incr_wrapCase;
  wire                when_Axi4Channel_l322;
  wire                _zz_unburstify_result_ready;
  wire                stage0_valid;
  reg                 stage0_ready;
  wire                stage0_payload_last;
  wire       [11:0]   stage0_payload_fragment_addr;
  wire       [8:0]    stage0_payload_fragment_id;
  wire       [2:0]    stage0_payload_fragment_size;
  wire       [1:0]    stage0_payload_fragment_burst;
  wire                stage0_payload_fragment_write;
  wire       [8:0]    _zz_io_axi_r_payload_data;
  wire                stage0_fire;
  wire       [63:0]   _zz_io_axi_r_payload_data_1;
  wire                stage1_valid;
  wire                stage1_ready;
  wire                stage1_payload_last;
  wire       [11:0]   stage1_payload_fragment_addr;
  wire       [8:0]    stage1_payload_fragment_id;
  wire       [2:0]    stage1_payload_fragment_size;
  wire       [1:0]    stage1_payload_fragment_burst;
  wire                stage1_payload_fragment_write;
  reg                 stage0_rValid;
  reg                 stage0_rData_last;
  reg        [11:0]   stage0_rData_fragment_addr;
  reg        [8:0]    stage0_rData_fragment_id;
  reg        [2:0]    stage0_rData_fragment_size;
  reg        [1:0]    stage0_rData_fragment_burst;
  reg                 stage0_rData_fragment_write;
  wire                when_Stream_l369;
  reg [7:0] ram_symbol0 [0:511];
  reg [7:0] ram_symbol1 [0:511];
  reg [7:0] ram_symbol2 [0:511];
  reg [7:0] ram_symbol3 [0:511];
  reg [7:0] ram_symbol4 [0:511];
  reg [7:0] ram_symbol5 [0:511];
  reg [7:0] ram_symbol6 [0:511];
  reg [7:0] ram_symbol7 [0:511];
  reg [7:0] _zz_ramsymbol_read;
  reg [7:0] _zz_ramsymbol_read_1;
  reg [7:0] _zz_ramsymbol_read_2;
  reg [7:0] _zz_ramsymbol_read_3;
  reg [7:0] _zz_ramsymbol_read_4;
  reg [7:0] _zz_ramsymbol_read_5;
  reg [7:0] _zz_ramsymbol_read_6;
  reg [7:0] _zz_ramsymbol_read_7;

  assign _zz_Axi4Incr_alignMask = {(2'b10 < Axi4Incr_validSize),{(2'b01 < Axi4Incr_validSize),(2'b00 < Axi4Incr_validSize)}};
  assign _zz_Axi4Incr_baseIncr = {8'd0, Axi4Incr_sizeValue};
  assign _zz_Axi4Incr_wrapCase_1 = {1'd0, Axi4Incr_validSize};
  assign _zz_Axi4Incr_wrapCase_2 = {1'd0, _zz_Axi4Incr_wrapCase};
  assign _zz_Axi4Incr_result_1 = Axi4Incr_base[11 : 1];
  assign _zz_Axi4Incr_result_2 = Axi4Incr_baseIncr[0 : 0];
  assign _zz_Axi4Incr_result_3 = Axi4Incr_base[11 : 2];
  assign _zz_Axi4Incr_result_4 = Axi4Incr_baseIncr[1 : 0];
  assign _zz_Axi4Incr_result_5 = Axi4Incr_base[11 : 3];
  assign _zz_Axi4Incr_result_6 = Axi4Incr_baseIncr[2 : 0];
  assign _zz_Axi4Incr_result_7 = Axi4Incr_base[11 : 4];
  assign _zz_Axi4Incr_result_8 = Axi4Incr_baseIncr[3 : 0];
  assign _zz_Axi4Incr_result_9 = Axi4Incr_base[11 : 5];
  assign _zz_Axi4Incr_result_10 = Axi4Incr_baseIncr[4 : 0];
  assign _zz_Axi4Incr_result_11 = Axi4Incr_base[11 : 6];
  assign _zz_Axi4Incr_result_12 = Axi4Incr_baseIncr[5 : 0];
  assign _zz_Axi4Incr_result_13 = Axi4Incr_base[11 : 7];
  assign _zz_Axi4Incr_result_14 = Axi4Incr_baseIncr[6 : 0];
  always @(*) begin
    _zz_ram_port0 = {_zz_ramsymbol_read_7, _zz_ramsymbol_read_6, _zz_ramsymbol_read_5, _zz_ramsymbol_read_4, _zz_ramsymbol_read_3, _zz_ramsymbol_read_2, _zz_ramsymbol_read_1, _zz_ramsymbol_read};
  end
  always @(posedge clk) begin
    if(stage0_fire) begin
      _zz_ramsymbol_read <= ram_symbol0[_zz_io_axi_r_payload_data];
      _zz_ramsymbol_read_1 <= ram_symbol1[_zz_io_axi_r_payload_data];
      _zz_ramsymbol_read_2 <= ram_symbol2[_zz_io_axi_r_payload_data];
      _zz_ramsymbol_read_3 <= ram_symbol3[_zz_io_axi_r_payload_data];
      _zz_ramsymbol_read_4 <= ram_symbol4[_zz_io_axi_r_payload_data];
      _zz_ramsymbol_read_5 <= ram_symbol5[_zz_io_axi_r_payload_data];
      _zz_ramsymbol_read_6 <= ram_symbol6[_zz_io_axi_r_payload_data];
      _zz_ramsymbol_read_7 <= ram_symbol7[_zz_io_axi_r_payload_data];
    end
  end

  always @(posedge clk) begin
    if(io_axi_w_payload_strb[0] && stage0_fire && stage0_payload_fragment_write ) begin
      ram_symbol0[_zz_io_axi_r_payload_data] <= _zz_io_axi_r_payload_data_1[7 : 0];
    end
    if(io_axi_w_payload_strb[1] && stage0_fire && stage0_payload_fragment_write ) begin
      ram_symbol1[_zz_io_axi_r_payload_data] <= _zz_io_axi_r_payload_data_1[15 : 8];
    end
    if(io_axi_w_payload_strb[2] && stage0_fire && stage0_payload_fragment_write ) begin
      ram_symbol2[_zz_io_axi_r_payload_data] <= _zz_io_axi_r_payload_data_1[23 : 16];
    end
    if(io_axi_w_payload_strb[3] && stage0_fire && stage0_payload_fragment_write ) begin
      ram_symbol3[_zz_io_axi_r_payload_data] <= _zz_io_axi_r_payload_data_1[31 : 24];
    end
    if(io_axi_w_payload_strb[4] && stage0_fire && stage0_payload_fragment_write ) begin
      ram_symbol4[_zz_io_axi_r_payload_data] <= _zz_io_axi_r_payload_data_1[39 : 32];
    end
    if(io_axi_w_payload_strb[5] && stage0_fire && stage0_payload_fragment_write ) begin
      ram_symbol5[_zz_io_axi_r_payload_data] <= _zz_io_axi_r_payload_data_1[47 : 40];
    end
    if(io_axi_w_payload_strb[6] && stage0_fire && stage0_payload_fragment_write ) begin
      ram_symbol6[_zz_io_axi_r_payload_data] <= _zz_io_axi_r_payload_data_1[55 : 48];
    end
    if(io_axi_w_payload_strb[7] && stage0_fire && stage0_payload_fragment_write ) begin
      ram_symbol7[_zz_io_axi_r_payload_data] <= _zz_io_axi_r_payload_data_1[63 : 56];
    end
  end

  always @(*) begin
    case(Axi4Incr_wrapCase)
      3'b000 : _zz_Axi4Incr_result = {_zz_Axi4Incr_result_1,_zz_Axi4Incr_result_2};
      3'b001 : _zz_Axi4Incr_result = {_zz_Axi4Incr_result_3,_zz_Axi4Incr_result_4};
      3'b010 : _zz_Axi4Incr_result = {_zz_Axi4Incr_result_5,_zz_Axi4Incr_result_6};
      3'b011 : _zz_Axi4Incr_result = {_zz_Axi4Incr_result_7,_zz_Axi4Incr_result_8};
      3'b100 : _zz_Axi4Incr_result = {_zz_Axi4Incr_result_9,_zz_Axi4Incr_result_10};
      3'b101 : _zz_Axi4Incr_result = {_zz_Axi4Incr_result_11,_zz_Axi4Incr_result_12};
      default : _zz_Axi4Incr_result = {_zz_Axi4Incr_result_13,_zz_Axi4Incr_result_14};
    endcase
  end

  assign unburstify_buffer_last = (unburstify_buffer_beat == 8'h01);
  assign Axi4Incr_validSize = unburstify_buffer_transaction_size[1 : 0];
  assign Axi4Incr_sizeValue = {(2'b11 == Axi4Incr_validSize),{(2'b10 == Axi4Incr_validSize),{(2'b01 == Axi4Incr_validSize),(2'b00 == Axi4Incr_validSize)}}};
  assign Axi4Incr_alignMask = {9'd0, _zz_Axi4Incr_alignMask};
  assign Axi4Incr_base = (unburstify_buffer_transaction_addr[11 : 0] & (~ Axi4Incr_alignMask));
  assign Axi4Incr_baseIncr = (Axi4Incr_base + _zz_Axi4Incr_baseIncr);
  always @(*) begin
    casez(unburstify_buffer_len)
      8'b????1??? : begin
        _zz_Axi4Incr_wrapCase = 2'b11;
      end
      8'b????01?? : begin
        _zz_Axi4Incr_wrapCase = 2'b10;
      end
      8'b????001? : begin
        _zz_Axi4Incr_wrapCase = 2'b01;
      end
      default : begin
        _zz_Axi4Incr_wrapCase = 2'b00;
      end
    endcase
  end

  assign Axi4Incr_wrapCase = (_zz_Axi4Incr_wrapCase_1 + _zz_Axi4Incr_wrapCase_2);
  always @(*) begin
    case(unburstify_buffer_transaction_burst)
      2'b00 : begin
        Axi4Incr_result = unburstify_buffer_transaction_addr;
      end
      2'b10 : begin
        Axi4Incr_result = _zz_Axi4Incr_result;
      end
      default : begin
        Axi4Incr_result = Axi4Incr_baseIncr;
      end
    endcase
  end

  always @(*) begin
    io_axi_arw_ready = 1'b0;
    if(!unburstify_buffer_valid) begin
      io_axi_arw_ready = unburstify_result_ready;
    end
  end

  always @(*) begin
    if(unburstify_buffer_valid) begin
      unburstify_result_valid = 1'b1;
    end else begin
      unburstify_result_valid = io_axi_arw_valid;
    end
  end

  always @(*) begin
    if(unburstify_buffer_valid) begin
      unburstify_result_payload_last = unburstify_buffer_last;
    end else begin
      unburstify_result_payload_last = 1'b1;
      if(when_Axi4Channel_l322) begin
        unburstify_result_payload_last = 1'b0;
      end
    end
  end

  always @(*) begin
    if(unburstify_buffer_valid) begin
      unburstify_result_payload_fragment_id = unburstify_buffer_transaction_id;
    end else begin
      unburstify_result_payload_fragment_id = io_axi_arw_payload_id;
    end
  end

  always @(*) begin
    if(unburstify_buffer_valid) begin
      unburstify_result_payload_fragment_size = unburstify_buffer_transaction_size;
    end else begin
      unburstify_result_payload_fragment_size = io_axi_arw_payload_size;
    end
  end

  always @(*) begin
    if(unburstify_buffer_valid) begin
      unburstify_result_payload_fragment_burst = unburstify_buffer_transaction_burst;
    end else begin
      unburstify_result_payload_fragment_burst = io_axi_arw_payload_burst;
    end
  end

  always @(*) begin
    if(unburstify_buffer_valid) begin
      unburstify_result_payload_fragment_write = unburstify_buffer_transaction_write;
    end else begin
      unburstify_result_payload_fragment_write = io_axi_arw_payload_write;
    end
  end

  always @(*) begin
    if(unburstify_buffer_valid) begin
      unburstify_result_payload_fragment_addr = Axi4Incr_result;
    end else begin
      unburstify_result_payload_fragment_addr = io_axi_arw_payload_addr;
    end
  end

  assign when_Axi4Channel_l322 = (io_axi_arw_payload_len != 8'h00);
  assign _zz_unburstify_result_ready = (! (unburstify_result_payload_fragment_write && (! io_axi_w_valid)));
  assign stage0_valid = (unburstify_result_valid && _zz_unburstify_result_ready);
  assign unburstify_result_ready = (stage0_ready && _zz_unburstify_result_ready);
  assign stage0_payload_last = unburstify_result_payload_last;
  assign stage0_payload_fragment_addr = unburstify_result_payload_fragment_addr;
  assign stage0_payload_fragment_id = unburstify_result_payload_fragment_id;
  assign stage0_payload_fragment_size = unburstify_result_payload_fragment_size;
  assign stage0_payload_fragment_burst = unburstify_result_payload_fragment_burst;
  assign stage0_payload_fragment_write = unburstify_result_payload_fragment_write;
  assign _zz_io_axi_r_payload_data = stage0_payload_fragment_addr[11 : 3];
  assign stage0_fire = (stage0_valid && stage0_ready);
  assign _zz_io_axi_r_payload_data_1 = io_axi_w_payload_data;
  assign io_axi_r_payload_data = _zz_ram_port0;
  assign io_axi_w_ready = ((unburstify_result_valid && unburstify_result_payload_fragment_write) && stage0_ready);
  always @(*) begin
    stage0_ready = stage1_ready;
    if(when_Stream_l369) begin
      stage0_ready = 1'b1;
    end
  end

  assign when_Stream_l369 = (! stage1_valid);
  assign stage1_valid = stage0_rValid;
  assign stage1_payload_last = stage0_rData_last;
  assign stage1_payload_fragment_addr = stage0_rData_fragment_addr;
  assign stage1_payload_fragment_id = stage0_rData_fragment_id;
  assign stage1_payload_fragment_size = stage0_rData_fragment_size;
  assign stage1_payload_fragment_burst = stage0_rData_fragment_burst;
  assign stage1_payload_fragment_write = stage0_rData_fragment_write;
  assign stage1_ready = ((io_axi_r_ready && (! stage1_payload_fragment_write)) || ((io_axi_b_ready || (! stage1_payload_last)) && stage1_payload_fragment_write));
  assign io_axi_r_valid = (stage1_valid && (! stage1_payload_fragment_write));
  assign io_axi_r_payload_id = stage1_payload_fragment_id;
  assign io_axi_r_payload_last = stage1_payload_last;
  assign io_axi_r_payload_resp = 2'b00;
  assign io_axi_b_valid = ((stage1_valid && stage1_payload_fragment_write) && stage1_payload_last);
  assign io_axi_b_payload_resp = 2'b00;
  assign io_axi_b_payload_id = stage1_payload_fragment_id;
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      unburstify_buffer_valid <= 1'b0;
      stage0_rValid <= 1'b0;
    end else begin
      if(unburstify_result_ready) begin
        if(unburstify_buffer_last) begin
          unburstify_buffer_valid <= 1'b0;
        end
      end
      if(!unburstify_buffer_valid) begin
        if(when_Axi4Channel_l322) begin
          if(unburstify_result_ready) begin
            unburstify_buffer_valid <= io_axi_arw_valid;
          end
        end
      end
      if(stage0_ready) begin
        stage0_rValid <= stage0_valid;
      end
    end
  end

  always @(posedge clk) begin
    if(unburstify_result_ready) begin
      unburstify_buffer_beat <= (unburstify_buffer_beat - 8'h01);
      unburstify_buffer_transaction_addr[11 : 0] <= Axi4Incr_result[11 : 0];
    end
    if(!unburstify_buffer_valid) begin
      if(when_Axi4Channel_l322) begin
        if(unburstify_result_ready) begin
          unburstify_buffer_transaction_addr <= io_axi_arw_payload_addr;
          unburstify_buffer_transaction_id <= io_axi_arw_payload_id;
          unburstify_buffer_transaction_size <= io_axi_arw_payload_size;
          unburstify_buffer_transaction_burst <= io_axi_arw_payload_burst;
          unburstify_buffer_transaction_write <= io_axi_arw_payload_write;
          unburstify_buffer_beat <= io_axi_arw_payload_len;
          unburstify_buffer_len <= io_axi_arw_payload_len;
        end
      end
    end
    if(stage0_ready) begin
      stage0_rData_last <= stage0_payload_last;
      stage0_rData_fragment_addr <= stage0_payload_fragment_addr;
      stage0_rData_fragment_id <= stage0_payload_fragment_id;
      stage0_rData_fragment_size <= stage0_payload_fragment_size;
      stage0_rData_fragment_burst <= stage0_payload_fragment_burst;
      stage0_rData_fragment_write <= stage0_payload_fragment_write;
    end
  end


endmodule

module WishboneInterconComponent (
  input  wire          io_busMasters_0_CYC,
  input  wire          io_busMasters_0_STB,
  output wire          io_busMasters_0_ACK,
  input  wire          io_busMasters_0_WE,
  input  wire [27:0]   io_busMasters_0_ADR,
  output wire [31:0]   io_busMasters_0_DAT_MISO,
  input  wire [31:0]   io_busMasters_0_DAT_MOSI,
  input  wire [3:0]    io_busMasters_0_SEL,
  output wire          io_busSlaves_0_CYC,
  output wire          io_busSlaves_0_STB,
  input  wire          io_busSlaves_0_ACK,
  output wire          io_busSlaves_0_WE,
  output wire [27:0]   io_busSlaves_0_ADR,
  input  wire [31:0]   io_busSlaves_0_DAT_MISO,
  output wire [31:0]   io_busSlaves_0_DAT_MOSI,
  output wire [3:0]    io_busSlaves_0_SEL,
  output wire          io_busSlaves_1_CYC,
  output wire          io_busSlaves_1_STB,
  input  wire          io_busSlaves_1_ACK,
  output wire          io_busSlaves_1_WE,
  output wire [27:0]   io_busSlaves_1_ADR,
  input  wire [31:0]   io_busSlaves_1_DAT_MISO,
  output wire [31:0]   io_busSlaves_1_DAT_MOSI,
  output wire [3:0]    io_busSlaves_1_SEL
);

  wire       [31:0]   io_busMasters_0_decoder_io_input_DAT_MISO;
  wire                io_busMasters_0_decoder_io_input_ACK;
  wire       [31:0]   io_busMasters_0_decoder_io_outputs_0_DAT_MOSI;
  wire       [27:0]   io_busMasters_0_decoder_io_outputs_0_ADR;
  wire                io_busMasters_0_decoder_io_outputs_0_CYC;
  wire       [3:0]    io_busMasters_0_decoder_io_outputs_0_SEL;
  wire                io_busMasters_0_decoder_io_outputs_0_STB;
  wire                io_busMasters_0_decoder_io_outputs_0_WE;
  wire       [31:0]   io_busMasters_0_decoder_io_outputs_1_DAT_MOSI;
  wire       [27:0]   io_busMasters_0_decoder_io_outputs_1_ADR;
  wire                io_busMasters_0_decoder_io_outputs_1_CYC;
  wire       [3:0]    io_busMasters_0_decoder_io_outputs_1_SEL;
  wire                io_busMasters_0_decoder_io_outputs_1_STB;
  wire                io_busMasters_0_decoder_io_outputs_1_WE;

  WishboneDecoder io_busMasters_0_decoder (
    .io_input_CYC          (io_busMasters_0_CYC                                ), //i
    .io_input_STB          (io_busMasters_0_STB                                ), //i
    .io_input_ACK          (io_busMasters_0_decoder_io_input_ACK               ), //o
    .io_input_WE           (io_busMasters_0_WE                                 ), //i
    .io_input_ADR          (io_busMasters_0_ADR[27:0]                          ), //i
    .io_input_DAT_MISO     (io_busMasters_0_decoder_io_input_DAT_MISO[31:0]    ), //o
    .io_input_DAT_MOSI     (io_busMasters_0_DAT_MOSI[31:0]                     ), //i
    .io_input_SEL          (io_busMasters_0_SEL[3:0]                           ), //i
    .io_outputs_0_CYC      (io_busMasters_0_decoder_io_outputs_0_CYC           ), //o
    .io_outputs_0_STB      (io_busMasters_0_decoder_io_outputs_0_STB           ), //o
    .io_outputs_0_ACK      (io_busSlaves_0_ACK                                 ), //i
    .io_outputs_0_WE       (io_busMasters_0_decoder_io_outputs_0_WE            ), //o
    .io_outputs_0_ADR      (io_busMasters_0_decoder_io_outputs_0_ADR[27:0]     ), //o
    .io_outputs_0_DAT_MISO (io_busSlaves_0_DAT_MISO[31:0]                      ), //i
    .io_outputs_0_DAT_MOSI (io_busMasters_0_decoder_io_outputs_0_DAT_MOSI[31:0]), //o
    .io_outputs_0_SEL      (io_busMasters_0_decoder_io_outputs_0_SEL[3:0]      ), //o
    .io_outputs_1_CYC      (io_busMasters_0_decoder_io_outputs_1_CYC           ), //o
    .io_outputs_1_STB      (io_busMasters_0_decoder_io_outputs_1_STB           ), //o
    .io_outputs_1_ACK      (io_busSlaves_1_ACK                                 ), //i
    .io_outputs_1_WE       (io_busMasters_0_decoder_io_outputs_1_WE            ), //o
    .io_outputs_1_ADR      (io_busMasters_0_decoder_io_outputs_1_ADR[27:0]     ), //o
    .io_outputs_1_DAT_MISO (io_busSlaves_1_DAT_MISO[31:0]                      ), //i
    .io_outputs_1_DAT_MOSI (io_busMasters_0_decoder_io_outputs_1_DAT_MOSI[31:0]), //o
    .io_outputs_1_SEL      (io_busMasters_0_decoder_io_outputs_1_SEL[3:0]      )  //o
  );
  assign io_busMasters_0_DAT_MISO = io_busMasters_0_decoder_io_input_DAT_MISO;
  assign io_busMasters_0_ACK = io_busMasters_0_decoder_io_input_ACK;
  assign io_busSlaves_0_CYC = io_busMasters_0_decoder_io_outputs_0_CYC;
  assign io_busSlaves_0_ADR = io_busMasters_0_decoder_io_outputs_0_ADR;
  assign io_busSlaves_0_DAT_MOSI = io_busMasters_0_decoder_io_outputs_0_DAT_MOSI;
  assign io_busSlaves_0_STB = io_busMasters_0_decoder_io_outputs_0_STB;
  assign io_busSlaves_0_WE = io_busMasters_0_decoder_io_outputs_0_WE;
  assign io_busSlaves_0_SEL = io_busMasters_0_decoder_io_outputs_0_SEL;
  assign io_busSlaves_1_CYC = io_busMasters_0_decoder_io_outputs_1_CYC;
  assign io_busSlaves_1_ADR = io_busMasters_0_decoder_io_outputs_1_ADR;
  assign io_busSlaves_1_DAT_MOSI = io_busMasters_0_decoder_io_outputs_1_DAT_MOSI;
  assign io_busSlaves_1_STB = io_busMasters_0_decoder_io_outputs_1_STB;
  assign io_busSlaves_1_WE = io_busMasters_0_decoder_io_outputs_1_WE;
  assign io_busSlaves_1_SEL = io_busMasters_0_decoder_io_outputs_1_SEL;

endmodule

module Wb2Axi4 (
  input  wire          io_wb_CYC,
  input  wire          io_wb_STB,
  output reg           io_wb_ACK,
  input  wire          io_wb_WE,
  input  wire [27:0]   io_wb_ADR,
  output wire [31:0]   io_wb_DAT_MISO,
  input  wire [31:0]   io_wb_DAT_MOSI,
  input  wire [3:0]    io_wb_SEL,
  output reg           io_axi_aw_valid,
  input  wire          io_axi_aw_ready,
  output wire [31:0]   io_axi_aw_payload_addr,
  output wire [7:0]    io_axi_aw_payload_id,
  output wire [7:0]    io_axi_aw_payload_len,
  output wire [2:0]    io_axi_aw_payload_size,
  output wire [1:0]    io_axi_aw_payload_burst,
  output wire [0:0]    io_axi_aw_payload_lock,
  output wire [3:0]    io_axi_aw_payload_cache,
  output wire [2:0]    io_axi_aw_payload_prot,
  output reg           io_axi_w_valid,
  input  wire          io_axi_w_ready,
  output wire [63:0]   io_axi_w_payload_data,
  output wire [7:0]    io_axi_w_payload_strb,
  output wire          io_axi_w_payload_last,
  input  wire          io_axi_b_valid,
  output reg           io_axi_b_ready,
  input  wire [7:0]    io_axi_b_payload_id,
  input  wire [1:0]    io_axi_b_payload_resp,
  output reg           io_axi_ar_valid,
  input  wire          io_axi_ar_ready,
  output wire [31:0]   io_axi_ar_payload_addr,
  output wire [7:0]    io_axi_ar_payload_id,
  output wire [7:0]    io_axi_ar_payload_len,
  output wire [2:0]    io_axi_ar_payload_size,
  output wire [1:0]    io_axi_ar_payload_burst,
  output wire [0:0]    io_axi_ar_payload_lock,
  output wire [3:0]    io_axi_ar_payload_cache,
  output wire [2:0]    io_axi_ar_payload_prot,
  input  wire          io_axi_r_valid,
  output wire          io_axi_r_ready,
  input  wire [63:0]   io_axi_r_payload_data,
  input  wire [7:0]    io_axi_r_payload_id,
  input  wire [1:0]    io_axi_r_payload_resp,
  input  wire          io_axi_r_payload_last,
  input  wire          clk,
  input  wire          reset
);
  localparam data_state_S_IDLE = 2'd0;
  localparam data_state_S_WAIT_RD = 2'd1;
  localparam data_state_S_SEND_WR = 2'd2;
  localparam data_state_S_WAIT_BSEND = 2'd3;
  localparam adr_state_A_IDLE = 1'd0;
  localparam adr_state_A_WAIT = 1'd1;

  wire       [10:0]   _zz_io_axi_aw_payload_addr;
  wire       [63:0]   _zz_io_axi_w_payload_data;
  wire       [63:0]   _zz_io_axi_w_payload_data_1;
  wire       [7:0]    _zz_io_axi_w_payload_strb;
  wire       [7:0]    _zz_io_axi_w_payload_strb_1;
  wire       [10:0]   _zz_io_axi_ar_payload_addr;
  wire                odd_addr;
  wire                valid;
  reg        [1:0]    n_state;
  reg        [0:0]    addr_state;
  wire                when_Wb2Axi4_l82;
  wire                when_Wb2Axi4_l87;
  wire                when_Wb2Axi4_l96;
  wire                when_Wb2Axi4_l99;
  wire                when_Wb2Axi4_l118;
  wire                when_Wb2Axi4_l125;
  wire                when_Wb2Axi4_l127;
  wire                when_Wb2Axi4_l129;
  `ifndef SYNTHESIS
  reg [95:0] n_state_string;
  reg [47:0] addr_state_string;
  `endif


  assign _zz_io_axi_aw_payload_addr = io_wb_ADR[10 : 0];
  assign _zz_io_axi_w_payload_data = {32'd0, io_wb_DAT_MOSI};
  assign _zz_io_axi_w_payload_data_1 = ({32'd0,io_wb_DAT_MOSI} <<< 6'd32);
  assign _zz_io_axi_w_payload_strb = {4'd0, io_wb_SEL};
  assign _zz_io_axi_w_payload_strb_1 = ({4'd0,io_wb_SEL} <<< 3'd4);
  assign _zz_io_axi_ar_payload_addr = io_wb_ADR[10 : 0];
  `ifndef SYNTHESIS
  always @(*) begin
    case(n_state)
      data_state_S_IDLE : n_state_string = "S_IDLE      ";
      data_state_S_WAIT_RD : n_state_string = "S_WAIT_RD   ";
      data_state_S_SEND_WR : n_state_string = "S_SEND_WR   ";
      data_state_S_WAIT_BSEND : n_state_string = "S_WAIT_BSEND";
      default : n_state_string = "????????????";
    endcase
  end
  always @(*) begin
    case(addr_state)
      adr_state_A_IDLE : addr_state_string = "A_IDLE";
      adr_state_A_WAIT : addr_state_string = "A_WAIT";
      default : addr_state_string = "??????";
    endcase
  end
  `endif

  always @(*) begin
    io_axi_aw_valid = 1'b0;
    if(when_Wb2Axi4_l118) begin
      if(valid) begin
        io_axi_aw_valid = io_wb_WE;
      end
    end
  end

  always @(*) begin
    io_axi_w_valid = 1'b0;
    if(when_Wb2Axi4_l125) begin
      io_axi_w_valid = (valid && io_wb_WE);
    end
  end

  always @(*) begin
    io_axi_b_ready = 1'b1;
    if(!when_Wb2Axi4_l125) begin
      if(!when_Wb2Axi4_l127) begin
        if(when_Wb2Axi4_l129) begin
          io_axi_b_ready = 1'b1;
        end
      end
    end
  end

  always @(*) begin
    io_axi_ar_valid = 1'b0;
    if(when_Wb2Axi4_l118) begin
      if(valid) begin
        io_axi_ar_valid = (! io_wb_WE);
      end
    end
  end

  assign io_axi_r_ready = 1'b1;
  always @(*) begin
    io_wb_ACK = 1'b0;
    if(!when_Wb2Axi4_l125) begin
      if(when_Wb2Axi4_l127) begin
        io_wb_ACK = io_axi_r_valid;
      end else begin
        if(when_Wb2Axi4_l129) begin
          io_wb_ACK = io_axi_b_valid;
        end
      end
    end
  end

  assign odd_addr = io_wb_ADR[2];
  assign io_axi_aw_payload_id = 8'h00;
  assign io_axi_aw_payload_len = 8'h00;
  assign io_axi_aw_payload_size = 3'b011;
  assign io_axi_aw_payload_burst = 2'b00;
  assign io_axi_aw_payload_lock = 1'b0;
  assign io_axi_aw_payload_cache = 4'b0011;
  assign io_axi_aw_payload_prot = 3'b010;
  assign io_axi_ar_payload_lock = 1'b0;
  assign io_axi_ar_payload_id = 8'h01;
  assign io_axi_ar_payload_len = 8'h00;
  assign io_axi_ar_payload_size = 3'b011;
  assign io_axi_ar_payload_burst = 2'b00;
  assign io_axi_ar_payload_cache = 4'b0011;
  assign io_axi_ar_payload_prot = 3'b010;
  assign io_axi_w_payload_last = io_axi_w_valid;
  assign valid = (io_wb_CYC && io_wb_STB);
  assign when_Wb2Axi4_l82 = (valid && ((io_wb_WE && io_axi_aw_ready) || ((! io_wb_WE) && io_axi_ar_ready)));
  assign when_Wb2Axi4_l87 = ((io_wb_WE && io_axi_b_valid) || ((! io_wb_WE) && io_axi_r_valid));
  assign when_Wb2Axi4_l96 = (io_wb_WE && io_axi_w_ready);
  assign when_Wb2Axi4_l99 = (! io_wb_WE);
  assign when_Wb2Axi4_l118 = (addr_state == adr_state_A_IDLE);
  assign when_Wb2Axi4_l125 = (n_state == data_state_S_IDLE);
  assign when_Wb2Axi4_l127 = (n_state == data_state_S_WAIT_RD);
  assign when_Wb2Axi4_l129 = (n_state == data_state_S_WAIT_BSEND);
  assign io_axi_aw_payload_addr = {21'd0, _zz_io_axi_aw_payload_addr};
  assign io_axi_w_payload_data = ((! odd_addr) ? _zz_io_axi_w_payload_data : _zz_io_axi_w_payload_data_1);
  assign io_axi_w_payload_strb = ((! odd_addr) ? _zz_io_axi_w_payload_strb : _zz_io_axi_w_payload_strb_1);
  assign io_axi_ar_payload_addr = {21'd0, _zz_io_axi_ar_payload_addr};
  assign io_wb_DAT_MISO = (odd_addr ? io_axi_r_payload_data[63 : 32] : io_axi_r_payload_data[31 : 0]);
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      n_state <= data_state_S_IDLE;
      addr_state <= adr_state_A_IDLE;
    end else begin
      case(addr_state)
        adr_state_A_IDLE : begin
          if(when_Wb2Axi4_l82) begin
            addr_state <= adr_state_A_WAIT;
          end
        end
        default : begin
          if(when_Wb2Axi4_l87) begin
            addr_state <= adr_state_A_IDLE;
          end
        end
      endcase
      case(n_state)
        data_state_S_IDLE : begin
          if(valid) begin
            if(when_Wb2Axi4_l96) begin
              n_state <= data_state_S_WAIT_BSEND;
            end else begin
              if(when_Wb2Axi4_l99) begin
                n_state <= data_state_S_WAIT_RD;
              end
            end
          end
        end
        data_state_S_WAIT_RD : begin
          if(io_axi_r_valid) begin
            n_state <= data_state_S_IDLE;
          end
        end
        data_state_S_WAIT_BSEND : begin
          if(io_axi_b_valid) begin
            n_state <= data_state_S_IDLE;
          end
        end
        default : begin
        end
      endcase
    end
  end


endmodule

module USB23Wrapper (
  inout  wire [0:0]    io_usbIO_VBUS,
  input  wire [0:0]    io_usbIO_REFINCLKEXTP,
  input  wire [0:0]    io_usbIO_REFINCLKEXTM,
  inout  wire [0:0]    io_usbIO_RESEXTUSB2,
  inout  wire [0:0]    io_usbIO_DP,
  inout  wire [0:0]    io_usbIO_DM,
  input  wire [0:0]    io_usbIO_RXM,
  input  wire [0:0]    io_usbIO_RXP,
  output wire [0:0]    io_usbIO_TXM,
  output wire [0:0]    io_usbIO_TXP,
  input  wire          io_clk_60m,
  output wire          io_irq,
  output wire          axi_awvalid,
  input  wire          axi_awready,
  output wire [31:0]   axi_awaddr,
  output wire [7:0]    axi_awid,
  output wire [7:0]    axi_awlen,
  output wire [2:0]    axi_awsize,
  output wire [1:0]    axi_awburst,
  output wire [0:0]    axi_awlock,
  output wire [3:0]    axi_awcache,
  output wire [2:0]    axi_awprot,
  output wire          axi_wvalid,
  input  wire          axi_wready,
  output wire [63:0]   axi_wdata,
  output wire [7:0]    axi_wstrb,
  output wire          axi_wlast,
  input  wire          axi_bvalid,
  output wire          axi_bready,
  input  wire [7:0]    axi_bid,
  input  wire [1:0]    axi_bresp,
  output wire          axi_arvalid,
  input  wire          axi_arready,
  output wire [31:0]   axi_araddr,
  output wire [7:0]    axi_arid,
  output wire [7:0]    axi_arlen,
  output wire [2:0]    axi_arsize,
  output wire [1:0]    axi_arburst,
  output wire [0:0]    axi_arlock,
  output wire [3:0]    axi_arcache,
  output wire [2:0]    axi_arprot,
  input  wire          axi_rvalid,
  output wire          axi_rready,
  input  wire [63:0]   axi_rdata,
  input  wire [7:0]    axi_rid,
  input  wire [1:0]    axi_rresp,
  input  wire          axi_rlast,
  input  wire          io_wb_CYC,
  input  wire          io_wb_STB,
  output reg           io_wb_ACK,
  input  wire          io_wb_WE,
  input  wire [27:0]   io_wb_ADR,
  output reg  [31:0]   io_wb_DAT_MISO,
  input  wire [31:0]   io_wb_DAT_MOSI,
  input  wire [3:0]    io_wb_SEL,
  input  wire          clk,
  input  wire          reset
);
  localparam LmmiState_IDLE = 2'd0;
  localparam LmmiState_READ = 2'd1;
  localparam LmmiState_WRITE = 2'd2;

  wire                usbCore_XOIN18;
  wire                usbCore_XMCSYSREQ;
  wire                usbCore_ID;
  wire                usbCore_STARTRXDETU3RXDET;
  wire                usbCore_DISRXDETU3RXDET;
  wire                usbCore_SS_RX_ACJT_EN;
  wire                usbCore_SS_RX_ACJT_ININ;
  wire                usbCore_SS_RX_ACJT_INIP;
  wire                usbCore_SS_RX_ACJT_INIT_EN;
  wire                usbCore_SS_RX_ACJT_MODE;
  wire                usbCore_SS_TX_ACJT_DRVEN;
  wire                usbCore_SS_TX_ACJT_DATAIN;
  wire                usbCore_SS_TX_ACJT_HIGHZ;
  wire                usbCore_SCANEN_CTRL;
  wire                usbCore_SCANEN_USB3PHY;
  wire                usbCore_SCANEN_CGUSB3PHY;
  wire                usbCore_SCANEN_USB2PHY;
  wire                usbCore_USB3_SYSRSTN;
  wire                usbCore_USB_RESETN;
  wire                usbCore_LMMIRESETN;
  reg                 usbCore_LMMIREQUEST;
  reg                 usbCore_LMMIWRRD_N;
  wire       [14:0]   usbCore_LMMIOFFSET;
  wire       [7:0]    usbCore_XMBID;
  wire       [3:0]    usbCore_XMBMISC_INFO;
  wire       [7:0]    usbCore_XMRID;
  wire       [3:0]    usbCore_XMRMISC_INFO;
  wire       [0:0]    usbCore_TXM;
  wire       [0:0]    usbCore_TXP;
  wire                usbCore_XOOUT18;
  wire                usbCore_XMCSYSACK;
  wire                usbCore_XMCACTIVE;
  wire                usbCore_RESEXTUSB3;
  wire                usbCore_DISRXDETU3RXDETACK;
  wire                usbCore_SS_RX_ACJT_OUTN;
  wire                usbCore_SS_RX_ACJT_OUTP;
  wire                usbCore_INTERRUPT;
  wire                usbCore_LMMIRDATAVALID;
  wire                usbCore_LMMIREADY;
  wire       [31:0]   usbCore_LMMIRDATA;
  wire       [31:0]   usbCore_XMAWADDR;
  wire                usbCore_XMAWVALID;
  wire       [2:0]    usbCore_XMAWSIZE;
  wire       [7:0]    usbCore_XMAWLEN;
  wire       [1:0]    usbCore_XMAWBURST;
  wire       [7:0]    usbCore_XMAWID;
  wire       [0:0]    usbCore_XMAWLOCK;
  wire       [3:0]    usbCore_XMAWCACHE;
  wire       [2:0]    usbCore_XMAWPROT;
  wire       [3:0]    usbCore_XMAWMISC_INFO;
  wire       [63:0]   usbCore_XMWDATA;
  wire       [7:0]    usbCore_XMWSTRB;
  wire                usbCore_XMWVALID;
  wire                usbCore_XMWLAST;
  wire       [7:0]    usbCore_XMWID;
  wire                usbCore_XMBREADY;
  wire       [31:0]   usbCore_XMARADDR;
  wire                usbCore_XMARVALID;
  wire       [7:0]    usbCore_XMARLEN;
  wire       [2:0]    usbCore_XMARSIZE;
  wire       [1:0]    usbCore_XMARBURST;
  wire       [7:0]    usbCore_XMARID;
  wire       [0:0]    usbCore_XMARLOCK;
  wire       [3:0]    usbCore_XMARCACHE;
  wire       [2:0]    usbCore_XMARPROT;
  wire       [3:0]    usbCore_XMARMISC_INFO;
  wire                usbCore_XMRREADY;
  reg        [1:0]    stateMachine_state;
  wire                when_USB23_l269;
  `ifndef SYNTHESIS
  reg [39:0] stateMachine_state_string;
  `endif


  USB23 #(
    .USB_MODE("USB23"),
    .GSR("ENABLED")
  ) usbCore (
    .VBUS               ({io_usbIO_VBUS}),
    .REFINCLKEXTP       (io_usbIO_REFINCLKEXTP     ), //i
    .REFINCLKEXTM       (io_usbIO_REFINCLKEXTM     ), //i
    .RESEXTUSB2         ({io_usbIO_RESEXTUSB2}),
    .DP                 ({io_usbIO_DP}),
    .DM                 ({io_usbIO_DM}),
    .RXM                (io_usbIO_RXM              ), //i
    .RXP                (io_usbIO_RXP              ), //i
    .TXM                (usbCore_TXM               ), //o
    .TXP                (usbCore_TXP               ), //o
    .XOIN18             (usbCore_XOIN18            ), //i
    .XOOUT18            (usbCore_XOOUT18           ), //o
    .USBPHY_REFCLK_ALT  (io_clk_60m                ), //i
    .XMCSYSREQ          (usbCore_XMCSYSREQ         ), //i
    .XMCSYSACK          (usbCore_XMCSYSACK         ), //o
    .XMCACTIVE          (usbCore_XMCACTIVE         ), //o
    .ID                 (usbCore_ID                ), //i
    .STARTRXDETU3RXDET  (usbCore_STARTRXDETU3RXDET ), //i
    .DISRXDETU3RXDET    (usbCore_DISRXDETU3RXDET   ), //i
    .SS_RX_ACJT_EN      (usbCore_SS_RX_ACJT_EN     ), //i
    .SS_RX_ACJT_ININ    (usbCore_SS_RX_ACJT_ININ   ), //i
    .SS_RX_ACJT_INIP    (usbCore_SS_RX_ACJT_INIP   ), //i
    .SS_RX_ACJT_INIT_EN (usbCore_SS_RX_ACJT_INIT_EN), //i
    .SS_RX_ACJT_MODE    (usbCore_SS_RX_ACJT_MODE   ), //i
    .SS_TX_ACJT_DRVEN   (usbCore_SS_TX_ACJT_DRVEN  ), //i
    .SS_TX_ACJT_DATAIN  (usbCore_SS_TX_ACJT_DATAIN ), //i
    .SS_TX_ACJT_HIGHZ   (usbCore_SS_TX_ACJT_HIGHZ  ), //i
    .SCANEN_CTRL        (usbCore_SCANEN_CTRL       ), //i
    .SCANEN_USB3PHY     (usbCore_SCANEN_USB3PHY    ), //i
    .SCANEN_CGUSB3PHY   (usbCore_SCANEN_CGUSB3PHY  ), //i
    .SCANEN_USB2PHY     (usbCore_SCANEN_USB2PHY    ), //i
    .RESEXTUSB3         (usbCore_RESEXTUSB3        ), //o
    .DISRXDETU3RXDETACK (usbCore_DISRXDETU3RXDETACK), //o
    .SS_RX_ACJT_OUTN    (usbCore_SS_RX_ACJT_OUTN   ), //o
    .SS_RX_ACJT_OUTP    (usbCore_SS_RX_ACJT_OUTP   ), //o
    .USB3_MCUCLK        (clk                       ), //i
    .USB_SUSPENDCLK     (io_clk_60m                ), //i
    .USB3_SYSRSTN       (usbCore_USB3_SYSRSTN      ), //i
    .USB_RESETN         (usbCore_USB_RESETN        ), //i
    .USB2_RESET         (reset                     ), //i
    .INTERRUPT          (usbCore_INTERRUPT         ), //o
    .LMMICLK            (clk                       ), //i
    .LMMIRESETN         (usbCore_LMMIRESETN        ), //i
    .LMMIREQUEST        (usbCore_LMMIREQUEST       ), //i
    .LMMIWRRD_N         (usbCore_LMMIWRRD_N        ), //i
    .LMMIOFFSET         (usbCore_LMMIOFFSET[14:0]  ), //i
    .LMMIWDATA          (io_wb_DAT_MOSI[31:0]      ), //i
    .LMMIRDATAVALID     (usbCore_LMMIRDATAVALID    ), //o
    .LMMIREADY          (usbCore_LMMIREADY         ), //o
    .LMMIRDATA          (usbCore_LMMIRDATA[31:0]   ), //o
    .XMAWADDR           (usbCore_XMAWADDR[31:0]    ), //o
    .XMAWVALID          (usbCore_XMAWVALID         ), //o
    .XMAWSIZE           (usbCore_XMAWSIZE[2:0]     ), //o
    .XMAWLEN            (usbCore_XMAWLEN[7:0]      ), //o
    .XMAWBURST          (usbCore_XMAWBURST[1:0]    ), //o
    .XMAWID             (usbCore_XMAWID[7:0]       ), //o
    .XMAWLOCK           (usbCore_XMAWLOCK          ), //o
    .XMAWCACHE          (usbCore_XMAWCACHE[3:0]    ), //o
    .XMAWPROT           (usbCore_XMAWPROT[2:0]     ), //o
    .XMAWREADY          (axi_awready               ), //i
    .XMAWMISC_INFO      (usbCore_XMAWMISC_INFO[3:0]), //o
    .XMWDATA            (usbCore_XMWDATA[63:0]     ), //o
    .XMWSTRB            (usbCore_XMWSTRB[7:0]      ), //o
    .XMWVALID           (usbCore_XMWVALID          ), //o
    .XMWLAST            (usbCore_XMWLAST           ), //o
    .XMWID              (usbCore_XMWID[7:0]        ), //o
    .XMWREADY           (axi_wready                ), //i
    .XMBID              (usbCore_XMBID[7:0]        ), //i
    .XMBVALID           (axi_bvalid                ), //i
    .XMBRESP            (axi_bresp[1:0]            ), //i
    .XMBREADY           (usbCore_XMBREADY          ), //o
    .XMBMISC_INFO       (usbCore_XMBMISC_INFO[3:0] ), //i
    .XMARADDR           (usbCore_XMARADDR[31:0]    ), //o
    .XMARVALID          (usbCore_XMARVALID         ), //o
    .XMARLEN            (usbCore_XMARLEN[7:0]      ), //o
    .XMARSIZE           (usbCore_XMARSIZE[2:0]     ), //o
    .XMARBURST          (usbCore_XMARBURST[1:0]    ), //o
    .XMARID             (usbCore_XMARID[7:0]       ), //o
    .XMARLOCK           (usbCore_XMARLOCK          ), //o
    .XMARCACHE          (usbCore_XMARCACHE[3:0]    ), //o
    .XMARPROT           (usbCore_XMARPROT[2:0]     ), //o
    .XMARMISC_INFO      (usbCore_XMARMISC_INFO[3:0]), //o
    .XMARREADY          (axi_arready               ), //i
    .XMRID              (usbCore_XMRID[7:0]        ), //i
    .XMRVALID           (axi_rvalid                ), //i
    .XMRLAST            (axi_rlast                 ), //i
    .XMRDATA            (axi_rdata[63:0]           ), //i
    .XMRMISC_INFO       (usbCore_XMRMISC_INFO[3:0] ), //i
    .XMRRESP            (axi_rresp[1:0]            ), //i
    .XMRREADY           (usbCore_XMRREADY          )  //o
  );
  `ifndef SYNTHESIS
  always @(*) begin
    case(stateMachine_state)
      LmmiState_IDLE : stateMachine_state_string = "IDLE ";
      LmmiState_READ : stateMachine_state_string = "READ ";
      LmmiState_WRITE : stateMachine_state_string = "WRITE";
      default : stateMachine_state_string = "?????";
    endcase
  end
  `endif

  assign io_usbIO_TXM = usbCore_TXM;
  assign io_usbIO_TXP = usbCore_TXP;
  assign usbCore_XOIN18 = 1'b0;
  assign usbCore_XMCSYSREQ = 1'b0;
  assign usbCore_ID = 1'b1;
  assign usbCore_STARTRXDETU3RXDET = 1'b0;
  assign usbCore_DISRXDETU3RXDET = 1'b0;
  assign usbCore_SS_RX_ACJT_EN = 1'b0;
  assign usbCore_SS_RX_ACJT_ININ = 1'b0;
  assign usbCore_SS_RX_ACJT_INIP = 1'b0;
  assign usbCore_SS_RX_ACJT_INIT_EN = 1'b0;
  assign usbCore_SS_RX_ACJT_MODE = 1'b0;
  assign usbCore_SS_TX_ACJT_DRVEN = 1'b0;
  assign usbCore_SS_TX_ACJT_DATAIN = 1'b0;
  assign usbCore_SS_TX_ACJT_HIGHZ = 1'b0;
  assign usbCore_SCANEN_CTRL = 1'b0;
  assign usbCore_SCANEN_USB3PHY = 1'b0;
  assign usbCore_SCANEN_CGUSB3PHY = 1'b0;
  assign usbCore_SCANEN_USB2PHY = 1'b0;
  assign usbCore_USB3_SYSRSTN = (! reset);
  assign usbCore_USB_RESETN = (! reset);
  assign io_irq = usbCore_INTERRUPT;
  assign axi_awaddr = usbCore_XMAWADDR;
  assign axi_awvalid = usbCore_XMAWVALID;
  assign axi_awsize = usbCore_XMAWSIZE;
  assign axi_awlen = usbCore_XMAWLEN;
  assign axi_awburst = usbCore_XMAWBURST;
  assign axi_awid = usbCore_XMAWID;
  assign axi_awlock = usbCore_XMAWLOCK;
  assign axi_awcache = usbCore_XMAWCACHE;
  assign axi_awprot = usbCore_XMAWPROT;
  assign axi_wdata = usbCore_XMWDATA;
  assign axi_wstrb = usbCore_XMWSTRB;
  assign axi_wvalid = usbCore_XMWVALID;
  assign axi_wlast = usbCore_XMWLAST;
  assign usbCore_XMBID = axi_bid;
  assign usbCore_XMBMISC_INFO = 4'b0000;
  assign axi_bready = usbCore_XMBREADY;
  assign axi_araddr = usbCore_XMARADDR;
  assign axi_arvalid = usbCore_XMARVALID;
  assign axi_arlen = usbCore_XMARLEN;
  assign axi_arsize = usbCore_XMARSIZE;
  assign axi_arburst = usbCore_XMARBURST;
  assign axi_arid = usbCore_XMARID;
  assign axi_arcache = usbCore_XMARCACHE;
  assign axi_arlock = usbCore_XMARLOCK;
  assign axi_arprot = usbCore_XMARPROT;
  assign usbCore_XMRID = axi_rid;
  assign usbCore_XMRMISC_INFO = 4'b0000;
  assign axi_rready = usbCore_XMRREADY;
  assign usbCore_LMMIRESETN = (! reset);
  always @(*) begin
    usbCore_LMMIWRRD_N = 1'b0;
    case(stateMachine_state)
      LmmiState_IDLE : begin
        if(when_USB23_l269) begin
          if(io_wb_WE) begin
            usbCore_LMMIWRRD_N = 1'b1;
          end else begin
            usbCore_LMMIWRRD_N = 1'b0;
          end
        end
      end
      LmmiState_READ : begin
      end
      default : begin
      end
    endcase
  end

  assign usbCore_LMMIOFFSET = io_wb_ADR[16 : 2];
  always @(*) begin
    io_wb_ACK = 1'b0;
    case(stateMachine_state)
      LmmiState_IDLE : begin
      end
      LmmiState_READ : begin
        io_wb_ACK = usbCore_LMMIRDATAVALID;
      end
      default : begin
        io_wb_ACK = 1'b1;
      end
    endcase
  end

  always @(*) begin
    io_wb_DAT_MISO = 32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;
    case(stateMachine_state)
      LmmiState_IDLE : begin
      end
      LmmiState_READ : begin
        if(usbCore_LMMIRDATAVALID) begin
          io_wb_DAT_MISO = usbCore_LMMIRDATA;
        end
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    usbCore_LMMIREQUEST = 1'b0;
    case(stateMachine_state)
      LmmiState_IDLE : begin
        if(when_USB23_l269) begin
          usbCore_LMMIREQUEST = 1'b1;
        end
      end
      LmmiState_READ : begin
      end
      default : begin
      end
    endcase
  end

  assign when_USB23_l269 = (((io_wb_CYC && io_wb_STB) && (! io_wb_ACK)) && usbCore_LMMIREADY);
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      stateMachine_state <= LmmiState_IDLE;
    end else begin
      case(stateMachine_state)
        LmmiState_IDLE : begin
          if(when_USB23_l269) begin
            if(io_wb_WE) begin
              stateMachine_state <= LmmiState_WRITE;
            end else begin
              stateMachine_state <= LmmiState_READ;
            end
          end
        end
        LmmiState_READ : begin
          if(usbCore_LMMIRDATAVALID) begin
            stateMachine_state <= LmmiState_IDLE;
          end
        end
        default : begin
          stateMachine_state <= LmmiState_IDLE;
        end
      endcase
    end
  end


endmodule

module StreamFifoLowLatency (
  input  wire          io_push_valid,
  output wire          io_push_ready,
  input  wire [0:0]    io_push_payload,
  output wire          io_pop_valid,
  input  wire          io_pop_ready,
  output wire [0:0]    io_pop_payload,
  input  wire          io_flush,
  output wire [2:0]    io_occupancy,
  output wire [2:0]    io_availability,
  input  wire          clk,
  input  wire          reset
);

  wire                fifo_io_push_ready;
  wire                fifo_io_pop_valid;
  wire       [0:0]    fifo_io_pop_payload;
  wire       [2:0]    fifo_io_occupancy;
  wire       [2:0]    fifo_io_availability;

  StreamFifo fifo (
    .io_push_valid   (io_push_valid            ), //i
    .io_push_ready   (fifo_io_push_ready       ), //o
    .io_push_payload (io_push_payload          ), //i
    .io_pop_valid    (fifo_io_pop_valid        ), //o
    .io_pop_ready    (io_pop_ready             ), //i
    .io_pop_payload  (fifo_io_pop_payload      ), //o
    .io_flush        (io_flush                 ), //i
    .io_occupancy    (fifo_io_occupancy[2:0]   ), //o
    .io_availability (fifo_io_availability[2:0]), //o
    .clk             (clk                      ), //i
    .reset           (reset                    )  //i
  );
  assign io_push_ready = fifo_io_push_ready;
  assign io_pop_valid = fifo_io_pop_valid;
  assign io_pop_payload = fifo_io_pop_payload;
  assign io_occupancy = fifo_io_occupancy;
  assign io_availability = fifo_io_availability;

endmodule

module StreamArbiter (
  input  wire          io_inputs_0_valid,
  output wire          io_inputs_0_ready,
  input  wire [11:0]   io_inputs_0_payload_addr,
  input  wire [7:0]    io_inputs_0_payload_id,
  input  wire [7:0]    io_inputs_0_payload_len,
  input  wire [2:0]    io_inputs_0_payload_size,
  input  wire [1:0]    io_inputs_0_payload_burst,
  input  wire          io_inputs_0_payload_write,
  input  wire          io_inputs_1_valid,
  output wire          io_inputs_1_ready,
  input  wire [11:0]   io_inputs_1_payload_addr,
  input  wire [7:0]    io_inputs_1_payload_id,
  input  wire [7:0]    io_inputs_1_payload_len,
  input  wire [2:0]    io_inputs_1_payload_size,
  input  wire [1:0]    io_inputs_1_payload_burst,
  input  wire          io_inputs_1_payload_write,
  input  wire          io_inputs_2_valid,
  output wire          io_inputs_2_ready,
  input  wire [11:0]   io_inputs_2_payload_addr,
  input  wire [7:0]    io_inputs_2_payload_id,
  input  wire [7:0]    io_inputs_2_payload_len,
  input  wire [2:0]    io_inputs_2_payload_size,
  input  wire [1:0]    io_inputs_2_payload_burst,
  input  wire          io_inputs_2_payload_write,
  input  wire          io_inputs_3_valid,
  output wire          io_inputs_3_ready,
  input  wire [11:0]   io_inputs_3_payload_addr,
  input  wire [7:0]    io_inputs_3_payload_id,
  input  wire [7:0]    io_inputs_3_payload_len,
  input  wire [2:0]    io_inputs_3_payload_size,
  input  wire [1:0]    io_inputs_3_payload_burst,
  input  wire          io_inputs_3_payload_write,
  output wire          io_output_valid,
  input  wire          io_output_ready,
  output wire [11:0]   io_output_payload_addr,
  output wire [7:0]    io_output_payload_id,
  output wire [7:0]    io_output_payload_len,
  output wire [2:0]    io_output_payload_size,
  output wire [1:0]    io_output_payload_burst,
  output wire          io_output_payload_write,
  output wire [1:0]    io_chosen,
  output wire [3:0]    io_chosenOH,
  input  wire          clk,
  input  wire          reset
);

  wire       [7:0]    _zz__zz_maskProposal_0_2;
  wire       [7:0]    _zz__zz_maskProposal_0_2_1;
  wire       [3:0]    _zz__zz_maskProposal_0_2_2;
  reg        [11:0]   _zz_io_output_payload_addr_3;
  reg        [7:0]    _zz_io_output_payload_id;
  reg        [7:0]    _zz_io_output_payload_len;
  reg        [2:0]    _zz_io_output_payload_size;
  reg        [1:0]    _zz_io_output_payload_burst;
  reg                 _zz_io_output_payload_write;
  reg                 locked;
  wire                maskProposal_0;
  wire                maskProposal_1;
  wire                maskProposal_2;
  wire                maskProposal_3;
  reg                 maskLocked_0;
  reg                 maskLocked_1;
  reg                 maskLocked_2;
  reg                 maskLocked_3;
  wire                maskRouted_0;
  wire                maskRouted_1;
  wire                maskRouted_2;
  wire                maskRouted_3;
  wire       [3:0]    _zz_maskProposal_0;
  wire       [7:0]    _zz_maskProposal_0_1;
  wire       [7:0]    _zz_maskProposal_0_2;
  wire       [3:0]    _zz_maskProposal_0_3;
  wire                io_output_fire;
  wire                _zz_io_output_payload_addr;
  wire                _zz_io_output_payload_addr_1;
  wire       [1:0]    _zz_io_output_payload_addr_2;
  wire                _zz_io_chosen;
  wire                _zz_io_chosen_1;
  wire                _zz_io_chosen_2;

  assign _zz__zz_maskProposal_0_2 = (_zz_maskProposal_0_1 - _zz__zz_maskProposal_0_2_1);
  assign _zz__zz_maskProposal_0_2_2 = {maskLocked_2,{maskLocked_1,{maskLocked_0,maskLocked_3}}};
  assign _zz__zz_maskProposal_0_2_1 = {4'd0, _zz__zz_maskProposal_0_2_2};
  always @(*) begin
    case(_zz_io_output_payload_addr_2)
      2'b00 : begin
        _zz_io_output_payload_addr_3 = io_inputs_0_payload_addr;
        _zz_io_output_payload_id = io_inputs_0_payload_id;
        _zz_io_output_payload_len = io_inputs_0_payload_len;
        _zz_io_output_payload_size = io_inputs_0_payload_size;
        _zz_io_output_payload_burst = io_inputs_0_payload_burst;
        _zz_io_output_payload_write = io_inputs_0_payload_write;
      end
      2'b01 : begin
        _zz_io_output_payload_addr_3 = io_inputs_1_payload_addr;
        _zz_io_output_payload_id = io_inputs_1_payload_id;
        _zz_io_output_payload_len = io_inputs_1_payload_len;
        _zz_io_output_payload_size = io_inputs_1_payload_size;
        _zz_io_output_payload_burst = io_inputs_1_payload_burst;
        _zz_io_output_payload_write = io_inputs_1_payload_write;
      end
      2'b10 : begin
        _zz_io_output_payload_addr_3 = io_inputs_2_payload_addr;
        _zz_io_output_payload_id = io_inputs_2_payload_id;
        _zz_io_output_payload_len = io_inputs_2_payload_len;
        _zz_io_output_payload_size = io_inputs_2_payload_size;
        _zz_io_output_payload_burst = io_inputs_2_payload_burst;
        _zz_io_output_payload_write = io_inputs_2_payload_write;
      end
      default : begin
        _zz_io_output_payload_addr_3 = io_inputs_3_payload_addr;
        _zz_io_output_payload_id = io_inputs_3_payload_id;
        _zz_io_output_payload_len = io_inputs_3_payload_len;
        _zz_io_output_payload_size = io_inputs_3_payload_size;
        _zz_io_output_payload_burst = io_inputs_3_payload_burst;
        _zz_io_output_payload_write = io_inputs_3_payload_write;
      end
    endcase
  end

  assign maskRouted_0 = (locked ? maskLocked_0 : maskProposal_0);
  assign maskRouted_1 = (locked ? maskLocked_1 : maskProposal_1);
  assign maskRouted_2 = (locked ? maskLocked_2 : maskProposal_2);
  assign maskRouted_3 = (locked ? maskLocked_3 : maskProposal_3);
  assign _zz_maskProposal_0 = {io_inputs_3_valid,{io_inputs_2_valid,{io_inputs_1_valid,io_inputs_0_valid}}};
  assign _zz_maskProposal_0_1 = {_zz_maskProposal_0,_zz_maskProposal_0};
  assign _zz_maskProposal_0_2 = (_zz_maskProposal_0_1 & (~ _zz__zz_maskProposal_0_2));
  assign _zz_maskProposal_0_3 = (_zz_maskProposal_0_2[7 : 4] | _zz_maskProposal_0_2[3 : 0]);
  assign maskProposal_0 = _zz_maskProposal_0_3[0];
  assign maskProposal_1 = _zz_maskProposal_0_3[1];
  assign maskProposal_2 = _zz_maskProposal_0_3[2];
  assign maskProposal_3 = _zz_maskProposal_0_3[3];
  assign io_output_fire = (io_output_valid && io_output_ready);
  assign io_output_valid = ((((io_inputs_0_valid && maskRouted_0) || (io_inputs_1_valid && maskRouted_1)) || (io_inputs_2_valid && maskRouted_2)) || (io_inputs_3_valid && maskRouted_3));
  assign _zz_io_output_payload_addr = (maskRouted_1 || maskRouted_3);
  assign _zz_io_output_payload_addr_1 = (maskRouted_2 || maskRouted_3);
  assign _zz_io_output_payload_addr_2 = {_zz_io_output_payload_addr_1,_zz_io_output_payload_addr};
  assign io_output_payload_addr = _zz_io_output_payload_addr_3;
  assign io_output_payload_id = _zz_io_output_payload_id;
  assign io_output_payload_len = _zz_io_output_payload_len;
  assign io_output_payload_size = _zz_io_output_payload_size;
  assign io_output_payload_burst = _zz_io_output_payload_burst;
  assign io_output_payload_write = _zz_io_output_payload_write;
  assign io_inputs_0_ready = (maskRouted_0 && io_output_ready);
  assign io_inputs_1_ready = (maskRouted_1 && io_output_ready);
  assign io_inputs_2_ready = (maskRouted_2 && io_output_ready);
  assign io_inputs_3_ready = (maskRouted_3 && io_output_ready);
  assign io_chosenOH = {maskRouted_3,{maskRouted_2,{maskRouted_1,maskRouted_0}}};
  assign _zz_io_chosen = io_chosenOH[3];
  assign _zz_io_chosen_1 = (io_chosenOH[1] || _zz_io_chosen);
  assign _zz_io_chosen_2 = (io_chosenOH[2] || _zz_io_chosen);
  assign io_chosen = {_zz_io_chosen_2,_zz_io_chosen_1};
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      locked <= 1'b0;
      maskLocked_0 <= 1'b0;
      maskLocked_1 <= 1'b0;
      maskLocked_2 <= 1'b0;
      maskLocked_3 <= 1'b1;
    end else begin
      if(io_output_valid) begin
        maskLocked_0 <= maskRouted_0;
        maskLocked_1 <= maskRouted_1;
        maskLocked_2 <= maskRouted_2;
        maskLocked_3 <= maskRouted_3;
      end
      if(io_output_valid) begin
        locked <= 1'b1;
      end
      if(io_output_fire) begin
        locked <= 1'b0;
      end
    end
  end


endmodule

//Axi4WriteOnlyErrorSlave replaced by Axi4WriteOnlyErrorSlave_1

//Axi4ReadOnlyErrorSlave replaced by Axi4ReadOnlyErrorSlave_1

module Axi4WriteOnlyErrorSlave_1 (
  input  wire          io_axi_aw_valid,
  output wire          io_axi_aw_ready,
  input  wire [31:0]   io_axi_aw_payload_addr,
  input  wire [7:0]    io_axi_aw_payload_id,
  input  wire [7:0]    io_axi_aw_payload_len,
  input  wire [2:0]    io_axi_aw_payload_size,
  input  wire [1:0]    io_axi_aw_payload_burst,
  input  wire [0:0]    io_axi_aw_payload_lock,
  input  wire [3:0]    io_axi_aw_payload_cache,
  input  wire [2:0]    io_axi_aw_payload_prot,
  input  wire          io_axi_w_valid,
  output wire          io_axi_w_ready,
  input  wire [63:0]   io_axi_w_payload_data,
  input  wire [7:0]    io_axi_w_payload_strb,
  input  wire          io_axi_w_payload_last,
  output wire          io_axi_b_valid,
  input  wire          io_axi_b_ready,
  output wire [7:0]    io_axi_b_payload_id,
  output wire [1:0]    io_axi_b_payload_resp,
  input  wire          clk,
  input  wire          reset
);

  reg                 consumeData;
  reg                 sendRsp;
  reg        [7:0]    id;
  wire                io_axi_aw_fire;
  wire                io_axi_w_fire;
  wire                when_Axi4ErrorSlave_l24;
  wire                io_axi_b_fire;

  assign io_axi_aw_ready = (! (consumeData || sendRsp));
  assign io_axi_aw_fire = (io_axi_aw_valid && io_axi_aw_ready);
  assign io_axi_w_ready = consumeData;
  assign io_axi_w_fire = (io_axi_w_valid && io_axi_w_ready);
  assign when_Axi4ErrorSlave_l24 = (io_axi_w_fire && io_axi_w_payload_last);
  assign io_axi_b_valid = sendRsp;
  assign io_axi_b_payload_resp = 2'b11;
  assign io_axi_b_payload_id = id;
  assign io_axi_b_fire = (io_axi_b_valid && io_axi_b_ready);
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      consumeData <= 1'b0;
      sendRsp <= 1'b0;
    end else begin
      if(io_axi_aw_fire) begin
        consumeData <= 1'b1;
      end
      if(when_Axi4ErrorSlave_l24) begin
        consumeData <= 1'b0;
        sendRsp <= 1'b1;
      end
      if(io_axi_b_fire) begin
        sendRsp <= 1'b0;
      end
    end
  end

  always @(posedge clk) begin
    if(io_axi_aw_fire) begin
      id <= io_axi_aw_payload_id;
    end
  end


endmodule

module Axi4ReadOnlyErrorSlave_1 (
  input  wire          io_axi_ar_valid,
  output wire          io_axi_ar_ready,
  input  wire [31:0]   io_axi_ar_payload_addr,
  input  wire [7:0]    io_axi_ar_payload_id,
  input  wire [7:0]    io_axi_ar_payload_len,
  input  wire [2:0]    io_axi_ar_payload_size,
  input  wire [1:0]    io_axi_ar_payload_burst,
  input  wire [0:0]    io_axi_ar_payload_lock,
  input  wire [3:0]    io_axi_ar_payload_cache,
  input  wire [2:0]    io_axi_ar_payload_prot,
  output wire          io_axi_r_valid,
  input  wire          io_axi_r_ready,
  output wire [63:0]   io_axi_r_payload_data,
  output wire [7:0]    io_axi_r_payload_id,
  output wire [1:0]    io_axi_r_payload_resp,
  output wire          io_axi_r_payload_last,
  input  wire          clk,
  input  wire          reset
);

  reg                 sendRsp;
  reg        [7:0]    id;
  reg        [7:0]    remaining;
  wire                remainingZero;
  wire                io_axi_ar_fire;

  assign remainingZero = (remaining == 8'h00);
  assign io_axi_ar_ready = (! sendRsp);
  assign io_axi_ar_fire = (io_axi_ar_valid && io_axi_ar_ready);
  assign io_axi_r_valid = sendRsp;
  assign io_axi_r_payload_id = id;
  assign io_axi_r_payload_resp = 2'b11;
  assign io_axi_r_payload_last = remainingZero;
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      sendRsp <= 1'b0;
    end else begin
      if(io_axi_ar_fire) begin
        sendRsp <= 1'b1;
      end
      if(sendRsp) begin
        if(io_axi_r_ready) begin
          if(remainingZero) begin
            sendRsp <= 1'b0;
          end
        end
      end
    end
  end

  always @(posedge clk) begin
    if(io_axi_ar_fire) begin
      remaining <= io_axi_ar_payload_len;
      id <= io_axi_ar_payload_id;
    end
    if(sendRsp) begin
      if(io_axi_r_ready) begin
        remaining <= (remaining - 8'h01);
      end
    end
  end


endmodule

module WishboneDecoder (
  input  wire          io_input_CYC,
  input  wire          io_input_STB,
  output wire          io_input_ACK,
  input  wire          io_input_WE,
  input  wire [27:0]   io_input_ADR,
  output wire [31:0]   io_input_DAT_MISO,
  input  wire [31:0]   io_input_DAT_MOSI,
  input  wire [3:0]    io_input_SEL,
  output wire          io_outputs_0_CYC,
  output wire          io_outputs_0_STB,
  input  wire          io_outputs_0_ACK,
  output wire          io_outputs_0_WE,
  output wire [27:0]   io_outputs_0_ADR,
  input  wire [31:0]   io_outputs_0_DAT_MISO,
  output wire [31:0]   io_outputs_0_DAT_MOSI,
  output wire [3:0]    io_outputs_0_SEL,
  output wire          io_outputs_1_CYC,
  output wire          io_outputs_1_STB,
  input  wire          io_outputs_1_ACK,
  output wire          io_outputs_1_WE,
  output wire [27:0]   io_outputs_1_ADR,
  input  wire [31:0]   io_outputs_1_DAT_MISO,
  output wire [31:0]   io_outputs_1_DAT_MOSI,
  output wire [3:0]    io_outputs_1_SEL
);

  reg                 _zz_selectedOutput_CYC;
  reg                 _zz_selectedOutput_STB;
  reg                 _zz_selectedOutput_ACK;
  reg                 _zz_selectedOutput_WE;
  reg        [27:0]   _zz_selectedOutput_ADR;
  reg        [31:0]   _zz_selectedOutput_DAT_MISO;
  reg        [31:0]   _zz_selectedOutput_DAT_MOSI;
  reg        [3:0]    _zz_selectedOutput_SEL;
  wire                selector_0;
  wire                selector_1;
  wire       [0:0]    selectorIndex;
  wire                selectedOutput_CYC;
  wire                selectedOutput_STB;
  wire                selectedOutput_ACK;
  wire                selectedOutput_WE;
  wire       [27:0]   selectedOutput_ADR;
  wire       [31:0]   selectedOutput_DAT_MISO;
  wire       [31:0]   selectedOutput_DAT_MOSI;
  wire       [3:0]    selectedOutput_SEL;

  always @(*) begin
    case(selectorIndex)
      1'b0 : begin
        _zz_selectedOutput_CYC = io_outputs_0_CYC;
        _zz_selectedOutput_STB = io_outputs_0_STB;
        _zz_selectedOutput_ACK = io_outputs_0_ACK;
        _zz_selectedOutput_WE = io_outputs_0_WE;
        _zz_selectedOutput_ADR = io_outputs_0_ADR;
        _zz_selectedOutput_DAT_MISO = io_outputs_0_DAT_MISO;
        _zz_selectedOutput_DAT_MOSI = io_outputs_0_DAT_MOSI;
        _zz_selectedOutput_SEL = io_outputs_0_SEL;
      end
      default : begin
        _zz_selectedOutput_CYC = io_outputs_1_CYC;
        _zz_selectedOutput_STB = io_outputs_1_STB;
        _zz_selectedOutput_ACK = io_outputs_1_ACK;
        _zz_selectedOutput_WE = io_outputs_1_WE;
        _zz_selectedOutput_ADR = io_outputs_1_ADR;
        _zz_selectedOutput_DAT_MISO = io_outputs_1_DAT_MISO;
        _zz_selectedOutput_DAT_MOSI = io_outputs_1_DAT_MOSI;
        _zz_selectedOutput_SEL = io_outputs_1_SEL;
      end
    endcase
  end

  assign io_outputs_0_STB = io_input_STB;
  assign io_outputs_0_DAT_MOSI = io_input_DAT_MOSI;
  assign io_outputs_0_WE = io_input_WE;
  assign io_outputs_0_ADR = io_input_ADR;
  assign io_outputs_0_SEL = io_input_SEL;
  assign io_outputs_1_STB = io_input_STB;
  assign io_outputs_1_DAT_MOSI = io_input_DAT_MOSI;
  assign io_outputs_1_WE = io_input_WE;
  assign io_outputs_1_ADR = io_input_ADR;
  assign io_outputs_1_SEL = io_input_SEL;
  assign selector_0 = ((io_input_ADR < 28'h0ffffff) && io_input_CYC);
  assign selector_1 = (((io_input_ADR & (~ 28'h0000fff)) == 28'h1000000) && io_input_CYC);
  assign selectorIndex = selector_1;
  assign io_outputs_0_CYC = selector_0;
  assign io_outputs_1_CYC = selector_1;
  assign selectedOutput_CYC = _zz_selectedOutput_CYC;
  assign selectedOutput_STB = _zz_selectedOutput_STB;
  assign selectedOutput_ACK = _zz_selectedOutput_ACK;
  assign selectedOutput_WE = _zz_selectedOutput_WE;
  assign selectedOutput_ADR = _zz_selectedOutput_ADR;
  assign selectedOutput_DAT_MISO = _zz_selectedOutput_DAT_MISO;
  assign selectedOutput_DAT_MOSI = _zz_selectedOutput_DAT_MOSI;
  assign selectedOutput_SEL = _zz_selectedOutput_SEL;
  assign io_input_ACK = selectedOutput_ACK;
  assign io_input_DAT_MISO = selectedOutput_DAT_MISO;

endmodule

module StreamFifo (
  input  wire          io_push_valid,
  output wire          io_push_ready,
  input  wire [0:0]    io_push_payload,
  output reg           io_pop_valid,
  input  wire          io_pop_ready,
  output reg  [0:0]    io_pop_payload,
  input  wire          io_flush,
  output wire [2:0]    io_occupancy,
  output wire [2:0]    io_availability,
  input  wire          clk,
  input  wire          reset
);

  wire       [0:0]    _zz_logic_ram_port1;
  wire       [0:0]    _zz_logic_ram_port;
  reg                 _zz_1;
  reg                 logic_ptr_doPush;
  wire                logic_ptr_doPop;
  wire                logic_ptr_full;
  wire                logic_ptr_empty;
  reg        [2:0]    logic_ptr_push;
  reg        [2:0]    logic_ptr_pop;
  wire       [2:0]    logic_ptr_occupancy;
  wire       [2:0]    logic_ptr_popOnIo;
  wire                when_Stream_l1205;
  reg                 logic_ptr_wentUp;
  wire                io_push_fire;
  wire                logic_push_onRam_write_valid;
  wire       [1:0]    logic_push_onRam_write_payload_address;
  wire       [0:0]    logic_push_onRam_write_payload_data;
  wire                logic_pop_addressGen_valid;
  wire                logic_pop_addressGen_ready;
  wire       [1:0]    logic_pop_addressGen_payload;
  wire                logic_pop_addressGen_fire;
  wire       [0:0]    logic_pop_async_readed;
  wire                logic_pop_addressGen_translated_valid;
  wire                logic_pop_addressGen_translated_ready;
  wire       [0:0]    logic_pop_addressGen_translated_payload;
  (* ram_style = "distributed" *) reg [0:0] logic_ram [0:3];

  assign _zz_logic_ram_port = logic_push_onRam_write_payload_data;
  always @(posedge clk) begin
    if(_zz_1) begin
      logic_ram[logic_push_onRam_write_payload_address] <= _zz_logic_ram_port;
    end
  end

  assign _zz_logic_ram_port1 = logic_ram[logic_pop_addressGen_payload];
  always @(*) begin
    _zz_1 = 1'b0;
    if(logic_push_onRam_write_valid) begin
      _zz_1 = 1'b1;
    end
  end

  assign when_Stream_l1205 = (logic_ptr_doPush != logic_ptr_doPop);
  assign logic_ptr_full = (((logic_ptr_push ^ logic_ptr_popOnIo) ^ 3'b100) == 3'b000);
  assign logic_ptr_empty = (logic_ptr_push == logic_ptr_pop);
  assign logic_ptr_occupancy = (logic_ptr_push - logic_ptr_popOnIo);
  assign io_push_ready = (! logic_ptr_full);
  assign io_push_fire = (io_push_valid && io_push_ready);
  always @(*) begin
    logic_ptr_doPush = io_push_fire;
    if(logic_ptr_empty) begin
      if(io_pop_ready) begin
        logic_ptr_doPush = 1'b0;
      end
    end
  end

  assign logic_push_onRam_write_valid = io_push_fire;
  assign logic_push_onRam_write_payload_address = logic_ptr_push[1:0];
  assign logic_push_onRam_write_payload_data = io_push_payload;
  assign logic_pop_addressGen_valid = (! logic_ptr_empty);
  assign logic_pop_addressGen_payload = logic_ptr_pop[1:0];
  assign logic_pop_addressGen_fire = (logic_pop_addressGen_valid && logic_pop_addressGen_ready);
  assign logic_ptr_doPop = logic_pop_addressGen_fire;
  assign logic_pop_async_readed = _zz_logic_ram_port1;
  assign logic_pop_addressGen_translated_valid = logic_pop_addressGen_valid;
  assign logic_pop_addressGen_ready = logic_pop_addressGen_translated_ready;
  assign logic_pop_addressGen_translated_payload = logic_pop_async_readed;
  always @(*) begin
    io_pop_valid = logic_pop_addressGen_translated_valid;
    if(logic_ptr_empty) begin
      io_pop_valid = io_push_valid;
    end
  end

  assign logic_pop_addressGen_translated_ready = io_pop_ready;
  always @(*) begin
    io_pop_payload = logic_pop_addressGen_translated_payload;
    if(logic_ptr_empty) begin
      io_pop_payload = io_push_payload;
    end
  end

  assign logic_ptr_popOnIo = logic_ptr_pop;
  assign io_occupancy = logic_ptr_occupancy;
  assign io_availability = (3'b100 - logic_ptr_occupancy);
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      logic_ptr_push <= 3'b000;
      logic_ptr_pop <= 3'b000;
      logic_ptr_wentUp <= 1'b0;
    end else begin
      if(when_Stream_l1205) begin
        logic_ptr_wentUp <= logic_ptr_doPush;
      end
      if(io_flush) begin
        logic_ptr_wentUp <= 1'b0;
      end
      if(logic_ptr_doPush) begin
        logic_ptr_push <= (logic_ptr_push + 3'b001);
      end
      if(logic_ptr_doPop) begin
        logic_ptr_pop <= (logic_ptr_pop + 3'b001);
      end
      if(io_flush) begin
        logic_ptr_push <= 3'b000;
        logic_ptr_pop <= 3'b000;
      end
    end
  end


endmodule
