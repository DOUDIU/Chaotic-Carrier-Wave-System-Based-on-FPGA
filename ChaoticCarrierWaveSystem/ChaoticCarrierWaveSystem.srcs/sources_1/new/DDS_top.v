module DDS_top#(
    parameter u 			=   6 	,
    parameter x0			=   70	,//0-255
    parameter y0			=   50  ,//0-255
	parameter DATA_WIDTH	=	12 	,
	parameter ADDR_WIDTH	=	12 	
)(
	input					clk			,
	input					rst_n		,
	input					key1_in		,
	input					key2_in		,

	output		[11 : 0]	dac_data	
);

	//wire definition
	wire			[1 : 0]		wave_c				;
	wire			[25: 0]		f_word				;
	wire			[4 : 0]		amplitude			;
	wire	signed 	[19: 0] 	Chaotic_value   	;
	wire			[18: 0]		Chaotic_value_abs	;

	//assignment
	assign	Chaotic_value_abs 	= 	Chaotic_value[19] ? Chaotic_value[18: 0] : ~(Chaotic_value[18: 0]) ;//取绝对值
	assign	f_word				=	{Chaotic_value_abs,7'd0};//末尾补零

	//chaotic suquence making
	DouLogisticChaoticMapping #(
		.u                  (6              ),
		.x0                 (70             ),//0-255
		.y0                 (50             ) //0-255
	)u_DouLogisticChaoticMapping(
		.clk                (clk            ),
		.rst_n              (rst_n          ),

		.Chaotic_value      (Chaotic_value  )
	);

	//digital signal making
	DDS #(
		.DATA_WIDTH			(4'd12			),//数据位宽
		.ADDR_WIDTH			(4'd12			) //地址位宽
	)u_Dds(
		.clk      			(clk			),
		.rst_n    			(rst_n			),
		.f_word   			(f_word			),
		.wave_select		(wave_c			),
		.p_word   			(12'd0			),
		.amplitude			(amplitude		),
		.dac_data 			(dac_data		)
	);
	
	//wave type selection
	wave_select u_wave_select(
		.clk				(clk			),
		.rst_n				(rst_n			),
		.key0_in			(key1_in		),

		.wave_c				(wave_c			)
	);

	//amplitude selection
	amplitude_set u_Amplitude_set(
		.clk				(clk			),
		.rst_n				(rst_n			),
		.key2_in			(key2_in		),

		.amplitude			(amplitude		)	
	);



endmodule
