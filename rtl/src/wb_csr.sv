/* Implements commonly used control/status registers */
`default_nettype wire

module wb_csr #(
    // Maximum dimensions of image to be processed
    parameter MAX_COL_PIXELS = 1920                  ,
    parameter MAX_ROW_PIXELS = 1080                  ,
    parameter PIXEL_BITS     = 10                    ,
    parameter MAX_COL_WIDTH  = $clog2(MAX_COL_PIXELS),
    parameter MAX_ROW_WIDTH  = $clog2(MAX_ROW_PIXELS)
) (
    input  wire                       wb_clk           ,
    input  wire                       wb_rst           ,
    // Wishbone Interface
    input  wire     [           31:0] wb_adr_i         ,
    input  wire     [           31:0] wb_dat_i         ,
    input  wire     [            3:0] wb_sel_i         ,
    input  wire                       wb_we_i          ,
    input  wire                       wb_cyc_i         ,
    input  wire                       wb_stb_i         ,
    output      reg [           31:0] wb_dat_o         ,
    output      reg                   wb_ack_o         ,
    output wire                       wb_err_o         ,
    // All the signals are in this clock domain:
    input  wire                       clk              ,
    input  wire                       rst              ,
    // MISC
    input  wire                       pll_locked       ,
    input  wire                       buffer_full_err  ,
    // CAMIF
    output wire                       rx_en            ,
    output wire                       tx_en            ,
    output wire                       test_pattern_en  ,
    output wire                       test_pattern_type,
    input  wire     [MAX_COL_WIDTH:0] num_cols         ,
    input  wire     [MAX_ROW_WIDTH:0] num_rows         ,
    input  wire     [           31:0] num_frames       ,
    // Contains the average of all pixels for each of the 4 CFA channels
    input  wire     [           31:0] avg_chan_0       ,
    input  wire     [           31:0] avg_chan_1       ,
    input  wire     [           31:0] avg_chan_2       ,
    input  wire     [           31:0] avg_chan_3       ,
    // Per channel gain can be applied to implement AWB
    output wire     [            7:0] gain_chan_0      ,
    output wire     [            7:0] gain_chan_1      ,
    output wire     [            7:0] gain_chan_2      ,
    output wire     [            7:0] gain_chan_3
);


//------------------------------------------------------
// Register Interface parameters and definitions:
//------------------------------------------------------
    localparam REG_NOT_IMPLEMENTED = 'hdeadbeef;
    localparam REG_NOT_READABLE    = 'hfeedf00d;
    
    // The channel gain is by default set to a gain of 1.
    localparam GAIN_RESET_VAL = 'h3f3f3f3f;

    // Register addresses:
    localparam CSR_SCRATCH     = 'h00;
    localparam CSR_CONTROL     = 'h04;
    localparam CSR_STATUS      = 'h08;
    //localparam CSR_CONFIG      = 'h0C; // Reserved for future use
    localparam CSR_NUM_FRAMES  = 'h10;
    localparam CSR_IMAGE_STATS = 'h14;
    localparam CSR_IMAGE_GAIN  = 'h18;
    localparam CSR_CHAN_AVG_0  = 'h1C;
    localparam CSR_CHAN_AVG_1  = 'h20;
    localparam CSR_CHAN_AVG_2  = 'h24;
    localparam CSR_CHAN_AVG_3  = 'h28;

    // The scratch register is a 32 bit read/write register with a known reset pattern
    // thats useful for read/write testing in the real world.
    localparam MISC_SCRATCH_RESET_VALUE = 32'hfeedbeef;

    // Set the enable to a 1 to enable data from the image sensor to come into the design.
    typedef struct packed {
        logic buffer_full_err; // Set when buffers fills up, sticky bit, cleared on reset only! Useful for debug.
        logic test_pattern_type; // Select the type of test pattern to be output
        logic test_pattern_en; // Set to enable a test pattern
        logic tx_en;           // Enables Transmit data to flow
        logic rx_en;           // Enables Receive data to flow
        logic pll_locked;      // Set when the PLL has locked
    } control_status_reg_t;
    localparam CONTROL_STATUS_BITS = 5;

    typedef struct packed {
        logic [MAX_COL_WIDTH:0] num_col;    
        logic [MAX_ROW_WIDTH:0] num_row;    
    } image_stats_reg_t;
    localparam STATUS_REG_BITS = MAX_COL_WIDTH+1+MAX_ROW_WIDTH+1;

    typedef struct packed {
        logic [7:0][3:0] x;    
    } image_gain_reg_t;

    //------------------------------------------------------
    // Cross the clock domain:
    //------------------------------------------------------
    logic [6:0] wbs_adr_o;
    logic [31:0] wbs_dat_o;
    logic [3:0] wbs_sel_o;
    logic wbs_we_o;
    logic wbs_cyc_o;
    logic wbs_stb_o;
    logic [31:0] wbs_dat_i;
    logic wbs_ack_i;
    wb_cdc_mod #(.AW(7)) i_wb_cdc (
        .wbm_clk  (wb_clk       ),
        .wbm_rst  (wb_rst       ),
        .wbm_adr_i(wb_adr_i[6:0]),
        .wbm_dat_i(wb_dat_i     ),
        .wbm_sel_i(wb_sel_i     ),
        .wbm_we_i (wb_we_i      ),
        .wbm_cyc_i(wb_cyc_i     ),
        .wbm_stb_i(wb_stb_i     ),
        .wbm_dat_o(wb_dat_o     ),
        .wbm_ack_o(wb_ack_o     ),
        .wbs_clk  (clk          ),
        .wbs_rst  (rst          ),
        .wbs_adr_o(wbs_adr_o    ),
        .wbs_dat_o(wbs_dat_o    ),
        .wbs_sel_o(wbs_sel_o    ),
        .wbs_we_o (wbs_we_o     ),
        .wbs_cyc_o(wbs_cyc_o    ),
        .wbs_stb_o(wbs_stb_o    ),
        .wbs_dat_i(wbs_dat_i    ),
        .wbs_ack_i(wbs_ack_i    )
    );


    //------------------------------------------------------
    // Misc registers
    //------------------------------------------------------
    logic [31:0] misc_scratch;

    control_status_reg_t misc_control, misc_status;

    image_stats_reg_t image_stats;
    
    image_gain_reg_t image_gain;

    // Break out the control registers
    assign rx_en             = misc_control.rx_en;
    assign tx_en             = misc_control.tx_en;
    assign test_pattern_en   = misc_control.test_pattern_en;
    assign test_pattern_type = misc_control.test_pattern_type;

    // Status read register
    always @* begin
        misc_status = '0;
        // Status reads back control for writeable fields
        misc_status                 = misc_control;
        // Now override the read only parts
        misc_status.buffer_full_err = buffer_full_err;
        misc_status.pll_locked      = pll_locked;
    end

    // Image stats register
    always @* begin
        image_stats         = '0;
        image_stats.num_col = num_cols;
        image_stats.num_row = num_rows;
    end


    wire reg_access = wbs_cyc_o && wbs_stb_o;

    // Register read
    always_ff @(posedge clk) begin
        if(rst) begin
            wbs_dat_i <= '0;
        end else begin
            wbs_dat_i <= '0;

            if (reg_access && (~wbs_we_o) ) begin
                case(wbs_adr_o)
                    CSR_SCRATCH     : wbs_dat_i <= misc_scratch;
                    CSR_CONTROL     : wbs_dat_i <= misc_control;
                    CSR_STATUS      : wbs_dat_i <= misc_status;
                    CSR_NUM_FRAMES  : wbs_dat_i <= num_frames;
                    CSR_IMAGE_STATS : wbs_dat_i <= image_stats;
                    CSR_IMAGE_GAIN  : wbs_dat_i <= image_gain;
                    CSR_CHAN_AVG_0  : wbs_dat_i <= avg_chan_0;
                    CSR_CHAN_AVG_1  : wbs_dat_i <= avg_chan_1;
                    CSR_CHAN_AVG_2  : wbs_dat_i <= avg_chan_2;
                    CSR_CHAN_AVG_3  : wbs_dat_i <= avg_chan_3;
                    default         : wbs_dat_i <= REG_NOT_IMPLEMENTED;

                endcase
            end
        end
    end

    // Register Write
    always_ff @(posedge clk) begin
        if(rst) begin
            misc_scratch <= MISC_SCRATCH_RESET_VALUE;
            misc_control <= '0;
            image_gain   <= GAIN_RESET_VAL;
        end else begin

            // Default states

            if (reg_access && wbs_we_o) begin
                case (wbs_adr_o)
                    CSR_SCRATCH    : misc_scratch <= wbs_dat_o;
                    CSR_CONTROL    : misc_control <= wbs_dat_o[CONTROL_STATUS_BITS-1:0];
                    CSR_IMAGE_GAIN : image_gain   <= wbs_dat_o;
                    default        :;
                endcase
            end
        end
    end


    // WB Ack: single cycle access to all registers
    always_ff @(posedge clk) wbs_ack_i <= reg_access;

endmodule


`default_nettype wire