$fn = 48;

/* ============================================================
 *  FlightTracker Case
 * ============================================================ */

/* ============================================================
 *  Configuration
 * ============================================================ */
SIDE = "A";          // "A" = upper-right half
                     // "B" = lower-left half

/* ============================================================
 *  CSG tolerances
 * ============================================================ */

/*
 * Tiny overlap used to avoid coincident/coplanar surfaces.
 *
 * This is deliberately separate from mechanical clearances.
 */
boolean_eps = 0.01;

/*
 * Deliberate cutter over-travel.
 *
 * Unlike boolean_eps, this is a substantial overlap used to
 * ensure cutting geometry passes completely through the part.
 */
cut_overlap = 2;

/* ============================================================
 *  Primary dimensions
 * ============================================================ */

/* ---------- Screen ---------- */
screen_nominal_width  = 256;
screen_nominal_height = 128;
screen_nominal_depth  = 14;

screen_xy_clearance = 0.5;
screen_z_clearance  = 2;

screen_width  = screen_nominal_width  + screen_xy_clearance;
screen_height = screen_nominal_height + screen_xy_clearance;
screen_depth  = screen_nominal_depth  + screen_z_clearance;

/* ---------- Case ---------- */
back_thickness = 4;
wall_thickness = 2;

/* ---------- Rear / Pi chamber ---------- */
back_space = 35;

/* ---------- Screen support geometry ---------- */
support_width   = 2;
standoff_radius = 15;
chamfer_radius  = 15;

/* ============================================================
 *  Derived case dimensions
 * ============================================================ */
case_width =
    screen_width
    + 2 * wall_thickness;

case_height =
    screen_height
    + 2 * wall_thickness;

case_depth =
    back_thickness
    + back_space
    + screen_depth;

/*
 * Global Z datums.
 *
 * EVERY feature in the model should preferably be positioned
 * relative to one of these planes.
 */
z_back_outer = 0;

z_back_inner =
    back_thickness;

z_screen_seat =
    back_thickness
    + back_space;

z_front =
    case_depth;

/* ============================================================
 *  Diagonal case split
 * ============================================================ */
split_angle    = 45;
wall_cut_angle = 35;

/* ============================================================
 *  Raspberry Pi mounting
 * ============================================================ */
pi_standoff_height = 3;
pi_standoff_d       = 6;
pi_screw_hole_d     = 2.5;

pi_mount_inset = [1, 43.46];

/*
 * Pi mounting holes use a 58 x 49 mm layout.
 *
 * Position the lower-left mounting hole relative to the
 * screen cavity.
 */
pi_x =
    (screen_width / 2)
    - 59
    - wall_thickness
    - pi_standoff_d
    - pi_mount_inset[0];

pi_y =
    -(
        (screen_height / 2)
        - pi_standoff_d
        - pi_mount_inset[1]
    );

/* ============================================================
 *  Power cable opening
 * ============================================================ */
power_hole_radius   = 6;
power_hole_offset_y = 14.75;

/*
 * Maintains the original geometry.
 *
 * This offset is relative to the centre-plane of the rear
 * wall rather than the outside surface.
 */
power_hole_offset_z = 22.5;

power_hole_z =
    (back_thickness / 2)
    + power_hole_offset_z;

/*
 * Extra penetration into the model used by the side-wall
 * cutter.
 */
power_hole_cut_reach = 8.5;
power_hole_cut_extra = 10;

power_hole_cut_depth =
    wall_thickness
    + power_hole_cut_reach
    + power_hole_cut_extra;

power_trim_width = 1;

/* ============================================================
 *  Screen fixing clips
 * ============================================================ */
screen_corner_radius = 5;
screen_clip_height   = 0.5;

/* ============================================================
 *  Screw-lock tabs
 * ============================================================ */
tab_thickness_ratio = 0.6;

tab_radius =
    (screen_height / 4) / 2;

tab_a_y =
    screen_height / 3;

tab_b_y =
    -tab_a_y;

tab_cut_offset =
    tan(split_angle) * tab_a_y;

tab_a_x =
    tab_cut_offset;

tab_b_x =
    tab_cut_offset;

/*
 * Position adjustments relative to the split.
 */

tab_to_wall = -10;
tab_to_cut  = -tab_radius / 2;

