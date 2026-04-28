# BIOS Settings Record Template

Use this after validating the real T7810 BIOS posture with:

```bash
just platform-bios-rt-check
```

If Dell Command | Configure is available on the host, paste the actual result rather than paraphrasing it.

On legacy Dell Command | Configure `3.0` surfaces, the repo check may report the
mapped field names `usbemu`, `cstatesctrl`, `turbomode`, and `speedstep`
instead of the newer `usblegacy`, `cstates`, `intelturboboosten`, and
`intelspdstep`.

## Metadata

- Date:
- Owner issue:
- Host:
- Operator:
- BIOS version:
- BIOS date:

## Captured settings

| Setting | Expected | Observed | Source | Notes |
| --- | --- | --- | --- | --- |
| `usblegacy` | `disabled` | | `cctk` / manual BIOS check | |
| `cstates` | `c1` | | `cctk` / manual BIOS check | |
| `intelturboboosten` | `disabled` | | `cctk` / manual BIOS check | |
| `intelspdstep` | `disabled` | | `cctk` / manual BIOS check | |
| `hpet` | `enabled` | | `cctk` / manual BIOS check | |
| `computrace` | `deactivate` | | `cctk` / manual BIOS check | |

## Full check output

```text
<paste platform-bios-rt-check output here>
```

## Manual BIOS notes

- Any settings that could not be read via `cctk`:
- Any settings only verified manually in firmware setup:
- Any mismatch between expected and observed values:

## Impact on host posture

- Does the BIOS posture match the low-latency target: yes / no
- Is a reboot still pending: yes / no
- Does this record unlock a new SMI or reset validation run: yes / no

## Follow-up

- next validation command:
- next measurement to collect:
