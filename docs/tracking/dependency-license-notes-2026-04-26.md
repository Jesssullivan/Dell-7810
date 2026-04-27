# Dependency License Notes - 2026-04-26

This is a public-readiness dependency/license boundary note for
`Jesssullivan/Dell-7810`. It is not legal advice.

Repo-owned original work is licensed under `Zlib` via
[`LICENSE.md`](../../LICENSE.md). Dependencies, toolchains, upstream packages,
firmware, vendor documentation, and hardware product names keep their own
licenses and rights.

## Direct Surfaces Checked

| Surface | How this repo uses it | License authority | Current license status |
| --- | --- | --- | --- |
| Chapel `2.8.0` | Fetched by `nix/packages/chapel.nix` for host probes, Mason, and `chplcheck` | Upstream Chapel release license plus this repo's Nix package metadata | Chapel core is `Apache-2.0`; Chapel also ships bundled third-party components under their own licenses. The local Nix package keeps `meta.license = licenses.asl20` for the primary Chapel package and does not change upstream terms. |
| `quickchpl` `1.0.2` | Mason dependency for property-based Chapel tests in `analysis/` | `../quickchpl/LICENSE` and `../quickchpl/Mason.toml`; public source declares the same license | `MIT` |
| `nixpkgs` pinned input `b12141ef619e0a9c1c84dc8c684040326f27cdcc` | Package set for dev shells and Nix packages | `NixOS/nixpkgs` `COPYING` at the pinned revision | `MIT` for the nixpkgs source tree; individual package closures retain their package metadata and upstream licenses. |
| `flake-utils` pinned input `11707dc2f618dd54ca8739b309ec4fc024de578b` | Flake output helper library | `numtide/flake-utils` `LICENSE` at the pinned revision | `MIT` |
| `nix-systems/default` pinned input `da67096a3b9bf56a91d16901293e51ba5b49a27e` | Transitive flake systems list | `nix-systems/default` `LICENSE` at the pinned revision | `MIT` |
| Dev-shell tools from nixpkgs | `direnv`, `git`, `jq`, `just`, `python3`, `graphviz`, `openscad`, optional `freecad` | nixpkgs package metadata and each upstream project | Not vendored here; governed by their package and upstream licenses. |

## Audit Inputs

- SPDX zlib identifier: <https://spdx.org/licenses/Zlib.html>
- Chapel `2.8.0` license file:
  <https://raw.githubusercontent.com/chapel-lang/chapel/2.8.0/LICENSE>
- `quickchpl` public license file:
  <https://raw.githubusercontent.com/Jesssullivan/quickchpl/main/LICENSE>
- `nixpkgs` pinned `COPYING`:
  <https://raw.githubusercontent.com/NixOS/nixpkgs/b12141ef619e0a9c1c84dc8c684040326f27cdcc/COPYING>
- `flake-utils` pinned `LICENSE`:
  <https://raw.githubusercontent.com/numtide/flake-utils/11707dc2f618dd54ca8739b309ec4fc024de578b/LICENSE>
- `nix-systems/default` pinned `LICENSE`:
  <https://raw.githubusercontent.com/nix-systems/default/da67096a3b9bf56a91d16901293e51ba5b49a27e/LICENSE>

## Boundary Rules

- Do not copy dependency license grants into this repository's own license.
- Do not describe Chapel-derived packages as repo-owned code; this repo owns
  the Nix expression and wrapper posture, not Chapel itself.
- Do not describe `quickchpl` as Zlib-licensed unless its upstream project is
  relicensed separately.
- If this repo later vendors third-party source, add the upstream license text
  and a notice before publishing that source.
- If this repo later distributes binary closures, generate a closure-level
  license report from nixpkgs metadata rather than relying on this direct-input
  note.

## Current Public-Readiness Interpretation

The repo can use `Zlib` for its original source, docs, CAD, measurement
templates, and analysis glue while still depending on MIT and Apache-2.0
components. Public-facing wording should say "repo-owned work is Zlib; direct
dependencies retain their upstream licenses."
