`include "defines.sv"

module Top_module(clk, rst, address, write, read, data_in, data_out);

	input clk, rst, write, read;
	input [`WORD_LEN - 1: 0] data_in;
	input [`ADDRESS_LEN - 1:0] address;
	output logic [`WORD_LEN - 1: 0] data_out;

	logic clk, rst, miss_happend;
	logic [`CACHE_BLOCK_LEN - 3 : 0] mem_out;
	logic [`WORD_LEN - 1 : 0]cache_out;

	Cache_memory cache(.clk(clk), .rst(rst), .address(address), .make_miss(write), .data_out(cache_out), .miss(miss_happend), .data_in(mem_out));

	DataMemory memory(.clk(clk), .rst(rst), .Address(address), .WriteData(data_in),.MemRead(miss_happend & read), .MemWrite(write), .ReadData(mem_out));

	assign data_out = cache_out;

endmodule