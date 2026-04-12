include <../lib/project-config.scad>;
include <../lib/measured-params.scad>;

$fn = 48;
render_mode = is_undef(render_mode) ? "concept" : render_mode;

function measured_or_default(measured_value, default_value) =
    (use_measured_params && measured_value > 0) ? measured_value : default_value;

chassis_depth_actual = measured_or_default(measured_chassis_depth, chassis_depth);
chassis_width_actual = measured_or_default(measured_chassis_width, chassis_width);
chassis_height_actual = measured_or_default(measured_chassis_height_no_feet, chassis_height);

// Coordinate system:
// X = front to rear
// Y = left side outward from the chassis wall
// Z = bottom to top

module chassis_reference() {
    color([0.7, 0.7, 0.7, 0.15])
        cube([chassis_depth_actual, chassis_width_actual, chassis_height_actual]);
}

module cable_opening_reference() {
    translate([
        measured_or_default(measured_preferred_cable_opening_x, chassis_depth_actual * 0.55),
        chassis_width_actual + top_hat_wall / 2,
        measured_or_default(measured_preferred_cable_opening_z, chassis_height_actual * 0.58)
    ])
    rotate([90, 0, 0])
        linear_extrude(height = top_hat_wall * 2, center = true)
            offset(r = cable_opening_corner_radius)
                square([
                    cable_opening_width - 2 * cable_opening_corner_radius,
                    cable_opening_height - 2 * cable_opening_corner_radius
                ], center = true);
}

module top_hat_shell_concept() {
    difference() {
        translate([
            -top_hat_clearance,
            -top_hat_extra_width,
            -top_hat_clearance
        ])
            cube([
                chassis_depth_actual + top_hat_clearance * 2,
                chassis_width_actual + top_hat_extra_width + top_hat_clearance,
                chassis_height_actual + top_hat_extra_height + top_hat_clearance
            ]);

        translate([0, 0, 0])
            cube([chassis_depth_actual, chassis_width_actual, chassis_height_actual]);

        cable_opening_reference();
    }
}

module psu_shelf_reference() {
    color([0.85, 0.45, 0.15, 0.7])
        translate([
            measured_or_default(measured_psu_position_x, chassis_depth_actual * 0.45),
            chassis_width_actual + top_hat_extra_width - psu_shelf_width,
            measured_or_default(measured_psu_height_z, chassis_height_actual + top_hat_extra_height - psu_shelf_thickness)
        ])
            cube([psu_shelf_depth, psu_shelf_width, psu_shelf_thickness]);
}

module concept_assembly() {
    chassis_reference();
    color([0.2, 0.45, 0.8, 0.2]) top_hat_shell_concept();
    psu_shelf_reference();
}

if (render_mode == "concept") {
    concept_assembly();
}
