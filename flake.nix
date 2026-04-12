{
  description = "Dell 7810 top-hat CAD and fabrication workspace";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
      in
      {
        devShells.default = pkgs.mkShell {
          packages =
            with pkgs;
            [
              git
              jq
              just
              openscad
              python3
            ]
            ++ pkgs.lib.optionals (builtins.hasAttr "freecad" pkgs) [
              pkgs.freecad
            ];

          shellHook = ''
            echo "Dell 7810 CAD shell"
            echo "- OpenSCAD is the geometry source of truth"
            echo "- FreeCAD is optional support tooling if present"
          '';
        };
      });
}
