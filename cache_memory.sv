`include "defines.sv"

module Cache_memory(clk, rst, address, make_miss, 
		cache_out, miss, data_in);
	
	input clk, rst, make_miss;
	input [`CACHE_BLOCK_LEN - 3 : 0] data_in;
	input [`ADDRESS_LEN - 1:0] address;

	output logic[`WORD_LEN - 1:0] cache_out;
	output logic miss;

	reg [`CACHE_BLOCK_LEN - 1:0] data[0:`CACHE_CAP - 1];
	logic [`CACHE_INDEX_LEN - 1:0] idx;

	assign idx = address[`ADDRESS_LEN - 2 : 2];

	assign miss = (data[idx][`CACHE_BLOCK_LEN - 1] == 1'b1 & 
		data[idx][`CACHE_BLOCK_LEN - 2] == address[`ADDRESS_LEN - 1]) ? 0 : 1;

	always @(posedge clk, posedge rst) begin
		if (rst) begin
			data <= '{default:`WORD_LEN'b0};
			// miss <= 0;
			
		end else if (make_miss) begin
			data[idx][`CACHE_BLOCK_LEN - 1] <= 1'b0;

		end else begin
			if(data[idx][`CACHE_BLOCK_LEN - 1] == 1'b1) begin
				if (data[idx][`CACHE_BLOCK_LEN - 2] == address[`ADDRESS_LEN - 1]) begin
					// miss <= 1'b0;
					case (address[1:0])
						2'b00 :
							cache_out <= data[idx][31:0];
						2'b01 :
							cache_out <= data[idx][63:32];
						2'b10 :
							cache_out <= data[idx][95:64];
						2'b11 :
							cache_out <= data[idx][127:96];
					endcase // address[1:0]
				end// else
					// miss <= 1'b1;

			end //else if(data[idx][`CACHE_BLOCK_LEN - 1] == 1'b0)	miss <= 1'b1;
		end 
	end

	always@(posedge miss)begin
		data[idx] <= {1'b1, address[`ADDRESS_LEN - 1], data_in};
	end

endmodule // Cache_memory