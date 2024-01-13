module colorbar_gen_alt #(
    parameter h_active      = 'd1920                                           ,
    parameter H_FRONT_PORCH = 'd48                                             , // Clocks after last pixel of line.
    parameter H_SYNCH       = 'd32                                             , // Clocks asserted high before start of H front porch.
    parameter H_BACK_PORCH  = 'd110                                            , // Clocks before 1st pixel of line.
    parameter h_total       = h_active + H_FRONT_PORCH + H_SYNCH + H_BACK_PORCH, // Total of H_FRONT_PORCH and H_BACK_PORCH
    parameter v_active      = 'd1080                                           ,
    parameter V_FRONT_PORCH = 'd10                                             , // Lines before 1st active line of a frame.
    parameter V_SYNCH       = 'd44                                             , // Lines asserted high before V front porch
    parameter V_BACK_PORCH  = 'd20                                             ,
    parameter v_total       = v_active + V_FRONT_PORCH + V_SYNCH + V_BACK_PORCH,
    parameter mode          = 1                                                  // 0 = colorbar, 1 = incrementing data
) (
    input  logic       rstn,
    input  logic       clk ,
    output logic [9:0] data,
    output logic       fv  ,
    output logic       lv
);

    reg [15:0] col_ctr;
    reg [15:0] row_ctr;
    reg [10:0] color_cntr;
    reg [7:0] rstn_cnt;

    always @(posedge clk)
       if (!rstn)
             rstn_cnt <= 0;
       else
             rstn_cnt <= rstn_cnt[7] ? rstn_cnt : rstn_cnt+1;

    wire rst = !rstn_cnt[7];

    always @(posedge clk) begin
        if (rst) begin
            col_ctr  <= 0;
            row_ctr <= 0;
        end
        else begin

            // Increment the column counter till it reaches the total # of row pixels
            col_ctr <= (col_ctr< (h_total-1)) ? col_ctr+1 : 0;

            // Increment the row counter whenever the column couter rolls over
            row_ctr <= (col_ctr == (h_total-1)) ? (row_ctr == v_total ? 0 : row_ctr+1) : row_ctr;

        end
    end

    // Pick framing signals depending on the parameters:
    assign fv = (row_ctr > V_SYNCH+V_FRONT_PORCH) & (row_ctr <= v_active+V_FRONT_PORCH+V_SYNCH);
    assign lv = (col_ctr > H_SYNCH+H_FRONT_PORCH) & (col_ctr <= h_active+H_FRONT_PORCH+H_SYNCH) & fv;

    always @(posedge clk)
	    if(rst)
	         color_cntr <= 0;
	    else
	         color_cntr <= lv ? color_cntr+1 : 0;

    generate
        if (mode==1)
             assign data = color_cntr;
        else
             assign data = color_cntr<128   ? {10'h3FF}               // white
                         : color_cntr<256   ? {10'h2FF}               // red
                         : color_cntr<384   ? {10'h1FF}               // green
                         : color_cntr<512   ? {10'h0FF}               // Blue
                         : color_cntr<640   ? {10'h07F}               // Gray
                         : color_cntr<768   ? {10'h03F}               // black
                         : color_cntr<896   ? {10'h02F}               // ?
                         : color_cntr<1024  ? {10'h00F}               // ?
                         :                    {10'h000};                // 
/*             assign data = color_cntr<128	? {10'hFFFFFF}               // white
                         : color_cntr<256	? {10'hFF0000}               // red
                         : color_cntr<384 	? {10'h00FF00}   			 // green
						 : color_cntr<512 	? {10'h0000FF}               // Blue
                         : color_cntr<640 	? {10'hAAAAAA}               // Gray
                         : color_cntr<768 	? {10'h000000}               // black
						 : color_cntr<896 	? {10'h222222}               // ?
						 : color_cntr<1024 	? {10'h111111}               // ?
                         :                  {10'h00000};                // 
*/
    endgenerate
endmodule
