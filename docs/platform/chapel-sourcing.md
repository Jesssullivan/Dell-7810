# Chapel Sourcing

This note records where the Chapel toolchain for this repo should come from and
why the answer is currently split.

## Preferred source

The long-term source of truth should be the dedicated Chapel flake in the
sibling `chapel` repo, not a hand-maintained package inside this Dell repo.

That repo already exposes a real Nix surface with:

- `chapel`
- `chapel-gnu`
- `chapel-system-llvm`
- `chapel-llvm18`
- `chapel-llvm19`
- `chapel-llvm20`
- `chapel-llvm21`
- `chapel-dev`

It also carries Attic-backed CI for Darwin and Linux builds, including
`chapel-llvm19` on `aarch64-darwin`.

## Where GloriousFlywheel fits

`GloriousFlywheel` is the infrastructure pattern, not the Chapel package itself.

It provides:

- the cache/publication model,
- the downstream consumer pattern,
- FlakeHub and Attic framing for published flakes.

It does **not** currently expose Chapel as one of its own packages. The actual
Chapel flake surface lives in the sibling `chapel` repo.

## Current gaps in the external Chapel flake

The upstream sibling repo and the active preview packaging branch are now in
different states.

As inspected on April 22, 2026:

- the sibling repo's default branch still presents `2.7.0` as `latest`,
- `chapel-dev` in that repo tracks upstream main rather than the official
  `2.8.0` release,
- its configured Attic cache URL
  `https://nix-cache.fuzzy-dev.tinyland.dev/main` did not resolve on this host
  during verification,
- the committed local packaging branch in the sibling repo can be consumed as:
  `git+file:///Users/jess/git/chapel?ref=chapel-dell-7810-packaging&shallow=1`,
- the preview packaging worktree at
  `path:/tmp/chapel-dell-7810-packaging#chapel-llvm19` now evaluates with
  `2.8.0`, `mason`, `chapel-py`, and `chplcheck`,
- that preview branch intentionally leaves Chapel LSP extras out of the base
  `chapel-py` / `chplcheck` package path for now.

Those gaps matter here because this repo wants:

- `2.8.0` semantics for current Chapel work,
- Mason-managed `quickchpl` dependencies,
- `chplcheck` for lint and proof-structure hygiene.

## Current repo posture

For now, this repo keeps a local Chapel fallback in
[`nix/packages/chapel.nix`](/Users/jess/git/Dell-7810/nix/packages/chapel.nix)
so the analysis lane can keep moving even when the external compiler branch or
cache path is unavailable.

That local package should be treated as transitional infrastructure, not the
desired final ownership boundary.

## Current nixpkgs reality in this repo

This flake intentionally exposes two different Chapel surfaces:

- `packages.chapel`
- `packages."chapel-capture"`

They do not mean the same thing.

`packages.chapel` prefers plain `pkgs.chapel` when the pinned `nixpkgs` input
and the current platform actually provide it. As verified on April 23, 2026:

- for `x86_64-linux`, `.#packages.x86_64-linux.chapel.version` evaluates to
  `2.8.0`
- on the current local Darwin system, plain `pkgs.chapel` is absent in this
  pinned input, so the flake falls back to the repo-local package instead

`packages."chapel-capture"` is different. It is always the Dell-local package
from [`nix/packages/chapel.nix`](/Users/jess/git/Dell-7810/nix/packages/chapel.nix),
with the lighter capture-oriented build settings used by the live host-probe
recipes.

That distinction matters because the live `honey` operator path does not
currently consume plain `pkgs.chapel`; it intentionally goes through the
repo-owned `chapel-capture` surface so the host-characterization lane has a
known toolchain and a place to carry Linux-specific wrapper/runtime fixes.

## Where cacheable runners should fit

The intended long-term split is not "everything builds on `honey`."

It is:

- cacheable Chapel/package validation on the dogfood runner surface,
- published binary/cache reuse where possible,
- and direct `honey` execution only for the hardware-subject part of the work.

In other words, the shared GloriousFlywheel `tinyland-nix` capability class and
its cache-backed build substrate are the right home for:

- `packages.chapel` / `packages."chapel-capture"` build validation,
- `mason`, `quickchpl`, and `chplcheck` parity checks,
- Linux/Darwin package reproducibility,
- and cache publication for repeated compiler builds.

