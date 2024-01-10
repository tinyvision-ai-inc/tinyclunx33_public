//////////////////////////////////////////////////////////////////////////////////
// Company: Axelsys
// Author:  VO
// Module Name:    i2c_core
// Description:
//  i2c core module, compatiable with i2c spec; can handle the single byte read/write operation
//
// 0.1 --- Auguest 29,2009 --- File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module i2c_core (
  input  wire           rst_n     ,
  input  wire           clk       , //27MHz
  input  wire           scl       ,
  output      reg       scl_out   ,
  input  wire           sda       ,
  output      reg       sda_out   ,
  input  wire           i2c_rqt   ,
  input  wire           cmd       ,
  input  wire     [6:0] addr_dev  ,
  input  wire     [7:0] addr_reg_L,
  input  wire     [7:0] addr_reg_H, // Unused
  input  wire     [7:0] data_wr_L ,
  input  wire     [7:0] data_wr_H , // Unused
  output      reg [7:0] data_rd   ,
  output      reg       data_rdy  ,
  output      reg       error     ,
  output      reg       i2c_done
);

  parameter
    WRITE    = 1,
    READ     = 0;

  parameter   //i2c_cs status
    IDLE              = 1,
    START             = 2,
    SLV_ADDR_WR       = 3,
    SLV_ADDR_WR_ACK   = 4,
    REG_ADDR_H        = 5,
    REG_ADDR_ACK_H    = 6,
    REG_ADDR_L        = 7,
    REG_ADDR_ACK_L    = 8,
    TX_DATA_H         = 9,
    TX_DATA_ACK_H     = 10,
    TX_DATA_L         = 11,
    TX_DATA_ACK_L     = 12,
    STOP_TMP1         = 13,
    STOP_TMP2         = 14,
    IDLE_TMP          = 15,
    START_TMP         = 16,
    ADDR1_B           = 17,
    RX_ACK_D          = 18,
    ADDR2_B           = 19,
    RX_ACK_E          = 20,
    RX_DATA           = 21,
    TX_NAK            = 22,
    STOP1             = 23,
    STOP2             = 24,
    FINISH            = 25,
    WAIT_128U         = 26;


// tri          scl;
// tri          sda;


//   reg          scl_out;
//   reg          sda_out;

  reg scl_s1    ;
  reg scl_s2    ;
  reg sda_s1    ;
  reg sda_s2    ;
  reg i2c_rqt_s1;
  reg i2c_rqt_s2;

  wire scl_pos;
  wire scl_neg;
  wire sda_pos;
  wire sda_neg;

  reg [9:0] cnt_1bit;
  reg [3:0] cnt_bit ;
  reg [5:0] i2c_cs  ;
  reg [5:0] i2c_ns  ;

  reg [7:0] data_buf   ;
  reg [7:0] data_wr_tmp;
  reg [3:0] cnt_byte   ;

  reg  [13:0] cnt_128u  ;
  wire        timer_128u;

  wire timer_125u ;
  wire i2c_rqt_pos;
  reg  nack       ;
