`include "defines.sv"

module test_bench();

	logic clk = 1'b0, rst = 1'b0, write = 1'b0, read = 1'b1;
	logic [`WORD_LEN - 1: 0] data_in = 0, data_out;
	logic [`ADDRESS_LEN - 1:0] address = `ADDRESS_LEN'd1024;

	Top_module top_module(.clk(clk), .rst(rst), .address(address), 
			.write(write), .read(read), .data_in(data_in), .data_out(data_out));

	assign done = address[14];

	always@(posedge clk)begin
		if(~done & ~rst)
			address = address + 1'b1;
	end

	initial repeat (50000) #100 clk = ~clk;

	initial begin
		#150
		rst = 1'b1;
		#200
		rst = 1'b0;
	end

endmodule