SCAD_FILE := FlightTracker.scad
PARTS     := A B
STLS      := $(foreach side,$(PARTS),FlightTracker_Part$(side).stl)

.PHONY: all clean

all: $(STLS)

FlightTracker_Part%.stl: $(SCAD_FILE)
	openscad -D 'SIDE="$*"' -o $@ $<

clean:
	rm -f $(STLS)