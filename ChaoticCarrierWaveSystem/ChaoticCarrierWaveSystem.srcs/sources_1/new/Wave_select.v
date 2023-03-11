module wave_select(
	input				clk		,
	input				rst_n	,
	input				key0_in	,

	output	reg	[1:0]	wave_c
);

	wire	key_flag	;
	wire	key_state	;

	key_filter wave_key (
        .clk       (clk),
        .rst_n     (rst_n),
        .key_in    (key0_in),
        .key_flag  (key_flag),
        .key_state (key_state)
    );

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			wave_c <= 0;
		end
		else if (key_flag) begin
			wave_c <= wave_c + 1'b1;
		end
	end

endmodule