`timescale 1ns / 1ps


//module  clockDivider #(parameter n = 5000000) (input clk, rst, output reg clk_out);
//reg [31:0] count; 
//always @ (posedge(clk), posedge(rst)) begin
//    if (rst == 1'b1)
//        count <= 32'b0;
//    else if (count == n-1)
//        count <= 32'b0;
//    else
//        count <= count +1;
//end
//always @ (posedge(clk), posedge(rst)) begin 
//    if (rst == 1'b1)
//         clk_out <= 1'b0;
         
//    else if (count == n-1)
//         clk_out <= ~ clk_out;
//    else
//         clk_out <= clk_out;

//end
//endmodule


module clkdivider();

reg clk, rst;
wire clk_out;

clockDivider #(5) uut (clk, rst, clk_out);

initial begin 
clk = 0;
forever #5 clk = ~clk; 
end
initial begin
rst=1; #20
rst=0;
end


endmodule
