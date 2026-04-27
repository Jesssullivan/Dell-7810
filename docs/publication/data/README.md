# Publication Data

This directory stores small, derived data tables for paper, blog, and
presentation figures.

Derived tables must point back to raw captures and should not become a parallel
measurement authority.

Current tables:

- `honey-rt-smi-chapel-packet-2026-04-25.csv`: extracted from the first paired
  generic/RT SMI, `hwlat`, and Chapel host-characterization packet documented
  in the
  [result note](../../platform/honey-rt-smi-hwlat-chapel-series-2026-04-25.md).
- `honey-generic-rt-repeat-packet-2026-04-26.csv`: derived summary of the
  matched 2026-04-26 generic and RT repeat packets, including 120s SMI /
  `hwlat` windows and five-sample Chapel repeat distributions documented in
  [`../../platform/honey-generic-host-characterization-window-2026-04-26.md`](../../platform/honey-generic-host-characterization-window-2026-04-26.md),
  [`../../platform/honey-rt-host-characterization-window-2026-04-26.md`](../../platform/honey-rt-host-characterization-window-2026-04-26.md),
  and
  [`../../platform/honey-rt-chapel-repeat-2026-04-26.md`](../../platform/honey-rt-chapel-repeat-2026-04-26.md).
- `honey-public-capture-index-2026-04-26.csv`: raw `honey` capture inventory
  with publicization-sensitive finding counts and suggested public action.
  This table supports public branch preparation and is not a measurement
  result.

Regenerate with:

```sh
just publication-honey-rt-packet-csv
just public-capture-index
```
