`timescale 1ns/1ns
module DDS_top_tb();

	reg					clk			;
	reg					rst_n		;
	reg					key1_in		;
	reg					key2_in		;

	wire	[11:0]		dac_data	;

	localparam	clk_period = 20;

	DDS_top #(
		.u                  (4              ),
		.x0                 (70             ),//0-255
		.y0                 (50             ),//0-255
		.DATA_WIDTH			(12				),
		.ADDR_WIDTH			(12				)
	)inst_DDS_top(
		.clk      			(clk			),
		.rst_n    			(rst_n			)
	);


	initial clk = 0;
	always #(clk_period/2) clk = ~clk;

	initial begin
		#1;
		rst_n = 0;
		key1_in = 1;
		key2_in = 1;
		#(clk_period*20);
		rst_n = 1;
		#(clk_period*10);
	end




endmodule
