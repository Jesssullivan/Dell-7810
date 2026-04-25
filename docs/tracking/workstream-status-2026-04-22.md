# Workstream Status -- April 22, 2026

This is the current repo-level status snapshot.

For a file-oriented map of what is actually measured versus still scaffolded,
also use [`measured-evidence-map.md`](measured-evidence-map.md).

For the newer git/issue/symbiosis health check, also use
[`repo-health-reality-check-2026-04-23.md`](repo-health-reality-check-2026-04-23.md).

It is meant to answer five questions quickly:

1. what workstreams exist,
2. where attention has gone so far,
3. what is implemented but still incomplete,
4. what is currently lacking,
5. and what narrower scopes make sense next.

## Short read

The repo is no longer just a mechanical design stub.

It now has five real workstreams:

- case and enclosure measurement,
- printable coupon and CAD handoff scaffolding,
- Dell 7810 host platform and reset characterization,
- kernel/BIOS/latency posture documentation,
- Chapel/NUMA/property-test analysis and publication boundary work.

The strongest parts right now are:

- boundary definition,
- documentation structure,
- host/platform scaffolding,
- and the measurement-to-printable workflow surface.

The weakest parts right now are:

- real bench data,
- enclosure and fan-mod evidence,
- and fully closed validation of the external Chapel compiler branch.

## Current workstreams

## 1. Case and enclosure lane

### What exists

- measurement framework and ordered bench session docs
- expanded Session 01 feature register and priority log
- printable coupon matrix tied to named feature IDs
- safer SCAD apply workflow with evidence gating
- placeholder Session 01 STL family with embedded variant/status labels

### What is incomplete

- `session-01-priority-log.csv` is still `0 / 29` measured
- `measured-params.scad` is still effectively unpopulated for the real OEM
  interfaces
- all current coupon outputs are still placeholders rather than measured
  revisions
- no physical fit results are recorded yet

### Current blocker

Bench execution, not repo structure.

The same applies to the front-fan modification lane: it now has prior-art notes
and candidate parts, but not a measured 7810 inventory yet.

The new follow-on lane for actual candidate testing is now explicit under
`TIN-468`: support matrix first, optional acoustic-lite work second.

## 2. Dell 7810 host platform lane

### What exists

- reset matrix and power/reset research memo for `honey`
- reset-run template and capture script
- NUMA capture script and host inventory template
- live `honey` baseline captures and Dhall inventory records from 2026-04-22
- BIOS settings and power-path inventory templates
- boundary docs for what belongs here versus `XoxdWM`

### What is incomplete

- the reset matrix is still sparse
- BIOS settings are now machine-checked through legacy Dell Command | Configure
  `3.0.0`, but USB emulation is still enabled and `hpet` / `computrace` remain
  unknown through that export surface
- the generic host posture is now closed, but the RT branch is still a gated
  validation lane with a slower recovery profile and an RT-overlay mismatch
- the power-path inventory is still not filled with measured live data

### Current blocker

RT-branch reconciliation and broader measured host evidence, not basic host
reachability.

## 3. Kernel / BIOS / latency lane

### What exists

- generic T7810 host baseline config fragments
- RT overlay fragment
- host cmdline posture
- Dell-owned `smi-validate`
- Dell-owned low-latency tuned profile
- kernel-lane split docs separating host baseline from XR overlay
- imported historical SMI baseline

### What is incomplete

- there is now a bounded current SMI report in this repo, but no current
  `hwlatdetect` trace because `rt-tests` / `hwlatdetect` are still unavailable
- the generic lane is evidence-backed now, and the one-time RT lane is
  evidence-backed under the reconciled Dell validator too
- the RT reboot recovered more slowly and less smoothly than the generic lane

### Current blocker

Deciding whether the slower RT recovery is operationally acceptable and whether
more RT timing work is worth the host time.

## 4. Chapel / NUMA / proof-method lane

### What exists

- Mason workspace under `analysis/`
- host-specific modules:
  `HostNumaTiming` and `TimingProofs`
