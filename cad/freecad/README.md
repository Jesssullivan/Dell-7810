# FreeCAD Notes

FreeCAD is intentionally secondary in this repo.

Use it for:

- inspecting exported geometry,
- generating STEP or drawing outputs when OpenSCAD alone is awkward,
- reviewing fit-check imports against scans or manually traced references.

Avoid using it as a separate source of parametric truth for core enclosure geometry. If a dimension changes, the change should originate in the OpenSCAD parameters or source modules.
