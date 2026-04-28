include <../lib/project-config.scad>;
include <../lib/measured-params.scad>;

$fn = 32;
coupon_name = is_undef(coupon_name) ? "latch" : coupon_name;
rail_position = is_undef(rail_position) ? "mid" : rail_position;
latch_depth_delta = is_undef(latch_depth_delta) ? 0 : latch_depth_delta;
latch_width_delta = is_undef(latch_width_delta) ? 0 : latch_width_delta;
cable_style = is_undef(cable_style) ? "brush" : cable_style;
cable_margin = is_undef(cable_margin) ? 18 : cable_margin;
rear_mode = is_undef(rear_mode) ? "notch" : rear_mode;

function measured_or_default(measured_value, default_value) =
    (use_measured_params && measured_value > 0) ? measured_value : default_value;

function rail_position_value(front_value, mid_value, rear_value, global_value, default_value) =
    rail_position == "front"
        ? measured_or_default(front_value > 0 ? front_value : global_value, default_value)
        : rail_position == "rear"
            ? measured_or_default(rear_value > 0 ? rear_value : global_value, default_value)
            : measured_or_default(mid_value > 0 ? mid_value : global_value, default_value);

function rail_position_code() =
    rail_position == "front" ? "F" : rail_position == "rear" ? "R" : "M";

function latch_variant_code() =
    latch_depth_delta > 0.1 ? "+" : latch_depth_delta < -0.1 ? "-" : "0";

function cable_style_code() =
    cable_style == "split" ? "S" : cable_style == "control" ? "C" : "B";

function rear_mode_code() =
    rear_mode == "backer" ? "B" : "N";

function rail_status_code() =
    (use_measured_params && (
        measured_lower_rail_length > 0 ||
        measured_lower_rail_lip_depth > 0 ||
        measured_lower_rail_groove_width > 0 ||
        measured_lower_rail_z_offset > 0 ||
        measured_lower_rail_thickness > 0 ||
        measured_lower_rail_lip_depth_front > 0 ||
        measured_lower_rail_lip_depth_mid > 0 ||
        measured_lower_rail_lip_depth_rear > 0 ||
        measured_lower_rail_groove_width_front > 0 ||
        measured_lower_rail_groove_width_mid > 0 ||
        measured_lower_rail_groove_width_rear > 0
    )) ? "M" : "PH";

function latch_status_code() =
    (use_measured_params && (
        measured_latch_x > 0 ||
        measured_latch_z > 0 ||
        measured_latch_depth > 0 ||
        measured_latch_feature_width > 0 ||
        measured_oem_panel_thickness_latch_zone > 0
    )) ? "M" : "PH";

function cable_status_code() =
    (use_measured_params && (
        measured_bundle_width > 0 ||
        measured_bundle_height > 0 ||
        measured_largest_connector_diagonal > 0 ||
        measured_preferred_cable_opening_x > 0 ||
        measured_preferred_cable_opening_z > 0 ||
        measured_preferred_cable_opening_width > 0 ||
        measured_preferred_cable_opening_height > 0
    )) ? "M" : "PH";

function rear_status_code() =
    (use_measured_params && measured_rear_hook_depth > 0) ? "M" : "PH";

module rounded_slot_2d(width, height, radius) {
    offset(r = radius)
        square([
            max(width - 2 * radius, 1),
            max(height - 2 * radius, 1)
        ]);
}

module raised_text_label(label_text, position = [0, 0, 0], size = 3.2, height = 0.8) {
    translate(position)
        linear_extrude(height = height)
            text(label_text, size = size, halign = "left", valign = "baseline");
}

module latch_coupon() {
    latch_width_nominal = measured_or_default(measured_latch_feature_width, 28);
    latch_depth_nominal = measured_or_default(measured_latch_depth, 8);
    panel_thickness = measured_or_default(measured_oem_panel_thickness_latch_zone, 1.2);
    latch_width = max(latch_width_nominal + latch_width_delta, 8);
    latch_depth = max(latch_depth_nominal + latch_depth_delta, 2);

