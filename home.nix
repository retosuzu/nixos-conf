{
  config,
  pkgs,
  inputs,
  ...
}: {
  home.username = "callie";
  home.homeDirectory = "/home/callie";

  home.packages = with pkgs; [
    zsh
    vim
    wget
    sbctl
    git
    vesktop
    btop
    fastfetch
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
  };
  home.stateVersion = "26.05";
}
