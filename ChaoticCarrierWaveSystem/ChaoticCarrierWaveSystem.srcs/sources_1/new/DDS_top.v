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
	assign	Chaotic_value_abs 	= 	Chaotic_value[19] ? Chaotic_value[18: 0] : ~(Chaotic_value[18: 0]) ;//ȡ����ֵ
	assign	f_word				=	{Chaotic_value_abs,7'd0};//ĩβ����

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
		.DATA_WIDTH			(4'd12			),//����λ��
		.ADDR_WIDTH			(4'd12			) //��ַλ��
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
		.clk         (clk				), //ϵͳʱ��
		.rst_n       (rst_n				), //ϵͳ��λ
		.send_en     (data_valid		), //����ʹ��
		.data_byte   (dac_data[11:4]	), //���͵�����
		.baud_set    (1					), //����������

		.rs232_tx    (txd				), //FPGA������ת���ɴ������ݷ���
		.tx_done     (tx_done			), //����������ϱ�־
		.uart_state  ()  //���ڷ���״̬��1Ϊæ��0Ϊ����
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
