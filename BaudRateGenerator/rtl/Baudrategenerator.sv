///////////////////////////////////////////////////////////
// Module : BaudRtaegenerator
// Author : YashTomar
///////////////////////////////////////////////////////////

// Code your design here
`timescale 1ns/1ps
module BaudRateGenerator(
  input i_CLK,
  input i_RST_B,
  input i_OVER8,
  input [15:0]i_USARTBRR, // register value (12 bit mantissa and 4 bit fraction)
  output reg o_BRGCLK //  baud rate clock
);
  
  wire [11:0]MANTISSA;
  wire [3:0]FRACTION;
  reg [15:0]USARTDIV;
  reg [15:0]BAUDDIV;
  reg [15:0]counter;
  
  assign MANTISSA = i_USARTBRR[15:4];
  assign FRACTION = i_USARTBRR[3:0];
  assign USARTDIV = {MANTISSA,FRACTION}; // same as value of USARTBRR
  assign BAUDDIV = i_OVER8  ? (8 * USARTDIV/16) : (16 * USARTDIV/16);
  
  // counter to count clk
  always @(posedge i_CLK or negedge i_RST_B) begin
   	if(!i_RST_B) begin
      counter <= 'd0;
    end
     else if(counter == (BAUDDIV-1)) begin
      counter <= 16'd0;   
    end
    else begin
      counter <= counter + 'b1;
    end
  end
  
  always @(posedge i_CLK or negedge i_RST_B) begin
    if(!i_RST_B) begin
      o_BRGCLK <= 'd0;
    end
    else if(counter == (BAUDDIV/2)) begin
      o_BRGCLK <= ~ o_BRGCLK;
    end
    else if(counter == BAUDDIV - 1) begin
      o_BRGCLK <= ~ o_BRGCLK;
    end
    
  end
  
endmodule
