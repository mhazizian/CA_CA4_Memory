`include "defines.sv"

module Main_memory(clk, rst, address, write_data, read_en, 
		write_en, read_data_128, read_data_32);

	input [`ADDRESS_LEN - 1:0] address;
	input [`WORD_LEN - 1:0] write_data;
	input clk, rst, read_en, write_en;

	output logic[`WORD_LEN - 1:0] read_data_32;
	output logic[`CACHE_BLOCK_LEN - 3 :0] read_data_128;

	logic [`WORD_LEN -1:0] main_memory [0:`MEM_CAPACITY - 1];
	int i;


	always @(posedge clk, rst) begin
		if (rst) begin
			main_memory = '{default:`WORD_LEN'b0};		
			for (i = 1024 ; i < 9216 ; i = i + 1)
				main_memory[i] = i;

		end else if(write_en) 
			main_memory[address] = write_data;
	end



	always @(read_en, address) begin
		if (read_en) begin
			read_data_128 <= {
				main_memory[ {address[`ADDRESS_LEN - 1:2], 2'b11} ],
				main_memory[ {address[`ADDRESS_LEN - 1:2], 2'b10} ],
				main_memory[ {address[`ADDRESS_LEN - 1:2], 2'b01} ],
				main_memory[ {address[`ADDRESS_LEN - 1:2], 2'b00} ]	
			};

			read_data_32 <= address[`ADDRESS_LEN - 1:0];

		end
	end
	
endmodule