/* Screw geometry */

tab_pilot_d    = 2.5;
tab_clearance_d = 2.5;

/*
 * This was previously named tab_cs_od, but was actually
 * supplied to OpenSCAD as a radius.
 *
 * The new name preserves the original geometry.
 */
tab_countersink_r = 4;

/* Mechanical print clearance */

tab_fit_clearance = 0.5;

/* ============================================================
 *  Wall mounting holes
 * ============================================================ */

/*
 * These were previously named as "opening" and "tab" but are
 * actually used as radii.
 */
mount_hole_radius = 6;
mount_tab_radius  = 3.5;

mount_tab_thickness = 1;
mount_separation    = 80;

/*
 * Small locking portion extending through / behind the rear
 * surface.
 */
mount_tab_extension_below = 20;
mount_tab_height          = 22;

/*
 * Through-hole cutter depth is derived from the actual model.
 */
mount_hole_depth =
    case_depth
    + 2 * cut_overlap;

/* ============================================================
 *  Back-wall logo
 * ============================================================ */
logo_file      = "flight-tracker.svg";
logo_thickness = 0.2;     // raised height on the outer back face
logo_scale     = 3;
logo_x         = -screen_width / 2.35;
logo_y         = screen_height / 20;
logo_rotate    = 0;

/* ============================================================\
 *  Pi-side wall relief
 * ============================================================ */
pi_relief_width  = 40;
pi_relief_height = 60;
pi_relief_depth  = 100;

/* ============================================================
 *  Helper functions
 * ============================================================ */

/*
 * Position of the screw-lock tab for each case half.
 */
function tab_x(side) =
    side == "A"
        ? (tab_a_x + tab_to_wall) - tab_to_cut
        : (-tab_b_x - tab_to_wall) + tab_to_cut;

function tab_y(side) =
    side == "A"
        ? tab_a_y + tab_to_wall
        : tab_b_y - tab_to_wall;

/*
 * Rotation required to orient a corner support.
 */
function corner_rotation(sx, sy) =
    sx > 0
        ? (
            sy > 0
                ? 180
                : 90
          )
        : (
            sy > 0
                ? 270
                : 0
          );

/* ============================================================
 *  Parameter validation
 * ============================================================ */
module validate_parameters(side)
{
    assert(
        side == "A" || side == "B",
        "SIDE must be \"A\" or \"B\""
    );

    assert(
        screen_width > 0
        && screen_height > 0
        && screen_depth > 0,
        "Screen dimensions must be positive"
    );

    assert(
        wall_thickness > 0,
        "wall_thickness must be positive"
    );

    assert(
        back_thickness > 0,
        "back_thickness must be positive"
    );

    assert(
        back_space > 0,
        "back_space must be positive"
    );

    assert(
        chamfer_radius * 2 < screen_height,
        "chamfer_radius is too large for screen_height"
    );

    assert(
        standoff_radius * 2 < screen_height,
        "standoff_radius is too large for screen_height"
    );

    assert(
        screen_clip_height <= screen_depth,
        "screen_clip_height exceeds screen_depth"
    );

    children();
}

/* ============================================================
 *  Screw-lock tabs
 * ============================================================ */
module male_tab(side)
{
    x = tab_x(side);
    y = tab_y(side);

    tab_height =
        back_thickness
        * tab_thickness_ratio;

    translate([
        -x,
        -y,
        tab_height / 2
    ])
        rotate([0, 0, split_angle])
            difference() {

                /*
                 * Hexagonal male boss.
                 */

                cylinder(
                    d =
                        (tab_radius * 2)
                        - tab_fit_clearance,
                    h = tab_height,
                    center = true,
                    $fn = 6
                );

                /*
                 * Screw clearance hole.
                 */

                cylinder(
                    d = tab_clearance_d,
                    h = case_depth + 2 * cut_overlap,
                    center = true,
                    $fn = 30
                );

                /*
                 * Countersink.
                 *
                 * Geometry intentionally matches the original
                 * model.
                 */

                translate([0, 0, -1])
                    cylinder(
                        h = tab_height,
                        r1 = tab_countersink_r,
                        r2 = tab_clearance_d / 4,
                        center = true,
                        $fn = 30
                    );
            }
}

module female_tab(side)
{
    x = tab_x(side);
    y = tab_y(side);

