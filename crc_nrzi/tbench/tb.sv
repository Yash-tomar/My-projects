`timescale 1ns/1ps

module tb();

logic t_clk;
logic t_resetn;
logic t_data;
logic t_y;

//**************************DUT instantiation**********************

combined_crca_nrzi I_DUT(.clk_i(t_clk),.resetn_i(t_resetn),.data_i(t_data),.y_o(t_y));

//**************************RESET**********************************

//event for reset trigger and reset done
event treset_trig;
event treset_done;

initial begin
	forever begin
		@(treset_trig);
		  @(negedge t_clk);
		   t_resetn=0; //assert reset
		  @(negedge t_clk);
		   t_resetn=1; // deassert reset
		->treset_done;    
	end	
end

//Reset triggering at 10 time unit
initial begin
 	#10 ->tresetn_trig;
end

//*****************************CLK generation****************************

always begin
	clk=1;
	#5;
	clk=0;
	#5;
end	

//************************************************************************
int vectornum;
reg [31:0]out;
initial begin
	$readmemb("hexinput.txt",testvectors);
	vectornum=0;
	
	@(tresetn_done);   // wait to deassert the reset
	for(int i=0;i<10;i++)
	begin       	
	transaction(testvectors[vectornum],out);
	#100;
	end
end

task transaction(input [31:0]in, output [31:0]out);
	
	for(int i=0;i<32;i++)
	begin	
		@(negedge clk);
		t_data=in[0];
		in={1'b0,in[30:0]};
	
		out={out[30:0],1'b0};
		out[0]=t_y;
	end
endtask

endmodule
