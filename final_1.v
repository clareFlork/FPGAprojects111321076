module final_1(input CLK,
					input clear,
					input load,
					input start,
					input diff,
					input LOAD,
					input [3:0]data_in,
					input x_in,
					input reset,
					output reg[1:0]COM,
					output reg [6:0]seg,
					output reg [3:0]random_number,
					output reg[3:0] A_count
					);
					reg[3:0]state,next_state;
					parameter S0=4'b0011,S1=4'b1001,S2=4'b1000,S3=4'b0011,S4=4'b0101,S5=4'b0001,S6=4'b0110,S7=4'b0010,S8=4'b0100;
					
					reg[3:0]answer;
					reg [3:0]bin;
					divfreq F0(CLK,CLK_div);
					reg [0:0]flag;
					

					always@(posedge CLK,negedge reset)
					begin
							if(reset==0)
								begin 
								state<=S0;
								end 
							else 
								begin 
								state<=next_state;
								end
					 end
						always@(state,x_in)
							begin
								case(state)
									S0:if(x_in) next_state=S1;
										else next_state=S0;
									S1:if(x_in) next_state=S2;
										else next_state=S1;
									S2:if(x_in) next_state=S3;
										else next_state=S2;
									S3:if(x_in) next_state=S4;
										else next_state=S3;
									S4:if(x_in) next_state=S5;
										else next_state=S4;
									S5:if(x_in) next_state=S6;
										else next_state=S5;
									S6:if(x_in) next_state=S7;
										else next_state=S6;
									S7:if(x_in) next_state=S8;
										else next_state=S7;
									S8:if(x_in) next_state=S0;
										else next_state=S8;
								endcase
							if(x_in==0)
								begin 
									answer<=state;
								end
							end
					
			initial
				begin
					seg<=7'b1000000;
					COM<=2'b01;
				end
			//顯示0-9(範圍)
			always @(posedge CLK_div)
			begin
				if(COM==2'b10&&(bin==answer)&&start&&diff)
				begin
					seg=7'b0000001;//b0001000
					COM=~COM;
				end
				else if(COM==2'b01&&start)
					begin
					if(~diff)begin seg=7'b1000000;
					end
					else if(bin>answer)
					begin
						case(bin)
								4'b0000: seg= 7'b1000000;/*0*/
								4'b0001: seg= 7'b1111001;/*1*/
								4'b0010: seg= 7'b0100100;/*2*/
								4'b0011: seg= 7'b0110000;/*3*/
								4'b0100: seg= 7'b0011001;/*4*/
								4'b0101: seg= 7'b0010010;/*5*/
								4'b0110: seg= 7'b0000010;/*6*/
								4'b0111: seg= 7'b1111000;/*7*/
								4'b1000: seg= 7'b0000000;/*8*/
								4'b1001: seg= 7'b0010000;/*9*/
								endcase
					end
					COM=2'b10;

				end
				else if(COM==2'b10&&start)
						begin
						if(~diff)begin seg=7'b0010000;
						end
						else if(bin<answer)begin
						case(bin)
							4'b0000: seg= 7'b1000000;/*0*/
							4'b0001: seg= 7'b1111001;/*1*/
							4'b0010: seg= 7'b0100100;/*2*/
							4'b0011: seg= 7'b0110000;/*3*/
							4'b0100: seg= 7'b0011001;/*4*/
							4'b0101: seg= 7'b0010010;/*5*/
							4'b0110: seg= 7'b0000010;/*6*/
							4'b0111: seg= 7'b1111000;/*7*/
							4'b1000: seg= 7'b0000000;/*8*/
							4'b1001: seg= 7'b0010000;/*9*/
							endcase
						end
						COM=2'b01;
						end
				
					else if(~start)begin seg=7'b1111111;
					end
			end
		
		always@(posedge CLK,negedge clear)
		begin
		   if(~clear)bin<=4'b0000;
			else if(load) begin bin<=data_in;
			
			end
			else bin<=bin;
		end
initial
		begin
			if((bin<answer)&&diff)
				begin
				COM=2'b01;
				flag=1;
				end
			else if((bin>answer)&&diff)
				begin
				COM=2'b10;
				flag=1;
				end
			else if((bin==answer)&&diff)
				begin
				COM=2'b10;
				flag=1;
				end
		end

endmodule


module divfreq(input CLK,output reg CLK_div);//除頻器
			reg[24:0] Count;
			always@(posedge CLK) 
			begin
				if(Count>25000)
					begin
						Count<=25'b0;
						CLK_div<=~CLK_div;
					end
				else
				Count<=Count+1'b1;
				end
	endmodule