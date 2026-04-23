# Chapel Live Host Result Template

Owner issue: `TIN-470`
GitHub mirror: `#21`

Use this for the first Dell-owned live Chapel host result on `honey`.

This note is meant to capture a real host result, not just a successful local
build.

## Summary

- date:
- host:
- operator:
- compiler source used:
- Chapel version:
- kernel:
- tuned profile:
- expected lane:

## Commands

- build command:
- run command:
- just target, if used:

## Host context

- `uname -a`:
- `lscpu` summary:
- `numactl --hardware` summary:
- current cmdline posture summary:

## Probe result

- `HostNumaProbe` output summary:
- locales:
- sublocales:
- partition result:
- timing proof result:
- serial vs parallel summary:

## Interpretation

- what this proves:
- what this does **not** prove:
- whether this result is generic-lane or PREEMPT_RT-lane evidence:
- which RT contract claims it informs:
  normally this should stop short of C4 unless a downstream software result also exists

## Follow-on

- next Chapel-specific action:
- next host-validation action:
- whether the Dell-local Chapel fallback is still needed after this run:
