`timescale 1ns / 1ps
//THE FIRST 15 FIBONACCI NUMBERS 
module FIBONACCI(clk, SW, FIBOUT);
input clk;
input [1:0] SW; //RESET = SW[0]
output [11:0] FIBOUT; 

reg [11:0] prev_val;
reg [11:0] curr_val;
//integer done = 0;

reg clkdiv;
reg [26:0] count; //FOR CLK DIVISION
reg [3:0] cnt; //FOR FIB SEQUENCE

//CLOCK DIVISION
initial
begin
    count = 0;
    clkdiv = 0;
end

always @ (posedge clk)
begin
    count <= count + 1;
    if (count == 125000000)
    begin
        count <= 0;
        clkdiv <= ~clkdiv;
    end
end
//END - CLOCK DIVISION

always @ ( posedge clkdiv or posedge SW[0])
begin
        if (SW[0] == 1'b1)
        begin
            prev_val <= 12'b0; //PREVIOUS VALUE
            curr_val <= 12'b1; //CURRENT VALUE
            cnt <= 4'b0000;
        end
        else if (clk == 1'b1)
        begin
            cnt <= cnt + 1;
            begin
                prev_val <= curr_val;
                curr_val <= curr_val + prev_val;
            end
        end
end
assign FIBOUT = prev_val;
endmodule