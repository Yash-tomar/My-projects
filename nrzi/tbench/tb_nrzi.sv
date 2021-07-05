`timescale 1ns/1ps

module tb_nrzi();
reg count;
wire y_o;
reg resetn_i;
reg clk_i;

nrzi I_NRZI(clk_i,resetn_i,count,y_o);

//clk generation
always #10 clk_i=~clk_i;

initial begin
         clk_i = 0;
        resetn_i =1'b0;
        #20 resetn_i = 1'b1;
        #20 resetn_i = 1'b0;
        #20 resetn_i = 1'b1;
	count=1'b0;

	#1500 $finish;
end


always @(negedge clk_i)
begin
	count=count+1;
end

initial begin
	$display("Simulation Result are as follows:");
 	$monitor(" resetn_i: %b, clk: %b, a_i: %b, y_o: %b", resetn_i, clk_i, count, y_o);
end

initial begin
	 if ($test$plusargs("trace") != 0) begin
                $display("[%0t] Tracing to logs/vlt_dump.vcd...\n", $time);
                $dumpfile("logs/vlt_dump.vcd");
                $dumpvars;
        end
        $display("[%0t] Model Running...\n", $time);
end


endmodule
