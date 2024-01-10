/* The original wishbone CDC doesnt work properly as designed
 * Gutted its innards to be much simpler.
 */
module wb_cdc_mod #(parameter AW = 32) (
  input  wire          wbm_clk  ,
  input  wire          wbm_rst  ,
  input  wire [AW-1:0] wbm_adr_i,
  input  wire [  31:0] wbm_dat_i,
  input  wire [   3:0] wbm_sel_i,
  input  wire          wbm_we_i ,
  input  wire          wbm_cyc_i,
  input  wire          wbm_stb_i,
  output wire [  31:0] wbm_dat_o,
  output wire          wbm_ack_o,
  input  wire          wbs_clk  ,
  input  wire          wbs_rst  ,
  output wire [AW-1:0] wbs_adr_o,
  output wire [  31:0] wbs_dat_o,
  output wire [   3:0] wbs_sel_o,
  output wire          wbs_we_o ,
  output wire          wbs_cyc_o,
  output wire          wbs_stb_o,
  input  wire [  31:0] wbs_dat_i,
  input  wire          wbs_ack_i
);

  // Only the control signals need to cross the domain, the address and data will be stable
  // during this time.
  wire wbm_cs = wbm_cyc_i & wbm_stb_i;
  wire wbs_cs;
  sync2_reg i_m2s_sync2_reg (
    .clk(wbs_clk),
    .rst(~wbm_cs),
    .d  (wbm_cs ), //CDC
    .p  (       ),
    .q  (wbs_cs )
  );

  assign wbs_cyc_o = wbs_cs;
  assign wbs_stb_o = wbs_cs;
  assign {wbs_adr_o, wbs_dat_o, wbs_sel_o, wbs_we_o} = {wbm_adr_i, wbm_dat_i, wbm_sel_i, wbm_we_i};

  // The data from the WBS is assumed to be stable as long as the ACK
  // is active. Use the data as-is and only CDC the ack.
  sync2_reg i_s2m_sync2_reg (
    .clk(wbm_clk  ),
    .rst(~wbm_cs  ),
    .d  (wbs_ack_i), //CDC
    .p  (         ),
    .q  (wbm_ack_o)
  );

  assign wbm_dat_o = wbs_dat_i;

endmodule

module sync2_reg (
  input  wire clk,
  input  wire rst,
  input  wire d  ,
  output wire p  ,
  output wire q
);

   reg    q1, q2, q3;
   
   always @(posedge clk or posedge  rst) begin
    if (rst) begin
      q1 <= 0;
      q2 <= 0;
      q3 <= 0;
    end else begin
      q1 <= d;
      q2 <= q1;
      q3  <= q2;
    end
   end

   assign p = q2 ^ q3;
   assign q = q3;
   
endmodule