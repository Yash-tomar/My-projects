
`timescale 1ns/1ps

module combined_crca_nrzi
(
	input clk_i,
	input resetn_i,
	input data_i,
	output y_o
);

logic done_o;	  // indicate crc is compeleted
logic [15:0]r;    // 16 bit crc
logic enable_i;   // enable CRC
reg [31:0]data;   // store incoming data
reg [47:0]combined_data; // data+crc values   ->  Nrzi

assign enable_i = (resetn_i)?1:0;

//***********************CRCA instantiation***********
crca I_CRCA(clk_i,resetn_i,data_i,enable_i,done_o,r);

//***********************NRZI instantiation***********
nrzi_sv I_NRZI(clk_i,resetn_i, a_i,y_o);

always @ (posedge CLK or negedge resetn_i)
begin
	if(!resetn_i)
	begin
		
		combined_data<=48'd0;
	end
	else 
	begin
		if(done_o==1'b1)
		begin
			combined_data<={data,r};
		end	
		data<={data[30:0],data_i}; // store the incoming data into data   LSB TO MSB
		a_i<=combined_data[47]; //pass one value to nrzi on every posedge clk pulse
		combined_data<={combined_data[46:0],1'b0};
	end

end

endmodule

