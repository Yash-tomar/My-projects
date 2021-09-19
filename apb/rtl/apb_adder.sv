////////////////////////////////////////////////////////////////////////////////
//Project :- APB master - adder 
//	    
//Engineer :- Yash Tomar
//DOM      :- 17/09/21
//Datasheet link :- https://web.eecs.umich.edu/~prabal/teaching/eecs373-f12/readings/ARM_AMBA3_APB.pdf
/////////////////////////////////////////////////////////////////////////////////

module apb_adder(
	input logic pclk,
	input logic presetn,

	input logic [1:0]add_i, //2'b00-NOP , 2'b01-READ , 2'b10-NOP , 2'b11-WRITE
	
	input logic pready_i,
	output logic psel_o,
	output logic penable_o,
	output logic [31:0] paddr_o,
	output logic pwrite_o;
	output logic [7:0] pwdata_o,
	input logic [7:0] prdata_o,
);

logic next_pwrite;
logic pwrite_q;

typedef enum logic[1:0] {ST_IDLE,ST_SETUP,ST_ACCESS}apb_state;
apb_state state_q; //current state
apb_state next_state; //next state

always_ff
begin
	if(!presetn)
	begin
		state_q <= ST_IDLE;
		pwrite_q <= 1'b0
	end
	else
	begin
		state_q <= next_state;
		pwrite_q <= next_pwrite;
	end	
end

always_comb
begin
	next_pwrite = pwrite_q;
	case(state_q)
		ST_IDLE: begin  // At tranfer move to setup state
				if(add[0]) 
				begin
					next_state = ST_SETUP;
					next_pwrite = add[1];
				end
				else
					next_state = ST_IDLE;
			 end
		ST_SETUP: begin
				next_state = ST_ACCESS;
			  end
		ST_ACCESS: begin
				if(pready_i)
					next_state = ST_IDLE;
				else
					next_state = ST_ACCESS;
			   end
		default:next_state <= ST_IDLE;
	endcase
end

assign Psel_o=(state_q == ST_SETUP)|(state_q==ST_ACCESS);
assign penable_o = (state_q == ST_ACCESS); 
assign Paddr_o= 32{(state_q == ST_SETUP | state_q == ST_ACCESS)}  & 32'hD0AD00;
assign pwrite_o=pwrite_q;
endmodule
