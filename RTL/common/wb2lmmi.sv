module wb2lmmi (
  input  logic        clk             ,
  input  logic        rst             ,
  // Wishbone bus
  input  logic        wb_cyc, wb_stb, wb_we,
  input  logic [17:0] wb_adr         ,
  input  logic [31:0] wb_dat_w        ,
  output logic        wb_ack, wb_err  ,
  output logic [31:0] wb_dat_r        ,
  // LMMI bus
  input  logic [31:0] lmmi_rdata      ,
  input  logic        lmmi_rdata_valid,
  input  logic        lmmi_ready      ,
  output logic        lmmi_request    ,
  output logic        lmmi_wr_rdn     ,
  output logic [15:0] lmmi_offset     ,
  output logic [31:0] lmmi_wdata
);

  // Translate between WB and LMMI:
  assign lmmi_offset = wb_adr[17:2];
  assign wb_err      = 1'b0; // Dont deal with this for now
  assign lmmi_wdata  = wb_dat_w;

  // Wishbone state machine
  localparam [3:0]
    WB_IDLE = 'd0,
    LMMI_REQ = 'd1,
    WB_READ = 'd2,
    WB_WRITE = 'd3;

  reg [3:0] wb_state;

  always @(posedge clk) begin
    if (rst) begin
      wb_state <= WB_IDLE;
    end else begin

      // Default state
      wb_ack       <= 0;
      lmmi_request <= 0;
      lmmi_wr_rdn  <= 0;
      wb_dat_r <= '0;

      case (wb_state)
        WB_IDLE : begin
          if (wb_stb & wb_cyc & !wb_ack)
            wb_state <= LMMI_REQ;
        end

        LMMI_REQ : begin
          if (lmmi_ready) begin
            lmmi_request <= 1;

            if (wb_we) begin
              wb_state    <= WB_WRITE;
              lmmi_wr_rdn <= 1;
            end else begin
              wb_state    <= WB_READ;
              lmmi_wr_rdn <= 0;
            end
          end
        end

        WB_READ : begin
          wb_ack <= lmmi_rdata_valid;
          if (lmmi_rdata_valid) begin
            wb_dat_r <= lmmi_rdata;
            wb_state <= WB_IDLE;
            $display("%t:: LMMI RD: A:0x%08x, D: 0x%08x", $time, lmmi_offset, lmmi_rdata);
          end
        end

        WB_WRITE : begin
          wb_ack   <= 1;
          wb_state <= WB_IDLE;
          $display("%t:: LMMI WR: A:0x%08x, D: 0x%08x", $time, lmmi_offset, lmmi_wdata);
        end
      endcase
    end
  end

endmodule : wb2lmmi