# Extant Art And External References

This note captures the most relevant current references for the first design pass. It focuses on three things:

- what Dell officially designed the chassis for,
- what commercial cable pass-through hardware families already exist,
- and what fabrication constraints should shape the CAD workflow from the beginning.

## 1. OEM chassis constraints

### Dell Precision Tower 7810 owner's manual

Source:

- https://www.dell.com/support/manuals/en-us/precision-t7810-workstation/precision_t7810_om_pub/technical-specifications
- https://www.dell.com/support/manuals/en-us/precision-t7810-workstation/precision_t7810_om_pub/removing-the-computer-cover

Relevant facts:

- Dell specifies support for up to two full-height, full-length GPUs, but only up to a single 225 W class card.
- Official PSU configurations are 685 W or 825 W.
- Official physical dimensions are 416.90 mm high with feet, 172.60 mm wide, and 471.00 mm deep.
- Cover removal is explicitly a latch release followed by lifting the cover to about 45 degrees before removal.

Implication:

- The target build is well outside Dell's original power and enclosure intent, and the original cover motion itself is part of the interference problem. The replacement design should not assume OEM hinge-path behavior is worth preserving unless it directly helps serviceability.

## 2. Cable pass-through hardware families

### McMaster-Carr brush grommets and cable entry panels

Sources:

- https://www.mcmaster.com/products/table-grommets/
- https://www.mcmaster.com/products/rectangular-grommets/

Relevant families:

- Brush-seal furniture grommets: useful as a reference for low-cost brushed cable exits, especially for prototype bezels or non-sealed cable openings.
- Wraparound cable entry panels: modular split-entry parts that can be installed around existing terminated cables. McMaster's listed surface-mount panels include NEMA 12 / IP54 rated options with multiple insert layouts.

Concrete examples seen in current catalog data:

- `2807N11`: round brush-seal furniture grommet for a 3 inch hole. Good reference point for prototype cable bezels, not a strong final-industrial candidate by itself.
- `1016N149`: surface-mount wraparound cable entry panel with 2 small plus 1 large insert positions, about 3.9 x 2.3 inch overall footprint.
- `1016N152`: surface-mount wraparound panel with 2 small plus 2 large inserts, about 5.8 x 2.3 inch footprint.
- `1016N159`: surface-mount wraparound panel with 4 small plus 1 large inserts, about 4.7 x 2.3 inch footprint.
- `1016N14`: surface-mount wraparound panel with 4 small inserts, about 2.9 x 2.3 inch footprint.

Implication:

- McMaster is likely useful for early prototyping, off-the-shelf split entry parts, and fasteners. It is less likely to be the best final brushed opening if the design needs a very large clean industrial brush frame.

### icotek brush pass-through products

Sources:

- https://www.icotek.com/en-gb/products/brush-cable-pass-through
- https://www.icotek.com/en-us/products/brush-cable-pass-through/kel-bes-s
- https://www.icotek.com/en-us/products/brush-cable-pass-through/bes

Relevant families:

- `KEL-BES-S`: split brush plates that can be installed around already-routed cables and that match standard industrial connector cutout dimensions.
- `BES 10` and `BES 19`: rack-oriented brush strips with published sizes of 254 mm and 482 mm lengths.
- `KDR-BES-U`: universal clamp-profile brush strip for custom cut edges; icotek states it can clamp to 1.5-2 mm sheet edges and can work even on 90-degree bent sheet geometry.

Concrete examples seen in current catalog data:

- `BES 10`, part `51501`: 254 mm long, 12 mm wide, 44.5 mm high.
- `BES 19`, part `51500`: 482 mm long, 12 mm wide, 44.5 mm high.
- `KEL-BES-S`: available around standard 10-pin, 16-pin, and 24-pin industrial connector cutout families.
- icotek publishes CAD downloads for at least some of these families, which is useful for envelope checking before purchase.

Implication:

- icotek looks like the strongest candidate family for a custom enclosure because it already serves server racks, enclosures, and machine walls rather than furniture. `KDR-BES-U` is especially interesting if the custom panel ends up with a long straight cable slot in 1.5-2.0 mm sheet.

## 3. Fabrication guidance

### SendCutSend bending guidance

Source:

- https://sendcutsend.com/faq/how-to-prevent-bend-deformation/

Relevant guidance:

- keep cut features away from bend lines,
- meet minimum flange-length requirements,
- add bend reliefs when nearby cuts would weaken the form.

Implication:

- The cable pass-through should not be placed casually near a primary roof-to-side bend. If the pass-through and the bend compete for the same real estate, the design should split into multiple parts rather than force a weak bend zone.

## 4. Preliminary shortlist

### Best current direction for brushed cable exits

1. `icotek KDR-BES-U` if the design uses a long custom slot and sheet thickness lands in the supported clamp range.
2. `icotek KEL-BES-S` if the design benefits from a framed split brush plate tied to an industrial connector cutout pattern.
3. McMaster split cable-entry panels if dust control and terminated-cable serviceability matter more than a purely brushed opening.

### Best current direction for OEM interface reuse

1. Reuse the lower rail/tongue geometry first.
2. Validate the top quick-release latch with printed coupons before committing to it in metal.
3. If the increased shell height creates too much leverage, keep the lower OEM interface and move the top retention to screws or captive quarter-turn hardware.

## 5. Open research items

- Which exact cable bundle must fit through the opening at maximum configuration:
  ATX 24-pin, EPS 8-pin, PCIe 8-pin groups, fan leads, and any future sense leads should be measured as a bundle rather than guessed.
- Whether the external PSU should physically mount to the shell or only align with it.
- Which metal vendor and bend rules will define final flat-pattern tolerances.
- Whether a partially sealed cable-entry system is worth the cost versus a large brush opening plus dust filters elsewhere.

## 6. Notes on confidence

- Dell manual references are primary and should be treated as authoritative for OEM envelope and intended cover motion.
- icotek and McMaster references are primary product sources.
- The shortlist above is an engineering inference from those sources, not a final procurement decision.
