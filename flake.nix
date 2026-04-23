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
        chapel =
          if pkgs.stdenv.isDarwin
            && (builtins.hasAttr "chapel" pkgs)
            && pkgs.lib.meta.availableOn pkgs.stdenv.hostPlatform pkgs.chapel
          then pkgs.chapel
          else pkgs.callPackage ./nix/packages/chapel.nix { };
        chapelCapture = pkgs.callPackage ./nix/packages/chapel.nix {
          buildMason = false;
          buildChplcheck = false;
        };
        commonPackages =
          with pkgs;
          [
            direnv
            git
            jq
            just
            python3
          ];
        cadPackages =
          with pkgs;
          [
            openscad
          ]
          ++ pkgs.lib.optionals (
            (builtins.hasAttr "freecad" pkgs)
            && pkgs.lib.meta.availableOn pkgs.stdenv.hostPlatform pkgs.freecad
          ) [
            pkgs.freecad
          ];
      in
      {
        packages.chapel = chapel;
        packages."chapel-capture" = chapelCapture;

        devShells.default = pkgs.mkShell {
          packages = commonPackages ++ cadPackages;

          shellHook = ''
            echo "Dell 7810 CAD shell"
            echo "- OpenSCAD is the geometry source of truth"
            echo "- FreeCAD is optional support tooling if present"
          '';
        };

        devShells.chapel = pkgs.mkShell {
          packages = commonPackages ++ cadPackages ++ [ chapel ];

          shellHook = ''
            echo "Dell 7810 Chapel shell"
            echo "- Chapel 2.8.0 is available for NUMA and timing work"
            echo "- Mason and chplcheck should be on PATH"
            echo "- Run: just chapel-host-setup"
            echo "- Run: just chapel-host-build"
            echo "- Run: just chapel-host-test"
            echo "- Run: just chapel-host-demo"
          '';
        };

        devShells.chapel-capture = pkgs.mkShell {
          packages = commonPackages ++ [ chapelCapture ];

          shellHook = ''
            echo "Dell 7810 Chapel capture shell"
            echo "- Minimal local shell for HostNumaProbe compilation and remote capture"
            echo "- Avoids pulling CAD tooling into the live host probe path"
          '';
        };
      });
}
