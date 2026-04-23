# Chapel 2.8.0 -- parallel programming language for NUMA exploration
#
# Dell-local fallback package for Chapel 2.8.0 on the T7810 dual-socket Xeon.
# Originally developed in XoxdWM/nix/packages/chapel.nix, then formalized here
# so the host-analysis lane can keep moving.
# The preferred long-term compiler source is the dedicated sibling `chapel`
# repo; keep this package as a continuity surface, not a permanent ownership
# claim.
#
# Build posture for the Dell T7810 dual-socket Xeon:
#   CHPL_TASKS=qthreads    -- required for NUMA sublocale support
#   CHPL_LOCALE_MODEL=flat -- single-locale default with NUMA at runtime
#   CHPL_COMM=none         -- single-node host characterization
#   CHPL_LLVM=system       -- stable codegen via Nix LLVM

{ lib
, stdenv
, fetchurl
, python3
, llvmPackages_18
, gmp
, pkg-config
, which
, perl
, bash
, cmake
, makeWrapper
, buildMason ? true
, buildChplcheck ? true
}:

stdenv.mkDerivation rec {
  pname = "chapel";
  version = "2.8.0";

  src = fetchurl {
    url = "https://github.com/chapel-lang/chapel/releases/download/${version}/chapel-${version}.tar.gz";
    hash = "sha256-gOjDAY4z5JZ0x6JULgYlR+pB1k1lle2zt5npDIj5Y/g=";
  };

  dontUseCmakeConfigure = true;

  nativeBuildInputs = [ python3 pkg-config which perl bash cmake makeWrapper ];
  buildInputs = [ gmp llvmPackages_18.llvm llvmPackages_18.clang llvmPackages_18.libclang ];

  CHPL_LLVM = "system";
  CHPL_TASKS = "qthreads";
  CHPL_LOCALE_MODEL = "flat";
  CHPL_COMM = "none";
  CHPL_RE2 = "bundled";
  CHPL_GMP = "system";
  CHPL_HOST_COMPILER = "llvm";
  CHPL_TARGET_COMPILER = "llvm";
  CHPL_HOST_CC = "${llvmPackages_18.clang}/bin/clang";
  CHPL_HOST_CXX = "${llvmPackages_18.clang}/bin/clang++";
  CHPL_TARGET_CC = "${llvmPackages_18.clang}/bin/clang";
  CHPL_TARGET_CXX = "${llvmPackages_18.clang}/bin/clang++";

  postPatch = ''
    # Chapel's configure path shells out through util/printchplenv.
    # Normalize shipped interpreter directives so Linux Nix builds on honey
    # do not depend on /usr/bin/env existing inside the sandbox.
    patchShebangs util
  '';

  preBuild = ''
    export CHPL_HOME=$PWD
    export CHPL_LLVM_CONFIG=${llvmPackages_18.llvm.dev}/bin/llvm-config
  '';

  buildPhase = ''
    runHook preBuild
    make -j$NIX_BUILD_CORES
    ${lib.optionalString buildMason "make mason"}
    ${lib.optionalString buildChplcheck "make chplcheck"}
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{bin,lib,share/chapel}

    cp -r lib $out/

    cp -r modules $out/share/chapel/
    cp -r runtime $out/share/chapel/ 2>/dev/null || true
    cp -r make $out/share/chapel/ 2>/dev/null || true
    cp -r util $out/share/chapel/ 2>/dev/null || true
    cp -r third-party $out/share/chapel/ 2>/dev/null || true
    cp -r frontend $out/share/chapel/ 2>/dev/null || true
    cp -r tools $out/share/chapel/ 2>/dev/null || true

    find bin -type f -name chpl -exec cp {} $out/bin/ \;
    ${lib.optionalString buildMason "find bin -type f -name mason -exec cp {} $out/bin/ \\;"}
    ${lib.optionalString buildChplcheck "find bin -type f -name chplcheck -exec cp {} $out/bin/ \\;"}

    runHook postInstall
  '';

  postFixup = ''
    for f in $out/bin/*; do
      if [ -f "$f" ] && [ -x "$f" ]; then
        wrapProgram "$f" \
          --set CHPL_HOME "$out/share/chapel" \
          --prefix PATH : "${llvmPackages_18.clang}/bin" \
          2>/dev/null || true
      fi
    done
  '';

  meta = with lib; {
    description = "Chapel parallel programming language";
    homepage = "https://chapel-lang.org/";
    license = licenses.asl20;
    platforms = [ "x86_64-linux" "aarch64-darwin" "x86_64-darwin" ];
    maintainers = [];
  };
}
