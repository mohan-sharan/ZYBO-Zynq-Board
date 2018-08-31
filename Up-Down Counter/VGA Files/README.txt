CHAR_DISPLAY.v 
module defining the characters to be stored in character RAM and the character background and foreground colors

CHAR_GEN.v 
module containing the character RAM and ROM, which indicates whether the current pixel should be of foreground or background color based on video timing signals

CHAR_GEN_ROM.v 
module providing bitmapped definitions for the character set

CHAR_RAM.v 
module that stores the character codes for the entire screen

CLOCK_GEN.v 
clock divider module

MAIN.v 
primary module

SVGA_DEFINES.v 
definition of the resolution and display rate parameters

SVGA_TIMING_GENERATION.v 
SVGA timing signal generator module

VIDEO_OUT.v 
video output mux module

vga_constraints.xdc
constraints file
