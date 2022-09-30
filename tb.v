`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.04.2022 02:19:09
// Design Name: 
// Module Name: tb
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


module tb( );

    reg [1:0] base;
    reg clk,reset;
    reg [31:0] in_data;
    wire [31:0] out_data;
    
    log dut(clk, reset, base, in_data, out_data );
    
    initial
    begin 
    clk=1'b0;
    forever #5 clk=~clk;
    end

    initial 
    begin
        // Apply Inputs
        
        reset = 0;
        base = 2'b00;
        in_data = 32'h447a0000;
  #20 base = 2'b01;
  #20 base = 2'b10;
  #20 $stop;
    end    

endmodule