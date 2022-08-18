///////////////////////////////////////
// Module : Baud rate generator testbench
// Author : YashTomar
// DOM 	  : 18/08/22    
// /////////////////////////////////////

`timescale 1ns/1ps
module BRG_TB;
  
  reg i_CLK;
  reg i_RST_B;
  reg i_OVER8;
  wire [15:0]i_USARTBRR; 
  wire o_BRGCLK ;
  
  reg [11:0]MANTISSA;
  reg [3:0]FRACTION;
  
  //DUT_instantiation
  BaudRateGenerator I_BRG(.*);
  
  //clock generation
  always #62.6 i_CLK = !i_CLK;
  
  real div_fraction;
  
  assign i_USARTBRR = {MANTISSA, FRACTION};
  
  initial begin
    i_RST_B =1;
    i_CLK  =0;
    
    #200ns;
    i_RST_B =0;
    #200ns;
    i_RST_B =1;
    
    i_OVER8 = 0;
    MANTISSA = 'd27;
    div_fraction = 0.75 * 16;
    FRACTION = div_fraction;
    $display("MANTISSA = %b, Fraction =%b, over8 = %d", MANTISSA,FRACTION, i_OVER8);
  end
  
  initial begin
    $dumpfile("dump.vcd"); $dumpvars;
    #1s;
    $finish;
  end
  
endmodule
