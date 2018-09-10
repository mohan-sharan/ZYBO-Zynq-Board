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
FIBOUT
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
input [11:0]    FIBOUT;

reg [0:8*12-1] FIB_OUT = " ";

reg clkdiv;
reg [26:0] count;

//Clock Division
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
//Clock Division - End

always @ (posedge clkdiv)
begin
	case(FIBOUT) 
	   12'b000000000000: FIB_OUT <= "FIB:0";
	   12'b000000000001: FIB_OUT <= "FIB:1";
	   12'b000000000001: FIB_OUT <= "FIB:1";
	   12'b000000000010: FIB_OUT <= "FIB:2";
	   12'b000000000011: FIB_OUT <= "FIB:3";
	   12'b000000000101: FIB_OUT <= "FIB:5";
	   12'b000000001000: FIB_OUT <= "FIB:8";
	   12'b000000001101: FIB_OUT <= "FIB:13";
	   12'b000000010101: FIB_OUT <= "FIB:21";
	   12'b000000100010: FIB_OUT <= "FIB:34";
	   12'b000000110111: FIB_OUT <= "FIB:55";
	   12'b000001011001: FIB_OUT <= "FIB:89";
	   12'b000010010000: FIB_OUT <= "FIB:144";
	   12'b000011101001: FIB_OUT <= "FIB:233";
	   12'b000101111001: FIB_OUT <= "FIB:377";
	            default: FIB_OUT <= "DONE";
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
	if (char_line == 7'h02) begin	
		for (i = 0; i < 12; i = i + 1) begin
			if (char_column == i)
				char_write_data <= FIB_OUT[i*8+:8];
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
	background_red <= 1'b0;
	background_green <= 1'b0;
	background_blue <= 1'b1;
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