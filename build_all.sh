#!/bin/bash
openscad -D 'SIDE="A"' -o FlightTracker_PartA.stl FlightTracker.scad
openscad -D 'SIDE="B"' -o FlightTracker_PartB.stl FlightTracker.scad