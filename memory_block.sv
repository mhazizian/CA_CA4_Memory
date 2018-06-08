`include "defines.sv"

module memory_block(clk, rst, address, write, read, data_in, data_out, miss_counter);

	input clk, rst, write, read;
	input [`WORD_LEN - 1: 0] data_in;
	input [`ADDRESS_LEN - 1:0] address;
	output logic [`ADDRESS_LEN - 1:0] miss_counter;
	output logic [`WORD_LEN - 1: 0] data_out;
	
	logic clk, rst, miss;
	logic[`WORD_LEN - 1:0] data_out_memory;
	logic [`CACHE_BLOCK_LEN - 3 : 0] mem_out;
	logic [`WORD_LEN - 1 : 0]cache_out;

	Cache_memory cache(.clk(clk), .rst(rst), .address(address), .make_miss(write), 
		.cache_out(cache_out), .miss(miss), .data_in(mem_out));

	Data_memory memory(.clk(clk), .rst(rst), .address(address), .write_data(data_in), .mem_read(miss & read), 
		.mem_write(write), .read_data(mem_out), .data_out(data_out_memory));

	assign data_out = miss ? data_out_memory : cache_out;
	// assign data_out = cache_out;

	always@(posedge miss, posedge rst) begin
		if(rst)
			miss_counter = 0;
		else
			miss_counter = miss_counter + 1;
	end

endmodule
