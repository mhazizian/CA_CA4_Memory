`include "defines.sv"

module Cache_memory(clk, rst, write_en, read_en, address, invalid_data, 
		cache_out, miss, data_in);


	input clk, rst, write_en, read_en, invalid_data;
	input [`CACHE_BLOCK_LEN - 3:0] data_in;
	input [`ADDRESS_LEN - 1:0] address;

	output logic miss;
	output logic[`WORD_LEN - 1:0] cache_out;



	logic [`CACHE_BLOCK_LEN - 1:0] cache_mem [0:`CACHE_CAPACITY - 1];
	logic [`CACHE_INDEX_LEN - 1:0] idx;



	assign idx = address[`ADDRESS_LEN - 2 : 2];
	assign miss = (address[`ADDRESS_LEN - 1] != cache_mem[idx][`CACHE_BLOCK_LEN - 2]) 
			| (~cache_mem[idx][`CACHE_BLOCK_LEN - 1]);


	always @(posedge clk, posedge rst) begin
		if (rst) begin
			cache_mem <= '{default:`WORD_LEN'b0};

		end else if(invalid_data)
			cache_mem[idx][`CACHE_BLOCK_LEN - 1] <= 1'b0;
	end


	always @(address, read_en) begin
		if(read_en)begin
			case (address[1:0])
				2'b00 :
					cache_out <= cache_mem[idx][31:0];
				2'b01 :
					cache_out <= cache_mem[idx][63:32];
				2'b10 :
					cache_out <= cache_mem[idx][95:64];
				2'b11 :
					cache_out <= cache_mem[idx][127:96];
			endcase
		end
	end


	always@(posedge clk)begin
		if(write_en)
			cache_mem[idx] <= {1'b1, address[`ADDRESS_LEN - 1], data_in};
	end
	
endmodule
