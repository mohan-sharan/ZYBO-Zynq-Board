`include "SVGA_DEFINES.v"

module SVGA_TIMING_GENERATION
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

input 			pixel_clock;			// pixel clock
input 			reset;					// reset
output 			h_synch;			// horizontal synch for VGA connector
output 			v_synch;			// vertical synch for VGA connector
output			blank;					// composite blanking
output [10:0]	pixel_count;			// counts the pixels in a line
output [9:0]	line_count;				// counts the display lines
output [2:0]	subchar_pixel;			// pixel position within the character
output [2:0]	subchar_line;			// identifies the line number within a character block
output [6:0]	char_column;			// character number on the current line
output [6:0]	char_line;				// line number on the screen

reg [9:0]		line_count;				// counts the display lines
reg [10:0]		pixel_count;			// counts the pixels in a line	
reg				h_synch;					// horizontal synch
reg				v_synch;					// vertical synch

reg				h_blank;					// horizontal blanking
reg				v_blank;					// vertical blanking
reg				blank;					// composite blanking

reg [2:0] 		subchar_line;			// identifies the line number within a character block
reg [9:0] 		char_column_count;	// a counter used to define the character column number
reg [9:0] 		char_line_count;		// a counter used to define the character line number
reg 				reset_char_line; 		// flag to reset the character line during VBI
reg				reset_char_column;	// flag to reset the character column during HBI
reg [2:0]		subchar_pixel;			// pixel position within the character
reg [6:0]		char_column;			// character number on the current line
reg [6:0]		char_line;				// line number on the screen

// CREATE THE HORIZONTAL LINE PIXEL COUNTER
always @ (posedge pixel_clock or posedge reset) begin
	if (reset)
		// on reset set pixel counter to 0
		pixel_count <= 11'd0;
	
	else if (pixel_count == (`H_TOTAL - 1))
		// last pixel in the line, so reset pixel counter
		pixel_count <= 11'd0;
	
	else
		pixel_count <= pixel_count + 1;
end

// CREATE THE HORIZONTAL SYNCH PULSE
always @ (posedge pixel_clock or posedge reset) begin
	if (reset)
		// on reset remove h_synch
		h_synch <= 1'b0;
	
	else if (pixel_count == (`H_ACTIVE + `H_FRONT_PORCH - 1))
		// start of h_synch
		h_synch <= 1'b1;
	
	else if (pixel_count == (`H_TOTAL - `H_BACK_PORCH - 1))
		// end of h_synch
		h_synch <= 1'b0;
end

