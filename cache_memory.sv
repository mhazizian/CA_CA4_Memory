`include "defines.sv"

module Cache_memory(clk, rst, address, make_miss, data_out);
	
	input [`ADDRESS_LEN - 1:0] address;
	input clk, rst, make_miss;
	output logic[`WORD_LEN - 1:0] data_out;

	reg[`CACHE_BLOCK_LEN - 1:0] data[0:`CACHE_CAP - 1];

	logic [`CACHE_INDEX_LEN - 1:0] idx;
	assign idx = address[`ADDRESS_LEN - 2:3];

	always @(posedge clk, rst) begin
		if (rst) begin
			data = '{default:`WORD_LEN'b0};
		end else if (make_miss) begin
			data[idx][`CACHE_BLOCK_LEN - 1] = 0;

		end else begin
			if(data[idx][`CACHE_BLOCK_LEN - 1] == 1'b1) begin
				if (data[idx][`CACHE_BLOCK_LEN - 2] == address[`ADDRESS_LEN - 1]) begin
					case (address[1:0])
						2'b00 :
							data_out = data[idx][31:0];
						2'b01 :
							data_out = data[idx][63:32];
						2'b10 :
							data_out = data[idx][95:64];
						2'b11 :
							data_out = data[idx][127:96];
					endcase // address[1:0]
				end else
					data[idx][`CACHE_BLOCK_LEN - 1] = 1'b1;
			end 

			if(data[idx][`CACHE_BLOCK_LEN - 1] == 1'b0) begin
				// read from memory
				
				data[idx][`CACHE_BLOCK_LEN - 1] = 1'b1;
			end
		end 
	end

endmodule // Cache_memory
