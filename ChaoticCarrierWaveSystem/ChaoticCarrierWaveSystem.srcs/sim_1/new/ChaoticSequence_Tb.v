`timescale 1ns / 1ps

module ChaoticSequence_Tb();
    
	reg					        clk			    ;
	reg					        rst_n		    ;

    wire  signed  [19 : 0]      Chaotic_value   ;

    DouLogisticChaoticMapping #(
        .u                  (6              ),
        .x0                 (70             ),//0-255
        .y0                 (50             ) //0-255
    )u_DouLogisticChaoticMapping(
        .clk                (clk            ),
        .rst_n              (rst_n          ),

        .Chaotic_value      (Chaotic_value  )
    );

    initial begin
        clk     <=  0;
        rst_n   <=  0;
        #10
        rst_n   <=  1;
    end 

    always #5 begin
        clk     <=  ~clk    ;
    end





endmodule
