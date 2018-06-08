`include "defines.sv"
module tb_memory();

	logic clk = 1'b0, rst = 1'b0, miss, write_en_mem;
	logic [`ADDRESS_LEN - 1:0] address, miss_counter = 0;
	logic [`WORD_LEN - 1:0] write_data, cache_out, out_bus;

	logic[`WORD_LEN - 1:0] read_data_32;
	logic[`CACHE_BLOCK_LEN - 3 :0] read_data_128;

	int i;

	Main_memory main_memory(.clk(clk), .rst(rst), .address(address), .write_data(write_data), 

		.read_en(miss), .write_en(write_en_mem), .read_data_128(read_data_128), .read_data_32(read_data_32));


	Cache_memory cache(.clk(clk), .rst(rst), .write_en(miss), .read_en(~miss), .address(address), 

		.invalid_data(write_en_mem), .cache_out(cache_out), .miss(miss), .data_in(read_data_128));

	always @(posedge clk)begin
		if(miss)begin
			out_bus <= read_data_32;
			miss_counter <= miss_counter + 1;

		end else
			out_bus <= cache_out;
	end
		

	initial repeat(16388) #100 clk = ~clk;

	initial begin
		for (int i = 1024; i < 9217; i++) begin
			#200
			address = i;
		end
	end

	initial begin
		#50
			rst = 1'b1;
		#100
			rst = 1'b0;
	end

endmodule