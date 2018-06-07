`include "defines.sv"

module DataMemory(clk, rst, Address, WriteData, MemRead, MemWrite, ReadData);

	input [`ADDRESS_LEN - 1:0] Address;
	input [`WORD_LEN - 1:0] WriteData;
	input clk, rst, MemRead, MemWrite;

	output logic[`WORD_LEN * 4 - 1:0] ReadData;

	reg[`WORD_LEN -1:0] data[0:`MEM_CAP - 1];

	always @(MemRead, Address) begin
		if (MemRead) ReadData = {
			data[ {Address[`ADDRESS_LEN - 1:2], 2'b00} ], 
			data[ {Address[`ADDRESS_LEN - 1:2], 2'b01} ], 
			data[ {Address[`ADDRESS_LEN - 1:2], 2'b10} ], 
			data[ {Address[`ADDRESS_LEN - 1:2], 2'b11} ]
		};
	end
	
	always @(posedge clk, rst) begin
		if (rst) begin
			data = '{default:`WORD_LEN'b0};
		end else if(MemWrite) 
			data[Address] = WriteData;
	end

endmodule