# Lian Li desktop: Ryzen 5 5600, discrete RX 6600 (Navi 23), 16 GB RAM, WD SN570.
{
  hardware.cpu.amd.updateMicrocode = true;

  # Vermeer has no iGPU; amdgpu must be up before greetd or niri exits with no GPU.
  hardware.amdgpu.initrd.enable = true;
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  services.xserver.videoDrivers = [ "amdgpu" ];
  powerManagement.cpuFreqGovernor = "performance";
  boot.kernelParams = [
    "amd_pstate=active"
    # Mesa aborts niri on GPU reset (amdgpu_ctx_set_sw_reset_status). Keep
    # kernel recovery enabled so a hang from GIMP/gamescope is not fatal.
    "amdgpu.gpu_recovery=1"
  ];

  # NVMe already mounts with discard=async; fstrim still helps unused ranges.
  services.fstrim.enable = true;

  # 16 GB is tight under desktop + nix builds; zram sits in front of the 18G swapfile.
  zramSwap.enable = true;

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "radeonsi";
    VDPAU_DRIVER = "radeonsi";
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
  };
}
