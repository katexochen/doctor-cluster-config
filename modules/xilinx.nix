{
  pkgs,
  config,
  self,
  lib,
  ...
}:
let
  packages = self.packages.${pkgs.stdenv.hostPlatform.system};
  xrt-drivers = packages.xrt-drivers.override { inherit (config.boot.kernelPackages) kernel; };
  coyote-driver = packages.coyote-driver.override { inherit (config.boot.kernelPackages) kernel; };
in
{
  options = {
    hardware.xilinx.xrt-drivers.enable = lib.mkEnableOption "Propritary kernel drivers for flashing firmware";
    hardware.xilinx.coyote-driver.enable = lib.mkEnableOption "Coyote FPGA kernel driver";
  };

  config = {
    environment.systemPackages = [
      (packages.xilinx-env.override {
        xilinxName = "xilinx-shell";
        runScript = "bash";
      })
      (packages.xilinx-env.override {
        xilinxName = "vitis";
        runScript = "vitis";
      })
      # Versal-targeted variant: Vivado/Vitis 2025.1.
      # Required for V80 (the routed-locked static checkpoint Coyote ships
      # is built with Vivado 2024.2+, so 2023.2 cannot link against it).
      (packages.xilinx-env.override {
        xilinxName = "versal-shell";
        runScript = "bash";
        vivadoVersion = "2025.1";
      })
      packages.xntools-core
    ];

    services.udev.packages = [ packages.xilinx-cable-drivers ];

    # 6.0+ kernel
    boot.extraModulePackages =
      lib.optional
        config.hardware.xilinx.xrt-drivers.enable
        xrt-drivers
      ++ lib.optional
        config.hardware.xilinx.coyote-driver.enable
        coyote-driver;

    # The Coyote module is deliberately not added to boot.kernelModules.
    # It will be loaded manually after programming the FPGA.

    # hardware.graphics.extraPackages = [ packages.xrt ];
  };
}
