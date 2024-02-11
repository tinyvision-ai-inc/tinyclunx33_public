`ifndef __AXI_INFRASTRUCTURE__
`define __AXI_INFRASTRUCTURE__


	wire        axiReset     ;
	wire        axiClk       ;
	wire        usbM_awvalid ;
	wire        usbM_awready ;
	wire [23:0] usbM_awaddr  ;
	wire [ 7:0] usbM_awid    ;
	wire [ 7:0] usbM_awlen   ;
	wire [ 2:0] usbM_awsize  ;
	wire [ 1:0] usbM_awburst ;
	wire [ 0:0] usbM_awlock  ;
	wire [ 3:0] usbM_awcache ;
	wire [ 2:0] usbM_awprot  ;
	wire        usbM_wvalid  ;
	wire        usbM_wready  ;
	wire [63:0] usbM_wdata   ;
	wire [ 7:0] usbM_wstrb   ;
	wire        usbM_wlast   ;
	wire        usbM_bvalid  ;
	wire        usbM_bready  ;
	wire [ 7:0] usbM_bid     ;
	wire        usbM_arvalid ;
	wire        usbM_arready ;
	wire [23:0] usbM_araddr  ;
	wire [ 7:0] usbM_arid    ;
	wire [ 7:0] usbM_arlen   ;
	wire [ 2:0] usbM_arsize  ;
	wire [ 1:0] usbM_arburst ;
	wire [ 0:0] usbM_arlock  ;
	wire [ 3:0] usbM_arcache ;
	wire [ 2:0] usbM_arprot  ;
	wire        usbM_rvalid  ;
	wire        usbM_rready  ;
	wire [63:0] usbM_rdata   ;
	wire [ 7:0] usbM_rid     ;
	wire        usbM_rlast   ;
	wire        axi0_awvalid ;
	wire        axi0_awready ;
	wire [23:0] axi0_awaddr  ;
	wire [ 7:0] axi0_awid    ;
	wire [ 7:0] axi0_awlen   ;
	wire [ 2:0] axi0_awsize  ;
	wire [ 1:0] axi0_awburst ;
	wire [ 0:0] axi0_awlock  ;
	wire [ 3:0] axi0_awcache ;
	wire [ 2:0] axi0_awprot  ;
	wire        axi0_wvalid  ;
	wire        axi0_wready  ;
	wire [63:0] axi0_wdata   ;
	wire [ 7:0] axi0_wstrb   ;
	wire        axi0_wlast   ;
	wire        axi0_bvalid  ;
	wire        axi0_bready  ;
	wire [ 7:0] axi0_bid     ;
	wire        axi0_arvalid ;
	wire        axi0_arready ;
	wire [23:0] axi0_araddr  ;
	wire [ 7:0] axi0_arid    ;
	wire [ 7:0] axi0_arlen   ;
	wire [ 2:0] axi0_arsize  ;
	wire [ 1:0] axi0_arburst ;
	wire [ 0:0] axi0_arlock  ;
	wire [ 3:0] axi0_arcache ;
	wire [ 2:0] axi0_arprot  ;
	wire        axi0_rvalid  ;
	wire        axi0_rready  ;
	wire [63:0] axi0_rdata   ;
	wire [ 7:0] axi0_rid     ;
	wire        axi0_rlast   ;
