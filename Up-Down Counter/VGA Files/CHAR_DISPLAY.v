module CHAR_DISPLAY
(
char_column,
char_line,
subchar_line,
subchar_pixel,
pixel_clock,
reset,
vga_red_data,
vga_green_data,
vga_blue_data,
SW
);

input [6:0]		char_column;		// character number on the current line
input [6:0]		char_line;			// line number on the screen
input [2:0]		subchar_line;		// the line number within a character block 0-8
input [2:0]		subchar_pixel;		// the pixel number within a character block 0-8
input				pixel_clock;
input				reset;
output			vga_red_data;
output			vga_green_data;
output			vga_blue_data;
input [1:0]     SW;

reg [0:8*12-1] counter_out = "";

reg clkdiv;
reg [3:0] count_out;

//Clock Division
reg [26:0] count;
initial
begin
    count = 0;
    clkdiv = 0;
end

always @ (posedge pixel_clock)
begin
    count <= count + 1'b1;
    if (count == 25000000)
    begin
        count <= 0;
        clkdiv = ~clkdiv;
    end
end
//End - Clock Division   

always @ (posedge clkdiv)
if (SW[0]) 
begin
counter_out = "-> PAUSE";
end

else if (SW[1])
//UP-COUNTER
begin
count_out <= count_out + 1'b1;

case (count_out)
    4'b0000: counter_out =  " COUNT: 0";
    4'b0001: counter_out =  " COUNT: 1";
    4'b0010: counter_out =  " COUNT: 2";
    4'b0011: counter_out =  " COUNT: 3";
    4'b0100: counter_out =  " COUNT: 4";
    4'b0101: counter_out =  " COUNT: 5";
    4'b0110: counter_out =  " COUNT: 6";
    4'b0111: counter_out =  " COUNT: 7";
    4'b1000: counter_out =  " COUNT: 8";
    4'b1001: counter_out =  " COUNT: 9";
    4'b1010: counter_out =  " COUNT: 10";
    4'b1011: counter_out =  " COUNT: 11";
    4'b1100: counter_out =  " COUNT: 12";
    4'b1101: counter_out =  " COUNT: 13";
    4'b1110: counter_out =  " COUNT: 14";
    4'b1111: counter_out =  " COUNT: 15";
    default: counter_out =  " NULL";
endcase
end

else
//DOWN-COUNTER
begin
count_out <= count_out - 1'b1;

case (count_out)
     4'b1111: counter_out = " COUNT: 15";
     4'b1110: counter_out = " COUNT: 14";
     4'b1101: counter_out = " COUNT: 13";
     4'b1100: counter_out = " COUNT: 12";
     4'b1011: counter_out = " COUNT: 11";
     4'b1010: counter_out = " COUNT: 10";
     4'b1001: counter_out = " COUNT: 9";
     4'b1000: counter_out = " COUNT: 8";
     4'b0111: counter_out = " COUNT: 7";
     4'b0110: counter_out = " COUNT: 6";
     4'b0101: counter_out = " COUNT: 5";
     4'b0100: counter_out = " COUNT: 4";
     4'b0011: counter_out = " COUNT: 3";
     4'b0010: counter_out = " COUNT: 2";
     4'b0001: counter_out = " COUNT: 1";
     4'b0000: counter_out = " COUNT: 0";
    default: counter_out =  " NULL";
endcase
end

wire [13:0] 	char_addr = {char_line[6:0], char_column[6:0]};
wire				write_enable;			// character memory is written to on a clock rise when high
wire				pixel_on;				// high => output foreground color, low => output background color
reg [7:0] 		char_write_data;		// the data that will be written to character memory at the clock rise
integer			i;							// iterator

// always enable writing to character RAM
assign write_enable = 1;

// write the appropriate character data to memory
always @ (char_line or char_column) begin
	char_write_data <= 8'h20;
	if (char_line == 7'h0A) begin	
		for (i = 1; i < 12; i = i + 1) begin
			if (char_column == i)
				char_write_data <= counter_out[i*8+:8];
		end
	end
end


reg				background_red;		// the red component of the background color
reg				background_green;		// the green component of the background color
reg				background_blue;		// the blue component of the background color
reg				foreground_red;		// the red component of the foreground color
reg				foreground_green;		// the green component of the foreground color
reg				foreground_blue;		// the blue component of the foreground color

// use the result of the character generator module to choose between the foreground and background color
assign vga_red_data = (pixel_on) ? foreground_red : background_red;
assign vga_green_data = (pixel_on) ? foreground_green : background_green;
assign vga_blue_data = (pixel_on) ? foreground_blue : background_blue;

// select the appropriate character colors
always @ (char_line or char_column) begin
	// always use a black background with white text
	background_red <= 1'b0;
	background_green <= 1'b0;
	background_blue <= 1'b0;
	foreground_red <= 1'b1;
	foreground_green <= 1'b1;
	foreground_blue <= 1'b1;
end

// the character generator block includes the character RAM
// and the character generator ROM
CHAR_GEN CHAR_GEN
(
reset,				// reset signal
char_addr,			// write address
char_write_data,	// write data
write_enable,		// write enable
pixel_clock,		// write clock
char_addr,			// read address of current character
subchar_line,		// current line of pixels within current character
subchar_pixel,		// current column of pixels withing current character
pixel_clock,		// read clock
pixel_on				// read data
);

endmodule //CHAR_DISPLAY
