// Code your testbench here
// or browse Examples

`timescale 1ns/1ps
module LFSR_tb;
  
  logic clk;
  logic RSTn;
  logic [3:0]lfsr_o;
  
  //DUT instantiation
  LFSR I_DUT(.*);
  
  //clock generation
  always #5 clk = ~clk;
  
  initial begin
    clk = 0;
    RSTn = 1; #10;
    RSTn = 0; #10;
    RSTn = 1; #10;
    #200;
    $finish;
  end
  
  initial begin
    $monitor("lfsr_o = %b",lfsr_o);
    $dumpfile("dump.vcd"); 
    $dumpvars;
  end
  
endmodule 
