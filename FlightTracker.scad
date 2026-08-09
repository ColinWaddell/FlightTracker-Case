eps = 0.01; // mm
SIDE="B";

back_thickness = 6; // mm
wall_thickness = 3; // mm

screen_width  = 256;
screen_height = 128;
screen_depth  = 14;

back_space = 30; // mm
standoff_thickness = 10; // mm

split_angle = 45; // degrees

tab_radius = (screen_height / 4) / 2; // mm

tab_a_y = screen_height / 3; // mm
tab_b_y = -1 * tab_a_y; // mm

tab_cut_offset = tan(split_angle) * (tab_a_y); // mm 
tab_a_x = tab_cut_offset; // mm
tab_b_x = tab_cut_offset; // mm
tab_to_wall = -10; // mm
tab_to_cut = - tab_radius / 2; // mm

tab_pilot_od = 1.5; // mm
tab_hole_od = 2.5; // mm
tab_cs_od = 4; // mm-sorta

support_width = 3; // mm

/*

 |offset (opposite)
 |--------------x
 |             /
 |            /
 |           /
 |          /
 |         /
 |tab_a_y (adjacent)
 |       /
 |      / 
 |     /
 |    /
 |   /
 |angle = split_angle
 | /
 |/
 +-------------------------- 


 tan(split_angle) = opposite / tab_a_y
 opposite = tan(split_angle) * tab_a_y
*/

module male_tags(){
    x = SIDE == "A" ? (tab_a_x + tab_to_wall) - tab_to_cut : (-1 * (tab_b_x + tab_to_wall)) + tab_to_cut;
    y = SIDE == "A" ? tab_a_y + tab_to_wall : tab_b_y - tab_to_wall;
    translate([-x, -y, (back_thickness / 2) / 2])
        rotate([0, 0, split_angle])
            difference(){
                cylinder(d = tab_radius * 2, h = back_thickness / 2, center=true, $fn=6);
                cylinder(d = tab_hole_od, h = 100, center=true, $fn=30);
                translate([0, 0, -1])
                    cylinder(h=(back_thickness / 2), r1=tab_cs_od, r2=tab_hole_od / 4, center=true, $fn=30);

            }
}

module female_tags(){
    x = SIDE == "A" ? (tab_a_x + tab_to_wall) - tab_to_cut : (-1 * (tab_b_x + tab_to_wall)) + tab_to_cut;
    y = SIDE == "A" ? tab_a_y + tab_to_wall : tab_b_y - tab_to_wall;
    translate([x, y, (back_thickness / 2) / 2])
        rotate([0, 0, split_angle])
            union(){
                cylinder(d = tab_pilot_od, h = 100, center=true, $fn=30);
                cylinder(d = tab_radius * 2, h = back_thickness / 2, center=true, $fn=6);
            }
}


module chopping_block(){
    size = 1000;
    slide = SIDE == "A" ? size/2 : size/2 * -1;
    rotate([0, 0, 90 - split_angle])
        translate([0, slide, 0])
            cube([size, size, size], center=true);
}

/* Backplate */
module body() {
    union(){
        difference(){
            cube([
                screen_width + (wall_thickness * 2),
                screen_height + (wall_thickness * 2),
                screen_depth + back_space + back_thickness],
                center=true
            );
            translate([0, 0, ((back_thickness + eps) / 2)])
                cube([
                    screen_width,
                    screen_height,
                    screen_depth + back_space + eps],
                    center=true
                );
        }
        translate([0, 0, -(back_thickness + eps / 2)])
            difference(){
                cube([screen_width, screen_height, back_space], center=true);
                cube([screen_width - standoff_thickness, screen_height - standoff_thickness, back_space], center=true);
            }
    }
}

standoff_height = 3; // mm
standoff_od = 6; // mm
screw_hole_d = 3; // mm
pi_mount_inset = [5, 5];
pi_x = (screen_width / 2) - 59 - wall_thickness - standoff_od - pi_mount_inset[0];
pi_y = -1 * ((screen_height / 2) - standoff_od - pi_mount_inset[1]);

module raspberry_pi_mount_points(
    x = 0,
    y = 0,
    z = 0,
    height = standoff_height,
    outer_diameter = standoff_od,
    hole_diameter = screw_hole_d
) {
    for (y_offset = [0, 23, 49]) {
        for (x_offset = [0, 58]) {
            translate([
                x + x_offset,
                y + y_offset,
                z
            ])
                difference() {
                    cylinder(
                        h = height,
                        d = outer_diameter
                    );

                    translate([0, 0, -0.1])
                        cylinder(
                            h = height + 0.2,
                            d = hole_diameter
                        );
                }
        }
    }
}

module case(){
    union(){
        raspberry_pi_mount_points(
            x = wall_thickness + support_width + pi_x,
            y = pi_y,
            z = back_thickness
        );
        translate([0, 0, (screen_depth + back_thickness + back_space) / 2])
            body();
    }
}

difference(){
    union(){
        male_tags();
        difference(){
            case();
            chopping_block();
        }
    }
    female_tags();
}