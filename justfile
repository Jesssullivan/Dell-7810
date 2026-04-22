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
    openscad -D 'coupon_name="rail"' -D 'rail_position="mid"' -o output/stl/rail_coupon_placeholder.stl cad/openscad/src/fit_check_coupons.scad
    openscad -D 'coupon_name="rear"' -D 'rear_mode="notch"' -o output/stl/rear_coupon_placeholder.stl cad/openscad/src/fit_check_coupons.scad
    openscad -D 'coupon_name="cable"' -D 'cable_style="brush"' -o output/stl/cable_coupon_placeholder.stl cad/openscad/src/fit_check_coupons.scad

fit-coupons-session-01:
    mkdir -p output/stl
    openscad -D 'coupon_name="rail"' -D 'rail_position="front"' -o output/stl/rail_front_coupon_placeholder.stl cad/openscad/src/fit_check_coupons.scad
    openscad -D 'coupon_name="rail"' -D 'rail_position="mid"' -o output/stl/rail_mid_coupon_placeholder.stl cad/openscad/src/fit_check_coupons.scad
    openscad -D 'coupon_name="rail"' -D 'rail_position="rear"' -o output/stl/rail_rear_coupon_placeholder.stl cad/openscad/src/fit_check_coupons.scad
    openscad -D 'coupon_name="latch"' -D 'latch_depth_delta=-0.75' -o output/stl/latch_depth_minus_coupon_placeholder.stl cad/openscad/src/fit_check_coupons.scad
    openscad -D 'coupon_name="latch"' -D 'latch_depth_delta=0' -o output/stl/latch_depth_nominal_coupon_placeholder.stl cad/openscad/src/fit_check_coupons.scad
    openscad -D 'coupon_name="latch"' -D 'latch_depth_delta=0.75' -o output/stl/latch_depth_plus_coupon_placeholder.stl cad/openscad/src/fit_check_coupons.scad
    openscad -D 'coupon_name="rear"' -D 'rear_mode="notch"' -o output/stl/rear_notch_coupon_placeholder.stl cad/openscad/src/fit_check_coupons.scad
    openscad -D 'coupon_name="rear"' -D 'rear_mode="backer"' -o output/stl/rear_backer_coupon_placeholder.stl cad/openscad/src/fit_check_coupons.scad
    openscad -D 'coupon_name="cable"' -D 'cable_style="brush"' -o output/stl/cable_brush_coupon_placeholder.stl cad/openscad/src/fit_check_coupons.scad
    openscad -D 'coupon_name="cable"' -D 'cable_style="split"' -o output/stl/cable_split_coupon_placeholder.stl cad/openscad/src/fit_check_coupons.scad
    openscad -D 'coupon_name="cable"' -D 'cable_style="control"' -o output/stl/cable_control_coupon_placeholder.stl cad/openscad/src/fit_check_coupons.scad

measurements-session-01-status:
    bash scripts/measurements/session-01-status

measurements-session-01-evidence-status:
    bash scripts/measurements/session-01-evidence-status

measurements-session-01-scad-preview:
    bash scripts/measurements/session-01-scad-preview

measurements-session-01-apply-scad:
    bash scripts/measurements/session-01-apply-scad

measurements-session-01-apply-scad-write:
    bash scripts/measurements/session-01-apply-scad --write

platform-smi-validate:
    bash scripts/platform/smi-validate

platform-smi-validate-full:
    bash scripts/platform/smi-validate --full

platform-smi-validate-remote target="jess@honey":
    clean_target=$(printf '%s' "{{target}}" | sed 's/^target=//'); bash scripts/platform/remote-bios-control smi-validate --target "$clean_target"

platform-bios-rt-check:
    bash scripts/platform/dcc-configure-rt --check

platform-bios-rt-check-remote target="jess@honey":
    clean_target=$(printf '%s' "{{target}}" | sed 's/^target=//'); bash scripts/platform/remote-bios-control bios-check --target "$clean_target"

platform-bios-export-remote target="jess@honey":
    clean_target=$(printf '%s' "{{target}}" | sed 's/^target=//'); bash scripts/platform/remote-bios-control bios-export --target "$clean_target"

platform-bios-usbemu-disable-remote target="jess@honey":
    clean_target=$(printf '%s' "{{target}}" | sed 's/^target=//'); bash scripts/platform/remote-bios-control usbemu-disable --target "$clean_target"

platform-bios-usbemu-enable-remote target="jess@honey":
    clean_target=$(printf '%s' "{{target}}" | sed 's/^target=//'); bash scripts/platform/remote-bios-control usbemu-enable --target "$clean_target"

platform-stage-legacy-dcc-7810:
    bash scripts/platform/stage-legacy-dcc-7810

platform-stage-legacy-dcc-7810-remote target="jess@honey":
    clean_target=$(printf '%s' "{{target}}" | sed 's/^target=//'); bash scripts/platform/stage-legacy-dcc-7810 --remote "$clean_target"

platform-capture-reset-state tag="manual":
    clean_tag=$(printf '%s' "{{tag}}" | sed 's/^tag=//'); bash scripts/platform/capture-reset-state "$clean_tag"

platform-capture-reset-state-json tag="manual":
    clean_tag=$(printf '%s' "{{tag}}" | sed 's/^tag=//'); bash scripts/platform/capture-reset-state --json "$clean_tag"

