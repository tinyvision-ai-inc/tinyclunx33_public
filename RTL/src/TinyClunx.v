// Generator : SpinalHDL v1.9.4    git head : 270018552577f3bb8e5339ee2583c9c22d324215
// Component : TinyClunx
// Git hash  : 2162b3ab169125a6ab77aebfffc138824dbded2d

`timescale 1ns/1ps

module TinyClunx (
  input  wire          axiReset,
  input  wire          axiClk,
  input  wire          usbM_aw_valid,
  output wire          usbM_aw_ready,
  input  wire [23:0]   usbM_aw_payload_addr,
  input  wire [7:0]    usbM_aw_payload_id,
  input  wire [7:0]    usbM_aw_payload_len,
  input  wire [2:0]    usbM_aw_payload_size,
  input  wire [1:0]    usbM_aw_payload_burst,
  input  wire [0:0]    usbM_aw_payload_lock,
  input  wire [3:0]    usbM_aw_payload_cache,
  input  wire [2:0]    usbM_aw_payload_prot,
  input  wire          usbM_w_valid,
  output wire          usbM_w_ready,
  input  wire [63:0]   usbM_w_payload_data,
  input  wire [7:0]    usbM_w_payload_strb,
  input  wire          usbM_w_payload_last,
  output wire          usbM_b_valid,
  input  wire          usbM_b_ready,
  output wire [7:0]    usbM_b_payload_id,
  input  wire          usbM_ar_valid,
  output wire          usbM_ar_ready,
  input  wire [23:0]   usbM_ar_payload_addr,
  input  wire [7:0]    usbM_ar_payload_id,
  input  wire [7:0]    usbM_ar_payload_len,
  input  wire [2:0]    usbM_ar_payload_size,
  input  wire [1:0]    usbM_ar_payload_burst,
  input  wire [0:0]    usbM_ar_payload_lock,
  input  wire [3:0]    usbM_ar_payload_cache,
  input  wire [2:0]    usbM_ar_payload_prot,
  output wire          usbM_r_valid,
  input  wire          usbM_r_ready,
  output wire [63:0]   usbM_r_payload_data,
  output wire [7:0]    usbM_r_payload_id,
  output wire          usbM_r_payload_last,
  input  wire          sysM_aw_valid,
  output wire          sysM_aw_ready,
  input  wire [23:0]   sysM_aw_payload_addr,
  input  wire [7:0]    sysM_aw_payload_id,
  input  wire [7:0]    sysM_aw_payload_len,
  input  wire [2:0]    sysM_aw_payload_size,
  input  wire [1:0]    sysM_aw_payload_burst,
  input  wire [0:0]    sysM_aw_payload_lock,
  input  wire [3:0]    sysM_aw_payload_cache,
  input  wire [2:0]    sysM_aw_payload_prot,
  input  wire          sysM_w_valid,
  output wire          sysM_w_ready,
  input  wire [63:0]   sysM_w_payload_data,
  input  wire [7:0]    sysM_w_payload_strb,
  input  wire          sysM_w_payload_last,
  output wire          sysM_b_valid,
  input  wire          sysM_b_ready,
  output wire [7:0]    sysM_b_payload_id,
  input  wire          sysM_ar_valid,
  output wire          sysM_ar_ready,
  input  wire [23:0]   sysM_ar_payload_addr,
  input  wire [7:0]    sysM_ar_payload_id,
  input  wire [7:0]    sysM_ar_payload_len,
  input  wire [2:0]    sysM_ar_payload_size,
  input  wire [1:0]    sysM_ar_payload_burst,
  input  wire [0:0]    sysM_ar_payload_lock,
  input  wire [3:0]    sysM_ar_payload_cache,
  input  wire [2:0]    sysM_ar_payload_prot,
  output wire          sysM_r_valid,
  input  wire          sysM_r_ready,
  output wire [63:0]   sysM_r_payload_data,
  output wire [7:0]    sysM_r_payload_id,
  output wire          sysM_r_payload_last
);

  wire       [9:0]    axi1_ram1_io_axi_arbiter_io_readInputs_0_ar_payload_addr;
  wire       [9:0]    axi1_ram1_io_axi_arbiter_io_readInputs_1_ar_payload_addr;
  wire       [9:0]    axi1_ram1_io_axi_arbiter_io_writeInputs_0_aw_payload_addr;
  wire       [9:0]    axi1_ram1_io_axi_arbiter_io_writeInputs_1_aw_payload_addr;
  wire                axi1_ram1_io_axi_arw_ready;
  wire                axi1_ram1_io_axi_w_ready;
  wire                axi1_ram1_io_axi_b_valid;
  wire       [8:0]    axi1_ram1_io_axi_b_payload_id;
  wire       [1:0]    axi1_ram1_io_axi_b_payload_resp;
  wire                axi1_ram1_io_axi_r_valid;
  wire       [63:0]   axi1_ram1_io_axi_r_payload_data;
  wire       [8:0]    axi1_ram1_io_axi_r_payload_id;
  wire       [1:0]    axi1_ram1_io_axi_r_payload_resp;
  wire                axi1_ram1_io_axi_r_payload_last;
  wire                usbM_readOnly_decoder_io_input_ar_ready;
  wire                usbM_readOnly_decoder_io_input_r_valid;
  wire       [63:0]   usbM_readOnly_decoder_io_input_r_payload_data;
  wire       [7:0]    usbM_readOnly_decoder_io_input_r_payload_id;
  wire                usbM_readOnly_decoder_io_input_r_payload_last;
  wire                usbM_readOnly_decoder_io_outputs_0_ar_valid;
  wire       [23:0]   usbM_readOnly_decoder_io_outputs_0_ar_payload_addr;
  wire       [7:0]    usbM_readOnly_decoder_io_outputs_0_ar_payload_id;
  wire       [7:0]    usbM_readOnly_decoder_io_outputs_0_ar_payload_len;
  wire       [2:0]    usbM_readOnly_decoder_io_outputs_0_ar_payload_size;
  wire       [1:0]    usbM_readOnly_decoder_io_outputs_0_ar_payload_burst;
  wire       [0:0]    usbM_readOnly_decoder_io_outputs_0_ar_payload_lock;
  wire       [3:0]    usbM_readOnly_decoder_io_outputs_0_ar_payload_cache;
  wire       [2:0]    usbM_readOnly_decoder_io_outputs_0_ar_payload_prot;
  wire                usbM_readOnly_decoder_io_outputs_0_r_ready;
  wire                usbM_writeOnly_decoder_io_input_aw_ready;
  wire                usbM_writeOnly_decoder_io_input_w_ready;
  wire                usbM_writeOnly_decoder_io_input_b_valid;
  wire       [7:0]    usbM_writeOnly_decoder_io_input_b_payload_id;
  wire                usbM_writeOnly_decoder_io_outputs_0_aw_valid;
  wire       [23:0]   usbM_writeOnly_decoder_io_outputs_0_aw_payload_addr;
  wire       [7:0]    usbM_writeOnly_decoder_io_outputs_0_aw_payload_id;
  wire       [7:0]    usbM_writeOnly_decoder_io_outputs_0_aw_payload_len;
  wire       [2:0]    usbM_writeOnly_decoder_io_outputs_0_aw_payload_size;
  wire       [1:0]    usbM_writeOnly_decoder_io_outputs_0_aw_payload_burst;
  wire       [0:0]    usbM_writeOnly_decoder_io_outputs_0_aw_payload_lock;
  wire       [3:0]    usbM_writeOnly_decoder_io_outputs_0_aw_payload_cache;
  wire       [2:0]    usbM_writeOnly_decoder_io_outputs_0_aw_payload_prot;
  wire                usbM_writeOnly_decoder_io_outputs_0_w_valid;
  wire       [63:0]   usbM_writeOnly_decoder_io_outputs_0_w_payload_data;
  wire       [7:0]    usbM_writeOnly_decoder_io_outputs_0_w_payload_strb;
  wire                usbM_writeOnly_decoder_io_outputs_0_w_payload_last;
  wire                usbM_writeOnly_decoder_io_outputs_0_b_ready;
  wire                sysM_readOnly_decoder_io_input_ar_ready;
  wire                sysM_readOnly_decoder_io_input_r_valid;
  wire       [63:0]   sysM_readOnly_decoder_io_input_r_payload_data;
  wire       [7:0]    sysM_readOnly_decoder_io_input_r_payload_id;
  wire                sysM_readOnly_decoder_io_input_r_payload_last;
  wire                sysM_readOnly_decoder_io_outputs_0_ar_valid;
  wire       [23:0]   sysM_readOnly_decoder_io_outputs_0_ar_payload_addr;
  wire       [7:0]    sysM_readOnly_decoder_io_outputs_0_ar_payload_id;
  wire       [7:0]    sysM_readOnly_decoder_io_outputs_0_ar_payload_len;
  wire       [2:0]    sysM_readOnly_decoder_io_outputs_0_ar_payload_size;
  wire       [1:0]    sysM_readOnly_decoder_io_outputs_0_ar_payload_burst;
  wire       [0:0]    sysM_readOnly_decoder_io_outputs_0_ar_payload_lock;
  wire       [3:0]    sysM_readOnly_decoder_io_outputs_0_ar_payload_cache;
  wire       [2:0]    sysM_readOnly_decoder_io_outputs_0_ar_payload_prot;
  wire                sysM_readOnly_decoder_io_outputs_0_r_ready;
  wire                sysM_writeOnly_decoder_io_input_aw_ready;
  wire                sysM_writeOnly_decoder_io_input_w_ready;
  wire                sysM_writeOnly_decoder_io_input_b_valid;
  wire       [7:0]    sysM_writeOnly_decoder_io_input_b_payload_id;
  wire                sysM_writeOnly_decoder_io_outputs_0_aw_valid;
  wire       [23:0]   sysM_writeOnly_decoder_io_outputs_0_aw_payload_addr;
  wire       [7:0]    sysM_writeOnly_decoder_io_outputs_0_aw_payload_id;
  wire       [7:0]    sysM_writeOnly_decoder_io_outputs_0_aw_payload_len;
  wire       [2:0]    sysM_writeOnly_decoder_io_outputs_0_aw_payload_size;
  wire       [1:0]    sysM_writeOnly_decoder_io_outputs_0_aw_payload_burst;
  wire       [0:0]    sysM_writeOnly_decoder_io_outputs_0_aw_payload_lock;
  wire       [3:0]    sysM_writeOnly_decoder_io_outputs_0_aw_payload_cache;
  wire       [2:0]    sysM_writeOnly_decoder_io_outputs_0_aw_payload_prot;
  wire                sysM_writeOnly_decoder_io_outputs_0_w_valid;
  wire       [63:0]   sysM_writeOnly_decoder_io_outputs_0_w_payload_data;
  wire       [7:0]    sysM_writeOnly_decoder_io_outputs_0_w_payload_strb;
  wire                sysM_writeOnly_decoder_io_outputs_0_w_payload_last;
  wire                sysM_writeOnly_decoder_io_outputs_0_b_ready;
  wire                axi1_ram1_io_axi_arbiter_io_readInputs_0_ar_ready;
  wire                axi1_ram1_io_axi_arbiter_io_readInputs_0_r_valid;
  wire       [63:0]   axi1_ram1_io_axi_arbiter_io_readInputs_0_r_payload_data;
  wire       [7:0]    axi1_ram1_io_axi_arbiter_io_readInputs_0_r_payload_id;
  wire       [1:0]    axi1_ram1_io_axi_arbiter_io_readInputs_0_r_payload_resp;
  wire                axi1_ram1_io_axi_arbiter_io_readInputs_0_r_payload_last;
  wire                axi1_ram1_io_axi_arbiter_io_readInputs_1_ar_ready;
  wire                axi1_ram1_io_axi_arbiter_io_readInputs_1_r_valid;
  wire       [63:0]   axi1_ram1_io_axi_arbiter_io_readInputs_1_r_payload_data;
  wire       [7:0]    axi1_ram1_io_axi_arbiter_io_readInputs_1_r_payload_id;
  wire       [1:0]    axi1_ram1_io_axi_arbiter_io_readInputs_1_r_payload_resp;
  wire                axi1_ram1_io_axi_arbiter_io_readInputs_1_r_payload_last;
  wire                axi1_ram1_io_axi_arbiter_io_writeInputs_0_aw_ready;
  wire                axi1_ram1_io_axi_arbiter_io_writeInputs_0_w_ready;
  wire                axi1_ram1_io_axi_arbiter_io_writeInputs_0_b_valid;
  wire       [7:0]    axi1_ram1_io_axi_arbiter_io_writeInputs_0_b_payload_id;
  wire       [1:0]    axi1_ram1_io_axi_arbiter_io_writeInputs_0_b_payload_resp;
  wire                axi1_ram1_io_axi_arbiter_io_writeInputs_1_aw_ready;
  wire                axi1_ram1_io_axi_arbiter_io_writeInputs_1_w_ready;
  wire                axi1_ram1_io_axi_arbiter_io_writeInputs_1_b_valid;
  wire       [7:0]    axi1_ram1_io_axi_arbiter_io_writeInputs_1_b_payload_id;
  wire       [1:0]    axi1_ram1_io_axi_arbiter_io_writeInputs_1_b_payload_resp;
  wire                axi1_ram1_io_axi_arbiter_io_output_arw_valid;
  wire       [9:0]    axi1_ram1_io_axi_arbiter_io_output_arw_payload_addr;
  wire       [8:0]    axi1_ram1_io_axi_arbiter_io_output_arw_payload_id;
  wire       [7:0]    axi1_ram1_io_axi_arbiter_io_output_arw_payload_len;
  wire       [2:0]    axi1_ram1_io_axi_arbiter_io_output_arw_payload_size;
  wire       [1:0]    axi1_ram1_io_axi_arbiter_io_output_arw_payload_burst;
  wire                axi1_ram1_io_axi_arbiter_io_output_arw_payload_write;
  wire                axi1_ram1_io_axi_arbiter_io_output_w_valid;
  wire       [63:0]   axi1_ram1_io_axi_arbiter_io_output_w_payload_data;
  wire       [7:0]    axi1_ram1_io_axi_arbiter_io_output_w_payload_strb;
  wire                axi1_ram1_io_axi_arbiter_io_output_w_payload_last;
  wire                axi1_ram1_io_axi_arbiter_io_output_b_ready;
  wire                axi1_ram1_io_axi_arbiter_io_output_r_ready;
  wire                usbM_readOnly_ar_valid;
  wire                usbM_readOnly_ar_ready;
  wire       [23:0]   usbM_readOnly_ar_payload_addr;
  wire       [7:0]    usbM_readOnly_ar_payload_id;
  wire       [7:0]    usbM_readOnly_ar_payload_len;
  wire       [2:0]    usbM_readOnly_ar_payload_size;
  wire       [1:0]    usbM_readOnly_ar_payload_burst;
  wire       [0:0]    usbM_readOnly_ar_payload_lock;
  wire       [3:0]    usbM_readOnly_ar_payload_cache;
  wire       [2:0]    usbM_readOnly_ar_payload_prot;
  wire                usbM_readOnly_r_valid;
  wire                usbM_readOnly_r_ready;
  wire       [63:0]   usbM_readOnly_r_payload_data;
  wire       [7:0]    usbM_readOnly_r_payload_id;
  wire                usbM_readOnly_r_payload_last;
  wire                usbM_writeOnly_aw_valid;
  wire                usbM_writeOnly_aw_ready;
  wire       [23:0]   usbM_writeOnly_aw_payload_addr;
  wire       [7:0]    usbM_writeOnly_aw_payload_id;
  wire       [7:0]    usbM_writeOnly_aw_payload_len;
  wire       [2:0]    usbM_writeOnly_aw_payload_size;
  wire       [1:0]    usbM_writeOnly_aw_payload_burst;
  wire       [0:0]    usbM_writeOnly_aw_payload_lock;
  wire       [3:0]    usbM_writeOnly_aw_payload_cache;
  wire       [2:0]    usbM_writeOnly_aw_payload_prot;
  wire                usbM_writeOnly_w_valid;
  wire                usbM_writeOnly_w_ready;
  wire       [63:0]   usbM_writeOnly_w_payload_data;
  wire       [7:0]    usbM_writeOnly_w_payload_strb;
  wire                usbM_writeOnly_w_payload_last;
  wire                usbM_writeOnly_b_valid;
  wire                usbM_writeOnly_b_ready;
  wire       [7:0]    usbM_writeOnly_b_payload_id;
  wire                sysM_readOnly_ar_valid;
  wire                sysM_readOnly_ar_ready;
  wire       [23:0]   sysM_readOnly_ar_payload_addr;
  wire       [7:0]    sysM_readOnly_ar_payload_id;
  wire       [7:0]    sysM_readOnly_ar_payload_len;
  wire       [2:0]    sysM_readOnly_ar_payload_size;
  wire       [1:0]    sysM_readOnly_ar_payload_burst;
  wire       [0:0]    sysM_readOnly_ar_payload_lock;
  wire       [3:0]    sysM_readOnly_ar_payload_cache;
  wire       [2:0]    sysM_readOnly_ar_payload_prot;
  wire                sysM_readOnly_r_valid;
  wire                sysM_readOnly_r_ready;
  wire       [63:0]   sysM_readOnly_r_payload_data;
  wire       [7:0]    sysM_readOnly_r_payload_id;
  wire                sysM_readOnly_r_payload_last;
  wire                sysM_writeOnly_aw_valid;
  wire                sysM_writeOnly_aw_ready;
  wire       [23:0]   sysM_writeOnly_aw_payload_addr;
  wire       [7:0]    sysM_writeOnly_aw_payload_id;
  wire       [7:0]    sysM_writeOnly_aw_payload_len;
  wire       [2:0]    sysM_writeOnly_aw_payload_size;
  wire       [1:0]    sysM_writeOnly_aw_payload_burst;
  wire       [0:0]    sysM_writeOnly_aw_payload_lock;
  wire       [3:0]    sysM_writeOnly_aw_payload_cache;
  wire       [2:0]    sysM_writeOnly_aw_payload_prot;
  wire                sysM_writeOnly_w_valid;
  wire                sysM_writeOnly_w_ready;
  wire       [63:0]   sysM_writeOnly_w_payload_data;
  wire       [7:0]    sysM_writeOnly_w_payload_strb;
  wire                sysM_writeOnly_w_payload_last;
  wire                sysM_writeOnly_b_valid;
  wire                sysM_writeOnly_b_ready;
  wire       [7:0]    sysM_writeOnly_b_payload_id;
  wire                toplevel_usbM_readOnly_decoder_io_outputs_0_ar_validPipe_valid;
  wire                toplevel_usbM_readOnly_decoder_io_outputs_0_ar_validPipe_ready;
  wire       [23:0]   toplevel_usbM_readOnly_decoder_io_outputs_0_ar_validPipe_payload_addr;
  wire       [7:0]    toplevel_usbM_readOnly_decoder_io_outputs_0_ar_validPipe_payload_id;
  wire       [7:0]    toplevel_usbM_readOnly_decoder_io_outputs_0_ar_validPipe_payload_len;
  wire       [2:0]    toplevel_usbM_readOnly_decoder_io_outputs_0_ar_validPipe_payload_size;
  wire       [1:0]    toplevel_usbM_readOnly_decoder_io_outputs_0_ar_validPipe_payload_burst;
  wire       [0:0]    toplevel_usbM_readOnly_decoder_io_outputs_0_ar_validPipe_payload_lock;
  wire       [3:0]    toplevel_usbM_readOnly_decoder_io_outputs_0_ar_validPipe_payload_cache;
  wire       [2:0]    toplevel_usbM_readOnly_decoder_io_outputs_0_ar_validPipe_payload_prot;
  reg                 toplevel_usbM_readOnly_decoder_io_outputs_0_ar_rValid;
  wire                toplevel_usbM_readOnly_decoder_io_outputs_0_ar_validPipe_fire;
  wire                toplevel_usbM_writeOnly_decoder_io_outputs_0_aw_validPipe_valid;
  wire                toplevel_usbM_writeOnly_decoder_io_outputs_0_aw_validPipe_ready;
  wire       [23:0]   toplevel_usbM_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_addr;
  wire       [7:0]    toplevel_usbM_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_id;
  wire       [7:0]    toplevel_usbM_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_len;
  wire       [2:0]    toplevel_usbM_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_size;
  wire       [1:0]    toplevel_usbM_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_burst;
  wire       [0:0]    toplevel_usbM_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_lock;
  wire       [3:0]    toplevel_usbM_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_cache;
  wire       [2:0]    toplevel_usbM_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_prot;
  reg                 toplevel_usbM_writeOnly_decoder_io_outputs_0_aw_rValid;
  wire                toplevel_usbM_writeOnly_decoder_io_outputs_0_aw_validPipe_fire;
  wire                toplevel_sysM_readOnly_decoder_io_outputs_0_ar_validPipe_valid;
  wire                toplevel_sysM_readOnly_decoder_io_outputs_0_ar_validPipe_ready;
  wire       [23:0]   toplevel_sysM_readOnly_decoder_io_outputs_0_ar_validPipe_payload_addr;
  wire       [7:0]    toplevel_sysM_readOnly_decoder_io_outputs_0_ar_validPipe_payload_id;
  wire       [7:0]    toplevel_sysM_readOnly_decoder_io_outputs_0_ar_validPipe_payload_len;
  wire       [2:0]    toplevel_sysM_readOnly_decoder_io_outputs_0_ar_validPipe_payload_size;
  wire       [1:0]    toplevel_sysM_readOnly_decoder_io_outputs_0_ar_validPipe_payload_burst;
  wire       [0:0]    toplevel_sysM_readOnly_decoder_io_outputs_0_ar_validPipe_payload_lock;
  wire       [3:0]    toplevel_sysM_readOnly_decoder_io_outputs_0_ar_validPipe_payload_cache;
  wire       [2:0]    toplevel_sysM_readOnly_decoder_io_outputs_0_ar_validPipe_payload_prot;
  reg                 toplevel_sysM_readOnly_decoder_io_outputs_0_ar_rValid;
  wire                toplevel_sysM_readOnly_decoder_io_outputs_0_ar_validPipe_fire;
  wire                toplevel_sysM_writeOnly_decoder_io_outputs_0_aw_validPipe_valid;
  wire                toplevel_sysM_writeOnly_decoder_io_outputs_0_aw_validPipe_ready;
  wire       [23:0]   toplevel_sysM_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_addr;
  wire       [7:0]    toplevel_sysM_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_id;
  wire       [7:0]    toplevel_sysM_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_len;
  wire       [2:0]    toplevel_sysM_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_size;
  wire       [1:0]    toplevel_sysM_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_burst;
  wire       [0:0]    toplevel_sysM_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_lock;
  wire       [3:0]    toplevel_sysM_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_cache;
  wire       [2:0]    toplevel_sysM_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_prot;
  reg                 toplevel_sysM_writeOnly_decoder_io_outputs_0_aw_rValid;
  wire                toplevel_sysM_writeOnly_decoder_io_outputs_0_aw_validPipe_fire;

  Axi4SharedOnChipRam axi1_ram1 (
    .io_axi_arw_valid         (axi1_ram1_io_axi_arbiter_io_output_arw_valid             ), //i
    .io_axi_arw_ready         (axi1_ram1_io_axi_arw_ready                               ), //o
    .io_axi_arw_payload_addr  (axi1_ram1_io_axi_arbiter_io_output_arw_payload_addr[9:0] ), //i
    .io_axi_arw_payload_id    (axi1_ram1_io_axi_arbiter_io_output_arw_payload_id[8:0]   ), //i
    .io_axi_arw_payload_len   (axi1_ram1_io_axi_arbiter_io_output_arw_payload_len[7:0]  ), //i
    .io_axi_arw_payload_size  (axi1_ram1_io_axi_arbiter_io_output_arw_payload_size[2:0] ), //i
    .io_axi_arw_payload_burst (axi1_ram1_io_axi_arbiter_io_output_arw_payload_burst[1:0]), //i
    .io_axi_arw_payload_write (axi1_ram1_io_axi_arbiter_io_output_arw_payload_write     ), //i
    .io_axi_w_valid           (axi1_ram1_io_axi_arbiter_io_output_w_valid               ), //i
    .io_axi_w_ready           (axi1_ram1_io_axi_w_ready                                 ), //o
    .io_axi_w_payload_data    (axi1_ram1_io_axi_arbiter_io_output_w_payload_data[63:0]  ), //i
    .io_axi_w_payload_strb    (axi1_ram1_io_axi_arbiter_io_output_w_payload_strb[7:0]   ), //i
    .io_axi_w_payload_last    (axi1_ram1_io_axi_arbiter_io_output_w_payload_last        ), //i
    .io_axi_b_valid           (axi1_ram1_io_axi_b_valid                                 ), //o
    .io_axi_b_ready           (axi1_ram1_io_axi_arbiter_io_output_b_ready               ), //i
    .io_axi_b_payload_id      (axi1_ram1_io_axi_b_payload_id[8:0]                       ), //o
    .io_axi_b_payload_resp    (axi1_ram1_io_axi_b_payload_resp[1:0]                     ), //o
    .io_axi_r_valid           (axi1_ram1_io_axi_r_valid                                 ), //o
    .io_axi_r_ready           (axi1_ram1_io_axi_arbiter_io_output_r_ready               ), //i
    .io_axi_r_payload_data    (axi1_ram1_io_axi_r_payload_data[63:0]                    ), //o
    .io_axi_r_payload_id      (axi1_ram1_io_axi_r_payload_id[8:0]                       ), //o
    .io_axi_r_payload_resp    (axi1_ram1_io_axi_r_payload_resp[1:0]                     ), //o
    .io_axi_r_payload_last    (axi1_ram1_io_axi_r_payload_last                          ), //o
    .axiClk                   (axiClk                                                   ), //i
    .axiReset                 (axiReset                                                 )  //i
  );
  Axi4ReadOnlyDecoder usbM_readOnly_decoder (
    .io_input_ar_valid             (usbM_readOnly_ar_valid                                       ), //i
    .io_input_ar_ready             (usbM_readOnly_decoder_io_input_ar_ready                      ), //o
    .io_input_ar_payload_addr      (usbM_readOnly_ar_payload_addr[23:0]                          ), //i
    .io_input_ar_payload_id        (usbM_readOnly_ar_payload_id[7:0]                             ), //i
    .io_input_ar_payload_len       (usbM_readOnly_ar_payload_len[7:0]                            ), //i
    .io_input_ar_payload_size      (usbM_readOnly_ar_payload_size[2:0]                           ), //i
    .io_input_ar_payload_burst     (usbM_readOnly_ar_payload_burst[1:0]                          ), //i
    .io_input_ar_payload_lock      (usbM_readOnly_ar_payload_lock                                ), //i
    .io_input_ar_payload_cache     (usbM_readOnly_ar_payload_cache[3:0]                          ), //i
    .io_input_ar_payload_prot      (usbM_readOnly_ar_payload_prot[2:0]                           ), //i
    .io_input_r_valid              (usbM_readOnly_decoder_io_input_r_valid                       ), //o
    .io_input_r_ready              (usbM_readOnly_r_ready                                        ), //i
    .io_input_r_payload_data       (usbM_readOnly_decoder_io_input_r_payload_data[63:0]          ), //o
    .io_input_r_payload_id         (usbM_readOnly_decoder_io_input_r_payload_id[7:0]             ), //o
    .io_input_r_payload_last       (usbM_readOnly_decoder_io_input_r_payload_last                ), //o
    .io_outputs_0_ar_valid         (usbM_readOnly_decoder_io_outputs_0_ar_valid                  ), //o
    .io_outputs_0_ar_ready         (toplevel_usbM_readOnly_decoder_io_outputs_0_ar_validPipe_fire), //i
    .io_outputs_0_ar_payload_addr  (usbM_readOnly_decoder_io_outputs_0_ar_payload_addr[23:0]     ), //o
    .io_outputs_0_ar_payload_id    (usbM_readOnly_decoder_io_outputs_0_ar_payload_id[7:0]        ), //o
    .io_outputs_0_ar_payload_len   (usbM_readOnly_decoder_io_outputs_0_ar_payload_len[7:0]       ), //o
    .io_outputs_0_ar_payload_size  (usbM_readOnly_decoder_io_outputs_0_ar_payload_size[2:0]      ), //o
    .io_outputs_0_ar_payload_burst (usbM_readOnly_decoder_io_outputs_0_ar_payload_burst[1:0]     ), //o
    .io_outputs_0_ar_payload_lock  (usbM_readOnly_decoder_io_outputs_0_ar_payload_lock           ), //o
    .io_outputs_0_ar_payload_cache (usbM_readOnly_decoder_io_outputs_0_ar_payload_cache[3:0]     ), //o
    .io_outputs_0_ar_payload_prot  (usbM_readOnly_decoder_io_outputs_0_ar_payload_prot[2:0]      ), //o
    .io_outputs_0_r_valid          (axi1_ram1_io_axi_arbiter_io_readInputs_0_r_valid             ), //i
    .io_outputs_0_r_ready          (usbM_readOnly_decoder_io_outputs_0_r_ready                   ), //o
    .io_outputs_0_r_payload_data   (axi1_ram1_io_axi_arbiter_io_readInputs_0_r_payload_data[63:0]), //i
    .io_outputs_0_r_payload_id     (axi1_ram1_io_axi_arbiter_io_readInputs_0_r_payload_id[7:0]   ), //i
    .io_outputs_0_r_payload_last   (axi1_ram1_io_axi_arbiter_io_readInputs_0_r_payload_last      ), //i
    .axiClk                        (axiClk                                                       ), //i
    .axiReset                      (axiReset                                                     )  //i
  );
  Axi4WriteOnlyDecoder usbM_writeOnly_decoder (
    .io_input_aw_valid             (usbM_writeOnly_aw_valid                                       ), //i
    .io_input_aw_ready             (usbM_writeOnly_decoder_io_input_aw_ready                      ), //o
    .io_input_aw_payload_addr      (usbM_writeOnly_aw_payload_addr[23:0]                          ), //i
    .io_input_aw_payload_id        (usbM_writeOnly_aw_payload_id[7:0]                             ), //i
    .io_input_aw_payload_len       (usbM_writeOnly_aw_payload_len[7:0]                            ), //i
    .io_input_aw_payload_size      (usbM_writeOnly_aw_payload_size[2:0]                           ), //i
    .io_input_aw_payload_burst     (usbM_writeOnly_aw_payload_burst[1:0]                          ), //i
    .io_input_aw_payload_lock      (usbM_writeOnly_aw_payload_lock                                ), //i
    .io_input_aw_payload_cache     (usbM_writeOnly_aw_payload_cache[3:0]                          ), //i
    .io_input_aw_payload_prot      (usbM_writeOnly_aw_payload_prot[2:0]                           ), //i
    .io_input_w_valid              (usbM_writeOnly_w_valid                                        ), //i
    .io_input_w_ready              (usbM_writeOnly_decoder_io_input_w_ready                       ), //o
    .io_input_w_payload_data       (usbM_writeOnly_w_payload_data[63:0]                           ), //i
    .io_input_w_payload_strb       (usbM_writeOnly_w_payload_strb[7:0]                            ), //i
    .io_input_w_payload_last       (usbM_writeOnly_w_payload_last                                 ), //i
    .io_input_b_valid              (usbM_writeOnly_decoder_io_input_b_valid                       ), //o
    .io_input_b_ready              (usbM_writeOnly_b_ready                                        ), //i
    .io_input_b_payload_id         (usbM_writeOnly_decoder_io_input_b_payload_id[7:0]             ), //o
    .io_outputs_0_aw_valid         (usbM_writeOnly_decoder_io_outputs_0_aw_valid                  ), //o
    .io_outputs_0_aw_ready         (toplevel_usbM_writeOnly_decoder_io_outputs_0_aw_validPipe_fire), //i
    .io_outputs_0_aw_payload_addr  (usbM_writeOnly_decoder_io_outputs_0_aw_payload_addr[23:0]     ), //o
    .io_outputs_0_aw_payload_id    (usbM_writeOnly_decoder_io_outputs_0_aw_payload_id[7:0]        ), //o
    .io_outputs_0_aw_payload_len   (usbM_writeOnly_decoder_io_outputs_0_aw_payload_len[7:0]       ), //o
    .io_outputs_0_aw_payload_size  (usbM_writeOnly_decoder_io_outputs_0_aw_payload_size[2:0]      ), //o
    .io_outputs_0_aw_payload_burst (usbM_writeOnly_decoder_io_outputs_0_aw_payload_burst[1:0]     ), //o
    .io_outputs_0_aw_payload_lock  (usbM_writeOnly_decoder_io_outputs_0_aw_payload_lock           ), //o
    .io_outputs_0_aw_payload_cache (usbM_writeOnly_decoder_io_outputs_0_aw_payload_cache[3:0]     ), //o
    .io_outputs_0_aw_payload_prot  (usbM_writeOnly_decoder_io_outputs_0_aw_payload_prot[2:0]      ), //o
    .io_outputs_0_w_valid          (usbM_writeOnly_decoder_io_outputs_0_w_valid                   ), //o
    .io_outputs_0_w_ready          (axi1_ram1_io_axi_arbiter_io_writeInputs_0_w_ready             ), //i
    .io_outputs_0_w_payload_data   (usbM_writeOnly_decoder_io_outputs_0_w_payload_data[63:0]      ), //o
    .io_outputs_0_w_payload_strb   (usbM_writeOnly_decoder_io_outputs_0_w_payload_strb[7:0]       ), //o
    .io_outputs_0_w_payload_last   (usbM_writeOnly_decoder_io_outputs_0_w_payload_last            ), //o
    .io_outputs_0_b_valid          (axi1_ram1_io_axi_arbiter_io_writeInputs_0_b_valid             ), //i
    .io_outputs_0_b_ready          (usbM_writeOnly_decoder_io_outputs_0_b_ready                   ), //o
    .io_outputs_0_b_payload_id     (axi1_ram1_io_axi_arbiter_io_writeInputs_0_b_payload_id[7:0]   ), //i
    .axiClk                        (axiClk                                                        ), //i
    .axiReset                      (axiReset                                                      )  //i
  );
  Axi4ReadOnlyDecoder sysM_readOnly_decoder (
    .io_input_ar_valid             (sysM_readOnly_ar_valid                                       ), //i
    .io_input_ar_ready             (sysM_readOnly_decoder_io_input_ar_ready                      ), //o
    .io_input_ar_payload_addr      (sysM_readOnly_ar_payload_addr[23:0]                          ), //i
    .io_input_ar_payload_id        (sysM_readOnly_ar_payload_id[7:0]                             ), //i
    .io_input_ar_payload_len       (sysM_readOnly_ar_payload_len[7:0]                            ), //i
    .io_input_ar_payload_size      (sysM_readOnly_ar_payload_size[2:0]                           ), //i
    .io_input_ar_payload_burst     (sysM_readOnly_ar_payload_burst[1:0]                          ), //i
    .io_input_ar_payload_lock      (sysM_readOnly_ar_payload_lock                                ), //i
    .io_input_ar_payload_cache     (sysM_readOnly_ar_payload_cache[3:0]                          ), //i
    .io_input_ar_payload_prot      (sysM_readOnly_ar_payload_prot[2:0]                           ), //i
    .io_input_r_valid              (sysM_readOnly_decoder_io_input_r_valid                       ), //o
    .io_input_r_ready              (sysM_readOnly_r_ready                                        ), //i
    .io_input_r_payload_data       (sysM_readOnly_decoder_io_input_r_payload_data[63:0]          ), //o
    .io_input_r_payload_id         (sysM_readOnly_decoder_io_input_r_payload_id[7:0]             ), //o
    .io_input_r_payload_last       (sysM_readOnly_decoder_io_input_r_payload_last                ), //o
    .io_outputs_0_ar_valid         (sysM_readOnly_decoder_io_outputs_0_ar_valid                  ), //o
    .io_outputs_0_ar_ready         (toplevel_sysM_readOnly_decoder_io_outputs_0_ar_validPipe_fire), //i
    .io_outputs_0_ar_payload_addr  (sysM_readOnly_decoder_io_outputs_0_ar_payload_addr[23:0]     ), //o
    .io_outputs_0_ar_payload_id    (sysM_readOnly_decoder_io_outputs_0_ar_payload_id[7:0]        ), //o
    .io_outputs_0_ar_payload_len   (sysM_readOnly_decoder_io_outputs_0_ar_payload_len[7:0]       ), //o
    .io_outputs_0_ar_payload_size  (sysM_readOnly_decoder_io_outputs_0_ar_payload_size[2:0]      ), //o
    .io_outputs_0_ar_payload_burst (sysM_readOnly_decoder_io_outputs_0_ar_payload_burst[1:0]     ), //o
    .io_outputs_0_ar_payload_lock  (sysM_readOnly_decoder_io_outputs_0_ar_payload_lock           ), //o
    .io_outputs_0_ar_payload_cache (sysM_readOnly_decoder_io_outputs_0_ar_payload_cache[3:0]     ), //o
    .io_outputs_0_ar_payload_prot  (sysM_readOnly_decoder_io_outputs_0_ar_payload_prot[2:0]      ), //o
    .io_outputs_0_r_valid          (axi1_ram1_io_axi_arbiter_io_readInputs_1_r_valid             ), //i
    .io_outputs_0_r_ready          (sysM_readOnly_decoder_io_outputs_0_r_ready                   ), //o
    .io_outputs_0_r_payload_data   (axi1_ram1_io_axi_arbiter_io_readInputs_1_r_payload_data[63:0]), //i
    .io_outputs_0_r_payload_id     (axi1_ram1_io_axi_arbiter_io_readInputs_1_r_payload_id[7:0]   ), //i
    .io_outputs_0_r_payload_last   (axi1_ram1_io_axi_arbiter_io_readInputs_1_r_payload_last      ), //i
    .axiClk                        (axiClk                                                       ), //i
    .axiReset                      (axiReset                                                     )  //i
  );
  Axi4WriteOnlyDecoder sysM_writeOnly_decoder (
    .io_input_aw_valid             (sysM_writeOnly_aw_valid                                       ), //i
    .io_input_aw_ready             (sysM_writeOnly_decoder_io_input_aw_ready                      ), //o
    .io_input_aw_payload_addr      (sysM_writeOnly_aw_payload_addr[23:0]                          ), //i
    .io_input_aw_payload_id        (sysM_writeOnly_aw_payload_id[7:0]                             ), //i
    .io_input_aw_payload_len       (sysM_writeOnly_aw_payload_len[7:0]                            ), //i
    .io_input_aw_payload_size      (sysM_writeOnly_aw_payload_size[2:0]                           ), //i
    .io_input_aw_payload_burst     (sysM_writeOnly_aw_payload_burst[1:0]                          ), //i
    .io_input_aw_payload_lock      (sysM_writeOnly_aw_payload_lock                                ), //i
    .io_input_aw_payload_cache     (sysM_writeOnly_aw_payload_cache[3:0]                          ), //i
    .io_input_aw_payload_prot      (sysM_writeOnly_aw_payload_prot[2:0]                           ), //i
    .io_input_w_valid              (sysM_writeOnly_w_valid                                        ), //i
    .io_input_w_ready              (sysM_writeOnly_decoder_io_input_w_ready                       ), //o
    .io_input_w_payload_data       (sysM_writeOnly_w_payload_data[63:0]                           ), //i
    .io_input_w_payload_strb       (sysM_writeOnly_w_payload_strb[7:0]                            ), //i
    .io_input_w_payload_last       (sysM_writeOnly_w_payload_last                                 ), //i
    .io_input_b_valid              (sysM_writeOnly_decoder_io_input_b_valid                       ), //o
    .io_input_b_ready              (sysM_writeOnly_b_ready                                        ), //i
    .io_input_b_payload_id         (sysM_writeOnly_decoder_io_input_b_payload_id[7:0]             ), //o
    .io_outputs_0_aw_valid         (sysM_writeOnly_decoder_io_outputs_0_aw_valid                  ), //o
    .io_outputs_0_aw_ready         (toplevel_sysM_writeOnly_decoder_io_outputs_0_aw_validPipe_fire), //i
    .io_outputs_0_aw_payload_addr  (sysM_writeOnly_decoder_io_outputs_0_aw_payload_addr[23:0]     ), //o
    .io_outputs_0_aw_payload_id    (sysM_writeOnly_decoder_io_outputs_0_aw_payload_id[7:0]        ), //o
    .io_outputs_0_aw_payload_len   (sysM_writeOnly_decoder_io_outputs_0_aw_payload_len[7:0]       ), //o
    .io_outputs_0_aw_payload_size  (sysM_writeOnly_decoder_io_outputs_0_aw_payload_size[2:0]      ), //o
    .io_outputs_0_aw_payload_burst (sysM_writeOnly_decoder_io_outputs_0_aw_payload_burst[1:0]     ), //o
    .io_outputs_0_aw_payload_lock  (sysM_writeOnly_decoder_io_outputs_0_aw_payload_lock           ), //o
    .io_outputs_0_aw_payload_cache (sysM_writeOnly_decoder_io_outputs_0_aw_payload_cache[3:0]     ), //o
    .io_outputs_0_aw_payload_prot  (sysM_writeOnly_decoder_io_outputs_0_aw_payload_prot[2:0]      ), //o
    .io_outputs_0_w_valid          (sysM_writeOnly_decoder_io_outputs_0_w_valid                   ), //o
    .io_outputs_0_w_ready          (axi1_ram1_io_axi_arbiter_io_writeInputs_1_w_ready             ), //i
    .io_outputs_0_w_payload_data   (sysM_writeOnly_decoder_io_outputs_0_w_payload_data[63:0]      ), //o
    .io_outputs_0_w_payload_strb   (sysM_writeOnly_decoder_io_outputs_0_w_payload_strb[7:0]       ), //o
    .io_outputs_0_w_payload_last   (sysM_writeOnly_decoder_io_outputs_0_w_payload_last            ), //o
    .io_outputs_0_b_valid          (axi1_ram1_io_axi_arbiter_io_writeInputs_1_b_valid             ), //i
    .io_outputs_0_b_ready          (sysM_writeOnly_decoder_io_outputs_0_b_ready                   ), //o
    .io_outputs_0_b_payload_id     (axi1_ram1_io_axi_arbiter_io_writeInputs_1_b_payload_id[7:0]   ), //i
    .axiClk                        (axiClk                                                        ), //i
    .axiReset                      (axiReset                                                      )  //i
  );
  Axi4SharedArbiter axi1_ram1_io_axi_arbiter (
    .io_readInputs_0_ar_valid          (toplevel_usbM_readOnly_decoder_io_outputs_0_ar_validPipe_valid              ), //i
    .io_readInputs_0_ar_ready          (axi1_ram1_io_axi_arbiter_io_readInputs_0_ar_ready                           ), //o
    .io_readInputs_0_ar_payload_addr   (axi1_ram1_io_axi_arbiter_io_readInputs_0_ar_payload_addr[9:0]               ), //i
    .io_readInputs_0_ar_payload_id     (toplevel_usbM_readOnly_decoder_io_outputs_0_ar_validPipe_payload_id[7:0]    ), //i
    .io_readInputs_0_ar_payload_len    (toplevel_usbM_readOnly_decoder_io_outputs_0_ar_validPipe_payload_len[7:0]   ), //i
    .io_readInputs_0_ar_payload_size   (toplevel_usbM_readOnly_decoder_io_outputs_0_ar_validPipe_payload_size[2:0]  ), //i
    .io_readInputs_0_ar_payload_burst  (toplevel_usbM_readOnly_decoder_io_outputs_0_ar_validPipe_payload_burst[1:0] ), //i
    .io_readInputs_0_r_valid           (axi1_ram1_io_axi_arbiter_io_readInputs_0_r_valid                            ), //o
    .io_readInputs_0_r_ready           (usbM_readOnly_decoder_io_outputs_0_r_ready                                  ), //i
    .io_readInputs_0_r_payload_data    (axi1_ram1_io_axi_arbiter_io_readInputs_0_r_payload_data[63:0]               ), //o
    .io_readInputs_0_r_payload_id      (axi1_ram1_io_axi_arbiter_io_readInputs_0_r_payload_id[7:0]                  ), //o
    .io_readInputs_0_r_payload_resp    (axi1_ram1_io_axi_arbiter_io_readInputs_0_r_payload_resp[1:0]                ), //o
    .io_readInputs_0_r_payload_last    (axi1_ram1_io_axi_arbiter_io_readInputs_0_r_payload_last                     ), //o
    .io_readInputs_1_ar_valid          (toplevel_sysM_readOnly_decoder_io_outputs_0_ar_validPipe_valid              ), //i
    .io_readInputs_1_ar_ready          (axi1_ram1_io_axi_arbiter_io_readInputs_1_ar_ready                           ), //o
    .io_readInputs_1_ar_payload_addr   (axi1_ram1_io_axi_arbiter_io_readInputs_1_ar_payload_addr[9:0]               ), //i
    .io_readInputs_1_ar_payload_id     (toplevel_sysM_readOnly_decoder_io_outputs_0_ar_validPipe_payload_id[7:0]    ), //i
    .io_readInputs_1_ar_payload_len    (toplevel_sysM_readOnly_decoder_io_outputs_0_ar_validPipe_payload_len[7:0]   ), //i
    .io_readInputs_1_ar_payload_size   (toplevel_sysM_readOnly_decoder_io_outputs_0_ar_validPipe_payload_size[2:0]  ), //i
    .io_readInputs_1_ar_payload_burst  (toplevel_sysM_readOnly_decoder_io_outputs_0_ar_validPipe_payload_burst[1:0] ), //i
    .io_readInputs_1_r_valid           (axi1_ram1_io_axi_arbiter_io_readInputs_1_r_valid                            ), //o
    .io_readInputs_1_r_ready           (sysM_readOnly_decoder_io_outputs_0_r_ready                                  ), //i
    .io_readInputs_1_r_payload_data    (axi1_ram1_io_axi_arbiter_io_readInputs_1_r_payload_data[63:0]               ), //o
    .io_readInputs_1_r_payload_id      (axi1_ram1_io_axi_arbiter_io_readInputs_1_r_payload_id[7:0]                  ), //o
    .io_readInputs_1_r_payload_resp    (axi1_ram1_io_axi_arbiter_io_readInputs_1_r_payload_resp[1:0]                ), //o
    .io_readInputs_1_r_payload_last    (axi1_ram1_io_axi_arbiter_io_readInputs_1_r_payload_last                     ), //o
    .io_writeInputs_0_aw_valid         (toplevel_usbM_writeOnly_decoder_io_outputs_0_aw_validPipe_valid             ), //i
    .io_writeInputs_0_aw_ready         (axi1_ram1_io_axi_arbiter_io_writeInputs_0_aw_ready                          ), //o
    .io_writeInputs_0_aw_payload_addr  (axi1_ram1_io_axi_arbiter_io_writeInputs_0_aw_payload_addr[9:0]              ), //i
    .io_writeInputs_0_aw_payload_id    (toplevel_usbM_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_id[7:0]   ), //i
    .io_writeInputs_0_aw_payload_len   (toplevel_usbM_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_len[7:0]  ), //i
    .io_writeInputs_0_aw_payload_size  (toplevel_usbM_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_size[2:0] ), //i
    .io_writeInputs_0_aw_payload_burst (toplevel_usbM_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_burst[1:0]), //i
    .io_writeInputs_0_w_valid          (usbM_writeOnly_decoder_io_outputs_0_w_valid                                 ), //i
    .io_writeInputs_0_w_ready          (axi1_ram1_io_axi_arbiter_io_writeInputs_0_w_ready                           ), //o
    .io_writeInputs_0_w_payload_data   (usbM_writeOnly_decoder_io_outputs_0_w_payload_data[63:0]                    ), //i
    .io_writeInputs_0_w_payload_strb   (usbM_writeOnly_decoder_io_outputs_0_w_payload_strb[7:0]                     ), //i
    .io_writeInputs_0_w_payload_last   (usbM_writeOnly_decoder_io_outputs_0_w_payload_last                          ), //i
    .io_writeInputs_0_b_valid          (axi1_ram1_io_axi_arbiter_io_writeInputs_0_b_valid                           ), //o
    .io_writeInputs_0_b_ready          (usbM_writeOnly_decoder_io_outputs_0_b_ready                                 ), //i
    .io_writeInputs_0_b_payload_id     (axi1_ram1_io_axi_arbiter_io_writeInputs_0_b_payload_id[7:0]                 ), //o
    .io_writeInputs_0_b_payload_resp   (axi1_ram1_io_axi_arbiter_io_writeInputs_0_b_payload_resp[1:0]               ), //o
    .io_writeInputs_1_aw_valid         (toplevel_sysM_writeOnly_decoder_io_outputs_0_aw_validPipe_valid             ), //i
    .io_writeInputs_1_aw_ready         (axi1_ram1_io_axi_arbiter_io_writeInputs_1_aw_ready                          ), //o
    .io_writeInputs_1_aw_payload_addr  (axi1_ram1_io_axi_arbiter_io_writeInputs_1_aw_payload_addr[9:0]              ), //i
    .io_writeInputs_1_aw_payload_id    (toplevel_sysM_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_id[7:0]   ), //i
    .io_writeInputs_1_aw_payload_len   (toplevel_sysM_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_len[7:0]  ), //i
    .io_writeInputs_1_aw_payload_size  (toplevel_sysM_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_size[2:0] ), //i
    .io_writeInputs_1_aw_payload_burst (toplevel_sysM_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_burst[1:0]), //i
    .io_writeInputs_1_w_valid          (sysM_writeOnly_decoder_io_outputs_0_w_valid                                 ), //i
    .io_writeInputs_1_w_ready          (axi1_ram1_io_axi_arbiter_io_writeInputs_1_w_ready                           ), //o
    .io_writeInputs_1_w_payload_data   (sysM_writeOnly_decoder_io_outputs_0_w_payload_data[63:0]                    ), //i
    .io_writeInputs_1_w_payload_strb   (sysM_writeOnly_decoder_io_outputs_0_w_payload_strb[7:0]                     ), //i
    .io_writeInputs_1_w_payload_last   (sysM_writeOnly_decoder_io_outputs_0_w_payload_last                          ), //i
    .io_writeInputs_1_b_valid          (axi1_ram1_io_axi_arbiter_io_writeInputs_1_b_valid                           ), //o
    .io_writeInputs_1_b_ready          (sysM_writeOnly_decoder_io_outputs_0_b_ready                                 ), //i
    .io_writeInputs_1_b_payload_id     (axi1_ram1_io_axi_arbiter_io_writeInputs_1_b_payload_id[7:0]                 ), //o
    .io_writeInputs_1_b_payload_resp   (axi1_ram1_io_axi_arbiter_io_writeInputs_1_b_payload_resp[1:0]               ), //o
    .io_output_arw_valid               (axi1_ram1_io_axi_arbiter_io_output_arw_valid                                ), //o
    .io_output_arw_ready               (axi1_ram1_io_axi_arw_ready                                                  ), //i
    .io_output_arw_payload_addr        (axi1_ram1_io_axi_arbiter_io_output_arw_payload_addr[9:0]                    ), //o
    .io_output_arw_payload_id          (axi1_ram1_io_axi_arbiter_io_output_arw_payload_id[8:0]                      ), //o
    .io_output_arw_payload_len         (axi1_ram1_io_axi_arbiter_io_output_arw_payload_len[7:0]                     ), //o
    .io_output_arw_payload_size        (axi1_ram1_io_axi_arbiter_io_output_arw_payload_size[2:0]                    ), //o
    .io_output_arw_payload_burst       (axi1_ram1_io_axi_arbiter_io_output_arw_payload_burst[1:0]                   ), //o
    .io_output_arw_payload_write       (axi1_ram1_io_axi_arbiter_io_output_arw_payload_write                        ), //o
    .io_output_w_valid                 (axi1_ram1_io_axi_arbiter_io_output_w_valid                                  ), //o
    .io_output_w_ready                 (axi1_ram1_io_axi_w_ready                                                    ), //i
    .io_output_w_payload_data          (axi1_ram1_io_axi_arbiter_io_output_w_payload_data[63:0]                     ), //o
    .io_output_w_payload_strb          (axi1_ram1_io_axi_arbiter_io_output_w_payload_strb[7:0]                      ), //o
    .io_output_w_payload_last          (axi1_ram1_io_axi_arbiter_io_output_w_payload_last                           ), //o
    .io_output_b_valid                 (axi1_ram1_io_axi_b_valid                                                    ), //i
    .io_output_b_ready                 (axi1_ram1_io_axi_arbiter_io_output_b_ready                                  ), //o
    .io_output_b_payload_id            (axi1_ram1_io_axi_b_payload_id[8:0]                                          ), //i
    .io_output_b_payload_resp          (axi1_ram1_io_axi_b_payload_resp[1:0]                                        ), //i
    .io_output_r_valid                 (axi1_ram1_io_axi_r_valid                                                    ), //i
    .io_output_r_ready                 (axi1_ram1_io_axi_arbiter_io_output_r_ready                                  ), //o
    .io_output_r_payload_data          (axi1_ram1_io_axi_r_payload_data[63:0]                                       ), //i
    .io_output_r_payload_id            (axi1_ram1_io_axi_r_payload_id[8:0]                                          ), //i
    .io_output_r_payload_resp          (axi1_ram1_io_axi_r_payload_resp[1:0]                                        ), //i
    .io_output_r_payload_last          (axi1_ram1_io_axi_r_payload_last                                             ), //i
    .axiClk                            (axiClk                                                                      ), //i
    .axiReset                          (axiReset                                                                    )  //i
  );
  assign usbM_readOnly_ar_valid = usbM_ar_valid;
  assign usbM_ar_ready = usbM_readOnly_ar_ready;
  assign usbM_readOnly_ar_payload_addr = usbM_ar_payload_addr;
  assign usbM_readOnly_ar_payload_id = usbM_ar_payload_id;
  assign usbM_readOnly_ar_payload_len = usbM_ar_payload_len;
  assign usbM_readOnly_ar_payload_size = usbM_ar_payload_size;
  assign usbM_readOnly_ar_payload_burst = usbM_ar_payload_burst;
  assign usbM_readOnly_ar_payload_lock = usbM_ar_payload_lock;
  assign usbM_readOnly_ar_payload_cache = usbM_ar_payload_cache;
  assign usbM_readOnly_ar_payload_prot = usbM_ar_payload_prot;
  assign usbM_r_valid = usbM_readOnly_r_valid;
  assign usbM_readOnly_r_ready = usbM_r_ready;
  assign usbM_r_payload_data = usbM_readOnly_r_payload_data;
  assign usbM_r_payload_last = usbM_readOnly_r_payload_last;
  assign usbM_r_payload_id = usbM_readOnly_r_payload_id;
  assign usbM_writeOnly_aw_valid = usbM_aw_valid;
  assign usbM_aw_ready = usbM_writeOnly_aw_ready;
  assign usbM_writeOnly_aw_payload_addr = usbM_aw_payload_addr;
  assign usbM_writeOnly_aw_payload_id = usbM_aw_payload_id;
  assign usbM_writeOnly_aw_payload_len = usbM_aw_payload_len;
  assign usbM_writeOnly_aw_payload_size = usbM_aw_payload_size;
  assign usbM_writeOnly_aw_payload_burst = usbM_aw_payload_burst;
  assign usbM_writeOnly_aw_payload_lock = usbM_aw_payload_lock;
  assign usbM_writeOnly_aw_payload_cache = usbM_aw_payload_cache;
  assign usbM_writeOnly_aw_payload_prot = usbM_aw_payload_prot;
  assign usbM_writeOnly_w_valid = usbM_w_valid;
  assign usbM_w_ready = usbM_writeOnly_w_ready;
  assign usbM_writeOnly_w_payload_data = usbM_w_payload_data;
  assign usbM_writeOnly_w_payload_strb = usbM_w_payload_strb;
  assign usbM_writeOnly_w_payload_last = usbM_w_payload_last;
  assign usbM_b_valid = usbM_writeOnly_b_valid;
  assign usbM_writeOnly_b_ready = usbM_b_ready;
  assign usbM_b_payload_id = usbM_writeOnly_b_payload_id;
  assign sysM_readOnly_ar_valid = sysM_ar_valid;
  assign sysM_ar_ready = sysM_readOnly_ar_ready;
  assign sysM_readOnly_ar_payload_addr = sysM_ar_payload_addr;
  assign sysM_readOnly_ar_payload_id = sysM_ar_payload_id;
  assign sysM_readOnly_ar_payload_len = sysM_ar_payload_len;
  assign sysM_readOnly_ar_payload_size = sysM_ar_payload_size;
  assign sysM_readOnly_ar_payload_burst = sysM_ar_payload_burst;
  assign sysM_readOnly_ar_payload_lock = sysM_ar_payload_lock;
  assign sysM_readOnly_ar_payload_cache = sysM_ar_payload_cache;
  assign sysM_readOnly_ar_payload_prot = sysM_ar_payload_prot;
  assign sysM_r_valid = sysM_readOnly_r_valid;
  assign sysM_readOnly_r_ready = sysM_r_ready;
  assign sysM_r_payload_data = sysM_readOnly_r_payload_data;
  assign sysM_r_payload_last = sysM_readOnly_r_payload_last;
  assign sysM_r_payload_id = sysM_readOnly_r_payload_id;
  assign sysM_writeOnly_aw_valid = sysM_aw_valid;
  assign sysM_aw_ready = sysM_writeOnly_aw_ready;
  assign sysM_writeOnly_aw_payload_addr = sysM_aw_payload_addr;
  assign sysM_writeOnly_aw_payload_id = sysM_aw_payload_id;
  assign sysM_writeOnly_aw_payload_len = sysM_aw_payload_len;
  assign sysM_writeOnly_aw_payload_size = sysM_aw_payload_size;
  assign sysM_writeOnly_aw_payload_burst = sysM_aw_payload_burst;
  assign sysM_writeOnly_aw_payload_lock = sysM_aw_payload_lock;
  assign sysM_writeOnly_aw_payload_cache = sysM_aw_payload_cache;
  assign sysM_writeOnly_aw_payload_prot = sysM_aw_payload_prot;
  assign sysM_writeOnly_w_valid = sysM_w_valid;
  assign sysM_w_ready = sysM_writeOnly_w_ready;
  assign sysM_writeOnly_w_payload_data = sysM_w_payload_data;
  assign sysM_writeOnly_w_payload_strb = sysM_w_payload_strb;
  assign sysM_writeOnly_w_payload_last = sysM_w_payload_last;
  assign sysM_b_valid = sysM_writeOnly_b_valid;
  assign sysM_writeOnly_b_ready = sysM_b_ready;
  assign sysM_b_payload_id = sysM_writeOnly_b_payload_id;
  assign toplevel_usbM_readOnly_decoder_io_outputs_0_ar_validPipe_fire = (toplevel_usbM_readOnly_decoder_io_outputs_0_ar_validPipe_valid && toplevel_usbM_readOnly_decoder_io_outputs_0_ar_validPipe_ready);
  assign toplevel_usbM_readOnly_decoder_io_outputs_0_ar_validPipe_valid = toplevel_usbM_readOnly_decoder_io_outputs_0_ar_rValid;
  assign toplevel_usbM_readOnly_decoder_io_outputs_0_ar_validPipe_payload_addr = usbM_readOnly_decoder_io_outputs_0_ar_payload_addr;
  assign toplevel_usbM_readOnly_decoder_io_outputs_0_ar_validPipe_payload_id = usbM_readOnly_decoder_io_outputs_0_ar_payload_id;
  assign toplevel_usbM_readOnly_decoder_io_outputs_0_ar_validPipe_payload_len = usbM_readOnly_decoder_io_outputs_0_ar_payload_len;
  assign toplevel_usbM_readOnly_decoder_io_outputs_0_ar_validPipe_payload_size = usbM_readOnly_decoder_io_outputs_0_ar_payload_size;
  assign toplevel_usbM_readOnly_decoder_io_outputs_0_ar_validPipe_payload_burst = usbM_readOnly_decoder_io_outputs_0_ar_payload_burst;
  assign toplevel_usbM_readOnly_decoder_io_outputs_0_ar_validPipe_payload_lock = usbM_readOnly_decoder_io_outputs_0_ar_payload_lock;
  assign toplevel_usbM_readOnly_decoder_io_outputs_0_ar_validPipe_payload_cache = usbM_readOnly_decoder_io_outputs_0_ar_payload_cache;
  assign toplevel_usbM_readOnly_decoder_io_outputs_0_ar_validPipe_payload_prot = usbM_readOnly_decoder_io_outputs_0_ar_payload_prot;
  assign toplevel_usbM_readOnly_decoder_io_outputs_0_ar_validPipe_ready = axi1_ram1_io_axi_arbiter_io_readInputs_0_ar_ready;
  assign usbM_readOnly_ar_ready = usbM_readOnly_decoder_io_input_ar_ready;
  assign usbM_readOnly_r_valid = usbM_readOnly_decoder_io_input_r_valid;
  assign usbM_readOnly_r_payload_data = usbM_readOnly_decoder_io_input_r_payload_data;
  assign usbM_readOnly_r_payload_last = usbM_readOnly_decoder_io_input_r_payload_last;
  assign usbM_readOnly_r_payload_id = usbM_readOnly_decoder_io_input_r_payload_id;
  assign toplevel_usbM_writeOnly_decoder_io_outputs_0_aw_validPipe_fire = (toplevel_usbM_writeOnly_decoder_io_outputs_0_aw_validPipe_valid && toplevel_usbM_writeOnly_decoder_io_outputs_0_aw_validPipe_ready);
  assign toplevel_usbM_writeOnly_decoder_io_outputs_0_aw_validPipe_valid = toplevel_usbM_writeOnly_decoder_io_outputs_0_aw_rValid;
  assign toplevel_usbM_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_addr = usbM_writeOnly_decoder_io_outputs_0_aw_payload_addr;
  assign toplevel_usbM_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_id = usbM_writeOnly_decoder_io_outputs_0_aw_payload_id;
  assign toplevel_usbM_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_len = usbM_writeOnly_decoder_io_outputs_0_aw_payload_len;
  assign toplevel_usbM_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_size = usbM_writeOnly_decoder_io_outputs_0_aw_payload_size;
  assign toplevel_usbM_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_burst = usbM_writeOnly_decoder_io_outputs_0_aw_payload_burst;
  assign toplevel_usbM_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_lock = usbM_writeOnly_decoder_io_outputs_0_aw_payload_lock;
  assign toplevel_usbM_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_cache = usbM_writeOnly_decoder_io_outputs_0_aw_payload_cache;
  assign toplevel_usbM_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_prot = usbM_writeOnly_decoder_io_outputs_0_aw_payload_prot;
  assign toplevel_usbM_writeOnly_decoder_io_outputs_0_aw_validPipe_ready = axi1_ram1_io_axi_arbiter_io_writeInputs_0_aw_ready;
  assign usbM_writeOnly_aw_ready = usbM_writeOnly_decoder_io_input_aw_ready;
  assign usbM_writeOnly_w_ready = usbM_writeOnly_decoder_io_input_w_ready;
  assign usbM_writeOnly_b_valid = usbM_writeOnly_decoder_io_input_b_valid;
  assign usbM_writeOnly_b_payload_id = usbM_writeOnly_decoder_io_input_b_payload_id;
  assign toplevel_sysM_readOnly_decoder_io_outputs_0_ar_validPipe_fire = (toplevel_sysM_readOnly_decoder_io_outputs_0_ar_validPipe_valid && toplevel_sysM_readOnly_decoder_io_outputs_0_ar_validPipe_ready);
  assign toplevel_sysM_readOnly_decoder_io_outputs_0_ar_validPipe_valid = toplevel_sysM_readOnly_decoder_io_outputs_0_ar_rValid;
  assign toplevel_sysM_readOnly_decoder_io_outputs_0_ar_validPipe_payload_addr = sysM_readOnly_decoder_io_outputs_0_ar_payload_addr;
  assign toplevel_sysM_readOnly_decoder_io_outputs_0_ar_validPipe_payload_id = sysM_readOnly_decoder_io_outputs_0_ar_payload_id;
  assign toplevel_sysM_readOnly_decoder_io_outputs_0_ar_validPipe_payload_len = sysM_readOnly_decoder_io_outputs_0_ar_payload_len;
  assign toplevel_sysM_readOnly_decoder_io_outputs_0_ar_validPipe_payload_size = sysM_readOnly_decoder_io_outputs_0_ar_payload_size;
  assign toplevel_sysM_readOnly_decoder_io_outputs_0_ar_validPipe_payload_burst = sysM_readOnly_decoder_io_outputs_0_ar_payload_burst;
  assign toplevel_sysM_readOnly_decoder_io_outputs_0_ar_validPipe_payload_lock = sysM_readOnly_decoder_io_outputs_0_ar_payload_lock;
  assign toplevel_sysM_readOnly_decoder_io_outputs_0_ar_validPipe_payload_cache = sysM_readOnly_decoder_io_outputs_0_ar_payload_cache;
  assign toplevel_sysM_readOnly_decoder_io_outputs_0_ar_validPipe_payload_prot = sysM_readOnly_decoder_io_outputs_0_ar_payload_prot;
  assign toplevel_sysM_readOnly_decoder_io_outputs_0_ar_validPipe_ready = axi1_ram1_io_axi_arbiter_io_readInputs_1_ar_ready;
  assign sysM_readOnly_ar_ready = sysM_readOnly_decoder_io_input_ar_ready;
  assign sysM_readOnly_r_valid = sysM_readOnly_decoder_io_input_r_valid;
  assign sysM_readOnly_r_payload_data = sysM_readOnly_decoder_io_input_r_payload_data;
  assign sysM_readOnly_r_payload_last = sysM_readOnly_decoder_io_input_r_payload_last;
  assign sysM_readOnly_r_payload_id = sysM_readOnly_decoder_io_input_r_payload_id;
  assign toplevel_sysM_writeOnly_decoder_io_outputs_0_aw_validPipe_fire = (toplevel_sysM_writeOnly_decoder_io_outputs_0_aw_validPipe_valid && toplevel_sysM_writeOnly_decoder_io_outputs_0_aw_validPipe_ready);
  assign toplevel_sysM_writeOnly_decoder_io_outputs_0_aw_validPipe_valid = toplevel_sysM_writeOnly_decoder_io_outputs_0_aw_rValid;
  assign toplevel_sysM_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_addr = sysM_writeOnly_decoder_io_outputs_0_aw_payload_addr;
  assign toplevel_sysM_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_id = sysM_writeOnly_decoder_io_outputs_0_aw_payload_id;
  assign toplevel_sysM_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_len = sysM_writeOnly_decoder_io_outputs_0_aw_payload_len;
  assign toplevel_sysM_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_size = sysM_writeOnly_decoder_io_outputs_0_aw_payload_size;
  assign toplevel_sysM_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_burst = sysM_writeOnly_decoder_io_outputs_0_aw_payload_burst;
  assign toplevel_sysM_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_lock = sysM_writeOnly_decoder_io_outputs_0_aw_payload_lock;
  assign toplevel_sysM_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_cache = sysM_writeOnly_decoder_io_outputs_0_aw_payload_cache;
  assign toplevel_sysM_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_prot = sysM_writeOnly_decoder_io_outputs_0_aw_payload_prot;
  assign toplevel_sysM_writeOnly_decoder_io_outputs_0_aw_validPipe_ready = axi1_ram1_io_axi_arbiter_io_writeInputs_1_aw_ready;
  assign sysM_writeOnly_aw_ready = sysM_writeOnly_decoder_io_input_aw_ready;
  assign sysM_writeOnly_w_ready = sysM_writeOnly_decoder_io_input_w_ready;
  assign sysM_writeOnly_b_valid = sysM_writeOnly_decoder_io_input_b_valid;
  assign sysM_writeOnly_b_payload_id = sysM_writeOnly_decoder_io_input_b_payload_id;
  assign axi1_ram1_io_axi_arbiter_io_readInputs_0_ar_payload_addr = toplevel_usbM_readOnly_decoder_io_outputs_0_ar_validPipe_payload_addr[9:0];
  assign axi1_ram1_io_axi_arbiter_io_readInputs_1_ar_payload_addr = toplevel_sysM_readOnly_decoder_io_outputs_0_ar_validPipe_payload_addr[9:0];
  assign axi1_ram1_io_axi_arbiter_io_writeInputs_0_aw_payload_addr = toplevel_usbM_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_addr[9:0];
  assign axi1_ram1_io_axi_arbiter_io_writeInputs_1_aw_payload_addr = toplevel_sysM_writeOnly_decoder_io_outputs_0_aw_validPipe_payload_addr[9:0];
  always @(posedge axiClk or posedge axiReset) begin
    if(axiReset) begin
      toplevel_usbM_readOnly_decoder_io_outputs_0_ar_rValid <= 1'b0;
      toplevel_usbM_writeOnly_decoder_io_outputs_0_aw_rValid <= 1'b0;
      toplevel_sysM_readOnly_decoder_io_outputs_0_ar_rValid <= 1'b0;
      toplevel_sysM_writeOnly_decoder_io_outputs_0_aw_rValid <= 1'b0;
    end else begin
      if(usbM_readOnly_decoder_io_outputs_0_ar_valid) begin
        toplevel_usbM_readOnly_decoder_io_outputs_0_ar_rValid <= 1'b1;
      end
      if(toplevel_usbM_readOnly_decoder_io_outputs_0_ar_validPipe_fire) begin
        toplevel_usbM_readOnly_decoder_io_outputs_0_ar_rValid <= 1'b0;
      end
      if(usbM_writeOnly_decoder_io_outputs_0_aw_valid) begin
        toplevel_usbM_writeOnly_decoder_io_outputs_0_aw_rValid <= 1'b1;
      end
      if(toplevel_usbM_writeOnly_decoder_io_outputs_0_aw_validPipe_fire) begin
        toplevel_usbM_writeOnly_decoder_io_outputs_0_aw_rValid <= 1'b0;
      end
      if(sysM_readOnly_decoder_io_outputs_0_ar_valid) begin
        toplevel_sysM_readOnly_decoder_io_outputs_0_ar_rValid <= 1'b1;
      end
      if(toplevel_sysM_readOnly_decoder_io_outputs_0_ar_validPipe_fire) begin
        toplevel_sysM_readOnly_decoder_io_outputs_0_ar_rValid <= 1'b0;
      end
      if(sysM_writeOnly_decoder_io_outputs_0_aw_valid) begin
        toplevel_sysM_writeOnly_decoder_io_outputs_0_aw_rValid <= 1'b1;
      end
      if(toplevel_sysM_writeOnly_decoder_io_outputs_0_aw_validPipe_fire) begin
        toplevel_sysM_writeOnly_decoder_io_outputs_0_aw_rValid <= 1'b0;
      end
    end
  end


endmodule

module Axi4SharedArbiter (
  input  wire          io_readInputs_0_ar_valid,
  output wire          io_readInputs_0_ar_ready,
  input  wire [9:0]    io_readInputs_0_ar_payload_addr,
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
  input  wire [9:0]    io_readInputs_1_ar_payload_addr,
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
  input  wire [9:0]    io_writeInputs_0_aw_payload_addr,
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
  input  wire [9:0]    io_writeInputs_1_aw_payload_addr,
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
  output wire [9:0]    io_output_arw_payload_addr,
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
  input  wire          axiClk,
  input  wire          axiReset
);

  reg                 cmdArbiter_io_output_ready;
  wire                cmdRouteFork_thrown_translated_fifo_io_pop_ready;
  wire                cmdRouteFork_thrown_translated_fifo_io_flush;
  wire                cmdArbiter_io_inputs_0_ready;
  wire                cmdArbiter_io_inputs_1_ready;
  wire                cmdArbiter_io_inputs_2_ready;
  wire                cmdArbiter_io_inputs_3_ready;
  wire                cmdArbiter_io_output_valid;
  wire       [9:0]    cmdArbiter_io_output_payload_addr;
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
  wire       [9:0]    inputsCmd_0_payload_addr;
  wire       [7:0]    inputsCmd_0_payload_id;
  wire       [7:0]    inputsCmd_0_payload_len;
  wire       [2:0]    inputsCmd_0_payload_size;
  wire       [1:0]    inputsCmd_0_payload_burst;
  wire                inputsCmd_0_payload_write;
  wire                inputsCmd_1_valid;
  wire                inputsCmd_1_ready;
  wire       [9:0]    inputsCmd_1_payload_addr;
  wire       [7:0]    inputsCmd_1_payload_id;
  wire       [7:0]    inputsCmd_1_payload_len;
  wire       [2:0]    inputsCmd_1_payload_size;
  wire       [1:0]    inputsCmd_1_payload_burst;
  wire                inputsCmd_1_payload_write;
  wire                inputsCmd_2_valid;
  wire                inputsCmd_2_ready;
  wire       [9:0]    inputsCmd_2_payload_addr;
  wire       [7:0]    inputsCmd_2_payload_id;
  wire       [7:0]    inputsCmd_2_payload_len;
  wire       [2:0]    inputsCmd_2_payload_size;
  wire       [1:0]    inputsCmd_2_payload_burst;
  wire                inputsCmd_2_payload_write;
  wire                inputsCmd_3_valid;
  wire                inputsCmd_3_ready;
  wire       [9:0]    inputsCmd_3_payload_addr;
  wire       [7:0]    inputsCmd_3_payload_id;
  wire       [7:0]    inputsCmd_3_payload_len;
  wire       [2:0]    inputsCmd_3_payload_size;
  wire       [1:0]    inputsCmd_3_payload_burst;
  wire                inputsCmd_3_payload_write;
  wire                cmdOutputFork_valid;
  wire                cmdOutputFork_ready;
  wire       [9:0]    cmdOutputFork_payload_addr;
  wire       [7:0]    cmdOutputFork_payload_id;
  wire       [7:0]    cmdOutputFork_payload_len;
  wire       [2:0]    cmdOutputFork_payload_size;
  wire       [1:0]    cmdOutputFork_payload_burst;
  wire                cmdOutputFork_payload_write;
  wire                cmdRouteFork_valid;
  reg                 cmdRouteFork_ready;
  wire       [9:0]    cmdRouteFork_payload_addr;
  wire       [7:0]    cmdRouteFork_payload_id;
  wire       [7:0]    cmdRouteFork_payload_len;
  wire       [2:0]    cmdRouteFork_payload_size;
  wire       [1:0]    cmdRouteFork_payload_burst;
  wire                cmdRouteFork_payload_write;
  reg                 axi1_ram1_io_axi_arbiter_cmdArbiter_io_output_fork2_logic_linkEnable_0;
  reg                 axi1_ram1_io_axi_arbiter_cmdArbiter_io_output_fork2_logic_linkEnable_1;
  wire                when_Stream_l1020;
  wire                when_Stream_l1020_1;
  wire                cmdOutputFork_fire;
  wire                cmdRouteFork_fire;
  wire                _zz_io_output_arw_payload_id;
  wire                _zz_io_output_arw_payload_id_1;
  wire                when_Stream_l439;
  reg                 cmdRouteFork_thrown_valid;
  wire                cmdRouteFork_thrown_ready;
  wire       [9:0]    cmdRouteFork_thrown_payload_addr;
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
    .io_inputs_0_payload_addr  (inputsCmd_0_payload_addr[9:0]          ), //i
    .io_inputs_0_payload_id    (inputsCmd_0_payload_id[7:0]            ), //i
    .io_inputs_0_payload_len   (inputsCmd_0_payload_len[7:0]           ), //i
    .io_inputs_0_payload_size  (inputsCmd_0_payload_size[2:0]          ), //i
    .io_inputs_0_payload_burst (inputsCmd_0_payload_burst[1:0]         ), //i
    .io_inputs_0_payload_write (inputsCmd_0_payload_write              ), //i
    .io_inputs_1_valid         (inputsCmd_1_valid                      ), //i
    .io_inputs_1_ready         (cmdArbiter_io_inputs_1_ready           ), //o
    .io_inputs_1_payload_addr  (inputsCmd_1_payload_addr[9:0]          ), //i
    .io_inputs_1_payload_id    (inputsCmd_1_payload_id[7:0]            ), //i
    .io_inputs_1_payload_len   (inputsCmd_1_payload_len[7:0]           ), //i
    .io_inputs_1_payload_size  (inputsCmd_1_payload_size[2:0]          ), //i
    .io_inputs_1_payload_burst (inputsCmd_1_payload_burst[1:0]         ), //i
    .io_inputs_1_payload_write (inputsCmd_1_payload_write              ), //i
    .io_inputs_2_valid         (inputsCmd_2_valid                      ), //i
    .io_inputs_2_ready         (cmdArbiter_io_inputs_2_ready           ), //o
    .io_inputs_2_payload_addr  (inputsCmd_2_payload_addr[9:0]          ), //i
    .io_inputs_2_payload_id    (inputsCmd_2_payload_id[7:0]            ), //i
    .io_inputs_2_payload_len   (inputsCmd_2_payload_len[7:0]           ), //i
    .io_inputs_2_payload_size  (inputsCmd_2_payload_size[2:0]          ), //i
    .io_inputs_2_payload_burst (inputsCmd_2_payload_burst[1:0]         ), //i
    .io_inputs_2_payload_write (inputsCmd_2_payload_write              ), //i
    .io_inputs_3_valid         (inputsCmd_3_valid                      ), //i
    .io_inputs_3_ready         (cmdArbiter_io_inputs_3_ready           ), //o
    .io_inputs_3_payload_addr  (inputsCmd_3_payload_addr[9:0]          ), //i
    .io_inputs_3_payload_id    (inputsCmd_3_payload_id[7:0]            ), //i
    .io_inputs_3_payload_len   (inputsCmd_3_payload_len[7:0]           ), //i
    .io_inputs_3_payload_size  (inputsCmd_3_payload_size[2:0]          ), //i
    .io_inputs_3_payload_burst (inputsCmd_3_payload_burst[1:0]         ), //i
    .io_inputs_3_payload_write (inputsCmd_3_payload_write              ), //i
    .io_output_valid           (cmdArbiter_io_output_valid             ), //o
    .io_output_ready           (cmdArbiter_io_output_ready             ), //i
    .io_output_payload_addr    (cmdArbiter_io_output_payload_addr[9:0] ), //o
    .io_output_payload_id      (cmdArbiter_io_output_payload_id[7:0]   ), //o
    .io_output_payload_len     (cmdArbiter_io_output_payload_len[7:0]  ), //o
    .io_output_payload_size    (cmdArbiter_io_output_payload_size[2:0] ), //o
    .io_output_payload_burst   (cmdArbiter_io_output_payload_burst[1:0]), //o
    .io_output_payload_write   (cmdArbiter_io_output_payload_write     ), //o
    .io_chosen                 (cmdArbiter_io_chosen[1:0]              ), //o
    .io_chosenOH               (cmdArbiter_io_chosenOH[3:0]            ), //o
    .axiClk                    (axiClk                                 ), //i
    .axiReset                  (axiReset                               )  //i
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
    .axiClk          (axiClk                                                  ), //i
    .axiReset        (axiReset                                                )  //i
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

  assign when_Stream_l1020 = ((! cmdOutputFork_ready) && axi1_ram1_io_axi_arbiter_cmdArbiter_io_output_fork2_logic_linkEnable_0);
  assign when_Stream_l1020_1 = ((! cmdRouteFork_ready) && axi1_ram1_io_axi_arbiter_cmdArbiter_io_output_fork2_logic_linkEnable_1);
  assign cmdOutputFork_valid = (cmdArbiter_io_output_valid && axi1_ram1_io_axi_arbiter_cmdArbiter_io_output_fork2_logic_linkEnable_0);
  assign cmdOutputFork_payload_addr = cmdArbiter_io_output_payload_addr;
  assign cmdOutputFork_payload_id = cmdArbiter_io_output_payload_id;
  assign cmdOutputFork_payload_len = cmdArbiter_io_output_payload_len;
  assign cmdOutputFork_payload_size = cmdArbiter_io_output_payload_size;
  assign cmdOutputFork_payload_burst = cmdArbiter_io_output_payload_burst;
  assign cmdOutputFork_payload_write = cmdArbiter_io_output_payload_write;
  assign cmdOutputFork_fire = (cmdOutputFork_valid && cmdOutputFork_ready);
  assign cmdRouteFork_valid = (cmdArbiter_io_output_valid && axi1_ram1_io_axi_arbiter_cmdArbiter_io_output_fork2_logic_linkEnable_1);
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
  always @(posedge axiClk or posedge axiReset) begin
    if(axiReset) begin
      axi1_ram1_io_axi_arbiter_cmdArbiter_io_output_fork2_logic_linkEnable_0 <= 1'b1;
      axi1_ram1_io_axi_arbiter_cmdArbiter_io_output_fork2_logic_linkEnable_1 <= 1'b1;
    end else begin
      if(cmdOutputFork_fire) begin
        axi1_ram1_io_axi_arbiter_cmdArbiter_io_output_fork2_logic_linkEnable_0 <= 1'b0;
      end
      if(cmdRouteFork_fire) begin
        axi1_ram1_io_axi_arbiter_cmdArbiter_io_output_fork2_logic_linkEnable_1 <= 1'b0;
      end
      if(cmdArbiter_io_output_ready) begin
        axi1_ram1_io_axi_arbiter_cmdArbiter_io_output_fork2_logic_linkEnable_0 <= 1'b1;
        axi1_ram1_io_axi_arbiter_cmdArbiter_io_output_fork2_logic_linkEnable_1 <= 1'b1;
      end
    end
  end


endmodule

//Axi4WriteOnlyDecoder_1 replaced by Axi4WriteOnlyDecoder

//Axi4ReadOnlyDecoder_1 replaced by Axi4ReadOnlyDecoder

module Axi4WriteOnlyDecoder (
  input  wire          io_input_aw_valid,
  output wire          io_input_aw_ready,
  input  wire [23:0]   io_input_aw_payload_addr,
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
  output wire          io_outputs_0_aw_valid,
  input  wire          io_outputs_0_aw_ready,
  output wire [23:0]   io_outputs_0_aw_payload_addr,
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
  input  wire          axiClk,
  input  wire          axiReset
);

  wire                errorSlave_io_axi_aw_valid;
  wire                errorSlave_io_axi_w_valid;
  wire                errorSlave_io_axi_aw_ready;
  wire                errorSlave_io_axi_w_ready;
  wire                errorSlave_io_axi_b_valid;
  wire       [7:0]    errorSlave_io_axi_b_payload_id;
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
  wire                when_Utils_l717;
  wire                when_Utils_l719;
  wire                io_input_w_fire;
  wire                when_Utils_l691;
  reg                 pendingDataCounter_incrementIt;
  reg                 pendingDataCounter_decrementIt;
  wire       [2:0]    pendingDataCounter_valueNext;
  reg        [2:0]    pendingDataCounter_value;
  wire                pendingDataCounter_mayOverflow;
  wire                pendingDataCounter_willOverflowIfInc;
  wire                pendingDataCounter_willOverflow;
  reg        [2:0]    pendingDataCounter_finalIncrement;
  wire                when_Utils_l717_1;
  wire                when_Utils_l719_1;
  wire       [0:0]    decodedCmdSels;
  wire                decodedCmdError;
  reg        [0:0]    pendingSels;
  reg                 pendingError;
  wire                allowCmd;
  wire                allowData;
  reg                 _zz_cmdAllowedStart;

  Axi4WriteOnlyErrorSlave_1 errorSlave (
    .io_axi_aw_valid         (errorSlave_io_axi_aw_valid         ), //i
    .io_axi_aw_ready         (errorSlave_io_axi_aw_ready         ), //o
    .io_axi_aw_payload_addr  (io_input_aw_payload_addr[23:0]     ), //i
    .io_axi_aw_payload_id    (io_input_aw_payload_id[7:0]        ), //i
    .io_axi_aw_payload_len   (io_input_aw_payload_len[7:0]       ), //i
    .io_axi_aw_payload_size  (io_input_aw_payload_size[2:0]      ), //i
    .io_axi_aw_payload_burst (io_input_aw_payload_burst[1:0]     ), //i
    .io_axi_aw_payload_lock  (io_input_aw_payload_lock           ), //i
    .io_axi_aw_payload_cache (io_input_aw_payload_cache[3:0]     ), //i
    .io_axi_aw_payload_prot  (io_input_aw_payload_prot[2:0]      ), //i
    .io_axi_w_valid          (errorSlave_io_axi_w_valid          ), //i
    .io_axi_w_ready          (errorSlave_io_axi_w_ready          ), //o
    .io_axi_w_payload_data   (io_input_w_payload_data[63:0]      ), //i
    .io_axi_w_payload_strb   (io_input_w_payload_strb[7:0]       ), //i
    .io_axi_w_payload_last   (io_input_w_payload_last            ), //i
    .io_axi_b_valid          (errorSlave_io_axi_b_valid          ), //o
    .io_axi_b_ready          (io_input_b_ready                   ), //i
    .io_axi_b_payload_id     (errorSlave_io_axi_b_payload_id[7:0]), //o
    .axiClk                  (axiClk                             ), //i
    .axiReset                (axiReset                           )  //i
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
  assign when_Utils_l717 = (pendingCmdCounter_incrementIt && (! pendingCmdCounter_decrementIt));
  always @(*) begin
    if(when_Utils_l717) begin
      pendingCmdCounter_finalIncrement = 3'b001;
    end else begin
      if(when_Utils_l719) begin
        pendingCmdCounter_finalIncrement = 3'b111;
      end else begin
        pendingCmdCounter_finalIncrement = 3'b000;
      end
    end
  end

  assign when_Utils_l719 = ((! pendingCmdCounter_incrementIt) && pendingCmdCounter_decrementIt);
  assign pendingCmdCounter_valueNext = (pendingCmdCounter_value + pendingCmdCounter_finalIncrement);
  assign io_input_w_fire = (io_input_w_valid && io_input_w_ready);
  assign when_Utils_l691 = (io_input_w_fire && io_input_w_payload_last);
  always @(*) begin
    pendingDataCounter_incrementIt = 1'b0;
    if(cmdAllowedStart) begin
      pendingDataCounter_incrementIt = 1'b1;
    end
  end

  always @(*) begin
    pendingDataCounter_decrementIt = 1'b0;
    if(when_Utils_l691) begin
      pendingDataCounter_decrementIt = 1'b1;
    end
  end

  assign pendingDataCounter_mayOverflow = (pendingDataCounter_value == 3'b111);
  assign pendingDataCounter_willOverflowIfInc = (pendingDataCounter_mayOverflow && (! pendingDataCounter_decrementIt));
  assign pendingDataCounter_willOverflow = (pendingDataCounter_willOverflowIfInc && pendingDataCounter_incrementIt);
  assign when_Utils_l717_1 = (pendingDataCounter_incrementIt && (! pendingDataCounter_decrementIt));
  always @(*) begin
    if(when_Utils_l717_1) begin
      pendingDataCounter_finalIncrement = 3'b001;
    end else begin
      if(when_Utils_l719_1) begin
        pendingDataCounter_finalIncrement = 3'b111;
      end else begin
        pendingDataCounter_finalIncrement = 3'b000;
      end
    end
  end

  assign when_Utils_l719_1 = ((! pendingDataCounter_incrementIt) && pendingDataCounter_decrementIt);
  assign pendingDataCounter_valueNext = (pendingDataCounter_value + pendingDataCounter_finalIncrement);
  assign decodedCmdSels = (((io_input_aw_payload_addr & (~ 24'h0003ff)) == 24'h000000) && io_input_aw_valid);
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

  assign io_outputs_0_b_ready = io_input_b_ready;
  always @(posedge axiClk or posedge axiReset) begin
    if(axiReset) begin
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
  input  wire [23:0]   io_input_ar_payload_addr,
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
  output reg           io_input_r_payload_last,
  output wire          io_outputs_0_ar_valid,
  input  wire          io_outputs_0_ar_ready,
  output wire [23:0]   io_outputs_0_ar_payload_addr,
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
  input  wire          io_outputs_0_r_payload_last,
  input  wire          axiClk,
  input  wire          axiReset
);

  wire                errorSlave_io_axi_ar_valid;
  wire                errorSlave_io_axi_ar_ready;
  wire                errorSlave_io_axi_r_valid;
  wire       [63:0]   errorSlave_io_axi_r_payload_data;
  wire       [7:0]    errorSlave_io_axi_r_payload_id;
  wire                errorSlave_io_axi_r_payload_last;
  wire                io_input_ar_fire;
  wire                io_input_r_fire;
  wire                when_Utils_l691;
  reg                 pendingCmdCounter_incrementIt;
  reg                 pendingCmdCounter_decrementIt;
  wire       [2:0]    pendingCmdCounter_valueNext;
  reg        [2:0]    pendingCmdCounter_value;
  wire                pendingCmdCounter_mayOverflow;
  wire                pendingCmdCounter_willOverflowIfInc;
  wire                pendingCmdCounter_willOverflow;
  reg        [2:0]    pendingCmdCounter_finalIncrement;
  wire                when_Utils_l717;
  wire                when_Utils_l719;
  wire       [0:0]    decodedCmdSels;
  wire                decodedCmdError;
  reg        [0:0]    pendingSels;
  reg                 pendingError;
  wire                allowCmd;

  Axi4ReadOnlyErrorSlave_1 errorSlave (
    .io_axi_ar_valid         (errorSlave_io_axi_ar_valid            ), //i
    .io_axi_ar_ready         (errorSlave_io_axi_ar_ready            ), //o
    .io_axi_ar_payload_addr  (io_input_ar_payload_addr[23:0]        ), //i
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
    .io_axi_r_payload_last   (errorSlave_io_axi_r_payload_last      ), //o
    .axiClk                  (axiClk                                ), //i
    .axiReset                (axiReset                              )  //i
  );
  assign io_input_ar_fire = (io_input_ar_valid && io_input_ar_ready);
  assign io_input_r_fire = (io_input_r_valid && io_input_r_ready);
  assign when_Utils_l691 = (io_input_r_fire && io_input_r_payload_last);
  always @(*) begin
    pendingCmdCounter_incrementIt = 1'b0;
    if(io_input_ar_fire) begin
      pendingCmdCounter_incrementIt = 1'b1;
    end
  end

  always @(*) begin
    pendingCmdCounter_decrementIt = 1'b0;
    if(when_Utils_l691) begin
      pendingCmdCounter_decrementIt = 1'b1;
    end
  end

  assign pendingCmdCounter_mayOverflow = (pendingCmdCounter_value == 3'b111);
  assign pendingCmdCounter_willOverflowIfInc = (pendingCmdCounter_mayOverflow && (! pendingCmdCounter_decrementIt));
  assign pendingCmdCounter_willOverflow = (pendingCmdCounter_willOverflowIfInc && pendingCmdCounter_incrementIt);
  assign when_Utils_l717 = (pendingCmdCounter_incrementIt && (! pendingCmdCounter_decrementIt));
  always @(*) begin
    if(when_Utils_l717) begin
      pendingCmdCounter_finalIncrement = 3'b001;
    end else begin
      if(when_Utils_l719) begin
        pendingCmdCounter_finalIncrement = 3'b111;
      end else begin
        pendingCmdCounter_finalIncrement = 3'b000;
      end
    end
  end

  assign when_Utils_l719 = ((! pendingCmdCounter_incrementIt) && pendingCmdCounter_decrementIt);
  assign pendingCmdCounter_valueNext = (pendingCmdCounter_value + pendingCmdCounter_finalIncrement);
  assign decodedCmdSels = (((io_input_ar_payload_addr & (~ 24'h0003ff)) == 24'h000000) && io_input_ar_valid);
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
    io_input_r_payload_last = io_outputs_0_r_payload_last;
    if(pendingError) begin
      io_input_r_payload_last = errorSlave_io_axi_r_payload_last;
    end
  end

  assign io_outputs_0_r_ready = io_input_r_ready;
  always @(posedge axiClk or posedge axiReset) begin
    if(axiReset) begin
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
  input  wire [9:0]    io_axi_arw_payload_addr,
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
  input  wire          axiClk,
  input  wire          axiReset
);

  reg        [63:0]   _zz_ram_port0;
  wire       [2:0]    _zz_Axi4Incr_alignMask;
  wire       [11:0]   _zz_Axi4Incr_base;
  wire       [9:0]    _zz_Axi4Incr_base_1;
  wire       [11:0]   _zz_Axi4Incr_baseIncr;
  wire       [2:0]    _zz_Axi4Incr_wrapCase_1;
  wire       [2:0]    _zz_Axi4Incr_wrapCase_2;
  wire       [11:0]   _zz_Axi4Incr_result;
  reg        [11:0]   _zz_Axi4Incr_result_1;
  wire       [10:0]   _zz_Axi4Incr_result_2;
  wire       [0:0]    _zz_Axi4Incr_result_3;
  wire       [9:0]    _zz_Axi4Incr_result_4;
  wire       [1:0]    _zz_Axi4Incr_result_5;
  wire       [8:0]    _zz_Axi4Incr_result_6;
  wire       [2:0]    _zz_Axi4Incr_result_7;
  wire       [7:0]    _zz_Axi4Incr_result_8;
  wire       [3:0]    _zz_Axi4Incr_result_9;
  wire       [6:0]    _zz_Axi4Incr_result_10;
  wire       [4:0]    _zz_Axi4Incr_result_11;
  wire       [5:0]    _zz_Axi4Incr_result_12;
  wire       [5:0]    _zz_Axi4Incr_result_13;
  wire       [4:0]    _zz_Axi4Incr_result_14;
  wire       [6:0]    _zz_Axi4Incr_result_15;
  wire       [11:0]   _zz_Axi4Incr_result_16;
  reg                 unburstify_result_valid;
  wire                unburstify_result_ready;
  reg                 unburstify_result_payload_last;
  reg        [9:0]    unburstify_result_payload_fragment_addr;
  reg        [8:0]    unburstify_result_payload_fragment_id;
  reg        [2:0]    unburstify_result_payload_fragment_size;
  reg        [1:0]    unburstify_result_payload_fragment_burst;
  reg                 unburstify_result_payload_fragment_write;
  wire                unburstify_doResult;
  reg                 unburstify_buffer_valid;
  reg        [7:0]    unburstify_buffer_len;
  reg        [7:0]    unburstify_buffer_beat;
  reg        [9:0]    unburstify_buffer_transaction_addr;
  reg        [8:0]    unburstify_buffer_transaction_id;
  reg        [2:0]    unburstify_buffer_transaction_size;
  reg        [1:0]    unburstify_buffer_transaction_burst;
  reg                 unburstify_buffer_transaction_write;
  wire                unburstify_buffer_last;
  wire       [1:0]    Axi4Incr_validSize;
  reg        [9:0]    Axi4Incr_result;
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
  wire       [9:0]    stage0_payload_fragment_addr;
  wire       [8:0]    stage0_payload_fragment_id;
  wire       [2:0]    stage0_payload_fragment_size;
  wire       [1:0]    stage0_payload_fragment_burst;
  wire                stage0_payload_fragment_write;
  wire       [6:0]    _zz_io_axi_r_payload_data;
  wire                stage0_fire;
  wire       [63:0]   _zz_io_axi_r_payload_data_1;
  wire                stage1_valid;
  wire                stage1_ready;
  wire                stage1_payload_last;
  wire       [9:0]    stage1_payload_fragment_addr;
  wire       [8:0]    stage1_payload_fragment_id;
  wire       [2:0]    stage1_payload_fragment_size;
  wire       [1:0]    stage1_payload_fragment_burst;
  wire                stage1_payload_fragment_write;
  reg                 stage0_rValid;
  reg                 stage0_rData_last;
  reg        [9:0]    stage0_rData_fragment_addr;
  reg        [8:0]    stage0_rData_fragment_id;
  reg        [2:0]    stage0_rData_fragment_size;
  reg        [1:0]    stage0_rData_fragment_burst;
  reg                 stage0_rData_fragment_write;
  wire                when_Stream_l369;
  reg [7:0] ram_symbol0 [0:127];
  reg [7:0] ram_symbol1 [0:127];
  reg [7:0] ram_symbol2 [0:127];
  reg [7:0] ram_symbol3 [0:127];
  reg [7:0] ram_symbol4 [0:127];
  reg [7:0] ram_symbol5 [0:127];
  reg [7:0] ram_symbol6 [0:127];
  reg [7:0] ram_symbol7 [0:127];
  reg [7:0] _zz_ramsymbol_read;
  reg [7:0] _zz_ramsymbol_read_1;
  reg [7:0] _zz_ramsymbol_read_2;
  reg [7:0] _zz_ramsymbol_read_3;
  reg [7:0] _zz_ramsymbol_read_4;
  reg [7:0] _zz_ramsymbol_read_5;
  reg [7:0] _zz_ramsymbol_read_6;
  reg [7:0] _zz_ramsymbol_read_7;

  assign _zz_Axi4Incr_alignMask = {(2'b10 < Axi4Incr_validSize),{(2'b01 < Axi4Incr_validSize),(2'b00 < Axi4Incr_validSize)}};
  assign _zz_Axi4Incr_base_1 = unburstify_buffer_transaction_addr[9 : 0];
  assign _zz_Axi4Incr_base = {2'd0, _zz_Axi4Incr_base_1};
  assign _zz_Axi4Incr_baseIncr = {8'd0, Axi4Incr_sizeValue};
  assign _zz_Axi4Incr_wrapCase_1 = {1'd0, Axi4Incr_validSize};
  assign _zz_Axi4Incr_wrapCase_2 = {1'd0, _zz_Axi4Incr_wrapCase};
  assign _zz_Axi4Incr_result = _zz_Axi4Incr_result_1;
  assign _zz_Axi4Incr_result_16 = Axi4Incr_baseIncr;
  assign _zz_Axi4Incr_result_2 = Axi4Incr_base[11 : 1];
  assign _zz_Axi4Incr_result_3 = Axi4Incr_baseIncr[0 : 0];
  assign _zz_Axi4Incr_result_4 = Axi4Incr_base[11 : 2];
  assign _zz_Axi4Incr_result_5 = Axi4Incr_baseIncr[1 : 0];
  assign _zz_Axi4Incr_result_6 = Axi4Incr_base[11 : 3];
  assign _zz_Axi4Incr_result_7 = Axi4Incr_baseIncr[2 : 0];
  assign _zz_Axi4Incr_result_8 = Axi4Incr_base[11 : 4];
  assign _zz_Axi4Incr_result_9 = Axi4Incr_baseIncr[3 : 0];
  assign _zz_Axi4Incr_result_10 = Axi4Incr_base[11 : 5];
  assign _zz_Axi4Incr_result_11 = Axi4Incr_baseIncr[4 : 0];
  assign _zz_Axi4Incr_result_12 = Axi4Incr_base[11 : 6];
  assign _zz_Axi4Incr_result_13 = Axi4Incr_baseIncr[5 : 0];
  assign _zz_Axi4Incr_result_14 = Axi4Incr_base[11 : 7];
  assign _zz_Axi4Incr_result_15 = Axi4Incr_baseIncr[6 : 0];
  always @(*) begin
    _zz_ram_port0 = {_zz_ramsymbol_read_7, _zz_ramsymbol_read_6, _zz_ramsymbol_read_5, _zz_ramsymbol_read_4, _zz_ramsymbol_read_3, _zz_ramsymbol_read_2, _zz_ramsymbol_read_1, _zz_ramsymbol_read};
  end
  always @(posedge axiClk) begin
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

  always @(posedge axiClk) begin
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
      3'b000 : _zz_Axi4Incr_result_1 = {_zz_Axi4Incr_result_2,_zz_Axi4Incr_result_3};
      3'b001 : _zz_Axi4Incr_result_1 = {_zz_Axi4Incr_result_4,_zz_Axi4Incr_result_5};
      3'b010 : _zz_Axi4Incr_result_1 = {_zz_Axi4Incr_result_6,_zz_Axi4Incr_result_7};
      3'b011 : _zz_Axi4Incr_result_1 = {_zz_Axi4Incr_result_8,_zz_Axi4Incr_result_9};
      3'b100 : _zz_Axi4Incr_result_1 = {_zz_Axi4Incr_result_10,_zz_Axi4Incr_result_11};
      3'b101 : _zz_Axi4Incr_result_1 = {_zz_Axi4Incr_result_12,_zz_Axi4Incr_result_13};
      default : _zz_Axi4Incr_result_1 = {_zz_Axi4Incr_result_14,_zz_Axi4Incr_result_15};
    endcase
  end

  assign unburstify_buffer_last = (unburstify_buffer_beat == 8'h01);
  assign Axi4Incr_validSize = unburstify_buffer_transaction_size[1 : 0];
  assign Axi4Incr_sizeValue = {(2'b11 == Axi4Incr_validSize),{(2'b10 == Axi4Incr_validSize),{(2'b01 == Axi4Incr_validSize),(2'b00 == Axi4Incr_validSize)}}};
  assign Axi4Incr_alignMask = {9'd0, _zz_Axi4Incr_alignMask};
  assign Axi4Incr_base = (_zz_Axi4Incr_base & (~ Axi4Incr_alignMask));
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
        Axi4Incr_result = _zz_Axi4Incr_result[9:0];
      end
      default : begin
        Axi4Incr_result = _zz_Axi4Incr_result_16[9:0];
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
  assign _zz_io_axi_r_payload_data = stage0_payload_fragment_addr[9 : 3];
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
  always @(posedge axiClk or posedge axiReset) begin
    if(axiReset) begin
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

  always @(posedge axiClk) begin
    if(unburstify_result_ready) begin
      unburstify_buffer_beat <= (unburstify_buffer_beat - 8'h01);
      unburstify_buffer_transaction_addr[9 : 0] <= Axi4Incr_result[9 : 0];
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
  input  wire          axiClk,
  input  wire          axiReset
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
    .axiClk          (axiClk                   ), //i
    .axiReset        (axiReset                 )  //i
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
  input  wire [9:0]    io_inputs_0_payload_addr,
  input  wire [7:0]    io_inputs_0_payload_id,
  input  wire [7:0]    io_inputs_0_payload_len,
  input  wire [2:0]    io_inputs_0_payload_size,
  input  wire [1:0]    io_inputs_0_payload_burst,
  input  wire          io_inputs_0_payload_write,
  input  wire          io_inputs_1_valid,
  output wire          io_inputs_1_ready,
  input  wire [9:0]    io_inputs_1_payload_addr,
  input  wire [7:0]    io_inputs_1_payload_id,
  input  wire [7:0]    io_inputs_1_payload_len,
  input  wire [2:0]    io_inputs_1_payload_size,
  input  wire [1:0]    io_inputs_1_payload_burst,
  input  wire          io_inputs_1_payload_write,
  input  wire          io_inputs_2_valid,
  output wire          io_inputs_2_ready,
  input  wire [9:0]    io_inputs_2_payload_addr,
  input  wire [7:0]    io_inputs_2_payload_id,
  input  wire [7:0]    io_inputs_2_payload_len,
  input  wire [2:0]    io_inputs_2_payload_size,
  input  wire [1:0]    io_inputs_2_payload_burst,
  input  wire          io_inputs_2_payload_write,
  input  wire          io_inputs_3_valid,
  output wire          io_inputs_3_ready,
  input  wire [9:0]    io_inputs_3_payload_addr,
  input  wire [7:0]    io_inputs_3_payload_id,
  input  wire [7:0]    io_inputs_3_payload_len,
  input  wire [2:0]    io_inputs_3_payload_size,
  input  wire [1:0]    io_inputs_3_payload_burst,
  input  wire          io_inputs_3_payload_write,
  output wire          io_output_valid,
  input  wire          io_output_ready,
  output wire [9:0]    io_output_payload_addr,
  output wire [7:0]    io_output_payload_id,
  output wire [7:0]    io_output_payload_len,
  output wire [2:0]    io_output_payload_size,
  output wire [1:0]    io_output_payload_burst,
  output wire          io_output_payload_write,
  output wire [1:0]    io_chosen,
  output wire [3:0]    io_chosenOH,
  input  wire          axiClk,
  input  wire          axiReset
);

  wire       [7:0]    _zz__zz_maskProposal_0_2;
  wire       [7:0]    _zz__zz_maskProposal_0_2_1;
  wire       [3:0]    _zz__zz_maskProposal_0_2_2;
  reg        [9:0]    _zz_io_output_payload_addr_3;
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
  always @(posedge axiClk or posedge axiReset) begin
    if(axiReset) begin
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
  input  wire [23:0]   io_axi_aw_payload_addr,
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
  input  wire          axiClk,
  input  wire          axiReset
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
  assign io_axi_b_payload_id = id;
  assign io_axi_b_fire = (io_axi_b_valid && io_axi_b_ready);
  always @(posedge axiClk or posedge axiReset) begin
    if(axiReset) begin
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

  always @(posedge axiClk) begin
    if(io_axi_aw_fire) begin
      id <= io_axi_aw_payload_id;
    end
  end


endmodule

module Axi4ReadOnlyErrorSlave_1 (
  input  wire          io_axi_ar_valid,
  output wire          io_axi_ar_ready,
  input  wire [23:0]   io_axi_ar_payload_addr,
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
  output wire          io_axi_r_payload_last,
  input  wire          axiClk,
  input  wire          axiReset
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
  assign io_axi_r_payload_last = remainingZero;
  always @(posedge axiClk or posedge axiReset) begin
    if(axiReset) begin
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

  always @(posedge axiClk) begin
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
  input  wire          axiClk,
  input  wire          axiReset
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
  always @(posedge axiClk) begin
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
  always @(posedge axiClk or posedge axiReset) begin
    if(axiReset) begin
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
