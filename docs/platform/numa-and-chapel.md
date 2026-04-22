# NUMA And Chapel

This note explains what should be extracted from `XoxdWM` for Dell 7810 NUMA work and what should stay there.

## Why Chapel belongs here at all

The Dell 7810 is a dual-socket NUMA workstation. That topology is part of the hardware platform, not just an application detail.

The official Chapel locale documentation describes locales as units with processing and storage capabilities where local access is cheaper than remote access:

- https://chapel-lang.org/docs/language/spec/locales.html

That maps naturally to the T7810 question:

- can a simple Chapel workload see and use the platform's locality structure predictably?

That question belongs in this repo.

## What has already been extracted

- a repo-local Chapel fallback package:
  [`nix/packages/chapel.nix`](/Users/jess/git/Dell-7810/nix/packages/chapel.nix)
- a minimal dual-socket probe:
  [`analysis/examples/HostNumaProbe.chpl`](/Users/jess/git/Dell-7810/analysis/examples/HostNumaProbe.chpl)
- a top-level Chapel workspace with Mason and proof-oriented tests:
  [`analysis/README.md`](/Users/jess/git/Dell-7810/analysis/README.md)
  [`analysis/Mason.toml`](/Users/jess/git/Dell-7810/analysis/Mason.toml)
  [`analysis/test/TestHostNumaTiming.chpl`](/Users/jess/git/Dell-7810/analysis/test/TestHostNumaTiming.chpl)

`analysis/examples/DualSocketDemo.chpl` now exists only as a compatibility shim
for older references and local commands.

The preferred long-term compiler source is the dedicated Chapel flake, not the
fallback package in this repo. See
[`chapel-sourcing.md`](chapel-sourcing.md).

## What should stay in XoxdWM

These remain application-side concerns:

- BCI-specific Chapel analysis modules,
- Mason project structure coupled to software pipelines,
- offline analysis tied to compositor or UI workflows,
- benchmark claims that are really product-facing rather than host-characterization data.

## What this repo should add next

- a host inventory capture note:
  `lscpu -e`, `numactl --hardware`, `numastat`, and memory population notes.
- a single-locale vs dual-locale comparison on `honey`.
- one memory-locality-sensitive probe, not just a compute loop.
- issue-linked result notes with exact kernel, BIOS, and boot parameters.

## What not to do

- do not move the whole BCI analysis project here just because the workstation has two sockets.
- do not treat the existing demo as a performance claim.
- do not mix NUMA host characterization with XR application benchmarks in the same note.

## Immediate use

Use Chapel here as a hardware probe:

- verify that the runtime sees the expected locality structure,
- compare host postures across kernels or BIOS settings,
- and establish a reproducible baseline before any larger analysis stack is moved.

The repo now also includes a basic host inventory path via:

- [`scripts/platform/capture-numa-state`](/Users/jess/git/Dell-7810/scripts/platform/capture-numa-state)
- [`docs/platform/host-inventory-template.md`](host-inventory-template.md)

For the current extraction status versus `XoxdWM`, see
[`xoxdwm-boundary-audit.md`](xoxdwm-boundary-audit.md).
