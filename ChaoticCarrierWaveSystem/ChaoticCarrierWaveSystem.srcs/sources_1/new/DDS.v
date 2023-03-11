module DDS#(
	parameter	DATA_WIDTH	=	4'd12,
	parameter	ADDR_WIDTH	=	4'd12
)(
	input					clk			,
	input					rst_n		,
	input		[25	: 0]	f_word		,
	input		[1	: 0]	wave_select	,
	input		[11	: 0]	p_word		,
	input		[4	: 0]	amplitude	,

	output	reg	[11 : 0]	dac_data	
);
	//reg definition
	reg		[11:0]	addr	 ;

	//wire definition
	wire	[11:0]	dac_data0;
	wire	[11:0]	dac_data1;
	wire	[11:0]	dac_data2;
	wire	[11:0]	dac_data3;



	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			dac_data <= 12'd0;
		end
		else begin
			case(wave_select)
				2'b00	:	dac_data 	<= 	dac_data0 / amplitude;	
				2'b01	:	dac_data 	<= 	dac_data1 / amplitude;	
				2'b10	:	dac_data 	<= 	dac_data2 / amplitude;	
				2'b11	:	dac_data 	<= 	dac_data3 / amplitude;	
				default	:	;
			endcase
		end
	end


	reg	[31:0]	fre_acc;
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			fre_acc <= 0;
		end
		else begin
			fre_acc <= fre_acc + f_word;
		end
	end


	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			addr <= 0;
		end
		else begin
			addr <= fre_acc[31:20] + p_word;
		end
	end

	Sin_Rom #(
		.DATA_WIDTH		(DATA_WIDTH	),
		.ADDR_WIDTH		(ADDR_WIDTH	)
	) inst_sin_rom (
		.addr 			(addr		),
		.clk  			(clk		),
		.q    			(dac_data0	)
	);


	Triangle_Rom #(
		.DATA_WIDTH		(DATA_WIDTH	),
		.ADDR_WIDTH		(ADDR_WIDTH	)
	) inst_sanjiao_rom (
		.addr 			(addr		),
		.clk  			(clk		),
		.q    			(dac_data1	)
	);


	Saw_Tooth_Rom #(
		.DATA_WIDTH		(DATA_WIDTH	),
		.ADDR_WIDTH		(ADDR_WIDTH	)
	) inst_juchi_rom (
		.addr 			(addr		),
		.clk  			(clk		),
		.q    			(dac_data2	)
	);


	Square_Rom #(
		.DATA_WIDTH		(DATA_WIDTH	),
		.ADDR_WIDTH		(ADDR_WIDTH	)
	) inst_fangbo_rom (
		.addr 			(addr		),
		.clk  			(clk		),
		.q    			(dac_data3	)
	);



endmodule