/*	wire        axiS_arwvalid;
	wire        axiS_arwready;
	wire [31:0] axiS_arwaddr ;
	wire [ 8:0] axiS_arwid   ;
	wire [ 7:0] axiS_arwlen  ;
	wire [ 2:0] axiS_arwsize ;
	wire [ 1:0] axiS_arwburst;
	wire [ 3:0] axiS_arwcache;
	wire        axiS_arwwrite;
	wire        axiS_wvalid  ;
	wire        axiS_wready  ;
	wire [63:0] axiS_wdata   ;
	wire [ 7:0] axiS_wstrb   ;
	wire        axiS_wlast   ;
	wire        axiS_bvalid  ;
	wire        axiS_bready  ;
	wire [ 8:0] axiS_bid     ;
	wire        axiS_rvalid  ;
	wire        axiS_rready  ;
	wire [63:0] axiS_rdata   ;
	wire [ 8:0] axiS_rid     ;
	wire        axiS_rlast   ;
	*/
	TinyClunx i_TinyClunx (
		.axiReset              (axiReset     ),
		.axiClk                (axiClk       ),
		.usbM_aw_valid         (usbM_awvalid ),
		.usbM_aw_ready         (usbM_awready ),
		.usbM_aw_payload_addr  (usbM_awaddr  ),
		.usbM_aw_payload_id    (usbM_awid    ),
		.usbM_aw_payload_len   (usbM_awlen   ),
		.usbM_aw_payload_size  (usbM_awsize  ),
		.usbM_aw_payload_burst (usbM_awburst ),
		.usbM_aw_payload_lock  (usbM_awlock  ),
		.usbM_aw_payload_cache (usbM_awcache ),
		.usbM_aw_payload_prot  (usbM_awprot  ),
		.usbM_w_valid          (usbM_wvalid  ),
		.usbM_w_ready          (usbM_wready  ),
		.usbM_w_payload_data   (usbM_wdata   ),
		.usbM_w_payload_strb   (usbM_wstrb   ),
		.usbM_w_payload_last   (usbM_wlast   ),
		.usbM_b_valid          (usbM_bvalid  ),
		.usbM_b_ready          (usbM_bready  ),
		.usbM_b_payload_id     (usbM_bid     ),
		.usbM_ar_valid         (usbM_arvalid ),
		.usbM_ar_ready         (usbM_arready ),
		.usbM_ar_payload_addr  (usbM_araddr  ),
		.usbM_ar_payload_id    (usbM_arid    ),
		.usbM_ar_payload_len   (usbM_arlen   ),
		.usbM_ar_payload_size  (usbM_arsize  ),
		.usbM_ar_payload_burst (usbM_arburst ),
		.usbM_ar_payload_lock  (usbM_arlock  ),
		.usbM_ar_payload_cache (usbM_arcache ),
		.usbM_ar_payload_prot  (usbM_arprot  ),
		.usbM_r_valid          (usbM_rvalid  ),
		.usbM_r_ready          (usbM_rready  ),
		.usbM_r_payload_data   (usbM_rdata   ),
		.usbM_r_payload_id     (usbM_rid     ),
		.usbM_r_payload_last   (usbM_rlast   ),
		.sysM_aw_valid         (axi0_awvalid ),
		.sysM_aw_ready         (axi0_awready ),
		.sysM_aw_payload_addr  (axi0_awaddr  ),
		.sysM_aw_payload_id    (axi0_awid    ),
		.sysM_aw_payload_len   (axi0_awlen   ),
		.sysM_aw_payload_size  (axi0_awsize  ),
		.sysM_aw_payload_burst (axi0_awburst ),
		.sysM_aw_payload_lock  (axi0_awlock  ),
		.sysM_aw_payload_cache (axi0_awcache ),
		.sysM_aw_payload_prot  (axi0_awprot  ),
		.sysM_w_valid          (axi0_wvalid  ),
		.sysM_w_ready          (axi0_wready  ),
		.sysM_w_payload_data   (axi0_wdata   ),
		.sysM_w_payload_strb   (axi0_wstrb   ),
		.sysM_w_payload_last   (axi0_wlast   ),
		.sysM_b_valid          (axi0_bvalid  ),
		.sysM_b_ready          (axi0_bready  ),
		.sysM_b_payload_id     (axi0_bid     ),
		.sysM_ar_valid         (axi0_arvalid ),
		.sysM_ar_ready         (axi0_arready ),
		.sysM_ar_payload_addr  (axi0_araddr  ),
		.sysM_ar_payload_id    (axi0_arid    ),
		.sysM_ar_payload_len   (axi0_arlen   ),
		.sysM_ar_payload_size  (axi0_arsize  ),
		.sysM_ar_payload_burst (axi0_arburst ),
		.sysM_ar_payload_lock  (axi0_arlock  ),
		.sysM_ar_payload_cache (axi0_arcache ),
		.sysM_ar_payload_prot  (axi0_arprot  ),
		.sysM_r_valid          (axi0_rvalid  ),
		.sysM_r_ready          (axi0_rready  ),
		.sysM_r_payload_data   (axi0_rdata   ),
		.sysM_r_payload_id     (axi0_rid     ),
		.sysM_r_payload_last   (axi0_rlast   )
/*		,
		.axiS_arw_valid        (axiS_arwvalid),
		.axiS_arw_ready        (axiS_arwready),
		.axiS_arw_payload_addr (axiS_arwaddr ),
		.axiS_arw_payload_id   (axiS_arwid   ),
		.axiS_arw_payload_len  (axiS_arwlen  ),
		.axiS_arw_payload_size (axiS_arwsize ),
		.axiS_arw_payload_burst(axiS_arwburst),
		.axiS_arw_payload_cache(axiS_arwcache),
		.axiS_arw_payload_write(axiS_arwwrite),
		.axiS_w_valid          (axiS_wvalid  ),
		.axiS_w_ready          (axiS_wready  ),
		.axiS_w_payload_data   (axiS_wdata   ),
		.axiS_w_payload_strb   (axiS_wstrb   ),
		.axiS_w_payload_last   (axiS_wlast   ),
		.axiS_b_valid          (axiS_bvalid  ),
		.axiS_b_ready          (axiS_bready  ),
		.axiS_b_payload_id     (axiS_bid     ),
		.axiS_r_valid          (axiS_rvalid  ),
		.axiS_r_ready          (axiS_rready  ),
		.axiS_r_payload_data   (axiS_rdata   ),
		.axiS_r_payload_id     (axiS_rid     ),
		.axiS_r_payload_last   (axiS_rlast   )
*/
	);

`endif