// CREATE THE VERTICAL FRAME LINE COUNTER
always @ (posedge pixel_clock or posedge reset) begin
	if (reset)
		// on reset set line counter to 0
		line_count <= 10'd0;
	
	else if ((line_count == (`V_TOTAL - 1)) & (pixel_count == (`H_TOTAL - 1)))
		// last pixel in last line of frame, so reset line counter
		line_count <= 10'd0;
	
	else if ((pixel_count == (`H_TOTAL - 1)))
		// last pixel but not last line, so increment line counter
		line_count <= line_count + 1;
end

// CREATE THE VERTICAL SYNCH PULSE
always @ (posedge pixel_clock or posedge reset) begin
	if (reset)
		// on reset remove v_synch
		v_synch = 1'b0;

	else if ((line_count == (`V_ACTIVE + `V_FRONT_PORCH - 1) &
		   (pixel_count == `H_TOTAL - 1))) 
		// start of v_synch
		v_synch = 1'b1;
	
	else if ((line_count == (`V_TOTAL - `V_BACK_PORCH - 1)) &
		   (pixel_count == (`H_TOTAL - 1)))
		// end of v_synch
		v_synch = 1'b0;
end


// CREATE THE HORIZONTAL BLANKING SIGNAL
// the "-2" is used instead of "-1" because of the extra register delay
// for the composite blanking signal 
always @ (posedge pixel_clock or posedge reset) begin
	if (reset)
		// on reset remove the h_blank
		h_blank <= 1'b0;

	else if (pixel_count == (`H_ACTIVE -2)) 
		// start of HBI
		h_blank <= 1'b1;
	
	else if (pixel_count == (`H_TOTAL -2))
		// end of HBI
		h_blank <= 1'b0;
end


// CREATE THE VERTICAL BLANKING SIGNAL
// the "-2" is used instead of "-1"  in the horizontal factor because of the extra
// register delay for the composite blanking signal 
always @ (posedge pixel_clock or posedge reset) begin
	if (reset)
		// on reset remove v_blank
		v_blank <= 1'b0;

	else if ((line_count == (`V_ACTIVE - 1) &
		   (pixel_count == `H_TOTAL - 2))) 
		// start of VBI
		v_blank <= 1'b1;
	
	else if ((line_count == (`V_TOTAL - 1)) &
		   (pixel_count == (`H_TOTAL - 2)))
		// end of VBI
		v_blank <= 1'b0;
end


// CREATE THE COMPOSITE BANKING SIGNAL
always @ (posedge pixel_clock or posedge reset) begin
	if (reset)
		// on reset remove blank
		blank <= 1'b0;

	// blank during HBI or VBI
	else if (h_blank || v_blank)
		blank <= 1'b1;
		
	else
		// active video do not blank
		blank <= 1'b0;
end


/* 
   CREATE THE CHARACTER COUNTER.
   CHARACTERS ARE DEFINED WITHIN AN 8 x 8 PIXEL BLOCK.

	A 640  x 480 video mode will display 80  characters on 60 lines.
	A 800  x 600 video mode will display 100 characters on 75 lines.
	A 1024 x 768 video mode will display 128 characters on 96 lines.

	"subchar_line" identifies the row in the 8 x 8 block.
	"subchar_pixel" identifies the column in the 8 x 8 block.
*/

// CREATE THE VERTICAL FRAME LINE COUNTER
always @ (posedge pixel_clock or posedge reset) begin
	if (reset)
 		// on reset set line counter to 0
		subchar_line <= 3'b000;

	else if  ((line_count == (`V_TOTAL - 1)) & (pixel_count == (`H_TOTAL - 1) - `CHARACTER_DECODE_DELAY))
		// reset line counter
		subchar_line <= 3'b000;

	else if (pixel_count == (`H_TOTAL - 1) - `CHARACTER_DECODE_DELAY)
		// increment line counter
		subchar_line <= line_count + 1;
end

// subchar_pixel defines the pixel within the character line
always @ (posedge pixel_clock or posedge reset) begin
	if (reset)
		// reset to 5 so that the first character data can be latched
		subchar_pixel <= 3'b101;
	
	else if (pixel_count == ((`H_TOTAL - 1) - `CHARACTER_DECODE_DELAY))
		// reset to 5 so that the first character data can be latched
		subchar_pixel <= 3'b101;
	
	else
		subchar_pixel <= subchar_pixel + 1;
end


wire [9:0] char_column_count_iter = char_column_count + 1;

always @ (posedge pixel_clock or posedge reset) begin
	if (reset) begin
		char_column_count <= 10'd0;
		char_column <= 7'd0;
	end
	
	else if (reset_char_column) begin
		// reset the char column count during the HBI
		char_column_count <= 10'd0;
		char_column <= 7'd0;
	end
	
	else begin
		char_column_count <= char_column_count_iter;
		char_column <= char_column_count_iter[9:3];
	end
end

wire [9:0] char_line_count_iter = char_line_count + 1;

always @ (posedge pixel_clock or posedge reset) begin
	if (reset) begin
		char_line_count <= 10'd0;
		char_line <= 7'd0;
	end
	
	else if (reset_char_line) begin
		// reset the char line count during the VBI
		char_line_count <= 10'd0;
		char_line <= 7'd0;
	end
	
	else if (pixel_count == ((`H_TOTAL - 1) - `CHARACTER_DECODE_DELAY)) begin
		// last pixel but not last line, so increment line counter
		char_line_count <= char_line_count_iter;
		char_line <= char_line_count_iter[9:3];
	end
end

// CREATE THE CONTROL SIGNALS FOR THE CHARACTER ADDRESS COUNTERS
/* 
	The HOLD and RESET signals are advanced from the beginning and end
	of HBI and VBI to compensate for the internal character generation
	pipeline.
*/
always @ (posedge pixel_clock or posedge reset) begin
	if (reset)
		reset_char_column <= 1'b0;

	else if (pixel_count == ((`H_ACTIVE - 1) - `CHARACTER_DECODE_DELAY))
		// start of HBI
		reset_char_column <= 1'b1;
	
	else if (pixel_count == ((`H_TOTAL - 1) - `CHARACTER_DECODE_DELAY))
	 	// end of HBI					
		reset_char_column <= 1'b0;
end

always @ (posedge pixel_clock or posedge reset) begin
	if (reset)
		reset_char_line <= 1'b0;

	else if ((line_count == (`V_ACTIVE - 1)) &
		   (pixel_count == ((`H_ACTIVE - 1) - `CHARACTER_DECODE_DELAY)))
		// start of VBI
		reset_char_line <= 1'b1;
	
	else if ((line_count == (`V_TOTAL - 1)) &
		   (pixel_count == ((`H_TOTAL - 1) - `CHARACTER_DECODE_DELAY)))
		// end of VBI					
		reset_char_line <= 1'b0;
end
endmodule //SVGA_TIMING_GENERATION