- property-based tests using `quickchpl`
- canonical Dell-host example:
  `analysis/examples/HostNumaProbe.chpl`
- legacy `DualSocketDemo` shim kept only for compatibility
- publication-safe framing for Chapel and PBT claims
- compiler/source split:
  Dell-local analysis fallback plus sibling `chapel` compiler branch

### What is incomplete

- no green end-to-end local report yet for the full external `chplcheck` build
- one real generic-lane host result now exists from running `HostNumaProbe` on
  `honey`, but there is still no RT-lane Chapel result
- Dell still carries a local Chapel fallback package even though long-term
  compiler ownership should live in the sibling `chapel` repo

### Current blocker

The generic-lane live result and turnkey on-target operator path now both
exist. The remaining Chapel-side decision is how much future NUMA
interpretation should rely on Chapel itself versus the repo's OS-side host
inventory, and whether an RT-lane probe adds real value.

## 5. Boundary / publication / provenance lane

### What exists

- `XoxdWM` boundary audit
- duplication status script
- publication notes, narrative lanes, and claim-traceability docs
- provenance headers on the major extracted host-facing files
- host-specific Chapel naming to reduce semantic overlap with `XoxdWM`

### What is incomplete

- this is mostly policy and documentation right now
- it still needs to be exercised against real writing outputs such as paper
  outlines, figures, and result tables

### Current blocker

The next artifact has to be an actual writing/planning output, not more
meta-boundary prose.

## Where attention has gone so far

Attention has been concentrated on:

- building a trustworthy boundary with `XoxdWM`
- turning vague intentions into scripts, templates, and explicit repo surfaces
- preventing bad workflows, especially around guessed geometry and silent SCAD
  writes
- establishing a host-characterization Chapel lane that can be defended in a
  paper or talk

This was the right first investment because the repo previously lacked clear
ownership and repeatable procedures.

## Where attention has not gone enough

- actual bench measurement time
- actual low-latency validation time on `honey`
- result capture after running the new platform scripts
- first measured coupon revision after Session 01
- first RT-lane host NUMA/latency result note using the Chapel lane

In short:

- the repo is now strong on scaffolding and weak on fresh measured evidence.

The one material exception is that the host-platform lane now has a real live
baseline:

- BIOS `A34` confirmed
- generic `6.19.5-7.xr.el10` confirmed
- RT installed and now boot-validated once on `6.19.5-rt1-8.xr.el10`
- legacy DCC `3.0.0` installed and machine-checked
- USB emulation now set to `disable` and verified after reboot
- active tuned profile now `t7810-low-latency`
- current host cmdline now matches the intended low-latency posture
- kernel baseline now passes `30 / 30` config checks and `19 / 19` cmdline checks
- bounded SMI samples remain nonzero, but tracefs `hwlat` fallback reported
  `0 us` max latency on the post-tuned samples
- the RT lane preserved the same low-latency cmdline posture, and the Dell RT
  validator now passes against the shipped kernel posture on the second RT run

That baseline also exposed a cross-repo truth problem:

- the older `linux-xr-fast`/kernel-supplier wording was easy to read as if
  `honey` were currently live on an RT kernel
- Dell-7810 now carries the explicit audit note for that distinction in
  `docs/platform/honey-kernel-posture-cross-repo-audit-2026-04-22.md`
- as of April 25, 2026, `tinyland-inc/linux-xr` PR `#26` narrows the public
  kernel README so BIOS, SMI, C-state, NUMA, tuned, rollback, and RT host
  acceptance defer back to Dell-7810

## What is cooking in the repo right now

These are the major lanes that exist in the working tree but are not yet
meaningfully "done":

- the whole platform doc and script lane under `docs/platform/`, `scripts/`,
  and `packaging/`
- the Chapel analysis lane under `analysis/`, `nix/`, `.envrc`, `flake.nix`,
  and CI files
- the new publication framing under `docs/publication/`
- the Session 01 measurement and printable lane under `docs/measurements/`,
  `data/measurements/`, `cad/openscad/`, and `output/stl/`

This is a large body of work, but most of it is still pre-commit or
pre-integration state rather than a closed published revision.

