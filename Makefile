# Makefile for rendering OpenSCAD files to STL

# OpenSCAD executable
OPENSCAD = openscad

# Source files
SCAD_FILES = 2020-bracket-to_board.scad \
             2020-bracket-to_board-offset.scad \
             2020-bracket-to_board-offset_u.scad

# Output STL files (M3 and M4 variants)
STL_M3_FILES = $(SCAD_FILES:.scad=-m3.stl)
STL_M4_FILES = $(SCAD_FILES:.scad=-m4.stl)
STL_FILES = $(STL_M3_FILES) $(STL_M4_FILES)

# Default target
all: $(STL_FILES)

# Rule to convert .scad to -m3.stl
%-m3.stl: %.scad
	$(OPENSCAD) -o $@ -D bolt_size=3 $<

# Rule to convert .scad to -m4.stl
%-m4.stl: %.scad
	$(OPENSCAD) -o $@ -D bolt_size=4 $<

# Clean target to remove generated files
clean:
	rm -f $(STL_FILES)

# Phony targets
.PHONY: all clean
