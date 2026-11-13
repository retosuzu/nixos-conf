{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:

{

  imports = [
    ./hyprland.nix
  ];

  home.packages = with pkgs; [
    zsh
    vim
    wget
    sbctl
    git
    btop
    wootility
    osu-lazer-bin
    wireguard-tools
    proton-vpn
    yt-dlp
    grim
    slurp
    wl-clipboard
    inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

    programs = {
    ghostty.enable = true;
    home-manager.enable = true;
    fastfetch.enable = true;
    rofi.enable = true;
    noctalia = {
      enable = true;
    };
    git = {
      enable = true;
      settings.user = {
        name = "retosuzu";
        email = "callie@retosuzu.org";
      };
    };
    zsh = {
      enable = true;
      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          "z"
        ];
        theme = "fishy";
      };
    };
    thunderbird = {
      enable = true;
      profiles = {
        default = {
          isDefault = true;
          settings = {
            "general.useragent.override" = "";
          };
        };
      };
    };
    vesktop = {
      enable = true;
      vencord.useSystem = false;
    };
  };
  home.stateVersion = "26.05";
}
