//
// CRC-A 
// x^16 + x^12 + x^5 + 1
// Verilog LRM specific
// no SystemVerilog allowed here

module crca(
  input clk_i,
  input resetn_i,
  input data_i,
  input enable_i,
  output reg done_o,
  output reg [15:0] r_o
);


parameter S_IDLE       = 2'b00,
          S_START      = 2'b01,
          S_COMPUTING  = 2'b11,
          S_COMPLETED  = 2'b10;

function automatic [15:0] f_reverse_bits(input [15:0] data_i);
  parameter width = 16;
  integer i;
  begin
    //for (i = width - 1; i >= 0; i = i - 1) begin
    for (i = 0; i < width; i = i + 1) begin
      f_reverse_bits[width - i - 1] = data_i[i];
    end
  end 
endfunction

wire x16 = data_i;
reg [1:0] state;
reg [4:0] counter; 

wire [7:0] lowerbyte;
wire [7:0] upperbyte;
wire [15:0] crc_a_out0;
wire [15:0] crc_a_out1;
wire [15:0] crc_a_out2;
wire [15:0] crc_final;

always@(posedge clk_i, negedge resetn_i) 
begin
   if(!resetn_i)
      begin
         r_o       <= 16'hC6C6;
         state   <= S_IDLE;
         counter <= 5'b1_1111;
      end
   else
   begin
      case(state)
         S_IDLE: begin
                    state   <= (enable_i) ? S_COMPUTING : S_IDLE;
                    r_o       <= 16'hC6C6;
                    counter <= 31; 
                 end

         S_START: begin
                     state <= S_COMPUTING;
                  end
  
         S_COMPUTING: begin
                        r_o[15]    <= r_o[14];
                        r_o[14:13] <= r_o[13:12];
                        r_o[12]    <= r_o[11]^r_o[15]^x16;
                        r_o[11]    <= r_o[10];
                        r_o[10:6]  <= r_o[9:5];
                        r_o[5]     <= r_o[4]^r_o[15]^x16;
                        r_o[4]     <= r_o[3];
                        r_o[3:1]   <= r_o[2:0];
                        r_o[0]     <= r_o[15]^x16;  
                        state    <= (counter == 0) ? S_COMPLETED: S_COMPUTING;
                        counter  <= counter - 1;

                        if (counter == 5'b0_0000) begin
                            done_o <= 1;
                          end
                        else begin
                           done_o <= 0;
                        end
                      end

         S_COMPLETED: begin
                        done_o <= 0;
                        state  <= S_IDLE;
                       end
         default: state <= S_IDLE;
      endcase
    end //else begin
end //always begin

assign upperbyte = r_o[15:8];
assign lowerbyte = r_o[7:0];
assign crc_a_out0 = {upperbyte,lowerbyte};
assign crc_a_out1 = {lowerbyte,upperbyte};
//assign crc_a_out2 = {<<{r}};
assign crc_a_out2 = f_reverse_bits(r_o);
assign crc_final = (done_o) ? crc_a_out2: crc_final;  

endmodule