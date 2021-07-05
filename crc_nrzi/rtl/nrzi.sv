//module nrzi (input a, output y);
//module nrzi (input clk_i, input resetn_i, input a_i, output reg y_o);
module nrzi_sv (input clk_i, input resetn_i, input a_i, output y_o);

parameter TRUE= 1'b1,
          FALSE= 1'b0;

logic previous_input;
logic next_state;
logic previous_state;

//typedef enum {S_START, S_IDLE, S_COMPLETED, S_COMPUTING, S_TRANSITION, S_TRANSITION_0, S_TRANSITION_1 } e_state;

typedef enum logic [3:0] {
  S_START, 
  S_IDLE, 
  S_COMPLETED, 
  S_COMPUTING, 
  S_TRANSITION, 
  S_0, 
  S_1, 
  S_NOCHANGE, 
  S_LEVEL_HIGH, 
  S_LEVEL_LOW 
  } e_state;

e_state state;



e_state e_next_state;
e_state e_previous_state;

// function for transition S_NOCHANGE
function automatic transition(input data_i);
// 1--> make transition
// 0--> stay at the same level
// ABOVE is WRONG assumption according to 
// NRZ-S
// At the start of each bit time the signal level changes if the bit it 0.
// USB serial protocol
// should be  
// 0--> make transition
// 1--> stay at the same level

  begin
       if (data_i == 1'b1) begin // if data_i is 1 then transition should not occur.
         transition = FALSE;
        //stay at same level
       end
       else if(data_i== 1'b0) begin // else preserve the last value.
         transition = TRUE;
       //make transition
       end
 //      else begin
 //      $display("unexpected value"); 
 //       end
  end
endfunction

/*
always@(posedge clk_i, negedge resetn_i) begin

 if(!resetn_i) begin
    y_o<= 1'b0;
    previous_input <= 1'b0;
  end
  
  else begin
    //y_o <= transition(a_i);
     if (transition(a_i) (previous_input ) begin
      y_o <= ~a_i; 
     end 
    
     begin
      y_o <= a_i;
     end
  end
end
*/


assign y_o = previous_state;

// transition block
// reset conditions of transition during startup of block
// at posedge of clock and negedge reset go to S_TRANSITION which is a NULL state
always @(posedge clk_i or negedge resetn_i) begin
	if(!resetn_i) begin
    //y_o<= 1’b0;
    //next_state <=1'b0;
    previous_state <=1'b0;
    //e_next_state <= S_TRANSITION;

  end 
	else begin
  previous_state <= next_state;  
  e_previous_state <= e_next_state;
  end 
end


// transition determining block
always @(a_i or previous_state) begin : transistion 
 if(transition(a_i)) begin
   e_next_state = S_0;
   next_state = !previous_state;
 end
  else
  begin
   next_state = previous_state;
   //e_next_state <= S_0;
   e_next_state = S_NOCHANGE;
  end
end //begin transition



endmodule
