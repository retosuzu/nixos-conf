{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  boot = {
    consoleLogLevel = 3;
    plymouth = {
      enable = true;
      logo = ./plymouth.png;
    };
    # silent boot
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "udev.log_priority=3"
      "rd.systemd.show_status=auto"
    ];
    initrd.kernelModules = [
      "nvidia"
      "nvidia_modeset"
      "nvidia_uvm"
      "nvidia_drm"
    ];
    kernelModules = [
      "ntsync"
    ];
    loader = {
      efi.canTouchEfiVariables = true;
      limine = {
        enable = true;
        secureBoot.enable = true;
        maxGenerations = 10;
        extraConfig = ''
          remember_last_entry: yes
        '';
        extraEntries = ''
          /Windows
            protocol: efi
            path: uuid(b15c0e58-454d-4a6f-991d-fec298f0155f):/EFI/Microsoft/Boot/bootmgfw.efi
        '';
      };
    };
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;

  hardware = {
    graphics.enable = true;
    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.latest;
    };
  };

  nix.settings = {
    experimental-features = ["nix-command" "flakes" "pipe-operators"];
    substituters = ["https://ezkea.cachix.org" "https://hyprland.cachix.org" "https://noctalia.cachix.org"];
    trusted-public-keys = [
      "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    ];
    trusted-users = ["root" "@wheel"];
  };
  networking.hostName = "suuzu";

  networking.networkmanager.enable = true;

  networking.firewall.checkReversePath = false;

  time.timeZone = "Europe/London";

  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      ignoreUserConfig = true;
      addons = with pkgs; [
        fcitx5-mozc
      ];
      settings = {
        inputMethod = {
          "Groups/0" = {
            Name = "Default";
            "Default Layout" = "us";
            DefaultIM = "keyboard-us";
          };
          "Groups/0/Items/0".Name = "keyboard-us";
          "Groups/0/Items/1".Name = "mozc";
        };
      };
    };
  };

  services.xserver.enable = true;
  services.xserver.videoDrivers = ["nvidia"];
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users."callie" = {
    isNormalUser = true;
    description = "callie";
    extraGroups = ["networkmanager" "wheel"];
    shell = pkgs.zsh;
    packages = with pkgs; [
      kdePackages.kate
      #  thunderbird
    ];
  };

  programs = {
    steam = {
      enable = true;
      protontricks.enable = true;
      extraCompatPackages = [pkgs.proton-ge-bin pkgs.dwproton-bin];
    };
    hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
      xwayland.enable = true;
      withUWSM = true;
    };
    zsh = {
      enable = true;
      ohMyZsh = {
        enable = true;
        plugins = [
          "git"
          "z"
        ];
        theme = "fishy";
      };
    };
    nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 30d --keep 10";
      flake = "/home/callie/nix-config";
    };
  };

  nixpkgs.config.allowUnfree = true;

  services.udev.packages = [
    (pkgs.writeTextDir "lib/udev/rules.d/70-wooting.rules" ''
            # Wooting One Legacy
      SUBSYSTEM=="hidraw", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="ff01", MODE:="0660", GROUP="input", TAG+="uaccess"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="ff01", MODE:="0660", GROUP="input", TAG+="uaccess"
      # Wooting One update mode
      SUBSYSTEM=="hidraw", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2402", MODE:="0660", GROUP="input", TAG+="uaccess"

      # Wooting Two Legacy
      SUBSYSTEM=="hidraw", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="ff02", MODE:="0660", GROUP="input", TAG+="uaccess"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="ff02", MODE:="0660", GROUP="input", TAG+="uaccess"
      # Wooting Two update mode
      SUBSYSTEM=="hidraw", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2403", MODE:="0660", GROUP="input", TAG+="uaccess"

      # Generic Wootings
      SUBSYSTEM=="hidraw", ATTRS{idVendor}=="31e3", MODE:="0660", GROUP="input", TAG+="uaccess"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="31e3", MODE:="0660", GROUP="input", TAG+="uaccess"
    '')
  ];

  /*
    environment.systemPackages = with pkgs; [
    vim
    wget
    sbctl
    git
    vesktop
    btop
    fastfetch
    home-manager
    inputs.helium.packages.${system}.default
  ];
  */

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "26.05"; # Did you read the comment?
}
