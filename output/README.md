# Output Conventions

Generated artifacts belong here.

- `output/dxf/`: flat patterns for laser cutting
- `output/stl/`: prototype prints and visualization exports
- `output/step/`: exchange geometry for vendors or mechanical review
- `output/pdf/`: drawings, bend callouts, or assembly sheets

Only commit generated outputs that correspond to a tagged model revision or a prototype that was actually built.

Public candidate branches should prefer source plus recipes over generated mesh
noise. Session 01 placeholder coupons are generated with
`just fit-coupons-session-01` and are ignored by default until a measured or
built revision is intentionally promoted.
