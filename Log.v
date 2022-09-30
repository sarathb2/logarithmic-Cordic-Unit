`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.04.2022 02:07:45
// Design Name: 
// Module Name: Log
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////



module log(clk, reset, base, in_data, out_data );

    input clk, reset;
    input [1:0] base;
    input [31:0] in_data;
    output reg [31:0] out_data;
    
    reg [23:0] temp_x, temp_y, err;
    reg [7:0] exp;
    reg [31:0] temp_exp,temp_result,count;
    reg flag;
    
    integer i;
    
    always@(posedge clk or posedge reset)
    begin
         exp = in_data[30:23] - 8'd127;
         temp_x = {1'b1,in_data[22:0]};
        
        if(reset)
        out_data = 0;
        else
        begin 
                if(in_data[31]==1'b1)
                    out_data = 32'hffffffff;  // logarithm undefined for negative numbers
                    else
                       begin 
                       if(base ==2'b00)
				        begin  
                            case (exp)
                                8'd0 :begin
                                        temp_x = temp_x >> 1 ;                          // temp_x = temp_x / 2
                                        temp_y = 24'b000001001101000100000101 ;        // temp_y = 0 - log(1/2)
                                      end
                                8'd1 :begin
                                        temp_x = temp_x >> 1 ;                          // temp_x = temp_x / 4
                                        temp_y = 24'b0000100110100010000010100 ;        // temp_y = 0 - log(1/4)
                                      end
                                8'd2 :begin
                                        temp_x = temp_x >> 1 ;                          // temp_x = temp_x / 8
                                        temp_y = 24'b000011100111001100001110 ;        // temp_y = 0 - log(1/8)
                                      end
                                8'd3 :begin
                                        temp_x = temp_x >> 1 ;                          // temp_x = temp_x / 16
                                        temp_y = 24'b000100110100010000010011 ;        // temp_y = 0 - log(1/16)
                                      end
                                8'd4 :begin
                                        temp_x = temp_x >> 1 ;                          // temp_x = temp_x / 32
                                        temp_y = 24'b000110000001010100011000 ;        // temp_y = 0 - log(1/32)
                                      end
                                8'd5 :begin
                                        temp_x = temp_x >> 1 ;                          // temp_x = temp_x / 64
                                        temp_y = 24'b000111001110011000011101 ;        // temp_y = 0 - log(1/64)
                                      end
                                8'd6 :begin
                                        temp_x = temp_x >> 1 ;                          // temp_x = temp_x / 128
                                        temp_y = 24'b001000011011011100100010 ;        // temp_y = 0 - log(1/128)
                                      end
                                8'd7 :begin
                                        temp_x = temp_x >> 1 ;                          // temp_x = temp_x / 256
                                        temp_y = 24'b001001101000100000100111 ;        // temp_y = 0 - log(1/256)
                                      end
                                8'd8 :begin
                                        temp_x = temp_x >> 1 ;                          // temp_x = temp_x / 512
                                        temp_y = 24'b001010110101100100101011 ;        // temp_y = 0 - log(1/512)
                                      end
                                8'd9 :begin
                                        temp_x = temp_x >> 1 ;                          // temp_x = temp_x / 1024
                                        temp_y = 24'b001100000010101000110000 ;        // temp_y = 0 - log(1/1024)
                                      end       
                            endcase
                            
                            if( ((temp_x + (temp_x>>1)) & 24'h800000)==24'd0)
                                begin
                                temp_x = temp_x + (temp_x>>1) ;                         // temp_x = temp_x * 3/2
                                temp_y = temp_y - 24'b000000101101000101000101 ;        // temp_y = temp_y - log(3/2)
                                end
                            
                            if( ((temp_x + (temp_x>>2)) & 24'h800000)==24'd0) 
                                begin
                                temp_x = temp_x + (temp_x>>2) ;                          // temp_x = temp_x * 5/4
                                temp_y = temp_y - 24'b000000011000110011110010 ;        // temp_y = temp_y - log(5/4)
                                end
                            
                            if( ((temp_x + (temp_x>>3)) & 24'h800000)==24'd0) 
                                begin
                                temp_x = temp_x + (temp_x>>3) ;                          // temp_x = temp_x * 9/8
                                temp_y = temp_y - 24'b000000001101000110000101 ;        // temp_y = temp_y - log(9/8)
                                end
                            
                            if( ((temp_x + (temp_x>>4)) & 24'h800000)==24'd0) 
                                begin
                                temp_x = temp_x + (temp_x>>4) ;                          // temp_x = temp_x * 17/16
                                temp_y = temp_y - 24'b000000000110101111011000 ;        // temp_y = temp_y - log(17/16)
                                end
                            
                            if( ((temp_x + (temp_x>>5)) & 24'h800000)==24'd0) 
                                begin
                                temp_x = temp_x + (temp_x>>5) ;                          // temp_x = temp_x * 33/32
                                temp_y = temp_y - 24'b000000000011011010111101 ;        // temp_y = temp_y - log(33/32)
                                end
                            
                            if( ((temp_x + (temp_x>>6)) & 24'h800000)==24'd0) 
                                begin
                                temp_x = temp_x + (temp_x>>6) ;                          // temp_x = temp_x * 65/64
                                temp_y = temp_y - 24'b000000000001101110010100 ;        // temp_y = temp_y - log(65/64)
                                end
                             
                             if( ((temp_x + (temp_x>>7)) & 24'h800000)==24'd0) 
                                begin
                                temp_x = temp_x + (temp_x>>7) ;                          // temp_x = temp_x * 129/128
                                temp_y = temp_y - 24'b000000000000110111011000 ;        // temp_y = temp_y - log(129/128)
                                end   
                                
                             err = 24'h800000 - temp_x;
                             err = err >> 3 ;
                             temp_y = temp_y - err;
                             
                             // normalizing result//
                            
                             flag=0;
                             count=0;
                             for( i=0; i<24; i=i+1)
                                if(temp_y[23-i]==0 && flag == 0)
                                 count=count+1;
                                 else flag=1;
                                 
                             if (count <= 32'd3)
                                begin
                                temp_y = temp_y >> (3 - count);
                                temp_exp = 3-count +8'd127;
                                end
                               else
                                begin
                                temp_y = temp_y << (count - 3);
                                temp_exp = 8'd127 - (count - 3);
                                end
                                 
                              temp_result[22:0] = temp_result[22:0]<<(count+1); 
                              out_data = {1'd0,temp_exp[7:0],temp_y[19:0],3'b0}; 
                         
                         end 
                       
                       else if(base == 2'b01)
                        begin
                            case (exp)
                                8'd0 :begin
                                        temp_x = temp_x >> 1 ;                          // temp_x = temp_x / 2
                                        temp_y = 24'b000010110001011100100001 ;        // temp_y = 0 - ln(1/2)
                                      end
                                8'd1 :begin
                                        temp_x = temp_x >> 1 ;                          // temp_x = temp_x / 4
                                        temp_y = 24'b000101100010111001000011 ;        // temp_y = 0 - ln(1/4)
                                      end
                                8'd2 :begin
                                        temp_x = temp_x >> 1 ;                          // temp_x = temp_x / 8
                                        temp_y = 24'b001000010100010101100100 ;        // temp_y = 0 - ln(1/8)
                                      end
                                8'd3 :begin
                                        temp_x = temp_x >> 1 ;                          // temp_x = temp_x / 16
                                        temp_y = 24'b001011000101110010000110 ;        // temp_y = 0 - ln(1/16)
                                      end
                                8'd4 :begin
                                        temp_x = temp_x >> 1 ;                          // temp_x = temp_x / 32
                                        temp_y = 24'b001101110111001110100111 ;        // temp_y = 0 - ln(1/32)
                                      end
                                8'd5 :begin
                                        temp_x = temp_x >> 1 ;                          // temp_x = temp_x / 64
                                        temp_y = 24'b010000101000101011001001 ;        // temp_y = 0 - ln(1/64)
                                      end
                                8'd6 :begin
                                        temp_x = temp_x >> 1 ;                          // temp_x = temp_x / 128
                                        temp_y = 24'b010011011010000111101010 ;        // temp_y = 0 - ln(1/128)
                                      end
                                8'd7 :begin
                                        temp_x = temp_x >> 1 ;                          // temp_x = temp_x / 256
                                        temp_y = 24'b010110001011100100001100 ;        // temp_y = 0 - ln(1/256)
                                      end
                                8'd8 :begin
                                        temp_x = temp_x >> 1 ;                          // temp_x = temp_x / 512
                                        temp_y = 24'b011000111101000000101101 ;        // temp_y = 0 - ln(1/512)
                                      end
                                8'd9 :begin
                                        temp_x = temp_x >> 1 ;                          // temp_x = temp_x / 1024
                                        temp_y = 24'b011011101110011101001111 ;        // temp_y = 0 - ln(1/1024)
                                      end       
                            endcase
                            
                            if( ((temp_x + (temp_x>>1)) & 24'h800000)==24'd0)
                                begin
                                temp_x = temp_x + (temp_x>>1) ;                         // temp_x = temp_x * 3/2
                                temp_y = temp_y - 24'b000001100111110011001001 ;        // temp_y = temp_y - ln(3/2)
                                end
                            
                            if( ((temp_x + (temp_x>>2)) & 24'h800000)==24'd0) 
                                begin
                                temp_x = temp_x + (temp_x>>2) ;                          // temp_x = temp_x * 5/4
                                temp_y = temp_y - 24'b000000111001000111111111 ;        // temp_y = temp_y - ln(5/4)
                                end
                            
                            if( ((temp_x + (temp_x>>3)) & 24'h800000)==24'd0) 
                                begin
                                temp_x = temp_x + (temp_x>>3) ;                          // temp_x = temp_x * 9/8
                                temp_y = temp_y - 24'b000000011110001001110000 ;        // temp_y = temp_y - ln(9/8)
                                end
                            
                            if( ((temp_x + (temp_x>>4)) & 24'h800000)==24'd0) 
                                begin
                                temp_x = temp_x + (temp_x>>4) ;                          // temp_x = temp_x * 17/16
                                temp_y = temp_y - 24'b000000001111100001010010 ;        // temp_y = temp_y - ln(17/16)
                                end
                            
                            if( ((temp_x + (temp_x>>5)) & 24'h800000)==24'd0) 
                                begin
                                temp_x = temp_x + (temp_x>>5) ;                          // temp_x = temp_x * 33/32
                                temp_y = temp_y - 24'b000000000111111000001010 ;        // temp_y = temp_y - ln(33/32)
                                end
                            
                            if( ((temp_x + (temp_x>>6)) & 24'h800000)==24'd0) 
                                begin
                                temp_x = temp_x + (temp_x>>6) ;                          // temp_x = temp_x * 65/64
                                temp_y = temp_y - 24'b000000000011111110000001 ;        // temp_y = temp_y - ln(65/64)
                                end
                             
                             if( ((temp_x + (temp_x>>7)) & 24'h800000)==24'd0) 
                                begin
                                temp_x = temp_x + (temp_x>>7) ;                          // temp_x = temp_x * 129/128
                                temp_y = temp_y - 24'b000000000001111111100000 ;        // temp_y = temp_y - ln(129/128)
                                end   
                                
                             err = 24'h800000 - temp_x;
                             err = err >> 3 ;
                             temp_y = temp_y - err;
                            
                            // normalizing result//
                            
                             flag=0;
                             count=0;
                             for( i=0; i<24; i=i+1)
                                if(temp_y[23-i]==0 && flag == 0)
                                 count=count+1;
                                 else flag=1;
                                 
                             if (count <= 32'd3)
                                begin
                                temp_y = temp_y >> (3 - count);
                                temp_exp = 3-count +8'd127;
                                end
                               else
                                begin
                                temp_y = temp_y << (count - 3);
                                temp_exp = 8'd127 - (count - 3);
                                end
                                 
                              temp_result[22:0] = temp_result[22:0]<<(count+1); 
                              out_data = {1'd0,temp_exp[7:0],temp_y[19:0],3'b0}; 
                          end   
                         
                     else 
                        begin
                            case (exp)
                                8'd0 :begin
                                        temp_x = temp_x >> 1 ;                          // temp_x = temp_x / 2
                                        temp_y = 24'b000100000000000000000000 ;        // temp_y = 0 - log2(1/2)
                                      end
                                8'd1 :begin
                                        temp_x = temp_x >> 1 ;                          // temp_x = temp_x / 4
                                        temp_y = 24'b001000000000000000000000 ;        // temp_y = 0 - log2(1/4)
                                      end
                                8'd2 :begin
                                        temp_x = temp_x >> 1 ;                          // temp_x = temp_x / 8
                                        temp_y = 24'b001100000000000000000000 ;        // temp_y = 0 - log2(1/8)
                                      end
                                8'd3 :begin
                                        temp_x = temp_x >> 1 ;                          // temp_x = temp_x / 16
                                        temp_y = 24'b010000000000000000000000 ;        // temp_y = 0 - log2(1/16)
                                      end
                                8'd4 :begin
                                        temp_x = temp_x >> 1 ;                          // temp_x = temp_x / 32
                                        temp_y = 24'b010100000000000000000000 ;        // temp_y = 0 - log2(1/32)
                                      end
                                8'd5 :begin
                                        temp_x = temp_x >> 1 ;                          // temp_x = temp_x / 64
                                        temp_y = 24'b011000000000000000000000 ;        // temp_y = 0 - log2(1/64)
                                      end
                                8'd6 :begin
                                        temp_x = temp_x >> 1 ;                          // temp_x = temp_x / 128
                                        temp_y = 24'b011100000000000000000000 ;        // temp_y = 0 - log2(1/128)
                                      end
                                8'd7 :begin
                                        temp_x = temp_x >> 1 ;                          // temp_x = temp_x / 256
                                        temp_y = 24'b100000000000000000000000 ;        // temp_y = 0 - log2(1/256)
                                      end
                                8'd8 :begin
                                        temp_x = temp_x >> 1 ;                          // temp_x = temp_x / 512
                                        temp_y = 24'b100100000000000000000000 ;        // temp_y = 0 - log2(1/512)
                                      end
                                8'd9 :begin
                                        temp_x = temp_x >> 1 ;                          // temp_x = temp_x / 1024
                                        temp_y = 24'b101000000000000000000000 ;        // temp_y = 0 - log2(1/1024)
                                      end       
                            endcase
                            
                            if( ((temp_x + (temp_x>>1)) & 24'h800000)==24'd0)
                                begin
                                temp_x = temp_x + (temp_x>>1) ;                         // temp_x = temp_x * 3/2
                                temp_y = temp_y - 24'b000010010101110000000010 ;        // temp_y = temp_y - log2(3/2)
                                end
                            
                            if( ((temp_x + (temp_x>>2)) & 24'h800000)==24'd0) 
                                begin
                                temp_x = temp_x + (temp_x>>2) ;                          // temp_x = temp_x * 5/4
                                temp_y = temp_y - 24'b000001010010011010011110 ;        // temp_y = temp_y - log2(5/4)
                                end
                            
                            if( ((temp_x + (temp_x>>3)) & 24'h800000)==24'd0) 
                                begin
                                temp_x = temp_x + (temp_x>>3) ;                          // temp_x = temp_x * 9/8
                                temp_y = temp_y - 24'b000000101011100000000011 ;        // temp_y = temp_y - log2(9/8)
                                end
                            
                            if( ((temp_x + (temp_x>>4)) & 24'h800000)==24'd0) 
                                begin
                                temp_x = temp_x + (temp_x>>4) ;                          // temp_x = temp_x * 17/16
                                temp_y = temp_y - 24'b000000010110011000111111 ;        // temp_y = temp_y - log2(17/16)
                                end
                            
                            if( ((temp_x + (temp_x>>5)) & 24'h800000)==24'd0) 
                                begin
                                temp_x = temp_x + (temp_x>>5) ;                          // temp_x = temp_x * 33/32
                                temp_y = temp_y - 24'b000000001011010111010111 ;        // temp_y = temp_y - log2(33/32)
                                end
                            
                            if( ((temp_x + (temp_x>>6)) & 24'h800000)==24'd0) 
                                begin
                                temp_x = temp_x + (temp_x>>6) ;                          // temp_x = temp_x * 65/64
                                temp_y = temp_y - 24'b000000000101101110011110 ;        // temp_y = temp_y - log2(65/64)
                                end
                             
                             if( ((temp_x + (temp_x>>7)) & 24'h800000)==24'd0) 
                                begin
                                temp_x = temp_x + (temp_x>>7) ;                          // temp_x = temp_x * 129/128
                                temp_y = temp_y - 24'b000000000010110111111101 ;        // temp_y = temp_y - log2(129/128)
                                end   
                                
                             err = 24'h800000 - temp_x;
                             err = err >> 3 ;
                             temp_y = temp_y - err;
                            
                            // normalizing result//
                            
                             flag=0;
                             count=0;
                             for( i=0; i<24; i=i+1)
                                if(temp_y[23-i]==0 && flag == 0)
                                 count=count+1;
                                 else flag=1;
                                 
                             if (count <= 32'd3)
                                begin
                                temp_y = temp_y >> (3 - count);
                                temp_exp = 3-count +8'd127;
                                end
                               else
                                begin
                                temp_y = temp_y << (count - 3);
                                temp_exp = 8'd127 - (count - 3);
                                end
                                 
                              temp_result[22:0] = temp_result[22:0]<<(count+1); 
                              out_data = {1'd0,temp_exp[7:0],temp_y[19:0],3'b0}; 
                          end     
                          
              end
        end
        end
endmodule
