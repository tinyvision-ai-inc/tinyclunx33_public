//-------------------------------------------------------------------------
//  >>>>>>>>>>>>>>>>>>>>>>>>> COPYRIGHT NOTICE <<<<<<<<<<<<<<<<<<<<<<<<<
//-------------------------------------------------------------------------
//  Copyright (c) 2012 by Lattice Semiconductor Corporation      
// 
//-------------------------------------------------------------------------
// Permission:
//
//   Lattice Semiconductor grants permission to use this code for use
//   in synthesis for any Lattice programmable logic product.  Other
//   use of this code, including the selling or duplication of any
//   portion is strictly prohibited.
//
// Disclaimer:
//
//   This VHDL or Verilog source code is intended as a design reference
//   which illustrates how these types of functions can be implemented.
//   It is the user's responsibility to verify their design for
//   consistency and functionality through the use of formal
//   verification methods.  Lattice Semiconductor provides no warranty
//   regarding the use or functionality of this code.
//-------------------------------------------------------------------------
//
//    Lattice Semiconductor Corporation
//    5555 NE Moore Court
//    Hillsboro, OR 97124
//    U.S.A
//
//    TEL: 1-800-Lattice (USA and Canada)
//    503-268-8001 (other locations)
//
//    web: http://www.latticesemi.com/
//    email: techsupport@latticesemi.com
// 
//-------------------------------------------------------------------------
// 
//  Project  : Wistral ADC controller
//  File Name: i2c_slave_model.v
//  Author   : MDN
//-------------------------------------------------------------------------
//  Code Revision History :
//  Ver: | Author        | Mod. Date    |Changes Made:
//  V1.0 | MDN           | 16SEP2013    |                             
//-------------------------------------------------------------------------
//  Description: I2C slave model 
//-------------------------------------------------------------------------
`timescale 1 ns / 1 ps
 
module i2c_slave_model #(
	parameter NAME = "I2C_SLAVE",
	parameter I2C_ADR = 7'h20
) (
	output			atn,
	output [7:0]	o_rx_data,
	output			o_rx_vld,
	inout			sda,
	input			scl,
	input			no_ack
);
    // generate interrupt
    event request_attention;
    event service_completed;
    reg   atn_reg;
    reg [7:0] mem [15:0];
    reg [7:0] mem_do = 8'h00;
    reg [3:0] mem_addr = 4'b0000;
    reg       sta;
    reg       d_sta;
    reg       sto;
    reg [7:0] sr;
    reg       rw;    
    reg [7:0] td = 0;  // Test data
    wire      my_adr;
    wire      i2c_reset;
    reg [2:0] bit_cnt;
    wire      acc_done;
    reg       ld;
    reg       sda_o;
    wire      sda_dly;

	integer i;

    parameter idle = 3'b000;
    parameter slave_ack = 3'b001;
    parameter data = 3'b010;
    parameter data_ack = 3'b011;
    parameter not_mine = 3'b111;

    reg [2:0] state;

    initial begin
        mem[0] = 0;
        mem[1] = 0;
        mem[2] = 0;
        mem[3] = 0;
        mem[4] = 0;
        mem[5] = 0;
        mem[6] = 0;
        mem[7] = 0;
        mem[8] = 0;
        mem[9] = 0;
        mem[10] = 0;
        mem[11] = 0;
        mem[12] = 0;
        mem[13] = 0;
        mem[14] = 0;
        mem[15] = 0;
    end

    initial begin
        sda_o = 1'b1;
        state = idle;
    end

    assign atn = atn_reg;
    // detect my_address
    assign my_adr = (sr[7:5] == I2C_ADR[6:4]);
    
    // generate access done signal
    assign acc_done = !(|bit_cnt);

    // generate delayed version of sda
    assign #1 sda_dly = sda;

    // generate i2c_reset signal
    assign i2c_reset = sta || sto;

    // generate tri-states
    assign sda = sda_o ? 1'bz : 1'b0;

    assign o_rx_data = sr;
    assign o_rx_vld = state == data && !rw && acc_done;
                     
    always begin
        atn_reg <= 1'bz;
        @(request_attention);
        atn_reg <= 1'b0;
        @(service_completed);
    end
                
    // generate shift register
    always @(posedge scl) sr <= #1 {sr[6:0],sda};
    
    // generate bit-counter
    always @(posedge scl) begin
        if(ld) bit_cnt <= #1 3'b111;
        else bit_cnt <= #1 bit_cnt - 3'h1;
    end
    

    // detect start condition
    always @(negedge sda) begin
        if(scl) begin
            sta <= #1 1'b1;
            d_sta <= #1 1'b0;
            sto <= #1 1'b0;
`ifdef VERBOSE
            $display();
            $display("     Note: i2c_slave_model %h detected start condition.", I2C_ADR);
