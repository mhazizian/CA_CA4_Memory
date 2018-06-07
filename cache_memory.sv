`include "defines.sv"

module Cache_memory(clk, rst, address, make_miss, data_out, miss, data_in);
	
	input [`CACHE_BLOCK_LEN - 3 : 0] data_in;
	input [`ADDRESS_LEN - 1:0] address;
	input clk, rst, make_miss;
	output logic[`WORD_LEN - 1:0] data_out;
	output logic miss;

	reg[`CACHE_BLOCK_LEN - 1:0] data[0:`CACHE_CAP - 1];
	logic [`ADDRESS_LEN - 1:0] prev_address ;
	logic [`CACHE_INDEX_LEN - 1:0] idx, prev_idx;

	assign idx = address[`ADDRESS_LEN - 2:3];
	assign prev_idx = prev_address[`ADDRESS_LEN - 2:3];

	always @(posedge clk, rst) begin

		if(miss)
		begin
			data[prev_idx] = {1'b1, prev_address[`ADDRESS_LEN - 1], data_in};
			miss = 1'b0;
		end

		if (rst) begin
			data = '{default:`WORD_LEN'b0};
			miss = 0;
			prev_address = 0;

		end else if (make_miss) begin
			data[idx][`CACHE_BLOCK_LEN - 1] = 1'b0;

		end else begin
			if(data[idx][`CACHE_BLOCK_LEN - 1] == 1'b1) begin
				if (data[idx][`CACHE_BLOCK_LEN - 2] == address[`ADDRESS_LEN - 1]) begin
					miss = 1'b0;

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
					miss = 1'b1;

			end else if(data[idx][`CACHE_BLOCK_LEN - 1] == 1'b0)	miss = 1'b1;
		end 

		prev_address = address;

	end

endmodule // Cache_memory