# FlightTracker Case

A sleek, minimal enclosure for the [Original Flight Tracker](https://colinwaddell.github.io/FlightTracker/) project.

Designed for a **64×32 HUB75 RGB LED matrix with 4 mm pitch**, with mounting options for virtually any Raspberry Pi model.

The case is designed to keep the finished Flight Tracker compact and tidy, with:

- A dedicated power cable opening
- Built-in tabs to hold the RGB matrix securely in place
- Raspberry Pi mounting points
- Support for full-size Raspberry Pi boards and smaller boards such as the Pi Zero W
- Minimal support material required when printing
- A two-piece interlocking design so the enclosure can be printed on a normal-sized print bed

## Printables

The ready-to-print model is available on Printables:

https://www.printables.com/model/1820229-flight-tracker-screen-for-raspberry-pi-any-model-6

## Flight Tracker

This enclosure is the official case for the Original Flight Tracker project:

https://colinwaddell.github.io/FlightTracker/

## Hardware Required

You'll need:

- **2 × 2.5 × 8 mm screws** to secure the two halves of the case together
- **4 × 2.5 × 5 mm screws** to mount the Raspberry Pi to the case
- **64×32 HUB75 RGB LED matrix**, 4 mm pitch
- Raspberry Pi
- RGB Matrix Bonnet / compatible HUB75 interface

## Print Settings

- **Supports:** Baseplate only
- **Infill:** 5% is fine
- No other supports should be required

## Assembly

### 1. Prepare the Raspberry Pi mounts

Before assembling the case, check which Raspberry Pi you're using.

If you're using a normal full-sized Raspberry Pi, cut off the **centre support mounts**. These are only required when using one of the smaller boards such as a **Pi Zero W**.

### 2. Join the two halves

Fit the two halves of the case together by popping the hexagonal tabs into their respective slots on the back.

Pay careful attention to the splits in the top and bottom walls. These are designed to slot underneath each other so that the two halves lock together correctly.

This part can be a little tricky because the fit is deliberately tight. Take your time with it — the tight fit helps make sure the finished case stays snug, square and rigid.

### 3. Pre-fit the securing screws

Before fitting the screen, drive the two securing screws through the back panel once.

Be careful to make sure each screw taps cleanly through both the tab and its mating hole. You don't want the screw pushing the two halves apart as it goes in, as this could damage the tabs or split the case.

Once both screws have been driven through successfully, remove them again.

Doing this now cuts the threads while you still have some flexibility in the box. If you wait until the screen is fitted, you may find it much harder to get the securing screws started without putting unnecessary stress on everything.

### 4. Mount the Raspberry Pi

Mount the Raspberry Pi using the four **2.5 × 5 mm screws**.

Fit the RGB Matrix Bonnet to the Pi and make sure it is sitting correctly before installing everything into the case.

Take care that the Bonnet isn't touching the Pi, the case, or anything else where it shouldn't. Check that nothing conductive is sitting somewhere it could cause a short circuit.

### 5. Fit the screen

Hook up the RGB matrix screen to the Pi and Bonnet.

Insert the screen into the front of the case and carefully work it in behind the retaining tabs. These are designed to hold the screen securely without needing any additional fixings.

If your ribbon cable is long enough, rotate the screen so the cable can sit fully extended rather than bunched up or squashed. This helps reduce noise on the signal lines, which can otherwise cause the display to flicker.

Once the screen is sitting correctly and everything is lined up, put the two securing screws back through the rear of the case and tighten them up.

They only need to be tight enough to pull everything together firmly.

You're done.

## Source

The full OpenSCAD source for the case is contained in this repository.

Contributions, improvements and remixes for non-commercial use are welcome.

## License

This project is licensed under the **Creative Commons Attribution-NonCommercial 4.0 International License (CC BY-NC 4.0)**.

You may use, modify and redistribute the design for non-commercial purposes, with attribution.

**Commercial use, including selling printed versions of this design, is not permitted.**

See the [`LICENSE`](LICENSE) file for the full licence text.
