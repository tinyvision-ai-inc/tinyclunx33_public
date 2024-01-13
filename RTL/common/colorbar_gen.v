module colorbar_gen #(
    parameter h_active      = 11'd1280,
    parameter H_FRONT_PORCH = 11'd48  , // Clocks after last pixel of line.
    parameter H_SYNCH       = 11'd32   , // Clocks asserted high before start of H front porch.
    parameter H_BACK_PORCH  = 11'd110  , // Clocks before 1st pixel of line.
    parameter h_total       = h_active + H_FRONT_PORCH + H_SYNCH + H_BACK_PORCH, // Total of H_FRONT_PORCH and H_BACK_PORCH
    parameter v_active      = 11'd728  ,
    parameter V_FRONT_PORCH = 11'd10    , // Lines before 1st active line of a frame.
    parameter V_SYNCH       = 11'd44    , // Lines asserted high before V front porch
    parameter V_BACK_PORCH  = 11'd20   ,
    parameter v_total       = v_active + V_FRONT_PORCH + V_SYNCH + V_BACK_PORCH,
    parameter mode          = 1         // 0 = colorbar, 1 = walking 1's
) ( 
    input             rstn ,
    input             clk  ,
    output reg        de   ,
    output     [9:0] data ,
    output reg        vsync,
    output reg        hsync
);

    reg [15:0] pixcnt;
    reg [15:0] linecnt;
    reg [10:0] color_cntr;
    reg [7:0] rstn_cnt;

    always @(posedge clk)
       if (!rstn)
             rstn_cnt <= 0;
       else
             rstn_cnt <= rstn_cnt[7] ? rstn_cnt : rstn_cnt+1;

    always @(posedge clk) begin
       if (!rstn_cnt[7]) begin
       	  pixcnt    <= 0;
       	  linecnt   <= 0;
       	  de        <= 0;
          hsync     <= 1;
          vsync     <= 1;
       end
       else begin
          pixcnt    <= (pixcnt<h_total-1) ? pixcnt+1 : 0;

          linecnt   <= (linecnt==v_total-1 && pixcnt ==h_active+H_FRONT_PORCH-1)  ? 0         :
                       (linecnt< v_total-1 && pixcnt ==h_active+H_FRONT_PORCH-1)  ? linecnt+1 : linecnt;

          de        <= (pixcnt> 0) & (pixcnt<=h_active) & (linecnt>= 0) & (linecnt<=v_active-1);

       	  hsync     <= (pixcnt>h_active+H_FRONT_PORCH)   & (pixcnt<=h_active+H_FRONT_PORCH+H_SYNCH);
		  
          vsync     <= (linecnt>=v_active+V_FRONT_PORCH) & (linecnt<v_active+V_FRONT_PORCH+V_SYNCH);
       end
    end

    always @(posedge clk)
	    if(!rstn_cnt[7])
	         color_cntr <= 0;
	    else
	         color_cntr <= de ? color_cntr+1 : 0;

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
