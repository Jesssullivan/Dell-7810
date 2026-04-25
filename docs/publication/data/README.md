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

Regenerate with:

```sh
just publication-honey-rt-packet-csv
```
