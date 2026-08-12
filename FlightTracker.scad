$fn = 48;

/*
 * FlightTracker Case
 * ==================
 */

SIDE = "A";          // "A" = upper-right half, "B" = lower-left half

eps = 0.01;          // small offset to avoid coplanar faces


/* ============================================================
 *  Dimensions
 * ============================================================ */

/* Screen + tolerance */
screen_width  = 256 + 0.2;
screen_height = 128 + 0.2;
screen_depth  = 14 + 0.2;

/* Case walls */
back_thickness  = 6;     // rear wall (also the dovetail/tab wall)
wall_thickness  = 2;     // side walls
support_width   = 2;     // screen support ledge width

/* Pi chamber */
back_space         = 35;   // depth of the rear Pi cavity
standoff_thickness = 10;   // frame thickness around the Pi cavity

/* Diagonal split angle (degrees from horizontal) */
split_angle = 45;

/* Raspberry Pi mounting standoffs */
standoff_height = 3;
standoff_od     = 6;
screw_hole_d    = 2.5;
pi_mount_inset  = [1, 15];

/*
 * Pi mount position.
 *
 * The Pi mounting holes are laid out in a 58 x 49 mm grid.
 * We position the lower-left hole so the Pi sits inset from
 * the right edge of the screen cavity.
 */
pi_x = (screen_width / 2) - 59 - wall_thickness - standoff_od - pi_mount_inset[0];
pi_y = -1 * ((screen_height / 2) - standoff_od - pi_mount_inset[1]);


/* Power supply cable hole through the back wall.
 *
 * Positioned relative to the Pi mount point so it
 * tracks the Pi location as pi_x / pi_y change.
 */
power_hole_radius = 6;     // hole radius
power_hole_offset_y = 14.75;  // offset from Pi mount Y (along the wall)
power_hole_offset_z = 22.5;   // offset from back wall (height on the wall)


/* Screen fixing clips — rounded corner tabs that hold
 * the screen in place at the front opening.
 */
screen_corner_radius = 3;   // radius of the rounded corner
screen_clip_height   = 0.5; // how tall the clip is (Z)


/* ============================================================
 *  Screw-lock tabs
 * ============================================================
 *
 *  Each half carries a tab that straddles the diagonal cut.
 *  The opposite half has a matching clearance hole. A screw
 *  driven from the back exterior passes through the
 *  clearance hole and self-taps into the tab, locking the
 *  two halves together.
 *
 *  Tab A sits on the upper half (SIDE A), tab B on the
 *  lower half (SIDE B).
 */

tab_radius    = (screen_height / 4) / 2;  // tab hex radius
tab_a_y       = screen_height / 3;        // tab A offset along Y
tab_b_y       = -tab_a_y;                 // tab B offset along Y (mirrored)

tab_cut_offset = tan(split_angle) * tab_a_y;  // X offset from centre
tab_a_x        = tab_cut_offset;
tab_b_x        = tab_cut_offset;

tab_to_wall   = -10;              // tab offset toward the wall
tab_to_cut    = -tab_radius / 2;  // tab offset toward the cut line

tab_pilot_od  = 2.0;   // pilot hole (self-tap side)
tab_hole_od   = 2.5;   // clearance hole (screw side)
tab_cs_od     = 4;     // countersink diameter

tab_tol = 0.2; // allowance for print tolerance


/* ============================================================
 *  Modules
 * ============================================================ */

/*
 * Male tab — the hexagonal boss with a clearance hole that
 * the screw passes through. Rendered on the half that
 * carries the tab.
 */
module male_tab()
{
    x = SIDE == "A"
        ? (tab_a_x + tab_to_wall) - tab_to_cut
        : (-1 * (tab_b_x + tab_to_wall)) + tab_to_cut;
    y = SIDE == "A"
        ? tab_a_y + tab_to_wall
        : tab_b_y - tab_to_wall;

    translate([-x, -y, back_thickness / 4])
        rotate([0, 0, split_angle])
            difference() {
                cylinder(d = (tab_radius * 2) - tab_tol, h = back_thickness / 2,
                         center = true, $fn = 6);
                cylinder(d = tab_hole_od, h = 100,
                         center = true, $fn = 30);
                translate([0, 0, -1])
                    cylinder(h = back_thickness / 2,
                             r1 = tab_cs_od, r2 = tab_hole_od / 4,
                             center = true, $fn = 30);
            }
}


/*
 * Female tab — the hexagonal recess plus pilot hole cut
 * into the opposite half to receive the male tab.
 */
module female_tab()
{
    x = SIDE == "A"
        ? (tab_a_x + tab_to_wall) - tab_to_cut
        : (-1 * (tab_b_x + tab_to_wall)) + tab_to_cut;
    y = SIDE == "A"
        ? tab_a_y + tab_to_wall
        : tab_b_y - tab_to_wall;

    translate([x, y, back_thickness / 4])
        rotate([0, 0, split_angle])
            union() {
                cylinder(d = tab_pilot_od, h = 100,
                         center = true, $fn = 30);
                cylinder(d = (tab_radius * 2) + tab_tol, h = (back_thickness / 2) + tab_tol,
                         center = true, $fn = 6);
            }
}


/*
 * Chopping block — a large cube that removes the half of
 * the case we don't want to render. The block is rotated to
 * the split angle and shifted to one side depending on
 * which half is selected.
 */
module chopping_block()
{
    size  = 1000;
    slide = SIDE == "A" ? size / 2 : -size / 2;

    rotate([0, 0, 90 - split_angle])
        translate([0, slide, 0])
            cube([size, size, size], center = true);
}