    tab_height =
        back_thickness
        * tab_thickness_ratio;

    translate([
        x,
        y,
        tab_height / 2
    ])
        rotate([0, 0, split_angle])
            union() {

                /*
                 * Pilot hole.
                 */

                cylinder(
                    d = tab_pilot_d,
                    h = case_depth + 2 * cut_overlap,
                    center = true,
                    $fn = 30
                );

                /*
                 * Hexagonal receiving recess.
                 */

                cylinder(
                    d =
                        (tab_radius * 2)
                        + tab_fit_clearance,

                    h =
                        tab_height
                        + tab_fit_clearance,

                    center = true,
                    $fn = 6
                );
            }
}

/* ============================================================
 *  Case split cutter
 * ============================================================ */
module chopping_block(side)
{
    size =
        max(
            case_width,
            case_height,
            case_depth
        ) * 4;

    x_bottom =
        -screen_height
        / (2 * tan(split_angle));

    x_top =
        screen_height
        / (2 * tan(split_angle));

    y_wall =
        screen_height / 2;

    p1 = [
        x_bottom,
        -y_wall
    ];

    p2 = [
        x_top,
        y_wall
    ];

    wall_cut_mid_point =
        size / 4;

    wall_cut_offset =
        tan(90 - wall_cut_angle)
        * wall_cut_mid_point;

    poly =
        side == "A"

        ? [
            [-size, -size],

            [
                x_bottom + wall_cut_offset,
                -size
            ],

            [
                x_bottom + wall_cut_offset,
                -wall_cut_mid_point
            ],

            p1,
            p2,

            [
                x_top - wall_cut_offset,
                wall_cut_mid_point
            ],

            [
                x_top - wall_cut_offset,
                size
            ],

            [-size, size]
        ]

        : [
            [size, size],

            [
                x_top - wall_cut_offset,
                size
            ],

            [
                x_top - wall_cut_offset,
                wall_cut_mid_point
            ],

            p2,
            p1,

            [
                x_bottom + wall_cut_offset,
                -wall_cut_mid_point
            ],

            [
                x_bottom + wall_cut_offset,
                -size
            ],

            [size, -size]
        ];

    /*
     * Cutter is centred around the completed case rather than
     * around world Z=0.
     */
    translate([
        0,
        0,
        case_depth / 2
    ])
        linear_extrude(
            height =
                case_depth
                + 2 * cut_overlap,

            center = true
        )
            polygon(poly);
}

/* ============================================================
 *  Raspberry Pi mounting points
 * ============================================================ */
module raspberry_pi_mount_points(
    x = 0,
    y = 0,
    z = z_back_inner,
    height = pi_standoff_height,
    outer_diameter = pi_standoff_d,
    hole_diameter = pi_screw_hole_d
)
{
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

                    translate([
                        0,
                        0,
                        -boolean_eps
                    ])
                        cylinder(
                            h =
                                height
                                + 2 * boolean_eps,

                            d = hole_diameter
                        );
                }
        }
    }
}

/* ============================================================
 *  Power cable opening
 * ============================================================ */
module power_hole()
{
    cy =
        pi_y
        + power_hole_offset_y;

    translate([
        case_width / 2,
        cy,
        power_hole_z
    ])
        rotate([0, 90, 0])
            cylinder(
                h = power_hole_cut_depth,
                r = power_hole_radius,
                center = true
            );
}

module power_outline()
{
    cx =
        case_width / 2;

    cy =
        pi_y
        + power_hole_offset_y;

    translate([
        cx,
        cy,
        power_hole_z
    ])
        rotate([0, 90, 0])
            rotate_extrude()
                translate([
                    power_hole_radius,
                    0
                ])
                    circle(
                        d = power_trim_width
                    );
}

/* ============================================================
 *  Chamfer helpers
 * ============================================================ */
module chamfer_profile(r)
{
    difference() {

        square([r, r]);

        circle(
            r = r
        );
    }
}

module chamfer(
    pos,
    rot,
    length,
    r
)
{
    translate(pos)
        rotate(rot)
            linear_extrude(
                height = length
            )
                chamfer_profile(r);
}

/* ============================================================
 *  Internal rear-wall chamfers
 * ============================================================ */
