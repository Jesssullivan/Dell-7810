# Host Inventory Template

Use this template when establishing a clean workstation baseline for `honey`.

Pair it with:

- [`scripts/platform/capture-numa-state`](/Users/jess/git/Dell-7810/scripts/platform/capture-numa-state)
- [`scripts/platform/capture-reset-state`](/Users/jess/git/Dell-7810/scripts/platform/capture-reset-state)

## Metadata

- Date:
- Owner issue:
- Host:
- Operator:
- Intended purpose:

## Inventory capture

Run:

```bash
just platform-capture-numa-state tag=baseline-<run-id>
just platform-save-numa-state-json tag=baseline-<run-id>
```

Paste or attach the output here:

```text
<numa-state capture>
```

## Summary

- BIOS version:
- Board name:
- CPU model:
- Total RAM:
- NUMA nodes observed:
- CPUs per NUMA node:
- Any asymmetry worth noting:

## Kernel posture

- Kernel version:
- Generic host-latency baseline in use: yes / no
- RT overlay in use: yes / no
- Current boot cmdline source:
- Current tuned profile:

## Notes

- Any discrepancy between expected and observed topology:
- Any missing tools during capture:
- Follow-up measurement to take next:

Machine-readable note:

- the saved JSON capture in `output/capture-json/` can be referenced from the
  Dhall host-inventory records under `dhall/defaults/`
- to seed a Dhall record from that capture, run:

```bash
just platform-project-host-inventory-dhall output/capture-json/numa-<run-id>.json
```