/*
 * Raspberry Pi mounting standoffs.
 *
 * Six cylindrical standoffs in a 58 x 49 mm grid, each with
 * a screw hole through the centre.
 *
 *   x, y, z  — position of the lower-left standoff centre
 */
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
            translate([x + x_offset, y + y_offset, z])
                difference() {
                    cylinder(h = height, d = outer_diameter);
                    translate([0, 0, -0.1])
                        cylinder(h = height + 0.2, d = hole_diameter);
                }
        }
    }
}


/*
 * Power supply cable hole through the side wall.
 *
 * Drilled along X through the right side wall, at the
 * Pi mount Y position plus the user offset.
 */
module power_hole()
{
    cy = pi_y + power_hole_offset_y;
    cz = -(screen_depth + back_space + back_thickness) / 2
        + back_thickness / 2
        + power_hole_offset_z;

    translate([
        (screen_width + 2 * wall_thickness) / 2,
        cy,
        cz
    ])
        rotate([0, 90, 0])
            cylinder(
                h = (wall_thickness + standoff_thickness) + 10,
                r = power_hole_radius,
                center = true
            );
}

power_trim_width = 1; // mm

module power_outline()
{
    cx = (screen_width + 2 * wall_thickness) / 2;
    cy = pi_y + power_hole_offset_y;
    cz = -(screen_depth + back_space + back_thickness) / 2
        + back_thickness / 2
        + power_hole_offset_z;

    translate([cx, cy, cz])
        rotate([0, 90, 0])
            rotate_extrude()
                translate([power_hole_radius, 0, 0])
                    circle(d = power_trim_width);
}


/*
 * Case body — the hollow shell.
 *
 * A solid block with the interior carved out, plus a
 * standoff frame around the Pi cavity opening. Everything
 * is centred on the origin.
 */
module case_body()
{
    difference(){
        union() {
            difference() {
                /* Solid outer block with square vertical edges.
                 * A simple cube sized by the screen dimensions
                 * plus the wall thickness on each side. Front
                 * and back faces stay flat.
                 */
                cube([
                    screen_width  + (2 * wall_thickness),
                    screen_height + (2 * wall_thickness),
                    screen_depth + back_space + back_thickness
                ], center = true);

                /* Interior cavity (screen + Pi chamber) */
                translate([0, 0, (back_thickness + eps) / 2])
                    cube([
                        screen_width,
                        screen_height,
                        screen_depth + back_space + eps
                    ], center = true);
            }

            /* Standoff wedges in each corner for the screen
             * to rest on. Each is a triangular prism
             * (standoff_thickness on each leg) and back_space
             * tall, using half the material of a square block.
             */
            for (sx = [-1, 1], sy = [-1, 1]) {
                translate([
                    sx * (screen_width  / 2 - standoff_thickness / 2),
                    sy * (screen_height / 2 - standoff_thickness / 2),
                    -(back_thickness + eps / 2)
                ])
                    rotate([0, 0, sx > 0 ? (sy > 0 ? 180 : 90) : (sy > 0 ? 270 : 0)])
                        linear_extrude(back_space + eps, center = true)
                            polygon([
                                [-standoff_thickness / 2 - eps, -standoff_thickness / 2 - eps],
                                [ standoff_thickness / 2 + eps, -standoff_thickness / 2 - eps],
                                [-standoff_thickness / 2 - eps,  standoff_thickness / 2 + eps]
                            ]);
            }
            power_outline();
        }
        /* Power supply cable hole through the back wall */
        power_hole();
    }
}


/*
 * Full case — body plus Pi mounting standoffs.
 */
module case()
{
    union() {
        raspberry_pi_mount_points(
            x = wall_thickness + support_width + pi_x,
            y = pi_y,
            z = back_thickness
        );
        translate([0, 0, (screen_depth + back_thickness + back_space) / 2])
            case_body();
    }
}

/*
 * Screen fixing clips.
 *
 * Four small rounded-corner tabs at the front opening
 * that overlap the inserted screen to hold it in place.
 * Each is a square with a quarter-circle cutout, giving
 * the inside corners of the screen opening a rounded look.
 *
 * The case body is centred on the origin, so the screen
 * opening spans:
 *   X: -screen_width/2  to  +screen_width/2
 *   Y: -screen_height/2 to  +screen_height/2
 *   Z: front face is at +screen_depth/2 (relative to body)
 */
module screen_fixing()
{
    front_z = (screen_depth + back_space + back_thickness) / 2;
    clip_z = front_z - screen_clip_height;

    half_w = screen_width  / 2;
    half_h = screen_height / 2;
    r = screen_corner_radius;

    // Bottom-left
    translate([-half_w, -half_h, clip_z])
        linear_extrude(screen_clip_height)
            difference() {
                square([r, r]);
                translate([r, r])
                    circle(r = r);
            }

    // Bottom-right
    translate([half_w - r, -half_h, clip_z])
        linear_extrude(screen_clip_height)
            difference() {
                square([r, r]);
                translate([0, r])
                    circle(r = r);
            }

    // Top-left
    translate([-half_w, half_h - r, clip_z])
        linear_extrude(screen_clip_height)
            difference() {
                square([r, r]);
                translate([r, 0])
                    circle(r = r);
            }

    // Top-right
    translate([half_w - r, half_h - r, clip_z])
        linear_extrude(screen_clip_height)
            difference() {
                square([r, r]);
                circle(r = r);
            }
}


/* ============================================================
 *  Render
 * ============================================================
 *
 *  For the selected half:
 *    1. Add the male tab (boss with clearance hole)
 *    2. Cut away the unwanted half with the chopping block
 *    3. Cut the female tab (recess + pilot hole)
 */

difference() {
    union() {
        male_tab();
        difference() {
            union(){
                case();
                translate([0, 0, (screen_depth + back_thickness + back_space) / 2])
                    screen_fixing();
            }
            chopping_block();
        }
    }
    female_tab();
}