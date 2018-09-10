module VIDEO_OUT
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
R0,R1,R2,R3,
G0,G1,G2,G3,
B0,B1,B2,B3

);

input				pixel_clock;
input				reset;
input				vga_red_data;
input				vga_green_data;
input				vga_blue_data;
input				h_synch;
input				v_synch;
input				blank;

output			VGA_HSYNCH;
output			VGA_VSYNCH;
/*
output			VGA_OUT_RED;
output			VGA_OUT_GREEN;
output			VGA_OUT_BLUE;
*/
output R0,R1,R2, R3;
output G0,G1,G2,G3;
output B0,B1,B2,B3;

reg				VGA_HSYNCH;
reg				VGA_VSYNCH;


reg				VGA_OUT_RED=1'b1;
reg				VGA_OUT_GREEN=1'b0;
reg				VGA_OUT_BLUE=1'b0;


wire R0,R1,R2,R3,G0,G1,G2,G3, B0,B1,B2,B3;


assign R0=VGA_OUT_RED ;
assign R1=VGA_OUT_RED ;
assign R2= VGA_OUT_RED ;
assign R3 =VGA_OUT_RED;

assign G0= VGA_OUT_GREEN ;
assign  G1=VGA_OUT_GREEN ;
assign G2=VGA_OUT_GREEN ;
assign G3=VGA_OUT_GREEN;

assign B0=VGA_OUT_BLUE ;
assign B1=VGA_OUT_BLUE ;
assign B2=VGA_OUT_BLUE ;
assign B3=VGA_OUT_BLUE ;

// make the external video connections
always @ (posedge pixel_clock or posedge reset) begin
	if (reset) begin
		// shut down the video output during reset
		VGA_HSYNCH 				<= 1'b1;
		VGA_VSYNCH 				<= 1'b1;
		VGA_OUT_RED				<= 1'b0;
		VGA_OUT_GREEN			<= 1'b0;
		VGA_OUT_BLUE			<= 1'b0;
	end
	
	else if (blank) begin
		// output black during the blank signal
		VGA_HSYNCH	 			<= h_synch;
		VGA_VSYNCH 	 			<= v_synch;
		VGA_OUT_RED				<= 1'b0;
		VGA_OUT_GREEN			<= 1'b0;
		VGA_OUT_BLUE			<= 1'b0;
	end
	
	else begin
		// output color data otherwise
		VGA_HSYNCH	 			<= h_synch;
		VGA_VSYNCH 	 			<= v_synch;
		VGA_OUT_RED				<= vga_red_data;
		VGA_OUT_GREEN			<= vga_green_data;
		VGA_OUT_BLUE			<= vga_blue_data;
	end
end

endmodule // VIDEO_OUT