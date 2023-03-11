module DouLogisticChaoticMapping #(
    parameter u     =   4   ,
    parameter x0    =   100 ,//0-255
    parameter y0    =   50   //0-255
)(
    input                       clk             ,
    input                       rst_n           ,

    output  signed  [19 : 0]    Chaotic_value
);

reg         [9  : 0]    counter;
reg         [19 : 0]    Xn;
reg         [19 : 0]    Yn;
reg         [19 : 0]    Xn_o;
reg         [19 : 0]    Yn_o;


always@(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        counter     <=  0;
    end
    else begin
        counter     <=  counter     +   1'b1;
    end
end


always@(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        Xn_o    <=      x0;
        Yn_o    <=      y0;
        Xn      <=      0 ;
        Yn      <=      0 ;
    end
    else if(counter == 10'd1023)begin
        Xn_o    <=      Xn;
        Yn_o    <=      Yn;
        Xn      <=      u*Xn_o*(255-Xn_o) >> 8;
        Yn      <=      u*Yn_o*(255-Yn_o) >> 8;
    end
end

assign  Chaotic_value = Yn - Xn;



endmodule