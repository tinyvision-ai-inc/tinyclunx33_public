wire [31:0] wb_m2s_wb0_adr;
wire [31:0] wb_m2s_wb0_dat;
wire  [3:0] wb_m2s_wb0_sel;
wire        wb_m2s_wb0_we;
wire        wb_m2s_wb0_cyc;
wire        wb_m2s_wb0_stb;
wire  [2:0] wb_m2s_wb0_cti;
wire  [1:0] wb_m2s_wb0_bte;
wire [31:0] wb_s2m_wb0_dat;
wire        wb_s2m_wb0_ack;
wire        wb_s2m_wb0_err;
wire        wb_s2m_wb0_rty;
wire [31:0] wb_m2s_usb_adr;
wire [31:0] wb_m2s_usb_dat;
wire  [3:0] wb_m2s_usb_sel;
wire        wb_m2s_usb_we;
wire        wb_m2s_usb_cyc;
wire        wb_m2s_usb_stb;
wire  [2:0] wb_m2s_usb_cti;
wire  [1:0] wb_m2s_usb_bte;
wire [31:0] wb_s2m_usb_dat;
wire        wb_s2m_usb_ack;
wire        wb_s2m_usb_err;
wire        wb_s2m_usb_rty;
wire [31:0] wb_m2s_scratch_ram_adr;
wire [31:0] wb_m2s_scratch_ram_dat;
wire  [3:0] wb_m2s_scratch_ram_sel;
wire        wb_m2s_scratch_ram_we;
wire        wb_m2s_scratch_ram_cyc;
wire        wb_m2s_scratch_ram_stb;
wire  [2:0] wb_m2s_scratch_ram_cti;
wire  [1:0] wb_m2s_scratch_ram_bte;
wire [31:0] wb_s2m_scratch_ram_dat;
wire        wb_s2m_scratch_ram_ack;
wire        wb_s2m_scratch_ram_err;
wire        wb_s2m_scratch_ram_rty;
wire [31:0] wb_m2s_csr_adr;
wire [31:0] wb_m2s_csr_dat;
wire  [3:0] wb_m2s_csr_sel;
wire        wb_m2s_csr_we;
wire        wb_m2s_csr_cyc;
wire        wb_m2s_csr_stb;
wire  [2:0] wb_m2s_csr_cti;
wire  [1:0] wb_m2s_csr_bte;
wire [31:0] wb_s2m_csr_dat;
wire        wb_s2m_csr_ack;
wire        wb_s2m_csr_err;
wire        wb_s2m_csr_rty;
wire [31:0] wb_m2s_sl_adr;
wire [31:0] wb_m2s_sl_dat;
wire  [3:0] wb_m2s_sl_sel;
wire        wb_m2s_sl_we;
wire        wb_m2s_sl_cyc;
wire        wb_m2s_sl_stb;
wire  [2:0] wb_m2s_sl_cti;
wire  [1:0] wb_m2s_sl_bte;
wire [31:0] wb_s2m_sl_dat;
wire        wb_s2m_sl_ack;
wire        wb_s2m_sl_err;
wire        wb_s2m_sl_rty;

wb_intercon wb_intercon0
   (.wb_clk_i             (wb_clk),
    .wb_rst_i             (wb_rst),
    .wb_wb0_adr_i         (wb_m2s_wb0_adr),
    .wb_wb0_dat_i         (wb_m2s_wb0_dat),
    .wb_wb0_sel_i         (wb_m2s_wb0_sel),
    .wb_wb0_we_i          (wb_m2s_wb0_we),
    .wb_wb0_cyc_i         (wb_m2s_wb0_cyc),
    .wb_wb0_stb_i         (wb_m2s_wb0_stb),
    .wb_wb0_cti_i         (wb_m2s_wb0_cti),
    .wb_wb0_bte_i         (wb_m2s_wb0_bte),
    .wb_wb0_dat_o         (wb_s2m_wb0_dat),
    .wb_wb0_ack_o         (wb_s2m_wb0_ack),
    .wb_wb0_err_o         (wb_s2m_wb0_err),
    .wb_wb0_rty_o         (wb_s2m_wb0_rty),
    .wb_usb_adr_o         (wb_m2s_usb_adr),
    .wb_usb_dat_o         (wb_m2s_usb_dat),
    .wb_usb_sel_o         (wb_m2s_usb_sel),
    .wb_usb_we_o          (wb_m2s_usb_we),
    .wb_usb_cyc_o         (wb_m2s_usb_cyc),
    .wb_usb_stb_o         (wb_m2s_usb_stb),
    .wb_usb_cti_o         (wb_m2s_usb_cti),
    .wb_usb_bte_o         (wb_m2s_usb_bte),
    .wb_usb_dat_i         (wb_s2m_usb_dat),
    .wb_usb_ack_i         (wb_s2m_usb_ack),
    .wb_usb_err_i         (wb_s2m_usb_err),
    .wb_usb_rty_i         (wb_s2m_usb_rty),
    .wb_scratch_ram_adr_o (wb_m2s_scratch_ram_adr),
    .wb_scratch_ram_dat_o (wb_m2s_scratch_ram_dat),
    .wb_scratch_ram_sel_o (wb_m2s_scratch_ram_sel),
    .wb_scratch_ram_we_o  (wb_m2s_scratch_ram_we),
    .wb_scratch_ram_cyc_o (wb_m2s_scratch_ram_cyc),
    .wb_scratch_ram_stb_o (wb_m2s_scratch_ram_stb),
    .wb_scratch_ram_cti_o (wb_m2s_scratch_ram_cti),
    .wb_scratch_ram_bte_o (wb_m2s_scratch_ram_bte),
    .wb_scratch_ram_dat_i (wb_s2m_scratch_ram_dat),
    .wb_scratch_ram_ack_i (wb_s2m_scratch_ram_ack),
    .wb_scratch_ram_err_i (wb_s2m_scratch_ram_err),
    .wb_scratch_ram_rty_i (wb_s2m_scratch_ram_rty));

