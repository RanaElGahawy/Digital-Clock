`timescale 1ns / 1ps



//module bin_counter_nbits #(parameter n = 3) (input clk, reset, UpDown, Inc, output reg [n:0]count);

//always @(posedge clk, posedge reset)
//begin
// if (reset == 1)
//        count <= 0; 
//else if ( UpDown == 0 )    
//        count <= count + Inc +1;    
//else if ( UpDown == 1)
//        count <= count -Inc - 1;        
//end
//endmodule


module counter_testbench( );

reg clk, reset, UpDown, Inc;
wire [3:0] count;

bin_counter_nbits  uut  (.clk(clk), .reset(reset), .UpDown(UpDown), .Inc(Inc), .count(count));

initial begin 
clk = 0;
forever #5 clk = ~clk; 
end

initial begin
reset=1; #20
reset=0;
end

initial begin
UpDown=1;  #50
UpDown=0;
end

initial begin
Inc=1; #100
Inc=0;
end
endmodule
