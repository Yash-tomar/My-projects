// Code your design here

module LFSR(
	input clk,
  	input RSTn,
  output [3:0]lfsr_o
);
  
  logic [3:0]lfsr_ff;
  logic [3:0]nxt_lfsr;
  
  assign lfsr_o = lfsr_ff;
  
  always @(posedge clk or negedge RSTn) 
    begin
      if(!RSTn) begin
        lfsr_ff <= 4'hf;
      end
      else begin
        lfsr_ff <= nxt_lfsr;
      end
    end
  
  assign nxt_lfsr = {lfsr_ff[2:0],lfsr_ff[3]^lfsr_ff[2]};
  
endmodule