module internal_chamfers()
{
    radius =
        chamfer_radius;

    /*
     * The chamfers begin on the inner surface of the rear
     * wall.
     *
     * chamfer_profile() occupies:
     *
     *     Z = z - radius ... z
     *
     * Therefore placing its datum at:
     *
     *     z_back_inner + radius
     *
     * puts its bottom exactly on z_back_inner.
     */

    z =
        z_back_inner
        + radius;

    /* Top-left */
    chamfer(
        [
            (-screen_width / 2)
                + radius
                - boolean_eps,

            screen_height / 2,

            z
        ],

        [90, 180, 0],

        screen_height,

        radius
    );

    /* Top-right */
    chamfer(
        [
            (screen_width / 2)
                - radius
                + boolean_eps,

            screen_height / 2,

            z
        ],

        [90, 90, 0],

        screen_height,

        radius
    );

    /* Bottom-right */
    chamfer(
        [
            screen_width / 2,

            radius
                - screen_height / 2,

            z
        ],

        [180, 90, 0],

        screen_width,

        radius
    );

    /* Bottom-left */
    chamfer(
        [
            -screen_width / 2,

            (screen_height / 2)
                - radius,

            z
        ],

        [0, 90, 0],

        screen_width,

        radius
    );
}

/* ============================================================
 *  Main case shell
 * ============================================================ */
module case_shell()
{
    difference() {

        /*
         * Outer case.
         *
         * Rear face = Z 0
         * Front face = Z case_depth
         */
        translate([
            0,
            0,
            case_depth / 2
        ])
            cube([
                case_width,
                case_height,
                case_depth
            ], center = true);

        /*
         * Interior cavity.
         *
         * Starts at the inner surface of the rear wall and
         * continues slightly beyond the front surface.
         */
        cavity_depth =
            back_space
            + screen_depth
            + boolean_eps;

        translate([
            0,
            0,

            z_back_inner
            + cavity_depth / 2
            - boolean_eps / 2
        ])
            cube([
                screen_width,
                screen_height,
                cavity_depth
            ], center = true);
    }
}

/* ============================================================
 *  Rear chamber corner supports
 * ============================================================ */

module screen_supports()
{
    radius =
        standoff_radius;

    /*
     * These supports occupy exactly the Pi chamber:
     *
     *     Z = z_back_inner ... z_screen_seat
     *
     * Their geometry is therefore completely independent of
     * screen_depth.
     */
    support_z =
        z_back_inner
        + back_space / 2;

    for (
        sx = [-1, 1],
        sy = [-1, 1]
    ) {

        translate([
            sx * (
                screen_width / 2
                - radius
            ),

            sy * (
                screen_height / 2
                - radius
            ),

            support_z
        ])
            rotate([0, 0, 180])
                rotate([
                    0,
                    0,
                    corner_rotation(sx, sy)
                ])
                    linear_extrude(
                        height =
                            back_space
                            + boolean_eps,

                        center = true
                    )
                        chamfer_profile(radius);
    }
}

/* ============================================================
 *  Pi-side wall relief
 * ============================================================ */
module pi_side_relief()
{
    /*
     * Relief begins exactly at the rear-wall inner surface.
     *
     * The old expression involving screen_depth simplified to
     * this once the model was converted to global coordinates.
     */

    translate([
        (screen_width - pi_relief_width) / 2,

        -(
            screen_height
            - 118
            - chamfer_radius * 2
        ) / 2,

        z_back_inner
            + pi_relief_depth / 2
    ])
        cube([
            pi_relief_width,
            pi_relief_height,
            pi_relief_depth
        ], center = true);
}

/* ============================================================
 *  Back-wall logo
 * ============================================================ */
module back_logo()
{
    /*
     * The SVG is imported as 2D geometry in the XY plane.
     *
     * We extrude it 0.4 mm and place it on the OUTER rear
     * surface (z_back_outer = 0), protruding outwards in
     * the -Z direction.
     */
    /*
     * The SVG is pixel art built from many adjacent/overlapping
     * rectangles. Extruding that directly yields a non-manifold
     * mesh (shared internal faces) that CGAL cannot convert to a
     * Nef polyhedron.
     *
     * A tiny grow-then-shrink offset dissolves the coincident
     * edges into a single clean outline before extrusion.
     */
    logo_merge = 0.01;

