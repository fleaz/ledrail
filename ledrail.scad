// main variables / parameters
sign_length = 300;
sign_depth = 4;

// other variables
strip_height = 5;
strip_width = 12;
sign_rail_socket_length = sign_length;
sign_rail_socket_width = sign_depth;
sign_rail_socket_height = 15;
wall_thickness = 2;
rail_length = sign_length;
rail_width = 35;
rail_wall_height = 20;
rail_height = sign_rail_socket_height + rail_wall_height;
side_wall_thickness = (rail_width-strip_width)/2;
esp_height = 7;
esp_length = 35;
esp_width = 26;
epsilon = 0.01;
screw_diameter = 4;
wago_height = 10;
wago_width = 12;
wago_length = 18;
wago_compartment_height = wago_height + 1;
wago_compartment_width = (wago_width + 2 ) * 2;
wago_compartment_length = wago_length + 4;
cable_duct_width = 4;
cable_duct_height = 6;
usb_port_width = 14;
usb_port_height = esp_height;
side_plate_screw_depth = 8;

module prism(l, w, h) {
    polyhedron(
        points=[[0,0,0], [l,0,0], [l,w,0], [0,w,0], [0,w,h], [l,w,h]],
        faces=[[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]]
    );
};

difference() {
    // body
    union() {
        translate([0, side_wall_thickness, 0])
            cube([sign_length, strip_width, rail_wall_height-strip_height]);
        translate([0, 0, 0])
            cube([sign_length, side_wall_thickness, rail_wall_height]);
        translate([0, strip_width+side_wall_thickness, 0])
            cube([sign_length, side_wall_thickness, rail_wall_height]);
    }

    // esp tray
    translate([-epsilon, rail_width/2-esp_width/2, (rail_wall_height-strip_height)/2-esp_height/2])
        cube([esp_length+epsilon, esp_width, esp_height]);

    // cable duct
    translate([-epsilon, rail_width/2-cable_duct_width/2, 5+epsilon])
        cube([cable_duct_width+epsilon, cable_duct_width, 10]);

    // wago compartment
    translate([esp_length + 4, rail_width/2-wago_compartment_length/2, -epsilon])
        cube([wago_compartment_width, wago_compartment_length, wago_compartment_height + epsilon]);
    // wago compartment cable duct
    translate([esp_length + (wago_compartment_width/2) + 2.5, -epsilon, -epsilon])
        cube([5, (rail_width-wago_compartment_length)/2 + 2 *epsilon, 5]);

    // power cable duct
    translate([esp_length - epsilon, rail_width/2-cable_duct_width/2, (rail_wall_height-strip_height)/2-esp_height/2])
        cube([4+2*epsilon, cable_duct_width, cable_duct_width]);

    // screw holes side plate
    translate([-epsilon, screw_diameter*1.25, rail_wall_height*3/4])
        rotate([-90, 0, -90])
            cylinder(side_plate_screw_depth+epsilon, d=screw_diameter);
    translate([-epsilon, rail_width-screw_diameter*1.25, rail_wall_height*3/4])
        rotate([-90, 0, -90])
            cylinder(side_plate_screw_depth+epsilon, d=screw_diameter);
    translate([rail_length+epsilon, screw_diameter*1.25, rail_wall_height*3/4])
        rotate([-90, 0, 90])
            cylinder(side_plate_screw_depth+epsilon, d=screw_diameter);
    translate([rail_length+epsilon, rail_width-screw_diameter*1.25, rail_wall_height*3/4])
        rotate([-90, 0, 90])
            cylinder(side_plate_screw_depth+epsilon, d=screw_diameter);

    // screw holes core
    translate([rail_length*1/4, -epsilon, rail_wall_height/2])
        rotate([-90, 0, 0])
            cylinder(rail_width+epsilon*2, d=screw_diameter);
    translate([rail_length*3/4, -epsilon, rail_wall_height/2])
        rotate([-90, 0, 0])
            cylinder(rail_width+epsilon*2, d=screw_diameter);
}

// esp position guidance
translate([0, (rail_width-esp_width)/2+3,  (rail_wall_height-strip_height)/2-esp_height/2+esp_height-(esp_height-4.7)])
    rotate([0, -90, 180])
        prism(esp_height-4.7, 3, 5);

// esp position guidance
translate([5, rail_width-(rail_width-esp_width)/2,  (rail_wall_height-strip_height)/2-esp_height/2+esp_height-(esp_height-3.25)])
    rotate([0, -90, 90])
        prism(esp_height-3.25, 5, 3);

translate([esp_length-2, (rail_width-esp_width)/2,  (rail_wall_height-strip_height)/2-esp_height/2+esp_height-(esp_height-1.3)])
    cube([2, 2, esp_height-1.3]);

translate([esp_length-2, rail_width-((rail_width-esp_width)/2+2),  (rail_wall_height-strip_height)/2-esp_height/2+esp_height-(esp_height-1.3)])
    cube([2, 2, esp_height-1.3]);

// prism led rail
translate([0, 0, rail_wall_height])
    prism(sign_length, rail_width/2-sign_rail_socket_width/2, sign_rail_socket_height);
translate([0, rail_width/2+sign_depth/2, rail_height])
    rotate([270, 0, 0])
        prism(sign_length, sign_rail_socket_height, rail_width/2-sign_rail_socket_width/2);

// prism support
translate([0, side_wall_thickness+strip_width/2-sign_depth/2, rail_wall_height])
    rotate([180, 0, 0])
        prism(sign_length, strip_width/2-sign_depth/2, strip_height);
translate([0, side_wall_thickness+strip_width, rail_wall_height-strip_height])
    rotate([90, 0, 0])
        prism(sign_length, strip_height, strip_width/2-sign_depth/2);

// side plate
*translate([-2, 0, 0]) {
    difference() {
        union() {
            cube([2, rail_width, rail_wall_height]);
            translate([0, rail_width/2-sign_depth/2, rail_wall_height])
                cube([2, sign_depth, sign_rail_socket_height]);
            translate([0, 0, rail_wall_height])
                prism(2, rail_width/2-sign_rail_socket_width/2, sign_rail_socket_height);
            translate([0, rail_width/2+sign_depth/2, rail_height])
                rotate([270, 0, 0])
                    prism(2, sign_rail_socket_height, rail_width/2-sign_rail_socket_width/2);
        }

        // usb port opening
        translate([-epsilon, rail_width/2-usb_port_width/2, (rail_wall_height-strip_height)/2-esp_height/2-0.5])
            cube([2+2*epsilon, usb_port_width, usb_port_height+0.5]);
        
        // screw holes
        translate([-epsilon, screw_diameter*1.25, rail_wall_height*3/4])
            rotate([-90, 0, -90])
                cylinder(side_plate_screw_depth+epsilon, d=screw_diameter);
        translate([-epsilon, rail_width-screw_diameter*1.25, rail_wall_height*3/4])
            rotate([-90, 0, -90])
                cylinder(side_plate_screw_depth+epsilon, d=screw_diameter);
        translate([rail_length+epsilon, screw_diameter*1.25, rail_wall_height*3/4])
            rotate([-90, 0, 90])
                cylinder(side_plate_screw_depth+epsilon, d=screw_diameter);
        translate([rail_length+epsilon, rail_width-screw_diameter*1.25, rail_wall_height*3/4])
            rotate([-90, 0, 90])
                cylinder(side_plate_screw_depth+epsilon, d=screw_diameter);
    }
}
