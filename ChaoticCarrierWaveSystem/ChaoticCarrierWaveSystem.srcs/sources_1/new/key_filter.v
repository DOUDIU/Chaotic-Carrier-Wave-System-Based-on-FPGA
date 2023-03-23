
module key_filter(
    input                   clk         ,
    input                   rst_n       ,
    input                   key_in      ,
    output   reg            key_flag    ,
    output   reg            key_state    
);
 
 
parameter IDLE      = 4'b0001      ;
parameter FILTER1   = 4'b0010      ;
parameter STABLE    = 4'b0100      ;
parameter FILTER2   = 4'b1000      ;
 
parameter TIME_20MS = 20'd1000_000 ;
 
reg   [  3: 0]         state_c      ;
reg   [  3: 0]         state_n      ;
 
wire                   IDLE_to_FILTER1  ;
wire                   FILTER1_to_STABLE;
wire                   STABLE_to_FILTER2;
wire                   FILTER2_to_IDLE  ;
 
reg                    key_in_ff0   ;
reg                    key_in_ff1   ;
reg                    key_in_ff2   ;
 
wire                   key_in_pos   ;
wire                   key_in_neg   ;
 
reg   [ 19: 0]         cnt          ;
wire                   add_cnt      ;
wire                   end_cnt      ;
 

always  @(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        state_c <= IDLE;
    end
    else begin
        state_c <= state_n;
    end
end

always  @(*)begin
    case(state_c)
        IDLE   :begin
                    if(IDLE_to_FILTER1)
                        state_n = FILTER1;
                    else
                        state_n = state_c;
                end
        FILTER1:begin
                    if(FILTER1_to_STABLE)
                        state_n = STABLE;
                    else
                        state_n = state_c;
                end
        STABLE :begin
                    if(STABLE_to_FILTER2)
                        state_n = FILTER2;
                    else
                        state_n = state_c;
                end
        FILTER2:begin
                    if(FILTER2_to_IDLE)
                        state_n = IDLE;
                    else
                        state_n = state_c;
                end
        default:state_n = IDLE;
    endcase
end
 

assign IDLE_to_FILTER1   = key_in_neg   ;
assign FILTER1_to_STABLE = state_c==FILTER1 && end_cnt;
assign STABLE_to_FILTER2 = key_in_pos   ;
assign FILTER2_to_IDLE   = state_c==FILTER2 && end_cnt;
 

always  @(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        key_in_ff0 <= 1;
        key_in_ff1 <= 1;
        key_in_ff2 <= 1;
    end
    else begin
        key_in_ff0 <= key_in;
        key_in_ff1 <= key_in_ff0;
        key_in_ff2 <= key_in_ff1;
    end
end
 

assign key_in_pos = (state_c==STABLE) ?(key_in_ff1 && !key_in_ff2):1'b0;
assign key_in_neg = (state_c==IDLE) ?(!key_in_ff1 && key_in_ff2):1'b0;
 

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        cnt <= 0;
    end
    else if(add_cnt)begin
        if(end_cnt)
            cnt <= 0;
        else
            cnt <= cnt + 1'b1;
    end
    else begin
        cnt <= 0;
    end
end
 
assign add_cnt = state_c==FILTER1 || state_c==FILTER2;       
assign end_cnt = add_cnt && cnt== TIME_20MS-1;
 

always  @(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        key_flag <= 0;
    end
    else if(state_c==FILTER1 && end_cnt) begin
        key_flag <= 1;
    end
    else begin
        key_flag <= 0;
    end
end
 

always  @(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        key_state <= 1;
    end
    else if(state_c==STABLE || state_c==FILTER2) begin
        key_state <= 0;
    end
    else begin
        key_state <= 1;
    end
end
endmodule