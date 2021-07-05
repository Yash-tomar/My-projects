module nrzi(input clk_i,input resetn_i,input data_i,output  y_o);

reg next_state,prev_state;

assign y_o=prev_state;

always @(posedge clk_i or negedge resetn_i)
begin
	if(!resetn_i)
       	begin
		prev_state<=0;
		next_state<=0;
	end
	else
		prev_state<=next_state;
end

always @(data_i)
begin
	if(data_i)
	begin
		next_state<=~prev_state;	
	end
	else
		next_state<=prev_state;
end


endmodule
