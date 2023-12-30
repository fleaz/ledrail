// ###
// Variablews
// ###

// main variables / parameters
sign_length = 200;
sign_depth = 4;

// other variables
sign_length_offset = 0.5;
strip_height = 5;
strip_width = 12;
sign_rail_socket_width = sign_depth;
sign_rail_socket_height = 15;
wall_thickness = 2;
rail_length = sign_length + sign_length_offset;
rail_width = 35;
rail_wall_height = 20;
rail_height = sign_rail_socket_height + rail_wall_height;
side_wall_thickness = (rail_width-strip_width)/2;
esp_height = 7;
esp_length = 35;
esp_width = 26;
esp_access_z = 1;
esp_access_x = 2;
epsilon = 0.01;
cable_duct_width = 8;
cable_duct_height = 6;
usb_port_width = 14;
usb_port_height = esp_height + 0.5;

// ###
// Modules
// ###

module prism(l, w, h) {
    polyhedron(
        points=[[0,0,0], [l,0,0], [l,w,0], [0,w,0], [0,w,h], [l,w,h]],
        faces=[[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]]
    );
};

// integrated side wall
module side_wall() {
    difference() {
        union() {
            cube([wall_thickness, rail_width, rail_wall_height]);
            translate([0, rail_width/2-sign_depth/2, rail_wall_height])
                cube([wall_thickness, sign_depth, sign_rail_socket_height]);
            translate([0, 0, rail_wall_height])
                prism(wall_thickness, rail_width/2-sign_rail_socket_width/2, sign_rail_socket_height);
            translate([0, rail_width/2+sign_depth/2, rail_height])
                rotate([270, 0, 0])
                    prism(wall_thickness, sign_rail_socket_height, rail_width/2-sign_rail_socket_width/2);
        }
    }
}

module esp_tray() {
    difference() {
        cube([esp_length+2, esp_width+2, esp_height+2]);
        translate([1, 1, 1]) {
            cube([esp_length, esp_width, esp_height]);
        }
        // usb port opening
        translate([-epsilon, 1 + (esp_width - usb_port_width) / 2, 1 - 0.5]) {
            cube([1+2*epsilon, usb_port_width, usb_port_height]);
        }
        // lower / z-axis access
        translate([-epsilon, 1 + (esp_width - usb_port_width) / 2, 1 - 0.5]) {
            cube([1+2*epsilon, usb_port_width, usb_port_height]);
        }
    }
    esp_guidance_one_height = esp_height-4.7;
    // esp position guidance
    translate([1, 3+1, 1 + esp_height - esp_guidance_one_height])
        rotate([0, -90, 180])
            prism(esp_guidance_one_height, 3, 5);
    esp_guidance_two_width = 3;
    esp_guidance_two_height = esp_height-3.25;
    translate([5, 1 + 3 + esp_width - esp_guidance_two_width, 1 + esp_height - esp_guidance_two_height])
        rotate([0, -90, 90])
            prism(esp_guidance_two_height, (-1) + 5, esp_guidance_two_width);
    esp_guidance_back_height = esp_height-1.3;
    esp_guidance_back_side = 2;
    translate([1 + esp_length - esp_guidance_back_side, 1, 1 + esp_height - esp_guidance_back_height])
        cube([esp_guidance_back_side, esp_guidance_back_side, esp_guidance_back_height]);
    translate([1 + esp_length - esp_guidance_back_side, 1 + esp_width - esp_guidance_back_side, 1 + esp_height - esp_guidance_back_height])
        cube([esp_guidance_back_side, esp_guidance_back_side, esp_guidance_back_height]);
}

!esp_tray()

// ###
// Model 
// ###

difference() {
    // body
    union() {
        translate([0, side_wall_thickness, 0])
            cube([rail_length, strip_width, rail_wall_height-strip_height]);
        translate([0, 0, 0])
            cube([rail_length, side_wall_thickness, rail_wall_height]);
        translate([0, strip_width+side_wall_thickness, 0])
            cube([rail_length, side_wall_thickness, rail_wall_height]);
    }

    translate([-epsilon, rail_width/2-esp_width/2, (rail_wall_height-strip_height)/2-esp_height/2]) {
        esp_tray();
    }
    // cable duct
    translate([-epsilon, rail_width/2-cable_duct_width/2, 5+epsilon])
        cube([4+epsilon, cable_duct_width, 10]);
}

// prism led rail
translate([0, 0, rail_wall_height])
    prism(rail_length, rail_width/2-sign_rail_socket_width/2, sign_rail_socket_height);
translate([0, rail_width/2+sign_depth/2, rail_height])
    rotate([270, 0, 0])
        prism(rail_length, sign_rail_socket_height, rail_width/2-sign_rail_socket_width/2);

// prism support
translate([0, side_wall_thickness+strip_width/2-sign_depth/2, rail_wall_height])
    rotate([180, 0, 0])
        prism(rail_length, strip_width/2-sign_depth/2, strip_height);
translate([0, side_wall_thickness+strip_width, rail_wall_height-strip_height])
    rotate([90, 0, 0])
        prism(rail_length, strip_height, strip_width/2-sign_depth/2);

translate([rail_length, 0, 0]) {
    side_wall();
}
translate([-wall_thickness, 0, 0]) {
    side_wall();
}