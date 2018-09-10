module CHAR_RAM
(
clka,
wea,
addra,
dia,

clkb,
addrb,
dob
);

input  clka;
input  wea;
input  [13:0] addra;
input  [7:0] dia;

input  clkb;
input  [13:0] addrb;
output [7:0] dob;

//reg    [7:0] ram [1023:0];
reg    [7:0] ram [0:1023];
reg    [13:0] read_addrb;

always @(posedge clka) begin
	if (wea)
		ram[addra] <= dia;
end

always @(posedge clkb) begin
	read_addrb <= addrb;
end

assign dob = ram[read_addrb];

// fill the character RAM with spaces
integer index;
initial begin
	for (index = 0; index < 1024; index = index + 1) begin
		ram[index] = 8'h20; // ASCII space
	end                     
end

endmodule //CHAR_RAM