# XoxdWM Boundary Audit

This note is the explicit ownership audit between this repo and
`../XoxdWM`.

The point is not to pretend the Dell-7810 lane started here. The point is to
stop accidentally maintaining two fuzzy sources of truth.

## Short conclusion

Three different kinds of material currently exist across the two repos:

- historical source material that was first built in `XoxdWM`,
- current workstation-platform evidence and contracts that belong here,
- XR and deployment machinery that should stay in `XoxdWM`.

The main rule is:

- this repo owns the Dell 7810 host contract and evidence,
- `XoxdWM` owns XR product logic, XR patch carry, and host deployment ops.

## What was already built in XoxdWM

These are not new inventions in this repo. They already existed in
`XoxdWM` and should be treated as historical provenance:

| XoxdWM source | Dell-7810 status | Boundary decision | Notes |
| --- | --- | --- | --- |
| `packaging/scripts/smi-validate` | extracted to `scripts/platform/smi-validate` | Dell owns the workstation-facing copy | The Dell copy is a de-XR, host-oriented derivative, not a new concept. |
| `packaging/tuned/xr-bci/tuned.conf` | extracted to `packaging/tuned/t7810-low-latency/tuned.conf` | Dell owns the generic T7810 posture | The boot and sysctl posture came from the XR/BCI profile; this repo should keep the host-only form. |
| `nix/packages/chapel.nix` | extracted to `nix/packages/chapel.nix` | temporary Dell fallback only | Compiler ownership should move toward the dedicated sibling `chapel` repo, not remain duplicated forever. |
| `analysis/Mason.toml` and the earlier `analysis/examples/DualSocketDemo.chpl` surface | extracted and reshaped under `analysis/` | Dell owns host-characterization variants | The old demo was BCI-oriented; the Dell repo now prefers `HostNumaProbe.chpl` as the canonical host example and keeps `DualSocketDemo` only as a legacy shim. |
| `packaging/rpm/kernel-xr.spec` host-safe config sections | partially extracted into `packaging/kernel/` docs and fragments | Dell owns the generic host baseline | The host-safe pieces should live here as config fragments, not as a full RPM lane. |
| historical T7810 latency findings | imported into `docs/platform/t7810-smi-baseline.md` | Dell owns the historical record for host comparison | Do not rewrite this baseline again unless there is fresh measured data. |

## What this repo should own

These are now first-class Dell-7810 concerns and should stop living as
incidental side effects of `XoxdWM`:

- reset behavior and reset-run evidence for `honey`,
- power-path and multi-PSU documentation,
- BIOS posture and SMI characterization for the Dell 7810 itself,
- generic T7810 host-kernel baseline fragments and validation steps,
- NUMA host inventory and minimal Chapel probes,
- case measurements, printable coupons, and enclosure design evidence.

That means new host evidence should land here first, even if the active host is
also the XR workstation.

## What should stay in XoxdWM

These remain genuinely XR-side concerns:

- `nix/kernel/xr-kernel.nix`
- `patches/bigscreen-beyond-edid.patch`
- `patches/0007-vesa-dsc-bpp.patch`
- XR-specific sections of `packaging/rpm/kernel-xr.spec`
- remote `beyond-*` bring-up and install recipes in `justfile`
- compositor, Monado, sway, OpenXR, and headset test logic
- product-facing support claims about Beyond or XR runtime behavior

These are not generic Dell 7810 host facts. They are display-stack and XR
bring-up artifacts.

## What should be referenced, not copied blindly

These `XoxdWM` files contain real validated host facts, but they are too
operationally entangled to copy into this repo wholesale:

| XoxdWM source | Why it matters | Why it should not be copied as-is |
| --- | --- | --- |
| `packaging/dhall/defaults/honey-stock.dhall` | records a real validated boot baseline on `honey` as of March 16, 2026 | embeds live UUIDs, mount topology, and service/storage assumptions |
| `packaging/dhall/defaults/honey-debug.dhall` | captures an actual debug-boot posture | still part of deployment/boot-entry operations rather than hardware design evidence |
| `packaging/dhall/defaults/honey-xr.dhall` | shows the actual XR boot posture and which parameters were already validated live | mixes host timing posture with XR GPU assumptions and a concrete installed kernel |
| `packaging/dhall/generate-boot.dhall` | formalizes the boot rendering pipeline | this is boot ops plumbing, not workstation platform evidence |
| `packaging/scripts/honey-storage-migrate` | records the real storage migration and thick-LVM invariants for `honey` | operational migration logic with rollback and phase handling, not enclosure/platform R&D |

This is the most important boundary clarification from the audit:

- boot and storage truth for `honey` is still operational truth in `XoxdWM`,
- but workstation hardware evidence and host-contract documents belong here.

If that ops material eventually moves, it should probably move into a dedicated
host-ops lane, not into the mechanical-design repo by default.

## Concrete no-duplication rules

Use these rules when adding new platform work:

1. If the work records what the Dell 7810 hardware does, put it here.
2. If the work changes how `honey` boots or is deployed, keep it in `XoxdWM` unless a separate ops home exists.
3. If the work exists only to make the Beyond or XR stack function, keep it in `XoxdWM`.
4. If a file here is derived from `XoxdWM`, say so in the surrounding docs instead of pretending it was created from scratch.
5. Do not create a second “baseline” note when an older measured baseline already exists; add a dated follow-on measurement instead.
6. If the artifact is raw host evidence or bench geometry evidence, keep the raw
   capture in Dell-7810 and let `XoxdWM` summarize it by reference only.

## Immediate follow-on work

- Keep using `docs/platform/t7810-smi-baseline.md` as the historical floor instead of writing another historical timing note.
- Treat `scripts/platform/smi-validate` and `packaging/tuned/t7810-low-latency/` as Dell-owned derivatives with `XoxdWM` provenance.
- Keep the Chapel compiler lane pointed at the sibling `chapel` repo so the Dell repo does not grow a second permanent compiler packaging surface.
- Do not pull `honey` Dhall boot generations or storage migration scripts into this repo unless the goal is an explicit host-ops extraction.
- When host measurements are taken on `honey`, cross-link them here and only summarize the result in `XoxdWM` if XR work depends on them.
- Use [`../tracking/measured-evidence-map.md`](../tracking/measured-evidence-map.md)
  to keep "measured here" separate from "scaffolded here" and from
  "summarized in XoxdWM".
