default:
    @just --list

concept-stl:
    mkdir -p output/stl
    openscad -D 'render_mode="concept"' -o output/stl/top_hat_concept_placeholder.stl cad/openscad/src/top_hat_assembly.scad

fit-coupon-stl coupon="latch":
    mkdir -p output/stl
    openscad -D 'coupon_name="{{coupon}}"' -o output/stl/{{coupon}}_coupon_placeholder.stl cad/openscad/src/fit_check_coupons.scad

fit-coupons-core:
    mkdir -p output/stl
    openscad -D 'coupon_name="latch"' -o output/stl/latch_coupon_placeholder.stl cad/openscad/src/fit_check_coupons.scad
    openscad -D 'coupon_name="rail"' -o output/stl/rail_coupon_placeholder.stl cad/openscad/src/fit_check_coupons.scad
    openscad -D 'coupon_name="rear"' -o output/stl/rear_coupon_placeholder.stl cad/openscad/src/fit_check_coupons.scad
    openscad -D 'coupon_name="cable"' -o output/stl/cable_coupon_placeholder.stl cad/openscad/src/fit_check_coupons.scad

platform-runner-enrollment-status *args:
    bash scripts/platform/runner-enrollment-status {{args}}
