`include "SVGA_DEFINES.v"

module CLOCK_GEN 
(
SYSTEM_CLOCK,
pixel_clock

);

input SYSTEM_CLOCK;
output pixel_clock;

// Begin clock division
	parameter N = 2;	// parameter for clock division
	//reg clk_25Mhz;
	reg pixel_clock;
	reg [N-1:0] count;
	always @ (posedge SYSTEM_CLOCK) begin
		count <= count + 1'b1;
		pixel_clock <= count[N-1];
	end
	// End clock division


endmodule



/*




module CLOCK_GEN 
(
SYSTEM_CLOCK,

system_clock_buffered,
pixel_clock,
reset
);

input			SYSTEM_CLOCK;				// 100MHz LVTTL SYSTEM CLOCK

output 		system_clock_buffered;	// buffered SYSTEM_CLOCK
output		pixel_clock;				// adjusted SYSTEM_CLOCK
output		reset;						// reset asserted when DCMs are NOT LOCKED

wire			low  = 1'b0;
wire			high = 1'b1;

// signals associated with the system clock DCM
wire 			system_dcm_reset;
wire 			system_dcm_locked;
wire			system_clock_in;
wire			system_clock_unbuffered;
wire			pixel_clock_unbuffered;
wire 			system_clock_buffered;
wire			pixel_clock;

IBUFG SYSTEM_CLOCK_BUF (
.O  (system_clock_in),
.I  (SYSTEM_CLOCK)
);

// instantiate the clock input buffers for the internal clocks
BUFG SYS_CLOCK_BUF (
.O  (system_clock_buffered),
.I  (system_clock_unbuffered)
);

BUFG PIXEL_CLOCK_BUF (
.O  (pixel_clock),
.I  (pixel_clock_unbuffered)
);

assign reset = !system_dcm_locked;

DCM SYSTEM_DCM (
.CLKFB		(system_clock_buffered),
.CLKIN		(system_clock_in),
.DSSEN		(low),
.PSCLK		(low),
.PSEN			(low),
.PSINCDEC	(low),
.RST			(system_dcm_reset),
.CLK0			(system_clock_unbuffered),
.CLK90		(),
.CLK180		(),
.CLK270		(),
.CLK2X		(),
.CLK2X180	(),
.CLKDV		(),
.CLKFX		(pixel_clock_unbuffered),
.CLKFX180	(),
.LOCKED		(system_dcm_locked),
.PSDONE		(),
.STATUS		()
);
defparam SYSTEM_DCM.CLKDV_DIVIDE = 2.0; // divide the system clock (50 MHz) by 2.0 to determine CLKDV (25 MHz)
defparam SYSTEM_DCM.CLKFX_DIVIDE = `CLK_DIVIDE; // the denominator of the clock multiplier used to determine CLKFX
defparam SYSTEM_DCM.CLKFX_MULTIPLY = `CLK_MULTIPLY; // the numerator of the clock multiplier used to determine CLKFX
defparam SYSTEM_DCM.CLKIN_DIVIDE_BY_2 = "FALSE";
defparam SYSTEM_DCM.CLKIN_PERIOD = 20.0; // period of input clock in ns
defparam SYSTEM_DCM.CLKOUT_PHASE_SHIFT = "NONE"; // phase shift of NONE
defparam SYSTEM_DCM.CLK_FEEDBACK = "1X"; // feedback of NONE, 1X 
defparam SYSTEM_DCM.DFS_FREQUENCY_MODE = "LOW"; // LOW frequency mode for frequency synthesis
defparam SYSTEM_DCM.DLL_FREQUENCY_MODE = "LOW"; // LOW frequency mode for DLL
defparam SYSTEM_DCM.DUTY_CYCLE_CORRECTION = "TRUE"; // Duty cycle correction, TRUE
defparam SYSTEM_DCM.PHASE_SHIFT = 0; // Amount of fixed phase shift from -255 to 255
defparam SYSTEM_DCM.STARTUP_WAIT = "FALSE"; // Delay configuration DONE until DCM LOCK FALSE

SRL16 RESET_SYSTEM_DCM (
.Q		(system_dcm_reset),
.CLK	(system_clock_in),
.D 	(low),
.A0	(high),
.A1	(high),
.A2	(high),
.A3	(high)
);
defparam RESET_SYSTEM_DCM.INIT = "000F";

endmodule //CLOCK_GEN
*/