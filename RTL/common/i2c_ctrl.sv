module i2c_ctrl #(
   parameter INIT_FILE    = "init_file.mem", // File containing packed data of (address, value)
   parameter NUM_ADDR     = 'd43           , // Number of I2C accesses to send out
   parameter STARTUP_TIME = 'd18000000       // Some devices need to wait a bit after reset to initialize them
) (
   input  logic       rst_n      ,
   input  logic       clk        , // 27MHz
   output logic       config_done,
   output logic       cmd        ,
   output logic [6:0] addr_dev   ,
   output logic [7:0] addr_reg_H ,
   output logic [7:0] addr_reg_L ,
   output logic [7:0] data_wr_H  ,
   output logic [7:0] data_wr_L  ,
   input  logic       data_rdy   ,
   input  logic [7:0] data_rd    ,
   input  logic       i2c_done   ,
   output logic       i2c_rqt    ,
   input  logic       shutdown
);
   logic                        i2c_done_s1 ;
   logic [$clog2(NUM_ADDR)-1:0] step_cnt    ;
   logic                        i2c_done_neg;

   assign addr_reg_H = 8'd0;
   assign data_wr_H  = 8'd0;

   localparam
      WRITE= 1,
      READ = 0;


   always@(posedge clk) i2c_done_s1<=i2c_done;
   assign i2c_done_neg = !i2c_done && i2c_done_s1;

   logic [31:0] cnt_startup  ;
   logic        timer_startup;

   always @(posedge clk or negedge rst_n)
      begin
         if(!rst_n || shutdown)
            begin
               cnt_startup <= 0;
            end
         `ifdef SIM
            else if (cnt_startup==STARTUP_TIME/1000000)    cnt_startup<=STARTUP_TIME/1000; // one time count so hold - count for 1.1ms
         `else
            else if (cnt_startup==STARTUP_TIME)    cnt_startup<=STARTUP_TIME; // one time count so hold - count for 1.1ms
         `endif
         else                    cnt_startup<=cnt_startup+1;
      end

   `ifdef SIM
      assign timer_startup = (cnt_startup==STARTUP_TIME/1000);
   `else
      assign timer_startup = (cnt_startup==STARTUP_TIME);
   `endif

   logic i2c_req;

   always@(posedge clk or  negedge rst_n)
      begin
         if(!rst_n || shutdown)
            begin
               i2c_req     <= 0;
               step_cnt    <= 0;
               config_done <= 0;
            end
         else if (!timer_startup)
            begin
               i2c_req  <= 0;
               step_cnt <= 0;
            end

         else if (step_cnt<=NUM_ADDR-1)
            begin // TBD: how many registers need to be configured.
               if(i2c_done_neg)
                  begin
                     step_cnt <= step_cnt+1;
                     i2c_req  <= 1'b0;
                  end
               else
                  begin
                     i2c_req <= 1'b1;
                  end
            end
         else if (step_cnt == NUM_ADDR)
            begin
               i2c_req     <= 1'b0;
               config_done <= 1'b1;
            end
      end

// ROM that holds the initialization data
   logic [23:0] rom     [0:NUM_ADDR-1];
   logic [23:0] rom_data              ;
   initial $readmemh(INIT_FILE, rom);

   always_ff @(posedge clk)
      rom_data <= rom[step_cnt];

   assign {addr_dev, addr_reg_L, data_wr_L} = rom_data[22:0];
   assign cmd = WRITE;

   // ROM takes a cycle to read out, align with this
   always_ff @(posedge clk)
      i2c_rqt <= i2c_req;

endmodule