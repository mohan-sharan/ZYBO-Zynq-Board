module MAIN
(
SYSTEM_CLOCK,

SW,

LED,

VGA_HSYNCH,
VGA_VSYNCH,
/*
VGA_OUT_RED,
VGA_OUT_GREEN,
VGA_OUT_BLUE*/
R0,R1,R2,R3,
G0,G1,G2,G3,
B0,B1, B2,B3
);

input				SYSTEM_CLOCK;				// 100MHz LVTTL SYSTEM CLOCK

input [3:0]		SW;							// switches

output [3:0]	LED;							// User LEDs

output 			VGA_HSYNCH;					// horizontal sync for the VGA output connector
output			VGA_VSYNCH;					// vertical sync for the VGA output connector
/*
output		 	VGA_OUT_RED;				// RED DAC data
output		 	VGA_OUT_GREEN;				// GREEN DAC data
output		 	VGA_OUT_BLUE;				// BLUE DAC data
*/
output R0,R1,R2,R3,G0,G1,G2,G3,B0,B1,B2,B3;
wire				system_clock_buffered;	// buffered SYSTEM CLOCK
wire				pixel_clock;				// generated from SYSTEM CLOCK
wire				reset;						// reset asserted when DCMs are NOT LOCKED

wire				vga_red_data;				// red video data
wire				vga_green_data;			// green video data
wire				vga_blue_data;				// blue video data

// internal video timing signals
wire 				h_synch;						// horizontal synch for VGA connector
wire 				v_synch;						// vertical synch for VGA connector
wire 				blank;						// composite blanking
wire [10:0]		pixel_count;				// bit mapped pixel position within the line
wire [9:0]		line_count;					// bit mapped line number in a frame lines within the frame
wire [2:0]		subchar_pixel;				// pixel position within the character
wire [2:0]		subchar_line;				// identifies the line number within a character block
wire [6:0]		char_column;				// character number on the current line
wire [6:0]		char_line;					// line number on the screen

assign LED[0] = SW[0]; // Turn LED 0 on when switch 0 is on
assign LED[1] = SW[1]; // Turn LED 1 on when switch 1 is on
//assign LED[2] = SW[2]; // Turn LED 2 on when switch 2 is on
//assign LED[3] = SW[3]; // Turn LED 3 on when switch 3 is on
//assign LED[4] = SW[4]; // Turn LED 4 on when switch 4 is on
//assign LED[5] = SW[5]; // Turn LED 5 on when switch 5 is on
//assign LED[6] = SW[6]; // Turn LED 6 on when switch 6 is on
//assign LED[7] = SW[7]; // Turn LED 7 on when switch 7 is on


// instantiate the character generator
CHAR_DISPLAY CHAR_DISPLAY
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

CLOCK_GEN CLOCK_GEN
(
SYSTEM_CLOCK,
pixel_clock
);
// instantiate the clock generation module
/*
CLOCK_GEN CLOCK_GEN 
(
SYSTEM_CLOCK,
system_clock_buffered,
pixel_clock,
reset
);*/


// instantiate the video timing generator
SVGA_TIMING_GENERATION SVGA_TIMING_GENERATION
(
pixel_clock,
reset,
h_synch,
v_synch,
blank,
pixel_count,
line_count,
subchar_pixel,
subchar_line,
char_column,
char_line
);

// instantiate the video output mux
VIDEO_OUT VIDEO_OUT
(
pixel_clock,
reset,
vga_red_data,
vga_green_data,
vga_blue_data,
h_synch,
v_synch,
blank,

VGA_HSYNCH,
VGA_VSYNCH,
/*
VGA_OUT_RED,
VGA_OUT_GREEN,
VGA_OUT_BLUE
*/
R0,
R1,
R2,
R3,
G0,
G1,
G2,
G3,
B0,
B1,
B2,
B3
);

endmodule // MAIN