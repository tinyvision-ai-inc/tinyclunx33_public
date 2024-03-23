`default_nettype none
`timescale 1ns/1ps

`include "sim_defines.sv"

module tb_fpga_top_lifcl33u_som;

	// MIPI Tx feeds the DUT
	wire        pixel_clk   ;
	wire        pixel_rst_n ;
	wire        pixel_fv    ;
	wire        pixel_lv    ;
	wire [ 9:0] pixel_data  ;
	wire        byte_clk_i  ;
	wire        byte_clk_o  ;
	wire        ref_clk     ;
	wire        tx_pll_clk  ;
	wire        pll_lock_i  ;
	wire        pll_lock_o  ;
	wire        tx_init_done;
	wire        tx_rdy      ;
	wire [ 5:0] byte_dt     ;
	wire [15:0] byte_wc     ;
	
	tri1        cam0_clk_p  ;
	tri1        cam0_clk_m  ;
	tri1 [ 1:0] cam0_dat_p  ;
	tri1 [ 1:0] cam0_dat_m  ;
    tri1       tx0_clk_p;
    tri1       tx0_clk_m;
    tri1 [1:0] tx0_dat_p;
    tri1 [1:0] tx0_dat_m;
	// Colorbar generates pixels
	localparam NUM_COLS = 30;
	localparam NUM_ROWS = 40;
/*
	assign pixel_clk   = dut.pixel_clk;
	assign pixel_rst_n = dut.pixel_rst_n;
	assign ref_clk     = dut.sync_clk;
	assign byte_wc = NUM_COLS*10/8;

  logic [9:0] tx_data;
  logic tx_fv, tx_lv;
		colorbar_gen_alt #(
			.h_active     (NUM_COLS),
			.v_active     (NUM_ROWS),
			.V_FRONT_PORCH('d10    ),
			.V_SYNCH      ('d10    ),
			.V_BACK_PORCH ('d5     )
		) i_colorbar_gen (
			.rstn(tx_init_done),
			.clk (pixel_clk   ),
			.data(pixel_data  ),
			.fv  (pixel_fv    ),
			.lv  (pixel_lv    )
		);

 
	// Back-back MIPI to test the MIPI path
	pixel_to_mipi #(.DT_WIDTH(10)) i_pixel_to_mipi (
		.pixel_clk    (pixel_clk               ),
		.rst_n        (pixel_rst_n             ),
		.pixel_rst_n  (pixel_rst_n             ),
		.pixel_fv     (pixel_fv                ),
		.pixel_lv     (pixel_lv                ),
		.pixel_data   (pixel_data              ),
		.byte_clk_i   ('0                      ),
		.byte_clk_o   (byte_clk_o              ),
		.ref_clk      (ref_clk                 ),
		.tx_pll_clk   (dut.tx_clk   ),
		.tx_pll_clk_90(dut.tx_clk_90),
		.pll_lock_i   (1                       ),
		.pll_lock_o   (pll_lock_o              ),
		.tx_init_done (tx_init_done            ),
		.tx_rdy       (tx_rdy                  ),
		.byte_dt      ('h2b                    ),
		.byte_wc      (byte_wc                 ),
		.tx_clk_p     (cam0_clk_p              ),
		.tx_clk_n     (cam0_clk_m              ),
		.tx_d_p       (cam0_dat_p              ),
		.tx_d_n       (cam0_dat_m              )
	);
*/
	
/*------------------------------------------------------------------------------
--  MIPI Rx
------------------------------------------------------------------------------*/
  wire           rx_fv            ;
  wire           rx_lv            ;
  wire [    9:0] rx_data          ;
  wire [   15:0] rx_wc               ;
  wire           hs_sync             ;
  wire           hs_d_en             ;
  wire           rx_lp_en            ;
  wire           rx_lp_av_en         ;
  wire [2*8-1:0] rx_payload          ;
  wire           rx_payload_en       ;
  wire [    5:0] rx_dt               ;
/*
	mipi_to_pixel #(.NUM_RX_LANE(2), .RX_GEAR(8), .DT_WIDTH(10)) i_mipi_to_pixel (
		.rx_clk_p     (tx0_clk_p               ),
		.rx_clk_n     (tx0_clk_m               ),
		.rx_d_p       (tx0_dat_p               ),
		.rx_d_n       (tx0_dat_m               ),
		.sync_clk     (dut.sync_clk ),
		.rst_n        (dut.usb_rst_n),
		.pll_lock     (dut.pll_lock ),
		.byte_clk_i   (dut.byte_clk ),
		.byte_clk_o   (                        ),
		.tx_rdy_i     (dut.tx_rdy   ),
		.ref_dt       (dut.ref_dt   ),
		.pixel_clk    (pixel_clk               ),
		.pixel_rst_n  (pixel_rst_n             ),
		.pixel_fv     (rx_fv                   ),
		.pixel_lv     (rx_lv                   ),
		.pixel_data   (rx_data                 ),
		.rx_wc        (rx_wc                   ),
		.hs_sync      (hs_sync                 ),
		.hs_d_en      (hs_d_en                 ),
		.rx_lp_en     (rx_lp_en                ),
		.rx_lp_av_en  (rx_lp_av_en             ),
		.rx_payload   (rx_payload              ),
		.rx_payload_en(rx_payload_en           ),
		.rx_dt        (rx_dt                   )
	);
*/

always @(posedge pixel_clk) if (rx_fv & rx_lv) $display("%x", rx_data);


	logic       gpio_b1                 ;
	logic       gpio_g1                 ;
	logic       button_n                ;
	logic       clk_2                = 0;
	logic       uart_rxd             = 0;
	logic       uart_txd                ;
	tri1       scl                     ;
	tri1       sda                     ;
	logic       spiflash_clk            ;
	logic       spiflash_cs_n           ;
	tri1  [3:0] spiflash_dq             ;
	wire        VBUS_i                  ;
	wire        usb23_DMP               ;
	wire        usb23_DP                ;
	wire        usb23_REFINCLKEXTM_i    ;
	wire        usb23_REFINCLKEXTP_i    ;
	wire        usb23_RESEXTUSB2        ;
	wire        usb23_RXMP_i            ;
	wire        usb23_RXPP_i            ;
	wire        usb23_TXMP_o            ;
	wire        usb23_TXPP_o            ;

	// Need GSR to get the simulations going properly
	reg CLK_GSR  = 0;
	reg USER_GSR = 1;
	GSR GSR_INST (.GSR_N(USER_GSR), .CLK(CLK_GSR));
  PUR PUR_INST(dut.reset_n);

	initial begin
		$display("Starting testbench");
		button_n = 0;
		#500;
		button_n = 1;
/*
	  @(dut.tx_init_done);
	  $display("%0t TX init_done\n", $time);
	  $display("Starting DPHY models");
		*/
	  #10000000;
		$stop();
	end

	localparam CLK_24M_PERIOD = 41.66/2;
	initial begin
		forever #CLK_24M_PERIOD clk_2 = ~clk_2;
	end

	W25Q128JVxIM #(.FIRMWARE_FILENAME("firmware.hex"), .FIRMWARE_OFFSET('h0010_0000))
		i_flash (
		.CSn  (spiflash_cs_n ),
		.CLK  (spiflash_clk  ),
		.DIO  (spiflash_dq[0]),
		.DO   (spiflash_dq[1]),
		.WPn  (spiflash_dq[2]),
		.HOLDn(spiflash_dq[3])
	);
		             

	// Decode UART:
	wire uart_vr = dut.i_litex_soc_gen.uart_uart_source_valid & dut.i_litex_soc_gen.uart_uart_source_ready;
	always @(posedge uart_vr) $display("%s", dut.i_litex_soc_gen.uart_uart_source_payload_data);

 //I2C slave model
	parameter  SLAVE_ADDR1              = 7'h10; // PLL
	wire [7:0] i2c_slave1_rx_data            ;
	wire       i2c_slave1_rx_data_vld        ;
	i2c_slave_model #(
		.NAME   ("I2C"      ),
		.I2C_ADR(SLAVE_ADDR1)
	) i2c_slave1 (
		.scl      (scl                    ),
		.sda      (sda                    ),
		.no_ack   (1'b0                   ),
		.atn      (/*open*/               ),
		// Outputs
		.o_rx_data(i2c_slave1_rx_data[7:0]),
		.o_rx_vld (i2c_slave1_rx_data_vld )
	);

	always @(posedge i2c_slave1_rx_data_vld) $display("%t::: I2C slave received: %x", $time, i2c_slave1_rx_data);

	`define TX_FREQ_TGT 100 //  = Byte clock frequency
	parameter TX_DPHY_CLK_PERIOD = (1000000/(`TX_FREQ_TGT*8))*2;

	dphy_lp_hs_checker #(
		.name      ("DPHY_TX_HS_LP_CHK"),
		.lane_width(2                  ),
		.clk_period(TX_DPHY_CLK_PERIOD )
	) dphy_tx_hs_lp_chk (
		.clk_p_i(tx0_clk_p),
		.clk_n_i(tx0_clk_m),
		.do_p_i (tx0_dat_p),
		.do_n_i (tx0_dat_m)
	);

	rx_model #(.NUM_LANE(2), .CLK_MODE("CONTINUOUS")) tx_checker (
		.reset_i(~pixel_rst_n),
		.c_p_i  (tx0_clk_p  ),
		.c_n_i  (tx0_clk_m  ),
		.d_p_i  (tx0_dat_p  ),
		.d_n_i  (tx0_dat_m  )
	);

	fpga_top_som_no_mipi dut (
		.gpio_b1             (gpio_b1             ),
		.gpio_g1             (gpio_g1             ),
		.button_n            (button_n            ),
		.clk_2               (clk_2               ),
		.uart_rxd            (uart_rxd            ),
		.uart_txd            (uart_txd            ),
		.scl                 (scl                 ),
		.sda                 (sda                 ),
		.spiflash_clk        (spiflash_clk        ),
		.spiflash_cs_n       (spiflash_cs_n       ),
		.spiflash_dq         (spiflash_dq         ),
		.cam0_clk_p          (cam0_clk_p          ),
		.cam0_clk_m          (cam0_clk_m          ),
		.cam0_dat_p          (cam0_dat_p          ),
		.cam0_dat_m          (cam0_dat_m          ),
		.tx0_clk_p           (tx0_clk_p           ),
		.tx0_clk_m           (tx0_clk_m           ),
		.tx0_dat_p           (tx0_dat_p           ),
		.tx0_dat_m           (tx0_dat_m           ),
		.VBUS_i              (VBUS_i              ),
		.usb23_DMP           (usb23_DMP           ),
		.usb23_DP            (usb23_DP            ),
		.usb23_REFINCLKEXTM_i(usb23_REFINCLKEXTM_i),
		.usb23_REFINCLKEXTP_i(usb23_REFINCLKEXTP_i),
		.usb23_RESEXTUSB2    (usb23_RESEXTUSB2    ),
		.usb23_RXMP_i        (usb23_RXMP_i        ),
		.usb23_RXPP_i        (usb23_RXPP_i        ),
		.usb23_TXMP_o        (usb23_TXMP_o        ),
		.usb23_TXPP_o        (usb23_TXPP_o        )
	);   


endmodule
