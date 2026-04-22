# Duplication Status

This note records the current overlap between this repo and `XoxdWM`.

It only measures the Dell-7810 versus `XoxdWM` split. For the separate Chapel
compiler ownership boundary, use [`chapel-sourcing.md`](chapel-sourcing.md).

As of April 22, 2026, the important result is:

- the checked extracted host surfaces are **not** exact duplicates,
- but several are still clearly **derived forks** of earlier `XoxdWM` code,
- and some important operational surfaces are **still intentionally anchored in
  `XoxdWM`**.

## Current checked duplicate pairs

Run the current local status check with:

```bash
just platform-xoxdwm-duplication-status
```

That script currently checks these pairs:

- `packaging/scripts/smi-validate` -> `scripts/platform/smi-validate`
- `packaging/tuned/xr-bci/tuned.conf` -> `packaging/tuned/t7810-low-latency/tuned.conf`
- `nix/packages/chapel.nix` -> `nix/packages/chapel.nix`
- `analysis/examples/DualSocketDemo.chpl` -> `analysis/examples/DualSocketDemo.chpl`
- `analysis/Mason.toml` -> `analysis/Mason.toml`

The present expectation is that these are derived forks, not byte-identical
copies.

## Current state

### Derived forks that still exist

- `scripts/platform/smi-validate`
- `packaging/tuned/t7810-low-latency/tuned.conf`
- `nix/packages/chapel.nix`
- `analysis/examples/DualSocketDemo.chpl`
- `analysis/Mason.toml`

These are acceptable for now because they have diverged in purpose:

- the Dell copies are narrower and host-facing,
- the `XoxdWM` copies still sit closer to XR/BCI product and deployment work.

### Dell-only surfaces

These now exist here without a current `XoxdWM` peer:

- reset-run capture and templates
- NUMA capture and host-inventory scaffolding
- the reset matrix and power-path research notes
- the entire case-measurement and printable-coupon lane
- `HostNumaTiming`, `TimingProofs`, and the current property-based tests

### XoxdWM-anchored surfaces

These still should not be copied here wholesale:

- `packaging/dhall/defaults/honey-stock.dhall`
- `packaging/dhall/defaults/honey-debug.dhall`
- `packaging/dhall/defaults/honey-xr.dhall`
- `packaging/dhall/generate-boot.dhall`
- `packaging/scripts/honey-storage-migrate`
- `nix/kernel/xr-kernel.nix`

These are still the active operational or XR-overlay truth surfaces.

## Provenance hardening (2026-04-22)

As of April 22, 2026, the following provenance fixes have been applied:

- `scripts/platform/smi-validate`: header updated from "derived from XoxdWM"
  to "Dell-owned host validator; originally developed in XoxdWM, formalized here"
- `nix/packages/chapel.nix`: header corrected to "Dell-local fallback for
  analysis continuity; prefer the sibling `chapel` repo for long-term compiler
  ownership"
- `XoxdWM/nix/packages/chapel.nix`: header now marks itself as a deployment
  fallback, but still points at Dell-7810 as canonical; that should be
  normalized toward the sibling `chapel` repo in follow-on cross-repo cleanup
- `XoxdWM/packaging/scripts/dcc-configure-rt`: header updated to point at the
  Dell-owned host-platform copy
- `XoxdWM/docs/research/t7810-smi-baseline.md`: deprecation note added; future
  SMI measurements go to Dell-7810

Cross-repo discoverability was also added:
- both READMEs now link to the sibling repo
- 6 XoxdWM proof/support docs now have evidence anchors pointing to Dell-7810
  for hardware claims
- `docs/platform/authority-map.md` provides a single lookup surface

## What to de-duplicate next

The next sensible de-duplication targets are:

1. Chapel fallback packaging:
   reduce dependence on the Dell-local fallback once the sibling `chapel` repo
   is fully canonical for compiler work.
2. Legacy Chapel aliases:
   the Dell repo now prefers `HostNumaProbe.chpl` plus `chapel-host-*` recipe
   names; retire the old `DualSocketDemo` and plain `chapel-*` aliases once no
   local workflows depend on them.
3. Shared host posture extraction:
   if XoxdWM keeps Dell-specific boot constants inline, extract shared host
   inputs rather than moving boot-entry ops into this repo.
4. Platform schema extraction:
   the T7810 hardware type definition in XoxdWM is a candidate for a shared
   host/schema surface, not an automatic Dell-7810 move.

As of April 22, 2026, the first Dhall extraction step is now real on the
`XoxdWM` side:

- `packaging/dhall/HostFacts.dhall` now holds stable host identity/topology
  facts for `honey`
- `packaging/dhall/HostTiming.dhall` now holds reusable Dell timing and
  isolation posture fragments
- `Platform.dhall`, `BootParams.dhall`, and `defaults/honey-xr.dhall` now
  consume those narrower surfaces instead of repeating the Dell posture inline

## What not to de-duplicate yet

- Do not move the `honey` boot and storage ops lane into this repo just to
  reduce duplication metrics.
- Do not merge the XR kernel overlay into the generic Dell host baseline.
- Do not remove provenance headers from derived files; those are part of the
  boundary hardening.
