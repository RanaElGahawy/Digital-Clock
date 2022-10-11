`timescale 1ns / 1ps

module BCD (bcd,  seg );
input [3:0] bcd;
output reg[6:0] seg;
always @(bcd)
begin
    case (bcd) 
        0 : seg = 7'b0000001;
        1 : seg = 7'b1001111;
        2 : seg = 7'b0010010;
        3 : seg = 7'b0000110;
        4 : seg = 7'b1001100;
        5 : seg = 7'b0100100;
        6 : seg = 7'b0100000;
        7 : seg = 7'b0001111;
        8 : seg = 7'b0000000;
        9 : seg = 7'b0000100;
    endcase
end  
endmodule


module bin_counter_nbits #(parameter n = 3) (input clk, reset, UpDown, Inc, output reg [n:0]count);

initial 
count = 0;

always @(posedge clk, posedge reset)
begin
 if (reset == 1)
        count <= 0; 
else if ( UpDown == 0 )    
        count <= count +Inc +1;    
else if (UpDown)
        count <= count-Inc - 1;        
end
endmodule


module  clockDivider #(parameter n = 5000000) (input clk, rst, output reg clk_out);
reg [31:0] count; 

always @ (posedge(clk), posedge(rst)) begin
    if (rst == 1 )
        count <= 32'b0;
    else if (count == n-1)
        count <= 32'b0;
    else
        count <= count +1;
end

always @ (posedge(clk)) begin 

     if (count == n-1)
         clk_out <= ~clk_out;
    else
         clk_out <= clk_out;

end
endmodule

module counter #(parameter n = 3) (input clk, reset, enable, output reg [n:0]count);
initial 
count = 0;

always @(posedge clk, posedge reset)
begin
    if (reset == 1)
        count <= 0; 
    else if (enable)
        begin if  (count == n-1)
            count <= 0;
        else 
            count <= count+1;    
      end
end
endmodule



module secondsandMinutesCounter (input clk, reset, output [3:0] sec_1, [3:0] sec_2, [3:0] min_1, [3:0] min_2 );
counter #(10) C1  (clk, reset, 1, sec_1);
counter #(6) C2  (clk, reset, (sec_1 == 9) , sec_2);
counter #(10) C3  (clk, reset, (sec_1 == 9 & sec_2 == 5), min_1);
counter #(6) C4  (clk, reset, (sec_1 == 9 & sec_2 == 5 & min_1 == 9), min_2);

endmodule




module digitalClock (input clk, reset, output reg dot, reg [3:0] sel, reg [6:0] bcd);

wire [3:0] sec_1, sec_2,  min_1, min_2;
wire [6:0]  sec_1_dec, sec_2_dec,  min_1_dec, min_2_dec;
wire clk_div, clk_div2;


clockDivider #(50000000) Div (clk, reset, clk_div);
clockDivider #(50000) Div2 (clk, reset, clk_div2);

secondsandMinutesCounter MyClock (clk_div , reset, sec_1, sec_2,  min_1, min_2);

BCD S1 (sec_1, sec_1_dec);
BCD S2 (sec_2, sec_2_dec);
BCD M1 (min_1, min_1_dec);
BCD M2 (min_2, min_2_dec);

reg [1:0] count;

always @(posedge clk_div2, posedge reset)
begin

if (reset)
begin
    count <= 0;
    sel = 4'b0000;
    dot = 1'b1;
    bcd = 7'b0000000;
end
else begin    
    count <= count +1;
    if ( count == 0 )
     begin    
     sel = 4'b1110;
     bcd = sec_1_dec;
     dot = 1'b1;

     end
    if ( count == 1 )
      begin    
      sel = 4'b1101;
      bcd = sec_2_dec;
      dot = 1'b1;

      end
    if ( count == 2 )
        begin    
        sel = 4'b1011;
        bcd = min_1_dec;
            dot = 1'b0;

        end
        
    if ( count == 3 )
      begin    
      sel = 4'b0111;
      bcd = min_2_dec;
          dot = 1'b1;

      end                                             
end   
end

endmodule