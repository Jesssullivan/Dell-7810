include <../lib/project-config.scad>;
include <../lib/measured-params.scad>;

$fn = 32;
coupon_name = is_undef(coupon_name) ? "latch" : coupon_name;

function measured_or_default(measured_value, default_value) =
    (use_measured_params && measured_value > 0) ? measured_value : default_value;

module label_strip(length = 50, width = 10, height = 2) {
    cube([length, width, height]);
}

module latch_coupon() {
    latch_width = measured_or_default(measured_latch_feature_width, 28);
    latch_depth = measured_or_default(measured_latch_depth, 8);

    union() {
        cube([latch_width + 12, 20, 6]);
        translate([6, 4, 6]) cube([latch_width, 12, latch_depth]);
    }
}

module rail_coupon() {
    rail_length = measured_or_default(measured_lower_rail_length, 90);
    rail_lip = measured_or_default(measured_lower_rail_lip_depth, 8);
    rail_groove = measured_or_default(measured_lower_rail_groove_width, 5);

    difference() {
        cube([min(rail_length, 120), 25, 8]);
        translate([8, 6, 2]) cube([max(min(rail_length, 120) - 16, 20), rail_groove, 6]);
        translate([8, 14, 2]) cube([max(min(rail_length, 120) - 16, 20), max(rail_lip - 1, 3), 6]);
    }
}

module cable_coupon() {
    bundle_width = measured_or_default(measured_bundle_width, 120);
    bundle_height = measured_or_default(measured_bundle_height, 30);
    opening_width = max(bundle_width + 20, 50);
    opening_height = max(bundle_height + 20, 30);
    opening_radius = min(cable_opening_corner_radius, min(opening_width, opening_height) / 4);

    difference() {
        cube([180, 80, 4]);
        translate([20, 15, -1])
            linear_extrude(height = 6)
                offset(r = opening_radius)
                    square([
                        opening_width - 2 * opening_radius,
                        opening_height - 2 * opening_radius
                    ]);
    }
}

module rear_coupon() {
    rear_depth = measured_or_default(measured_rear_hook_depth, 12);

    difference() {
        union() {
            cube([70, 20, 4]);
            translate([50, 0, 0]) cube([20, 45, 20]);
        }
        translate([54, 4, 4]) cube([rear_depth, 18, 12]);
    }
}

if (coupon_name == "latch") {
    latch_coupon();
}

if (coupon_name == "rail") {
    rail_coupon();
}

if (coupon_name == "cable") {
    cable_coupon();
}

if (coupon_name == "rear") {
    rear_coupon();
}
