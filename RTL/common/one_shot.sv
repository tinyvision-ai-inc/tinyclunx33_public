module one_shot #(parameter int PERIOD = 100 // Number of clock cycles for the one-shot pulse
) (
    input  wire     clk       , // Clock signal
    input  wire     rst       , // Active-high reset signal
    input  wire     start     , // Start signal
    output      reg pulse_o   , // One-shot pulse
    output wire     one_shot_o  // Level output: not registered!
);

    reg [$clog2(PERIOD)-1:0] counter; // Counter to count down from PERIOD to 0

    always @(posedge clk or posedge rst) begin
        if (rst) begin

            counter <= '0;
            pulse_o <= '0;

        end else begin
            
            if (start)            counter <= PERIOD;
            else if (counter > 0) counter <= counter - 'd1;

            pulse_o <= (counter == 'd1);

        end
    end

    // Level output when the counter isnt zero
    assign one_shot_o = (counter > '0);

endmodule