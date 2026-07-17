{
  lib,
  stdenv,
  kernel,
  src,
  coyotePlatform ? "ultrascale_plus",
}:

assert lib.assertMsg
  (builtins.elem coyotePlatform [
    "ultrascale_plus"
    "versal"
  ])
  "coyote-driver: coyotePlatform must be either 'ultrascale_plus' or 'versal'";

let
  kernelDir = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";
in
stdenv.mkDerivation {
  pname = "coyote-driver";
  version = "0-unstable-${src.shortRev or "dirty"}-${kernel.version}";

  # `src` is supplied by the pinned, non-flake Coyote input declared in
  # the repository's root flake.nix. Only the driver subtree is copied into
  # the writable build directory.
  inherit src;
  dontUnpack = true;

  # Provides the compiler and other tools needed to build an out-of-tree
  # module against the selected NixOS kernel.
  nativeBuildInputs = kernel.moduleBuildDependencies;

  # Kernel modules must not be built with the normal userspace PIE/PIC
  # hardening flags.
  hardeningDisable = [ "pic" ];

  enableParallelBuilding = true;

  buildPhase = ''
    runHook preBuild

    cp -r ${src}/driver ./driver
    chmod -R u+w ./driver

    pushd ./driver
    make \
      -j"$NIX_BUILD_CORES" \
      KERNELDIR="${kernelDir}" \
      TARGET_PLATFORM="${coyotePlatform}"
    popd

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm444 driver/build/coyote_driver.ko \
      "$out/lib/modules/${kernel.modDirVersion}/extra/coyote_driver.ko"

    runHook postInstall
  '';

  passthru = {
    inherit src coyotePlatform kernel;
  };

  meta = {
    description = "Coyote FPGA Linux kernel driver";
    homepage = "https://github.com/fpgasystems/Coyote";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
  };
}
