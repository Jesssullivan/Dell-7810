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

measurements-session-01-execution-packet:
    sed -n '1,220p' docs/measurements/session-01-execution-packet.md

measurements-honey-bench-packet:
    sed -n '1,260p' docs/measurements/honey-bench-packet.md

measurements-session-01-print-manifest:
    sed -n '1,200p' data/measurements/session-01-print-manifest.csv

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

platform-project-kernel-validation-dhall date host lane runtime_capture lane_status kernel_baseline smi_validate phase result:
    python3 scripts/platform/project-kernel-validation-dhall --date "{{date}}" --host "{{host}}" --lane "{{lane}}" --runtime-capture "{{runtime_capture}}" --kernel-lane-status "{{lane_status}}" --kernel-baseline "{{kernel_baseline}}" --smi-validate "{{smi_validate}}" --phase "{{phase}}" --result "{{result}}"

platform-capture-kernel-runtime-local:
    bash scripts/platform/capture-kernel-runtime-local

platform-capture-kernel-lane-status-local:
    bash scripts/platform/capture-kernel-lane-status-local

platform-project-chapel-host-probe-dhall capture date host compiler_source expected_lane result:
    python3 scripts/platform/project-chapel-host-probe-dhall "{{capture}}" --date "{{date}}" --host "{{host}}" --compiler-source "{{compiler_source}}" --expected-lane "{{expected_lane}}" --result "{{result}}"

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

platform-runner-enrollment-status *args:
    bash scripts/platform/runner-enrollment-status {{args}}

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

chapel-host-capture-live target="jess@honey" tag="manual":
    clean_target=$(printf '%s' "{{target}}" | sed 's/^target=//'); clean_tag=$(printf '%s' "{{tag}}" | sed 's/^tag=//'); nix develop --option builders '' path:.#chapel-capture --command bash scripts/platform/capture-chapel-host-probe --target "$clean_target" --tag "$clean_tag"

chapel-host-capture-live-save target="jess@honey" tag="manual":
    clean_target=$(printf '%s' "{{target}}" | sed 's/^target=//'); clean_tag=$(printf '%s' "{{tag}}" | sed 's/^tag=//'); mkdir -p data/captures/honey; nix develop --option builders '' path:.#chapel-capture --command bash scripts/platform/capture-chapel-host-probe --target "$clean_target" --tag "$clean_tag" > "data/captures/honey/chapel-host-probe-$clean_tag.txt"

chapel-host-capture-live-external target="jess@honey" tag="manual":
    clean_target=$(printf '%s' "{{target}}" | sed 's/^target=//'); clean_tag=$(printf '%s' "{{tag}}" | sed 's/^tag=//'); nix develop --option builders '' "$(bash scripts/platform/chapel-source-status --compiler-ref)" --command bash scripts/platform/capture-chapel-host-probe --target "$clean_target" --tag "$clean_tag"

chapel-host-capture-live-save-external target="jess@honey" tag="manual":
    clean_target=$(printf '%s' "{{target}}" | sed 's/^target=//'); clean_tag=$(printf '%s' "{{tag}}" | sed 's/^tag=//'); mkdir -p data/captures/honey; nix develop --option builders '' "$(bash scripts/platform/chapel-source-status --compiler-ref)" --command bash scripts/platform/capture-chapel-host-probe --target "$clean_target" --tag "$clean_tag" > "data/captures/honey/chapel-host-probe-$clean_tag.txt"

chapel-host-capture-live-on-target target="jess@honey" tag="manual":
    clean_target=$(printf '%s' "{{target}}" | sed 's/^target=//'); clean_tag=$(printf '%s' "{{tag}}" | sed 's/^tag=//'); bash scripts/platform/capture-chapel-host-probe-on-target --target "$clean_target" --tag "$clean_tag"

chapel-host-capture-live-save-on-target target="jess@honey" tag="manual":
    clean_target=$(printf '%s' "{{target}}" | sed 's/^target=//'); clean_tag=$(printf '%s' "{{tag}}" | sed 's/^tag=//'); mkdir -p data/captures/honey; bash scripts/platform/capture-chapel-host-probe-on-target --target "$clean_target" --tag "$clean_tag" > "data/captures/honey/chapel-host-probe-$clean_tag.txt"

chapel-host-capture-local tag="manual":
    clean_tag=$(printf '%s' "{{tag}}" | sed 's/^tag=//'); bash scripts/platform/capture-chapel-host-probe-local --tag "$clean_tag"

chapel-host-capture-local-save tag="manual":
    clean_tag=$(printf '%s' "{{tag}}" | sed 's/^tag=//'); mkdir -p data/captures/local; bash scripts/platform/capture-chapel-host-probe-local --tag "$clean_tag" > "data/captures/local/chapel-host-probe-$clean_tag.txt"

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