    union() {
        cube([latch_width + 16, 24, 6]);
        translate([8, 4, 6]) cube([latch_width, 16, latch_depth]);
        translate([0, 0, 6]) cube([8, 24, panel_thickness + 2]);
        translate([latch_width + 8, 0, 6]) cube([8, 24, panel_thickness + 2]);
        raised_text_label(
            str("L-", latch_variant_code(), " ", latch_status_code()),
            [3, 0.8, 6],
            3.0
        );
    }
}

module rail_coupon() {
    rail_length = measured_or_default(measured_lower_rail_length, 90);
    rail_lip = rail_position_value(
        measured_lower_rail_lip_depth_front,
        measured_lower_rail_lip_depth_mid,
        measured_lower_rail_lip_depth_rear,
        measured_lower_rail_lip_depth,
        8
    );
    rail_groove = rail_position_value(
        measured_lower_rail_groove_width_front,
        measured_lower_rail_groove_width_mid,
        measured_lower_rail_groove_width_rear,
        measured_lower_rail_groove_width,
        5
    );
    rail_thickness = measured_or_default(measured_lower_rail_thickness, 1.2);
    coupon_length = min(rail_length, 120);

    union() {
        difference() {
            cube([coupon_length, 28, 10]);
            translate([8, 5, rail_thickness]) cube([max(coupon_length - 16, 20), rail_groove, 9]);
            translate([8, 14, 2]) cube([max(coupon_length - 16, 20), max(rail_lip, 3), 7]);
            translate([8, 23, 2]) cube([max(coupon_length - 16, 20), 3, 7]);
        }
        raised_text_label(
            str("R-", rail_position_code(), " ", rail_status_code()),
            [3, 1.0, 10],
            3.2
        );
    }
}

module cable_coupon() {
    bundle_width = measured_or_default(measured_bundle_width, 120);
    bundle_height = measured_or_default(measured_bundle_height, 30);
    connector_diagonal = measured_or_default(measured_largest_connector_diagonal, 36);
    opening_width = max(
        measured_or_default(measured_preferred_cable_opening_width, bundle_width + cable_margin),
        50
    );
    opening_height = max(
        measured_or_default(measured_preferred_cable_opening_height, bundle_height + cable_margin),
        30
    );
    opening_radius = min(cable_opening_corner_radius, min(opening_width, opening_height) / 4);

    union() {
        difference() {
            cube([180, 80, 4]);

            if (cable_style == "split") {
                translate([28, 18, -1])
                    linear_extrude(height = 6)
                        hull() {
                            translate([0, opening_height / 2]) circle(r = opening_height / 2);
                            translate([max(connector_diagonal + cable_margin, opening_height), opening_height / 2])
                                circle(r = opening_height / 2);
                        }
            } else if (cable_style == "control") {
                translate([20, 12, -1])
                    linear_extrude(height = 6)
                        rounded_slot_2d(
                            opening_width + 20,
                            opening_height + 16,
                            min(opening_radius + 2, opening_height / 3)
                        );
            } else {
                translate([20, 15, -1])
                    linear_extrude(height = 6)
                        rounded_slot_2d(opening_width, opening_height, opening_radius);
            }
        }
        raised_text_label(
            str("C-", cable_style_code(), " ", cable_status_code()),
            [4, 71, 4],
            4.5
        );
    }
}

module rear_coupon() {
    rear_depth = measured_or_default(measured_rear_hook_depth, 12);

    if (rear_mode == "backer") {
        union() {
            difference() {
                cube([120, 90, 3]);
                translate([10, 10, -1]) cube([100, 3, 5]);
                translate([10, 10, -1]) cube([3, 70, 5]);
            }
            raised_text_label(
                str("RE-", rear_mode_code(), " ", rear_status_code()),
                [4, 81, 3],
                4.2
            );
        }
    } else {
        union() {
            difference() {
                union() {
                    cube([70, 20, 4]);
                    translate([50, 0, 0]) cube([20, 45, 20]);
                }
                translate([54, 4, 4]) cube([rear_depth, 18, 12]);
            }
            raised_text_label(
                str("RE-", rear_mode_code(), " ", rear_status_code()),
                [3, 1.0, 4],
                3.6
            );
        }
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
