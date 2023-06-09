`timescale 1ns/1ns

module sin_rom_tb (); /* this is automatically generated */

	reg clk;

	// (*NOTE*) replace reset, clock, others

	parameter DATA_WIDTH = 12;
	parameter ADDR_WIDTH = 12;

	reg [(ADDR_WIDTH-1):0] addr;
	wire [(DATA_WIDTH-1):0] q;

	localparam clk_period = 20;

	integer i;

	Sin_Rom #(
			.DATA_WIDTH(DATA_WIDTH),
			.ADDR_WIDTH(ADDR_WIDTH)
		) inst_sin_rom (
			.addr (addr),
			.clk  (clk),
			.q    (q)
		);

	initial clk = 0;
	always #(clk_period/2) clk =~clk;

	initial begin
		#1;
		#(clk_period*20);
		for(i=0;i<=100;i=i+1)begin
			addr = i;
			#clk_period;
		end
		#(clk_period*20);
		$stop;
	end




endmodule
