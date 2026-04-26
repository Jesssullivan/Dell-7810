# Power Path Inventory Template

Use this template to turn the current `honey` power arrangement into a measured, reviewable contract.

The goal is to stop describing the workstation as "Dell PSU plus external ATX assist" and instead record exactly what starts, powers, and resets what.

## Metadata

- Date:
- Owner issue:
- Host:
- Operator:

## PSU inventory

### Dell primary PSU

- Model:
- Rated wattage:
- Dell part number:
- Present harnesses:
- Distribution board part number:
- Notes:

### External or secondary PSU

- Model:
- Rated wattage:
- Form factor:
- Output cables installed:
- Notes:

## Current power consumers

- Motherboard and chassis:
- GPU slot power:
- GPU auxiliary PCIe power:
- Storage:
- Fans:
- Any other attached loads:

## Physical routing

- Where the external PSU sits relative to the chassis:
- How its cables enter the system:
- Whether the current cable route affects panel removal:
- Photos or sketches:

## Start and reset behavior

- What signal or event causes the external PSU to start:
- Is there a dedicated sync board:
- If yes, what board and how is it wired:
- If no, what improvised or inferred trigger is being used:
- What causes the external PSU to stop:
- Does a warm reboot leave any PSU or rail alive unexpectedly:

## GPU power detail

- GPU model:
- Number of auxiliary PCIe connectors used:
- Connector style: 6-pin / 8-pin / 12V-2x6 / adapter:
- Are separate PSU leads used for each connector: yes / no
- Any daisy-chained or pigtailed branches present:
- Any Dell proprietary header or adapter chain present:
- Which PSU feeds each connector:
- Cable part numbers or labels:
- Photos:

## Distribution-board and rail questions

- Which rails are definitely native Dell:
- Which rails are definitely external ATX:
- Which connections are still inferred rather than traced:
- Any suspected rail imbalance or weak link:

## Reset observations tied to this topology

- Known good behavior:
- Known bad behavior:
- Does hard AC break recover states that soft reboot does not:
- Related reset-matrix run IDs:

## Evidence bundle

- Photo IDs:
- Connector close-ups:
- Harness labels:
- Any continuity or voltage checks performed:
- Explicit unknowns still remaining:

## Outcome

- What this inventory now proves:
- What remains unsafe to assume:
- Next hardware or measurement step:
