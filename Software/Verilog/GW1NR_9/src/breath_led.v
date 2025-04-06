//200Hz Brath LED
module breath_led

(
    input         clk,
    input         rst,
    output        pwm_led_out 	//pwm output
    );

localparam CLK_FREQ = 27 ; 				//27MHz
localparam LED_PERIOD = 32'd31815;   // Example period = 200Hz*2^32/27MHz =31815
localparam N = 32;				//pwm bit width
localparam US_COUNT = CLK_FREQ ; 		//1 us counter
localparam MS_COUNT = CLK_FREQ*1000 ; 	//1 ms counter

localparam DUTY_STEP	  = 32'd100000 ;	//duty step
localparam DUTY_MIN_VALUE = 32'h6fffffff ;	//duty minimum value
localparam DUTY_MAX_VALUE = 32'hffffffff ;	//duty maximum value
					  
localparam IDLE    		= 0;	//IDLE state
localparam PWM_PLUS  	= 1;    //PWM duty plus state
localparam PWM_MINUS  	= 2;    //PWM duty minus state
localparam PWM_GAP  	= 3;    //PWM duty adjustment gap

wire 		pwm_out;	//pwm output
reg[31:0] 	period;		//pwm step value
reg[31:0] 	duty;		//duty value
reg			pwm_flag ;	//duty value plus and minus flag, 0: plus; 1: minus

reg[3:0] 	state;
reg[31:0] 	timer;		//duty adjustment counter

assign pwm_led_out = ~pwm_out ; //led low active

always@(posedge clk or posedge rst)
begin
	if(rst == 1'b1)
	begin
		period 		<= 32'd0;
		timer 		<= 32'd0;
		duty 		<= 32'd0;
		pwm_flag 	<= 1'b0 ;
		state 		<= IDLE;
	end
	else
		case(state)
			IDLE:
			begin
				period 		<= LED_PERIOD;
				state  		<= PWM_PLUS;
				duty   		<= DUTY_MIN_VALUE;				
			end
			PWM_PLUS :
			begin
				if (duty > DUTY_MAX_VALUE - DUTY_STEP)	//if duty is bigger than DUTY MAX VALUE minus DUTY_STEP , begin to minus duty value
				begin
					pwm_flag 	<= 1'b1 ;
					duty   		<= duty - DUTY_STEP ;
				end
				else
				begin
					pwm_flag 	<= 1'b0 ;					
					duty   		<= duty + DUTY_STEP ;	
				end
				
				state  		<= PWM_GAP ;
			end
			PWM_MINUS :
			begin
				if (duty < DUTY_MIN_VALUE + DUTY_STEP)	//if duty is little than DUTY MIN VALUE plus duty step, begin to add duty value
				begin
					pwm_flag 	<= 1'b0 ;
					duty   		<= duty + DUTY_STEP ;
				end
				else
				begin
					pwm_flag 	<= 1'b1 ;
					duty   		<= duty - DUTY_STEP ;	
				end	
				state  		<= PWM_GAP ;
			end
			PWM_GAP:
			begin
				if(timer >= US_COUNT*100)      //adjustment gap is 100us
				begin
					if (pwm_flag)
						state <= PWM_MINUS ;
					else
						state <= PWM_PLUS ;
						
					timer <= 32'd0;
				end
				else
				begin
					timer <= timer + 32'd1;
				end
			end
			default:
			begin
				state <= IDLE;		
			end			
		endcase
end


// Instantiate pwm_led
pwm #(
        .N(N)
    ) pwm_led_inst (
        .clk(clk),
        .rst(rst),
        .period(period),
        .duty(duty),
        .pwm_out(pwm_out)
   );
    endmodule