# Reset Run Template

Use this template for every new `honey` reset experiment so the matrix stops depending on freehand notes.

Pair it with:

- [`docs/research/honey-reset-matrix-2026-04-22.md`](../research/honey-reset-matrix-2026-04-22.md)
- [`scripts/platform/capture-reset-state`](/Users/jess/git/Dell-7810/scripts/platform/capture-reset-state)

## Metadata

- Owner issue:
- Run ID:
- Date:
- Operator:
- Host:
- Branch or config context:

## Topology under test

- Dell HDMI attached: yes / no
- Beyond attached: yes / no
- External or secondary ATX path: enabled / disabled / modified
- GPU power cabling notes:
- Other relevant hardware state:

## Before reset

Capture a state bundle before touching the machine:

```bash
just platform-capture-reset-state tag=before-<run-id>
just platform-save-reset-state-json tag=before-<run-id>
```

Record:

- `who -b`
- `uname -r`
- `uptime`
- DRM connector state
- current filtered kernel markers
- whether SSH and Tailscale are healthy before the run

Paste or attach the output here:

```text
<before-reset capture>
```

## Reset action

Record exactly one:

- controlled warm reboot
- OS shutdown followed by front-panel power-on
- manual hard reset
- full AC removal and restore

Execution notes:

- exact command or manual action:
- whether AC was broken:
- approximate start time:
- approximate boot-return time:
- anything unusual during shutdown:

## After reset

Capture the same state again:

```bash
just platform-capture-reset-state tag=after-<run-id>
just platform-save-reset-state-json tag=after-<run-id>
```

Paste or attach the output here:

```text
<after-reset capture>
```

## Outcome summary

- HDMI-A-2 result:
- DP-2 result:
- bad amdgpu markers present: yes / no
- LAN SSH returned cleanly: yes / no
- Tailscale returned cleanly: yes / no
- overall result: pass / fail / partial

## Matrix row candidate

| Run | Date and evidence window | Reset / trigger path | AC power break | HDMI-A-2 | DP-2 | Kernel markers | Remote operability | Outcome |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `<run-id>` | | | | | | | | |

## Interpretation

- What this run tells us:
- What this run does not prove:
- Whether this unlocks a change in power, reset, or kernel posture:

## Follow-up

- next run:
- next hardware change:
- next software or kernel check:

Machine-readable note:

- the saved JSON captures in `output/capture-json/` can be referenced from the
  Dhall reset-run records under `dhall/defaults/`
- to seed a Dhall reset-run record from a saved capture, run:

```bash
just platform-project-reset-run-dhall output/capture-json/reset-<run-id>.json <run-id> warm-reboot partial false
```
