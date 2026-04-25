# Publication Figures

This directory stores Graphviz source for paper, blog, and presentation figures.

Render all figures with:

```sh
nix develop .#publication -c just publication-figures-render
```

The renderer writes SVGs to `docs/publication/figures/rendered/`.

Current sources:

- [`bow2-module-architecture.dot`](bow2-module-architecture.dot): Chapel source
  and PBT module relationships.
- [`bow3-claim-ladder-authority.dot`](bow3-claim-ladder-authority.dot):
  C0-C4 claim ladder and repo authority split.
- [`bow5-host-probe-pipeline.dot`](bow5-host-probe-pipeline.dot): Nix + Chapel
  + Dhall host-probe evidence pipeline.

Graphviz is intentionally source-controlled; rendered SVGs can be regenerated.
