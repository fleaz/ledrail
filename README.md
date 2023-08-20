# LEDrail

A parameterized 3D printed rail for controllable LED stripes and acrylglass. This repo provides files, description and learnings on the 3d printing of the rail and laser engrave process.

![A set of example signs](images/rails_example.jpg)

## Specs

- 18 SK6812 LEDs
- 970mA max draw (570mA if on USB power)
- 5V input
- Power connectors
  - USB C
  - 5V / GND in a bottom compartment
- wled with all it*s features

## Reproduction

### Ingredients

- PMMA Acrylglass
- ESP8266 D1 Mini
- Around 150 gramm of filament
- WLED
- 300mm (customizable) LED strip, best with 60 LEDs per meter
- Two screws
- Glue
- Red and Black Wire
  
### Print the components

The 3D model source is written in OpenSCAD in [ledrail.scad](ledrail.scad). It is exported into three STL files:

- [ledrail.stl](ledrail.stl)
- [ledrail_side_plate.stl](ledrail_side_plate.stl)
- [ledrail_side_plate_closed.stl](ledrail_side_plate_closed.stl)

The first one is the main component which will hold everything together. There are two side plates: one has screw holes for easy removal in case of maintenance and a hole for the USB C port. The other side is closed and may be glued.

It may be necessary to split the model in half if the printer is not big enough (a bit more than 30x30x300 mm). In any case support can be reduced by printing it vertically with the esp compartment facing upwards.

### Engrave the PMMA acrylglass

Some general learnings:

- Use a cutable (non-melting) protective foil, big enough to protect the working area, so hot material removed by the laser does not damage surrounding material
- Mirror whatever you want to engrave and engrave it onto the back of the material
- Use a gradient for the applied depth of the engraving as the intensity of the effect declines otherwise the further away you are from the LED input

I was fortunate and found 20mm x 30mm PMMA Plexiglas for 4€ per piece on ebay.

### ESP wiring

The VCC (red) and GND (black) line enter the rail through the bottom compartment and connect the esp and the LED strip in parallel. This way either the esp provides power through its usb connector or the esp is bypassed by a stronger power source.

The ESP can provide 500mA to the strip max. In addition the chip itself draws up to 70mA.

A data wire (white) is connected to GPIO4 and the strip input.

### Configure wled

[Install wled via serial over USB-C](https://install.wled.me/). You can then configure wifi access either via the serial connection over USB-C or the hotspot the esp should open up. 

In the configuration screen make sure to set the following:

- Max draw to 500mA
- LED strip to SK6812
- Number of LEDs to 18

### A note on the OpenSCAD code

The code is pretty bad, really repetitive but does it's job. It's a simple model and there is a lot of refactoring in order. Feel free to send a merge request or meet up to discuss techniques over a cup of coffee.

You'll find two main variables at the top of the file to control the size of the acrylglas the rail is printed for.

The side-plate is "hidden" (via the "*" operator). To output stl files for the side plate(s) use the "!" operator instead.

# More pictures

![A set of rails, freshly printed and unglued](images/rails_unglued.png)

![A set of esp8266 ready to be prepared for operation in the rail](images/esps.png)

[picture of soldering process missing]

[picture of bottom and 5V connection missing]
