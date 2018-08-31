//UP-DOWN COUNTER

//sw[0] -> Reset
//sw[1] -> Up/Down
//btn[3] -> Count Speed
//led[3:0] -> LED Output
//clk -> Clock Input

`timescale 1ns / 1ps

module counter_fpga(led, clk, sw, btn);
output [3:0] led;
input [1:0] sw;
input [3:0] btn;
input clk;
reg [3:0] led;

reg [26:0] count;
reg clkdiv;

initial
begin
    count = 0;
    clkdiv = 0;
end

always @ (posedge clk)
begin

    if (btn[3])
    begin
        //count speed = high
        count <= count + 1;
        if(count == 12500000)
        begin
            count <= 0;
            clkdiv <= ~clkdiv;
        end
    end
    
    else
        begin
          //count speed = low
          count <= count + 1;
          if(count == 125000000)
          begin
              count <= 0;
              clkdiv <= ~clkdiv;
          end
        end

end

always @ (posedge clkdiv)
if (sw[0])
//reset state
begin
led <= 4'b1111; 
end

else if (sw[1])
//up-counter
begin
led <= led + 1;
end

else
//down-counter
begin
led <= led - 1;
end

endmodule