{
  config,
  pkgs,
  inputs,
  ...
}: {
  home.username = "callie";
  home.homeDirectory = "/home/callie";

  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    zsh
    vim
    wget
    sbctl
    git
    btop
    fastfetch
    wootility
    osu-lazer-bin
    wireguard-tools
    proton-vpn
    yt-dlp
    inputs.helium.packages.${system}.default
  ];

  programs = {
    ghostty.enable = true;
    home-manager.enable = true;
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
