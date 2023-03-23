module Uart_Byte_Tx(
    input                   clk         , //ϵͳʱ��
    input                   rst_n       , //ϵͳ��λ
    input                   send_en     , //����ʹ��
    input   [ 7 : 0 ]       data_byte   , //���͵�����
    input   [ 2 : 0 ]       baud_set    , //����������
    output  reg             rs232_tx    , //FPGAj������ת���ɴ������ݷ���
    output  reg             tx_done     , //����������ϱ�־
    output  reg             uart_state    //���ڷ���״̬��1Ϊæ��0Ϊ����
);


reg   [ 13: 0]         baud_c   ;//(4800bps-10416),(9600bps-5208),(19200bps-2604),
                                 //(38400bps-1302),(57600bps-868),(115200bps-434)
wire  [  9: 0]         data_out      ;
reg   [ 15: 0]         cnt0          ; //1bit���ݳ��ȼ���
reg   [  3: 0]         cnt1          ; //����һ�ֽ����ݶ�ÿ���ֽڼ���
wire                   add_cnt0      ; //������cnt0��һ����
wire                   add_cnt1      ; //������cnt1��һ����
wire                   end_cnt0      ; //������cnt0��������
wire                   end_cnt1      ; //������cnt1��������
reg   [  7: 0]         data_byte_ff  ; //����ʹ��ʱ�����͵����ݼĴ�����

//�����ʲ��ұ�
always  @(posedge clk or negedge rst_n)begin
     if(rst_n==1'b0)begin
        baud_c <= 5208;
    end
    else begin
        case(baud_set)
            0:      baud_c = 14'd10416;
            1:      baud_c = 14'd5208 ;
            2:      baud_c = 14'd2604 ;
            3:      baud_c = 14'd1302 ;
            4:      baud_c = 14'd868  ;
            5:      baud_c = 14'd434  ;
            default:baud_c = 14'd5208 ;//Ĭ��9600bps
        endcase
    end
end

//����״̬��־��0Ϊ���У�1Ϊæ
always  @(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        uart_state <= 0;
    end
    else if(send_en) begin
        uart_state <= 1;
    end
    else if(end_cnt1)begin
        uart_state <= 0;
    end
    else begin
        uart_state <= uart_state;
    end
end

//1bit���ݳ��ȼ���
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        cnt0 <= 0;
    end
    else if(add_cnt0)begin
        if(end_cnt0)
            cnt0 <= 0;
        else
            cnt0 <= cnt0 + 1'b1;
    end
end

assign add_cnt0 = uart_state==1;
assign end_cnt0 = add_cnt0 && cnt0== baud_c-1;

//����һ�ֽ����ݶ�ÿ���ֽڼ���
always @(posedge clk or negedge rst_n)begin 
    if(!rst_n)begin
        cnt1 <= 0;
    end
    else if(add_cnt1)begin
        if(end_cnt1)
            cnt1 <= 0;
        else
            cnt1 <= cnt1 + 1'b1;
    end
end

assign add_cnt1 = end_cnt0;
assign end_cnt1 = add_cnt1 && cnt1== 10-1;

//���ڷ��ͽ�����־
always  @(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        tx_done <= 0;
    end
    else if(end_cnt1) begin
        tx_done <= 1;
    end
    else begin
        tx_done <= 0;
    end
end

//����ʹ��ʱ�����͵����ݼĴ�����
always  @(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        data_byte_ff <= 0;
    end
    else if(send_en) begin
        data_byte_ff <= data_byte;
    end
end

//���ʹ������ݵ�����
always  @(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        rs232_tx <= 1;
    end
    else if(uart_state && cnt0==0) begin
        rs232_tx <= data_out[cnt1];
    end
end
assign data_out = {1'b1,data_byte_ff,1'b0};

endmodule

