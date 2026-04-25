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

platform-stage-legacy-dcc:
    bash scripts/platform/stage-legacy-dcc-7810

platform-stage-legacy-dcc-remote target="jess@honey":
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

platform-project-kernel-validation-dhall date host lane runtime_capture lane_status kernel_baseline smi_validate phase result:
    python3 scripts/platform/project-kernel-validation-dhall --date "{{date}}" --host "{{host}}" --lane "{{lane}}" --runtime-capture "{{runtime_capture}}" --kernel-lane-status "{{lane_status}}" --kernel-baseline "{{kernel_baseline}}" --smi-validate "{{smi_validate}}" --phase "{{phase}}" --result "{{result}}"

platform-capture-kernel-runtime-local:
    bash scripts/platform/capture-kernel-runtime-local

platform-capture-kernel-lane-status-local:
    bash scripts/platform/capture-kernel-lane-status-local

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

platform-tuned-status-remote target="jess@honey":
    clean_target=$(printf '%s' "{{target}}" | sed 's/^target=//'); bash scripts/platform/remote-tuned-control status --target "$clean_target"

platform-tuned-install-profile-remote target="jess@honey":
    clean_target=$(printf '%s' "{{target}}" | sed 's/^target=//'); bash scripts/platform/remote-tuned-control install-profile --target "$clean_target"

platform-tuned-activate-profile-remote target="jess@honey":
    clean_target=$(printf '%s' "{{target}}" | sed 's/^target=//'); bash scripts/platform/remote-tuned-control activate-profile --target "$clean_target"

platform-tuned-recommend-profile-remote target="jess@honey":
    clean_target=$(printf '%s' "{{target}}" | sed 's/^target=//'); bash scripts/platform/remote-tuned-control recommend-profile --target "$clean_target"