## What we are lacking most

If ranked by urgency:

1. real measured case data
2. host validation closure on `honey` after the first live baseline
3. one completed external Chapel compiler validation result
4. one concrete writing artifact that uses the new publication boundaries

Everything else is secondary to those four.

## Linear alignment check

The active Linear project is:

- `Dell 7810 Honey Power & Enclosure Stabilization`
  Status: `Planned`
  Priority: `High`

The current active issue surface is:

- `TIN-337`
  warm-reboot / display-reset stabilization
  Status: `Backlog`
- `TIN-338`
  Dell 7810 PSU and multi-PSU research
  Status: `In Progress`
- `TIN-339`
  reset matrix capture
  Status: `In Progress`
- `TIN-340`
  management-display / out-of-band recovery path
  Status: `In Progress`

There is also one important downstream issue outside this repo's authority:

- `TIN-346`
  first evidence-backed `XoxdWM` VR smoke path on `honey`
  Status: `Todo`

That issue is useful because it makes the repo boundary real:

- Dell-7810 should prove the host is healthy.
- `XoxdWM` should prove the XR software works on that healthy host.

## Repo versus Linear gaps

Linear is currently ahead on naming the April 22 recovery problem, but behind on
representing some of the repo work that now exists.

What Linear already captures well:

- warm-reboot and reset-path instability
- PSU / power-architecture research
- management-display recovery strategy
- the fact that `XoxdWM` needs downstream evidence, not hand-waving
- the newly filed BIOS / kernel authority-import lane under `TIN-397`

What Linear does not yet capture well:

- the Session 01 enclosure execution lane, which is still `0 / 29` measured and
  needs a first evidence-backed coupon revision
- the Dell-owned Chapel / NUMA / PBT lane as a host-characterization method
  surface, especially first live `honey` results
- the fact that the current branch is `TIN-339`-named while the working tree is
  broader than a single reset-matrix slice

Three repo gaps are now explicitly filed:

- `TIN-396` owns the fan and aftermarket-airflow authority import lane
- `TIN-397` owns the BIOS A34 / C-state / `linux-xr` authority import lane
- `TIN-398` owns the cross-repo kernel-posture truth-reconciliation lane

This means the repo is no longer blocked on planning clarity. It is mostly
blocked on execution and on splitting the remaining work into cleaner issue-sized
surfaces.

## Narrower scopes we can focus down to next

These are the sensible next scopes, ordered from most grounded to most
speculative.

## Scope A: Session 01 execution

Do the bench work, fill the CSV, run the evidence/status/apply scripts, and
produce the first measured coupon revision.

This is the best next move if the main goal is to advance the enclosure.

## Scope B: Real host platform capture on `honey`

Run:

- `just platform-capture-numa-state tag=baseline`
- `just platform-bios-rt-check`
- `just platform-smi-validate-full`
- `just platform-capture-reset-state tag=<run>`

Then fill the BIOS, power-path, and host-inventory templates.

This is the best next move if the main goal is to advance the workstation
platform contract.

As of the 2026-04-22 live baseline pass, the first and fourth items have now
been executed remotely enough to produce real JSON captures and Dhall records.
The next hard steps inside Scope B are:

- make `platform-bios-rt-check` truthful on-host by installing or staging `cctk`
- run `platform-smi-validate-full`
- decide whether the generic lane should regain the intended low-latency cmdline

## Scope C: Chapel branch closure

Finish validating the sibling `chapel` packaging branch and reduce the need for
the Dell-local compiler fallback.

This is the best next move if the main goal is compiler/tooling hygiene.

## Scope D: Publication artifact

Draft a paper outline, talk outline, or claim-to-figure/result map using the
new publication notes.

This is the best next move if the main goal is external communication and
research framing.

## Recommendation

The cleanest order from here is:

1. Scope A or Scope B, depending on whether the immediate priority is enclosure
   work or host-platform work
2. then Scope C
3. then Scope D

That order moves the repo from strong scaffolding toward strong evidence before
turning the publication lane into a polished output.