platform-save-reset-state-json tag="manual":
    clean_tag=$(printf '%s' "{{tag}}" | sed 's/^tag=//'); mkdir -p output/capture-json; bash scripts/platform/capture-reset-state --json "$clean_tag" > output/capture-json/reset-$clean_tag.json

platform-capture-numa-state tag="manual":
    clean_tag=$(printf '%s' "{{tag}}" | sed 's/^tag=//'); bash scripts/platform/capture-numa-state "$clean_tag"

platform-capture-numa-state-json tag="manual":
    clean_tag=$(printf '%s' "{{tag}}" | sed 's/^tag=//'); bash scripts/platform/capture-numa-state --json "$clean_tag"

platform-save-numa-state-json tag="manual":
    clean_tag=$(printf '%s' "{{tag}}" | sed 's/^tag=//'); mkdir -p output/capture-json; bash scripts/platform/capture-numa-state --json "$clean_tag" > output/capture-json/numa-$clean_tag.json

platform-project-host-inventory-dhall capture:
    python3 scripts/platform/project-host-inventory-dhall "{{capture}}"

platform-project-reset-run-dhall capture run_id trigger outcome ac_power_broken:
    python3 scripts/platform/project-reset-run-dhall "{{capture}}" --run-id "{{run_id}}" --trigger "{{trigger}}" --outcome "{{outcome}}" --ac-power-broken "{{ac_power_broken}}"

platform-validate-kernel-baseline:
    bash scripts/platform/validate-host-kernel-baseline

platform-validate-kernel-baseline-rt:
    bash scripts/platform/validate-host-kernel-baseline --expect-rt

platform-validate-kernel-baseline-remote target="jess@honey":
    clean_target=$(printf '%s' "{{target}}" | sed 's/^target=//'); bash scripts/platform/validate-host-kernel-baseline-remote "$clean_target"

platform-validate-kernel-baseline-remote-rt target="jess@honey":
    clean_target=$(printf '%s' "{{target}}" | sed 's/^target=//'); bash scripts/platform/validate-host-kernel-baseline-remote --expect-rt "$clean_target"

platform-kernel-status-remote target="jess@honey":
    clean_target=$(printf '%s' "{{target}}" | sed 's/^target=//'); bash scripts/platform/remote-kernel-control status --target "$clean_target"

platform-kernel-schedule-next-rt-remote target="jess@honey":
    clean_target=$(printf '%s' "{{target}}" | sed 's/^target=//'); bash scripts/platform/remote-kernel-control schedule-next-rt --target "$clean_target"

platform-kernel-clear-next-entry-remote target="jess@honey":
    clean_target=$(printf '%s' "{{target}}" | sed 's/^target=//'); bash scripts/platform/remote-kernel-control clear-next-entry --target "$clean_target"

platform-xoxdwm-duplication-status:
    bash scripts/platform/xoxdwm-duplication-status

platform-tuned-status-remote target="jess@honey":
    clean_target=$(printf '%s' "{{target}}" | sed 's/^target=//'); bash scripts/platform/remote-tuned-control status --target "$clean_target"

platform-tuned-install-profile-remote target="jess@honey":
    clean_target=$(printf '%s' "{{target}}" | sed 's/^target=//'); bash scripts/platform/remote-tuned-control install-profile --target "$clean_target"

platform-tuned-activate-profile-remote target="jess@honey":
    clean_target=$(printf '%s' "{{target}}" | sed 's/^target=//'); bash scripts/platform/remote-tuned-control activate-profile --target "$clean_target"

platform-tuned-recommend-profile-remote target="jess@honey":
    clean_target=$(printf '%s' "{{target}}" | sed 's/^target=//'); bash scripts/platform/remote-tuned-control recommend-profile --target "$clean_target"

chapel-source-status:
    bash scripts/platform/chapel-source-status

chapel-compiler-version:
    nix develop "$(bash scripts/platform/chapel-source-status --compiler-ref)" --command chpl --version

chapel-compiler-check:
    nix build "$(bash scripts/platform/chapel-source-status --compiler-ref)" --no-link --option builders ''

chapel-compiler-check-verbose:
    nix build "$(bash scripts/platform/chapel-source-status --compiler-ref)" --no-link -L --option builders ''

chapel-host-setup:
    cd analysis && mason external --setup && mason add quickchpl@1.0.2 || true

chapel-host-build:
    cd analysis && mason external --setup && (mason add quickchpl@1.0.2 || true) && mason build

chapel-host-test:
    cd analysis && mason external --setup && (mason add quickchpl@1.0.2 || true) && mason test -- --numTests=500

chapel-host-lint:
    cd analysis && chplcheck src/**/*.chpl test/**/*.chpl 2>&1 || true

chapel-host-demo:
    @command -v chpl >/dev/null || (echo "chpl not found; use direnv or nix develop path:.#chapel" && exit 1)
    chpl analysis/examples/HostNumaProbe.chpl -M analysis/src -o /tmp/dell-7810-numa-demo
    @echo "Built /tmp/dell-7810-numa-demo"
    @echo "Run on the T7810 with: /tmp/dell-7810-numa-demo -nl 1x2s"

chapel-setup:
    @just chapel-host-setup

chapel-build:
    @just chapel-host-build

chapel-test:
    @just chapel-host-test

chapel-lint:
    @just chapel-host-lint

chapel-demo:
    @just chapel-host-demo