    translate([
        logo_x,
        logo_y,
        back_thickness - boolean_eps
    ])
        rotate([0, 0, logo_rotate])
            scale(logo_scale)
                linear_extrude(
                    height = logo_thickness / logo_scale
                )
                    offset(r = -logo_merge)
                        offset(r =  logo_merge)
                            import(logo_file);
}

/* ============================================================
 *  Case body
 * ============================================================ */
module case_body()
{
    difference() {

        union() {
            case_shell();

            screen_supports();

            internal_chamfers();

            power_outline();
        }

        power_hole();

        pi_side_relief();
    }
}

/* ============================================================
 *  Full unsplit case
 * ============================================================ */

module case()
{
    union() {
        case_body();

        back_logo();

        raspberry_pi_mount_points(
            x =
                wall_thickness
                + support_width
                + pi_x,

            y = pi_y,

            z = z_back_inner
        );
    }
}

/* ============================================================
 *  Screen fixing clips
 * ============================================================ */

module screen_fixing()
{
    clip_z =
        z_front
        - screen_clip_height;

    half_w =
        screen_width / 2;

    half_h =
        screen_height / 2;

    r =
        screen_corner_radius;

    /* Bottom-left */
    translate([
        -half_w,
        -half_h,
        clip_z
    ])
        linear_extrude(
            height = screen_clip_height
        )
            difference() {

                square([r, r]);

                translate([r, r])
                    circle(r = r);
            }

    /* Bottom-right */
    translate([
        half_w - r,
        -half_h,
        clip_z
    ])
        linear_extrude(
            height = screen_clip_height
        )
            difference() {

                square([r, r]);

                translate([0, r])
                    circle(r = r);
            }

    /* Top-left */
    translate([
        -half_w,
        half_h - r,
        clip_z
    ])
        linear_extrude(
            height = screen_clip_height
        )
            difference() {

                square([r, r]);

                translate([r, 0])
                    circle(r = r);
            }

    /* Top-right */
    translate([
        half_w - r,
        half_h - r,
        clip_z
    ])
        linear_extrude(
            height = screen_clip_height
        )
            difference() {

                square([r, r]);

                circle(r = r);
            }
}

/* ============================================================
 *  Wall mounting holes
 * ============================================================ */

module mounting_hole()
{
    union() {

        /*
         * Main circular opening.
         */
        translate([
            0,
            0,
            mount_tab_thickness
        ])
            cylinder(
                h =
                    mount_hole_depth
                    - mount_tab_thickness,

                r = mount_hole_radius
            );

        /*
         * Half-hole opening through the rear surface.
         */
        difference() {

            cylinder(
                h = mount_hole_depth,
                r = mount_hole_radius
            );

            translate([
                -mount_hole_radius,
                0,
                -boolean_eps
            ])
                cube([
                    mount_hole_radius * 2,
                    mount_hole_radius * 2,
                    mount_hole_radius * 2
                ]);
        }

        /*
         * Narrow rear locking slot.
         */
        translate([
            0,
            0,
            -mount_tab_extension_below
        ])
            cylinder(
                h = mount_tab_height,
                r = mount_tab_radius
            );
    }
}

module mounting_holes()
{
    for (
        sx = [-1, 1],
        sy = [-1, 1]
    ) {
        translate([
            sx * mount_separation,

            sy * (
                screen_height / 2
                - chamfer_radius / 2
            ),

            -boolean_eps
        ])
            rotate([
                0,
                0,
                sy > 0
                    ? 0
                    : 180
            ])
                mounting_hole();
    }
}

/* ============================================================
 *  Complete case half
 * ============================================================ */
module flighttracker_case(side)
{
    difference() {
        union() {
            /*
             * Screw-lock boss belonging to this half.
             */
            male_tab(side);

            difference() {
                union() {
                    case();

                    screen_fixing();
                }

                /*
                 * Rear wall mounting slots.
                 */
                mounting_holes();

                /*
                 * Remove the opposite half.
                 */
                chopping_block(side);
            }
        }

        /*
         * Receiving socket for the opposite half's locking tab.
         */
        female_tab(side);
    }
}

/* ============================================================
 *  Render
 * ============================================================ */
validate_parameters(SIDE)
    flighttracker_case(SIDE);
