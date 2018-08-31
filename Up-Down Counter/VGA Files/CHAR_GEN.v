module CHAR_GEN(
// control
reset,
// write side
char_write_addr,
char_write_data,
char_write_enable,
char_write_clock,
// read side
char_address,
subchar_line,
subchar_pixel,
pixel_clock,
pixel_on
);

input				pixel_clock;
input				reset;
input [2:0]  	subchar_line;			// line number within 8 line block
input [13:0] 	char_address;			// character address "0" is upper left character
input [2:0]  	subchar_pixel;			// pixel position within 8 pixel block
input [13:0]   char_write_addr;
input [7:0] 	char_write_data;
input				char_write_enable;
input 			char_write_clock;
output			pixel_on;

reg 				latch_data;
reg 				latch_low_data;
reg 				shift_high;
reg 				shift_low;
reg [3:0] 		latched_low_char_data;
reg [7:0] 		latched_char_data;
reg 				pixel_on;

wire [7:0] 		ascii_code;
wire [10:0] 	chargen_rom_address = {ascii_code[7:0], subchar_line[2:0]};
wire [7:0] 		char_gen_rom_data;
 
// instantiate the CHARACTER RAM
CHAR_RAM CHAR_RAM
(
char_write_clock,
char_write_enable,
char_write_addr,
char_write_data,

pixel_clock,
char_address,
ascii_code
);

// instantiate the character generator ROM
CHAR_GEN_ROM CHAR_GEN_ROM
(
pixel_clock,
chargen_rom_address,
char_gen_rom_data
);

// LATCH THE CHARTACTER DATA FROM THE CHAR GEN ROM AND CREATE A SERIAL CHAR DATA STREAM
always @ (posedge pixel_clock or posedge reset)begin
			if (reset) begin
				latch_data <= 1'b0;
				end
			else if (subchar_pixel == 3'b110) begin
				latch_data <= 1'b1;
				end
			else if (subchar_pixel == 3'b111) begin
				latch_data <= 1'b0;
				end
			end

always @ (posedge pixel_clock or posedge reset)begin
			if (reset) begin
				latch_low_data <= 1'b0;
				end
			else if (subchar_pixel == 3'b010) begin
				latch_low_data <= 1'b1;
				end
			else if (subchar_pixel == 3'b011) begin
				latch_low_data <= 1'b0;
				end
			end

always @ (posedge pixel_clock or posedge reset)begin
			if (reset) begin
				shift_high <= 1'b1;
				end
			else if (subchar_pixel == 3'b011) begin
				shift_high <= 1'b0;
				end
			else if (subchar_pixel == 3'b111) begin
				shift_high <= 1'b1;
				end
			end

always @ (posedge pixel_clock or posedge reset)begin
			if (reset) begin
				shift_low <= 1'b0;
				end
			else if (subchar_pixel == 3'b011) begin
				shift_low <= 1'b1;
				end
			else if (subchar_pixel == 3'b111) begin
				shift_low <= 1'b0;
				end
			end

// serialize the CHARACTER MODE data
always @ (posedge pixel_clock or posedge reset) begin
	if (reset)
 		begin
			pixel_on = 1'b0;
			latched_low_char_data = 4'h0;
			latched_char_data  = 8'h00;
		end

	else if (shift_high)
		begin
			pixel_on = latched_char_data [7];
			latched_char_data [7] = latched_char_data [6];
			latched_char_data [6] = latched_char_data [5];
			latched_char_data [5] = latched_char_data [4];
			latched_char_data [4] = latched_char_data [7];
				if(latch_low_data) begin
					latched_low_char_data [3:0] = latched_char_data [3:0];
					end
				else begin
					latched_low_char_data [3:0] = latched_low_char_data [3:0];
					end
			end

	else if (shift_low)
		begin
			pixel_on = latched_low_char_data [3];
			latched_low_char_data [3] = latched_low_char_data [2];
			latched_low_char_data [2] = latched_low_char_data [1];
			latched_low_char_data [1] = latched_low_char_data [0];
			latched_low_char_data [0] = latched_low_char_data [3];
				if (latch_data) begin
					latched_char_data [7:0] = char_gen_rom_data[7:0];
					end
				else begin
					latched_char_data [7:0] = latched_char_data [7:0];
					end
				end
	 else 
	 	begin
		latched_low_char_data [3:0] = latched_low_char_data [3:0];
		latched_char_data [7:0] = latched_char_data [7:0];
		pixel_on = pixel_on;
		end
	end

endmodule //CHAR_GEN