//   assign scl = !scl_out?1'b0:1'bz;
//   assign sda = !sda_out?1'b0:1'bz;

  // Capture the state of the NACK as a persistent error condition
  always@(posedge clk or negedge rst_n)
    if (!rst_n) error <= 1'b0;
    else if (nack) error <= 1'b1;

  always@(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      cnt_bit <= 0;
    end
    else if (sda_neg && scl) cnt_bit<=0;
    else if (scl_neg && cnt_bit==9) cnt_bit<=1;
    else if (scl_neg ) cnt_bit<=cnt_bit+1;
  end

  always@(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      cnt_byte <= 0;
    end
    else if(sda_neg && scl) cnt_byte<=0;
    else if(scl_neg && cnt_bit==9) cnt_byte<= cnt_byte+1;
  end

  always@(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      scl_s1 <= 1'b1;
      scl_s2 <= 1'b1;
    end
    else begin
      scl_s1 <= scl;
      scl_s2 <= scl_s1;
    end
  end
  assign scl_pos = scl_s1 && !scl_s2;
  assign scl_neg = !scl_s1 && scl_s2;

  always@(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      sda_s1 <= 1'b1;
      sda_s2 <= 1'b1;
    end
    else begin
      sda_s1 <= sda;
      sda_s2 <= sda_s1;
    end
  end
  assign sda_pos = sda_s1 && !sda_s2;
  assign sda_neg = !sda_s1 && sda_s2;

  always@(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      i2c_rqt_s1 <= 1'b1;
      i2c_rqt_s2 <= 1'b1;
    end
    else begin
      i2c_rqt_s1 <= i2c_rqt;
      i2c_rqt_s2 <= i2c_rqt_s1;
    end
  end
  assign i2c_rqt_pos = i2c_rqt_s1 && !i2c_rqt_s2;

  always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      cnt_1bit <= 0;
    end
    else if (scl_pos || scl_neg)  cnt_1bit<=0;
    else if (cnt_1bit>270)    cnt_1bit<=0;
    else if (i2c_ns!=IDLE )     cnt_1bit<=cnt_1bit+1;
    else              cnt_1bit<=0;
  end
  assign timer_125u = (cnt_1bit==270); //170); //1.25u, half cycle of scl, assume clk is 10ns/cycle

  always @(posedge clk or negedge rst_n)
    begin
      if(!rst_n) begin
        cnt_128u <= 0;
      end
      else if (i2c_cs==WAIT_128U) cnt_128u<=cnt_128u+1;
      else  cnt_128u<=0;
    end
  assign timer_128u = cnt_128u>=6900;

  always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      scl_out <= 1'b1;
    end
    else if (i2c_cs==IDLE || i2c_cs==START || i2c_cs==FINISH) scl_out<=1'b1;
    else if (i2c_cs!=WAIT_128U && (i2c_cs!=IDLE && i2c_cs!=START && i2c_cs!=STOP2 && i2c_cs!=STOP_TMP2 && i2c_cs!=IDLE_TMP ) && timer_125u)  scl_out<=~scl_out;
  end

  // sda output
  always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      sda_out <= 1'b1;
    end
    else if (i2c_cs==START || i2c_cs==START_TMP )  sda_out<=1'b0;
    else if (i2c_cs==IDLE_TMP)  sda_out<=1'b1;
    else if (i2c_cs==STOP1 && cnt_1bit==125 )  sda_out<=1'b0;
    else if (i2c_cs==STOP_TMP1 && cnt_1bit==125 )  sda_out<=1'b0;
    else if (i2c_cs==STOP2 && cnt_1bit==125 )  sda_out<=1'b1;
    else if (i2c_cs==STOP_TMP2 && cnt_1bit==125 )  sda_out<=1'b1;
    else if ( i2c_cs== SLV_ADDR_WR || i2c_cs==ADDR1_B || i2c_cs== REG_ADDR_H || i2c_cs== REG_ADDR_L
      || i2c_cs==ADDR2_B || i2c_cs==TX_DATA_H || i2c_cs==TX_DATA_L  )  sda_out<=data_buf[7];
    else if ( ( i2c_cs==RX_DATA || i2c_cs==SLV_ADDR_WR_ACK || i2c_cs== REG_ADDR_ACK_H  || i2c_cs== REG_ADDR_ACK_L
        || i2c_cs==TX_DATA_ACK_H ||i2c_cs==TX_DATA_ACK_L || i2c_cs==RX_ACK_D || i2c_cs==RX_ACK_E || i2c_cs==TX_NAK)
      && cnt_1bit==125) sda_out<=1'b1;
  end

  always @(posedge clk ) begin
    if (i2c_rqt_pos && cmd==WRITE)
      data_wr_tmp <= data_wr_H;        // TBD
  end

  always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      data_rdy <= 1'b0;
    end
    else if (i2c_cs==RX_DATA && scl_neg && cnt_bit==8)
      data_rdy <= 1'b1;
    else data_rdy<=1'b0;
  end

  always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      data_rd <= 0;
    end
    else if (i2c_cs==RX_DATA && scl_neg && cnt_bit==8)
      data_rd <= data_buf;
  end

  // provide/get parallel data to/from the shift register
  always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      data_buf <= 8'h00;
    end
    else if (cnt_bit<9  &&  scl_pos && i2c_cs==RX_DATA) data_buf<={data_buf[6:0],sda}; //rx shift input
    else if (cnt_1bit==125) begin
      if      (cnt_bit==1  && i2c_cs==SLV_ADDR_WR)    data_buf <= {addr_dev,1'b0}      ;
      else if (cnt_bit==1  && i2c_cs==ADDR1_B)        data_buf <= {addr_dev,1'b1}      ;
      else if (cnt_bit==1  && i2c_cs==REG_ADDR_H)     data_buf <= addr_reg_H           ;
      else if (cnt_bit==1  && i2c_cs==REG_ADDR_L)     data_buf <= addr_reg_L           ;
      else if (cnt_bit==1  && i2c_cs==ADDR2_B)        data_buf <= addr_reg_H           ;  // TBD
      else if (cnt_bit==1  && i2c_cs==TX_DATA_H)      data_buf <= data_wr_H            ;
      else if (cnt_bit==1  && i2c_cs==TX_DATA_L)      data_buf <= data_wr_L            ;
      else if (!scl && cnt_bit!=1 && i2c_cs!=RX_DATA) data_buf <= {data_buf[6:0],1'b0} ;  //tx shift output
    end
  end

  //  i2c main fsm
  always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      i2c_cs <= IDLE;
    end
    else begin
      i2c_cs <= i2c_ns;
    end
  end

  // Detect a NACK condition, for now we only detect a NACK for the slave and not a register basis
  always @(posedge clk or negedge rst_n)
    if (!rst_n) nack <= 1'b0;
    else if (scl_neg)
      nack <= ( (i2c_cs == SLV_ADDR_WR_ACK) & sda);

  always@(timer_128u or i2c_cs or i2c_rqt_pos or  cmd or cnt_bit or timer_125u or scl_pos or scl_neg) begin
    case(i2c_cs)
      IDLE : begin
        if (i2c_rqt_pos) i2c_ns=START;
        else i2c_ns=IDLE;
      end
      START : begin
        if (timer_125u) i2c_ns=SLV_ADDR_WR;
        else i2c_ns=START;
      end
      SLV_ADDR_WR : begin
        if (scl_neg && cnt_bit==8) i2c_ns=SLV_ADDR_WR_ACK;
        else i2c_ns=SLV_ADDR_WR;
      end
      SLV_ADDR_WR_ACK : begin
        //if (scl_neg) i2c_ns=REG_ADDR_H;
        if (scl_neg) i2c_ns=REG_ADDR_L; // Modified for 8 bit addressing
        else i2c_ns=SLV_ADDR_WR_ACK;
      end
      REG_ADDR_H : begin
        if (scl_neg && cnt_bit==8) i2c_ns=REG_ADDR_ACK_H;
        else i2c_ns=REG_ADDR_H;
      end
      REG_ADDR_ACK_H : begin
        if (scl_neg) begin
          if (cmd==WRITE || cmd==READ) i2c_ns=REG_ADDR_L;
          //    else if (cmd==READ) i2c_ns=STOP_TMP1;
          else i2c_ns=REG_ADDR_ACK_H;
        end
        else i2c_ns=REG_ADDR_ACK_H;
      end
      REG_ADDR_L : begin
        if (scl_neg && cnt_bit==8) i2c_ns=REG_ADDR_ACK_L;
        else i2c_ns=REG_ADDR_L;
      end
      REG_ADDR_ACK_L : begin
        if (scl_neg) begin
          //if (cmd==WRITE) i2c_ns=TX_DATA_H;
          if (cmd==WRITE) i2c_ns=TX_DATA_L;
          else if (cmd==READ) i2c_ns=STOP_TMP1;
          else i2c_ns=REG_ADDR_ACK_L;
        end
        else i2c_ns=REG_ADDR_ACK_L;
      end
      TX_DATA_H : begin
        if (scl_neg && cnt_bit==8) i2c_ns=TX_DATA_ACK_H;
        else i2c_ns=TX_DATA_H;
      end
      TX_DATA_ACK_H : begin
        //if (scl_neg) i2c_ns=STOP1;
        if (scl_neg) i2c_ns=WAIT_128U;//TX_DATA_L; 8 bit data only
        else i2c_ns=TX_DATA_ACK_H;
      end
      TX_DATA_L : begin
        if (scl_neg && cnt_bit==8) i2c_ns=TX_DATA_ACK_L;
        else i2c_ns=TX_DATA_L;
      end
      TX_DATA_ACK_L : begin
        //if (scl_neg) i2c_ns=STOP1;
        if (scl_neg) i2c_ns=WAIT_128U;
        else i2c_ns=TX_DATA_ACK_L;
      end
      STOP_TMP1 : begin
        if (scl_pos) i2c_ns=STOP_TMP2;
        else i2c_ns=STOP_TMP1;
      end
      STOP_TMP2 : begin
        if (timer_125u) i2c_ns=IDLE_TMP;
        else i2c_ns=STOP_TMP2;
      end
      IDLE_TMP : begin
        if (timer_125u) i2c_ns=START_TMP;
        else i2c_ns=IDLE_TMP;
      end
      START_TMP : begin
        if (timer_125u) i2c_ns=ADDR1_B;
        else i2c_ns=START_TMP;
      end
      ADDR1_B : begin
        if (scl_neg && cnt_bit==8) i2c_ns=RX_ACK_D;
        else i2c_ns=ADDR1_B;
      end
      RX_ACK_D : begin
        if (scl_neg && cmd==READ) i2c_ns=RX_DATA;
        else i2c_ns=RX_ACK_D;
      end
      RX_DATA : begin
        if (scl_neg && cnt_bit==8) i2c_ns=TX_NAK;
        else i2c_ns=RX_DATA;
      end
      TX_NAK : begin
        if (scl_neg) i2c_ns=STOP1;
        else i2c_ns=TX_NAK;
      end
      WAIT_128U : begin
        if (timer_128u) i2c_ns= STOP1;
        else i2c_ns=WAIT_128U;
      end

      STOP1 : begin  //force sda to low
        if (scl_pos) i2c_ns=STOP2;
        else i2c_ns=STOP1;
      end
      STOP2 : begin   //rise sda
        if (timer_125u) i2c_ns=FINISH;
        else i2c_ns=STOP2;
      end
      FINISH : begin
        if (timer_125u) i2c_ns=IDLE;
        else i2c_ns=FINISH;
      end
      default : begin
        i2c_ns = IDLE;
      end
    endcase
  end


  always@(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      i2c_done <= 1'b0;
    end
    else if (i2c_rqt_pos) i2c_done<=1'b0;
    else if (i2c_ns==FINISH) i2c_done<=1'b1;
    else i2c_done<=1'b0;
  end
endmodule