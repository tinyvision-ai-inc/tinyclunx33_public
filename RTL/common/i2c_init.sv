/*
* This module will initialize the SI5351 PLL chip.
* To change the programming, you must edit the i2c_ctrl_si5351 module.
* NOTE: This module _DOES NOT_ check for a NAK which can happen if the
* I2C device is missing.
*/

module i2c_init #(
   parameter INIT_FILE    = "init_file.mem", // File containing packed data of (address, value)
   parameter NUM_ADDR     = 'd43           , // Number of I2C accesses to send out
   parameter STARTUP_TIME = 'd18000000       // Some devices need to wait a bit after reset to initialize them
) (
   input  wire rst_n       ,
   input  wire clk         ,
   input  wire scl         ,
   output wire scl_out     ,
   input  wire sda         ,
   output wire sda_out     ,
   output wire i2c_done    ,
   output wire config_done ,
   // An error is detected by looking for a NACK during the I2C write address phase. This usually
   // happens if the device at the address requested is not present. Check your init file for errors.
   output wire config_error,
   input       shutdown
);


   wire       cmd        ;
   wire [6:0] addr_dev   ;
   wire [7:0] addr_reg_H ;
   wire [7:0] addr_reg_L ;
   wire [7:0] data_wr_H  ;
   wire [7:0] data_wr_L  ;
   wire [7:0] data_rd    ;
   wire       i2c_rqt    ;
   wire       data_rdy   ;
   wire [7:0] i2c_data_rd; // Not really used...

   i2c_ctrl #(.INIT_FILE(INIT_FILE), .NUM_ADDR(NUM_ADDR), .STARTUP_TIME(STARTUP_TIME)) i_i2c_ctrl (
      .rst_n      (rst_n      ),
      .clk        (clk        ),
      .config_done(config_done),
      .cmd        (cmd        ),
      .addr_dev   (addr_dev   ),
      .addr_reg_H (addr_reg_H ),
      .addr_reg_L (addr_reg_L ),
      .data_wr_H  (data_wr_H  ),
      .data_wr_L  (data_wr_L  ),
      .data_rdy   (data_rdy   ),
      .data_rd    (data_rd    ),
      .i2c_done   (i2c_done   ),
      .i2c_rqt    (i2c_rqt    ),
      .shutdown   (shutdown   )
   );

   i2c_core i_i2c_core (
      .rst_n     (rst_n       ),
      .clk       (clk         ),
      .scl       (scl         ),
      .scl_out   (scl_out     ),
      .sda       (sda         ),
      .sda_out   (sda_out     ),
      .i2c_rqt   (i2c_rqt     ),
      .cmd       (cmd         ),
      .addr_dev  (addr_dev    ),
      .addr_reg_H(addr_reg_H  ),
      .addr_reg_L(addr_reg_L  ),
      .data_wr_H (data_wr_H   ),
      .data_wr_L (data_wr_L   ),
      .data_rd   (data_rd     ),
      .data_rdy  (data_rdy    ),
      .i2c_done  (i2c_done    ),
      .error     (config_error)
   );

   assign i2c_data_rd = data_rd;

endmodule