`endif
        end else 
            sta <= #1 1'b0;
    end

    always @(posedge scl) d_sta <= #1 sta;

    // detect stop condition
    always @(posedge sda) begin
        if(scl) begin
            sta <= #1 1'b0;
            sto <= #1 1'b1;
`ifdef VERBOSE
            $display("     Note: i2c_slave_model %h detected stop condition.", I2C_ADR);
            $display();
`endif
			if (mem_addr != 0) begin
				$write ("%0t ns : %0s I2C Slave received write data", $time/1000, NAME);
				for (i=0; i<mem_addr; i=i+1) begin
					$write (" %02h", mem[i]);
				end
				$write ("\n");
			end
        end else 
            sto <= #1 1'b0;
    end

    // generate statemachine
	always @(negedge scl or posedge sto) begin
		if (sto || (sta && !d_sta)) begin
			state <= #1 idle;
			sda_o <= #1 1'b1;
			ld <= #1 1'b1;
		end
		else begin
			sda_o <= #1 1'b1;
			ld <= #1 1'b0;
			case (state)
				idle:
					if (acc_done && !my_adr)   // Not mine, ignore until next one
						state <= #1 not_mine;
					else if (acc_done && my_adr) begin
                        state <= #1 slave_ack;
                        rw <= #1 sr[0];
//                        mem_addr <= #1 sr[4:1];
                        mem_addr <= #1 0;	// 20201017 MT
                        sda_o <= #1 no_ack;    // **** Vinayak
                        #2;
`ifdef VERBOSE
                        if (rw) $display("     Note: i2c_slave_model %h claimed rd cmd", I2C_ADR);
                        if (!rw) $display("     Note: i2c_slave_model %h claimed wr cmd", I2C_ADR);
`endif
                        if (rw) begin
                            mem_do <= #1 td; //mem[mem_addr];
                            //              td <= td + 1'b1;
                            //#2 $display("     Note: i2c_slave_model %h fetched rd data 20", I2C_ADR);
                        end
                    end

				slave_ack: begin
                    if (rw) begin
                        state <= #1 data;
                        sda_o <= #1 mem_do[7];
                    end
					else 
                        state <= #1 data;
                    ld    <= #1 1'b1;
                end
                
                data: begin
                    if (rw) 
                        sda_o <= #1 mem_do[7];
                    if (acc_done) begin
                        state <= #1 data_ack;              
						mem_addr <= #2 mem_addr + 1;
                        sda_o <= #1 rw || no_ack;  // *** Wilson
                        if (rw) begin
                            td <= #2 td + 1'b1;
                            #3 mem_do <= td; // mem[mem_addr];
                            //#5 $display("     Note: i2c_slave_model %h fetched rd data 0x14", I2C_ADR);
                        end
                        if (!rw) begin
                            mem[mem_addr] <= #1 sr;
`ifdef VERBOSE
//                            #2 $display("     Note: i2c_slave_model %h stored wr data %x.", I2C_ADR, sr);
                            #2 $display("  %0s I2C Slave received write data %x.", NAME, sr);
`endif
                        end
                    end
                end
        
                data_ack: begin
                    -> service_completed;
                    ld <= #1 1'b1;
					if (rw) begin
                        if (sr[0]) begin
                            state <= #1 idle;
                            sda_o <= #1 1'b1;
                        end
						else begin
                            state <= #1 data;
                            sda_o <= #1 mem_do[7];
                        end
					end
					else begin
                        state <= #1 data;
                        sda_o <= #1 1'b1;
                    end
                end
	        //not_mine: hold state until start or stop
            endcase
        end
    end

    // read data from memory
    always @(posedge scl) if(!acc_done && rw) mem_do <= #1 {mem_do[6:0], 1'b1};

    reg [7:0] mem_do_reg = 8'h00;  
    //register mem_do for display. Fix for the bug, which was displaying an
    //extra fetch in the output 
    always @(posedge scl) mem_do_reg <= mem_do;
`ifdef VERBOSE
    always @(negedge scl)
        if ((rw == 1)&& (state == data) && (bit_cnt == 7))
            #5 $display("     Note: i2c_slave_model %h fetched rd data %x", I2C_ADR, td);
`endif
  
    
endmodule
