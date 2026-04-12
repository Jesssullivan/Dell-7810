// Copy this file to a working measured-params file once bench data exists.
// Keep uncertain values commented or clearly marked provisional.
//
// Example workflow:
// 1. duplicate this file to measured-params.scad
// 2. fill values from the measurement log
// 3. include it from assembly or coupon models as needed

use_measured_params = true;

// Global envelope
measured_chassis_height_no_feet = 414.0;
measured_chassis_height_with_feet = 416.9;
measured_chassis_width = 172.6;
measured_chassis_depth = 471.0;

// OEM interface
measured_lower_rail_length = 0;
measured_lower_rail_lip_depth = 0;
measured_lower_rail_groove_width = 0;
measured_lower_rail_z_offset = 0;
measured_lower_rail_thickness = 0;

measured_latch_x = 0;
measured_latch_z = 0;
measured_latch_depth = 0;
measured_latch_feature_width = 0;

measured_rear_hook_depth = 0;

// GPU envelope
measured_gpu_side_plane_overhang = 0;
measured_gpu_length = 0;
measured_gpu_height = 0;
measured_gpu_thickness = 0;
measured_gpu_connector_protrusion = 0;

// Cable bundle
measured_bundle_width = 0;
measured_bundle_height = 0;
measured_largest_connector_diagonal = 0;
measured_preferred_cable_opening_x = 0;
measured_preferred_cable_opening_z = 0;

// PSU relationship
measured_psu_offset_y = 0;
measured_psu_position_x = 0;
measured_psu_height_z = 0;
