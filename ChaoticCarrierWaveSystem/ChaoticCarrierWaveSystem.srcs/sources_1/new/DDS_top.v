module DDS_top#(
    parameter u 			=   4 	,
    parameter x0			=   70	,//0-255
    parameter y0			=   50  ,//0-255
	parameter DATA_WIDTH	=	12 	,
	parameter ADDR_WIDTH	=	12 	
)(
	input					clk			,
	input					rst_n		,
	input					rxd			,
	output      			txd			
);

	wire						key1_in				;
	wire						key2_in				;
	wire			[11 : 0]	dac_data			;
	//wire definition
	wire			[1 : 0]		wave_c				;
	wire			[25: 0]		f_word				;
	wire			[4 : 0]		amplitude			;
	wire	signed 	[19: 0] 	Chaotic_value   	;
	wire			[18: 0]		Chaotic_value_abs	;
	wire						clk_115200			;
	wire						tx_triger_flag		;
	//assignment
	assign	Chaotic_value_abs 	= 	Chaotic_value[19] ? Chaotic_value[18: 0] : ~(Chaotic_value[18: 0]) ;//取绝对值
	assign	f_word				=	{Chaotic_value_abs,7'd0};//末尾补零

	//chaotic suquence making
	DouLogisticChaoticMapping #(
		.u                  (6              ),
		.x0                 (70             ),//0-255
		.y0                 (50             ) //0-255
	)u_DouLogisticChaoticMapping(
		.clk                (clk     		),
		.rst_n              (rst_n          ),

		.Chaotic_value      (Chaotic_value  )
	);

	//digital signal making
	DDS #(
		.DATA_WIDTH			(4'd12			),//数据位宽
		.ADDR_WIDTH			(4'd12			) //地址位宽
	)u_Dds(
		.clk      			(clk 			),
		.rst_n    			(rst_n			),
		.f_word   			(f_word			),
		.wave_select		(2'b00			),
		.p_word   			(12'd0			),
		.amplitude			(amplitude		),
		.dac_data 			(dac_data		),
		.data_request		(tx_done		),
		.data_valid			(data_valid		)
	);
	
	Uart_Byte_Tx u_Uart_Byte_Tx(
		.clk         (clk				), //系统时钟
		.rst_n       (rst_n				), //系统复位
		.send_en     (data_valid		), //发送使能
		.data_byte   (dac_data[11:4]	), //发送的数据
		.baud_set    (1					), //波特率设置

		.rs232_tx    (txd				), //FPGA将数据转换成串行数据发出
		.tx_done     (tx_done			), //发送数据完毕标志
		.uart_state  ()  //串口发送状态，1为忙，0为空闲
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
