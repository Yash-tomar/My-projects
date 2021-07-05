//
// CRC-A 
// x^16 + x^12 + x^5 + 1
// https://en.wikipedia.org/wiki/Cyclic_redundancy_check
//


module crca(
  input clk_i,
  input resetn_i,
  input data_i,
  input enable_i,
  output logic done_o,
  output logic [15:0] r
);

/*
parameter s_IDLE;
parameter s_START;
parameter s_COMPUTING;
parameter s_COMPLETED;
*/


function automatic [15:0] f_reverse_bits(input [15:0] data_i);
  parameter width = 16;
  reg [width-1:0] tmp_f;
  integer i;
  integer forloopwidth;
  begin
    for (i = width - 1; i >= 0; i = i - 1) begin
      f_reverse_bits[forloopwidth - i] = data_i[i];
    end
  end 
endfunction



typedef enum {S_START, S_IDLE, S_COMPLETED, S_COMPUTING} e_state;

wire x16 = data_i;
//logic [1:0] state;
e_state state;
logic [4:0] counter; //[4:0] for 32 bits need to change when datainput is more than 32 bits longer
//logic [15:0] r;
logic done_o_1;
logic [7:0] lowerbyte;
logic [7:0] upperbyte;
logic [15:0] crc_a_out0;
logic [15:0] crc_a_out1;
logic [15:0] crc_a_out2;
wire [15:0] crc_final;

always@(posedge clk_i, negedge resetn_i) begin
  if(!resetn_i) begin
     r <= 16'hC6C6; //need to check impact on area cost of design when not defaulting to C6C6
     state <= S_IDLE;
     //counter <= 32'hFFFF_FFFF;
     counter <= 5'b11111;
  end // if begin
  else begin
     case(state)
        S_IDLE: begin
            state   <= (enable_i) ? S_COMPUTING : S_IDLE;
            r       <= 16'hC6C6;  // reset to initial value as per CRC-A
            counter <= 31;        // counting length of serial data coming in
        end //begin S_IDLE
        S_START: begin
            state <= S_COMPUTING;
        end // begin //begin S_START
        S_COMPUTING: begin
           r[15]    <= r[14];
           r[14:13] <= r[13:12];
           r[12]    <= r[11]^r[15]^x16;
           r[11]    <= r[10];
           r[10:6]  <= r[9:5];
           r[5]     <= r[4]^r[15]^x16;
           r[4]     <= r[3];
           r[3:1]   <= r[2:0];
           r[0]     <= r[15]^x16;  //x16 input

           state    <= (counter == 0) ? S_COMPLETED: S_COMPUTING;
           counter  <= counter - 1;
     
           if (counter == 5'b00000) begin
             done_o <= 1;
             //crc_final <= r; 
           end // if begin
           else begin
             done_o <= 0;
           end // else begin
         end //begin S_COMPUTING
         S_COMPLETED: begin
             done_o <= 0;
             state  <= S_IDLE;
         end // begin S_COMPLETED
         default: state <= S_IDLE;
     endcase
  end //else begin
end //always begin


  //assign lowerbyte = r[15:8];
  //assign upperbyte = r[7:0];
  assign upperbyte = r[15:8];
  assign lowerbyte = r[7:0];
  assign crc_a_out0 = {upperbyte,lowerbyte};
  assign crc_a_out1 = {lowerbyte,upperbyte};
  //assign crc_a_out2 = {<<{r}};
   assign crc_a_out2 = f_reverse_bits(r);
  //assign crc_a_out2 = {<<{crc_a_out1}};
  assign crc_final = (done_o) ? crc_a_out2: crc_final;  
endmodule

//updated for stable branch

//commiting to stable branch working
// updated initial formatting Saturday 27th March 2021 12:49 GMT