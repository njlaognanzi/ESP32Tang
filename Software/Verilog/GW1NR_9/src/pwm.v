module pwm
#(
	parameter N = 16 //pwm bit width 
)
(
    input         clk,
    input         rst,
    input[N - 1:0]period,	//pwm step value, period= F_pwm*2^(N)/F_Clk
    input[N - 1:0]duty,		//duty value, duty cycle (%)= (duty / 2^N) × 100%
    output        pwm_out 	//pwm output
    );
 
reg[N - 1:0] period_r;		//period register
reg[N - 1:0] duty_r;		//duty register
reg[N - 1:0] period_cnt;	//period counter
reg pwm_r;
assign pwm_out = pwm_r;
always@(posedge clk or posedge rst)
begin
    if(rst==1)
    begin
        period_r <= { N {1'b0} };
        duty_r <= { N {1'b0} };
    end
    else
    begin
        period_r <= period;
        duty_r   <= duty;
    end
end
//period counter, step is period value
always@(posedge clk or posedge rst)
begin
    if(rst==1)
        period_cnt <= { N {1'b0} };
    else
        period_cnt <= period_cnt + period_r;
end

always@(posedge clk or posedge rst)
begin
    if(rst==1)
    begin
        pwm_r <= 1'b0;
    end
    else
    begin
        if(period_cnt >= duty_r)	//if period counter is bigger or equals to duty value, then set pwm value to high
            pwm_r <= 1'b1;
        else
            pwm_r <= 1'b0;
    end
end

endmodule

