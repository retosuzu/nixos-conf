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
    inputs.helium.packages.${system}.default
  ];

  programs = {
    git = {
      enable = true;
      settings.user = {
        name = "retosuzu";
        email = "callie@retosuzu.org";
      };
    };
    home-manager.enable = true;
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
    vesktop= {
      enable = true;
      vencord.useSystem = false;
    };
  };
  home.stateVersion = "26.05";
}