They are not the authority surface for:

- BIOS, SMI, or `hwlat` measurements,
- active kernel lane checks on `honey`,
- `numactl` and host inventory truth,
- or final live Chapel probe results on the dual-socket workstation.

As of April 23, 2026, the checked-in cacheable Chapel CI path has been rewired
toward the shared GloriousFlywheel `tinyland-nix` capability-class contract.
The old `ubuntu-latest` portable lane is retired. `Dell-7810` cannot yet
truthfully reach that shared lane, so the cacheable CI path is not yet live for
this repo. Live GitHub inventory currently shows zero accessible self-hosted
runners for this repo. The current Chapel host-probe recipes still use either:

- direct local `nix develop --option builders '' ...`, or
- direct on-target `nix build` on `honey`

That host-probe continuity posture is separate from the canonical CI path, not
the desired final dogfood shape for cacheable validation.

The repo now carries the workflow split for that shape:

- `.github/workflows/chapel-ci.yml`
  intended canonical shared-lane Chapel CI path once this repo can truthfully
  reach `tinyland-nix`
- `.github/workflows/chapel-dogfood.yml`
  shared-lane cache/publication path that reuses the same Chapel CI helper,
  records the built `chapel` and `chapel-capture` output paths, and publishes
  the flake surface to FlakeHub on `main` once this repo can actually claim the
  shared capability-class lane
- `.github/workflows/chapel-honey-evidence.yml`
  manual `honey` artifact lane for hardware-subject capture

The important policy boundary is that the manual `honey` lane uploads artifacts
only. It should not auto-commit or auto-promote measurements into repo truth.

## Recommended near-term split

- Use the committed sibling Chapel packaging branch as the preferred external
  source for compiler experiments and Darwin packaging validation:
  `git+file:///Users/jess/git/chapel?ref=chapel-dell-7810-packaging&shallow=1#chapel-llvm19`.
- That packaging branch is now published on `origin/chapel-dell-7810-packaging`;
  merge readiness should be judged from full builds, not just flake evaluation.
- Keep the preview worktree only as a fallback surface while iterating on the
  packaging branch:
  `path:/tmp/chapel-dell-7810-packaging#chapel-llvm19`.
- Keep the local Dell fallback for the analysis shell and for repo-local
  continuity when the external compiler branch or cache path is unavailable.
- Promote the preview branch into the sibling `chapel` repo once the full
  package build is green and the ownership boundary is ready.
- Treat LSP packaging as follow-on work; it should not block the CLI `chplcheck`
  or `quickchpl` analysis path.

## Useful commands

For local experiments against the committed sibling Chapel packaging branch:

```bash
nix build 'git+file:///Users/jess/git/chapel?ref=chapel-dell-7810-packaging&shallow=1#chplcheck' --no-link --option builders ''
nix develop 'git+file:///Users/jess/git/chapel?ref=chapel-dell-7810-packaging&shallow=1#chapel-llvm19'
```

For local experiments against the preview Chapel packaging worktree:

```bash
nix build 'path:/tmp/chapel-dell-7810-packaging#chplcheck' --no-link --option builders ''
nix develop 'path:/tmp/chapel-dell-7810-packaging#chapel-llvm19'
```

For local experiments against the sibling Chapel repo:

```bash
nix build 'path:/Users/jess/git/chapel#chapel-llvm19' --no-link
nix develop 'path:/Users/jess/git/chapel#chapel-dev'
```

For the current Dell-local fallback shell:

```bash
nix develop path:.#chapel
```

That shell should be treated as a continuity path for the Dell-host analysis
lane, not as a signal that this repo wants long-term co-equal compiler
ownership with the sibling `chapel` repo.

When the Chapel flake is published through the preferred public channel, replace
the local `path:` reference above with the published flake URL.

For this workstation, prefer `--option builders ''` when validating the
compiler branch locally. It avoids remote-builder stalls and keeps the result
closer to the behavior of the local Dell analysis shell.

Expect the full `chplcheck` build to take a while on Darwin. Even with `-L`,
the client can appear quiet while Nix is compiling the Chapel compiler itself
with local `clang++` workers.
