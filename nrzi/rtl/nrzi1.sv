module nrzi(input clk_i,input resetn_i,input data_i,output  y_o);

parameter TRUE=1,
	  FALSE=0;

logic next_state,prev_state,prev_input;

typedef enum{
	S_NOCHANGE,
	S_CHANGE
}e_state;

e_state state;
e_state e_next_state;
e_state e_prev_state;


assign y_o=prev_state;

always @(posedge clk_i or negedge resetn_i)
begin
	if(!resetn_i)
       	begin
		prev_state<=0;
		
	end
	else 
	begin
		prev_state<=next_state;
		e_prev_state<=e_next_state;
	end	
end

always @(data_i)
begin
	if(transition(data_i))
	begin
		e_next_state<=S_CHANGE;
		next_state<=~prev_state;	
	end
	else
	begin
		next_state<=prev_state;
		e_next_state<=S_NOCHANGE;
	end
end


endmodule
