`include "defines.sv"

module Data_memory(clk, rst, address, write_data, mem_read, 
		mem_write, read_data, data_out);

	input [`ADDRESS_LEN - 1:0] address;
	input [`WORD_LEN - 1:0] write_data;
	input clk, rst, mem_read, mem_write;

	output logic[`WORD_LEN - 1:0] data_out;
	output logic[`CACHE_BLOCK_LEN - 3 :0] read_data;

	int i;

	reg[`WORD_LEN -1:0] data[0:`MEM_CAP - 1];

	always @(mem_read, address) begin
		if (mem_read) begin
		read_data <= {
			data[ {address[`ADDRESS_LEN - 1:2], 2'b11} ],
			data[ {address[`ADDRESS_LEN - 1:2], 2'b10} ],
			data[ {address[`ADDRESS_LEN - 1:2], 2'b01} ],
			data[ {address[`ADDRESS_LEN - 1:2], 2'b00} ]	
		};

		data_out <= address[`ADDRESS_LEN - 1:0];

		end
	end
	

	always @(posedge clk, rst) begin
		if (rst) begin
			data = '{default:`WORD_LEN'b0};

			for (i = 1024 ; i < 9216 ; i = i + 1)
				data[i] = i;

		end else if(mem_write) 
			data[address] = write_data;
	end

endmodule