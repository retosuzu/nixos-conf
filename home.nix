{
  config,
  pkgs,
  inputs,
  ...
}: {
  home.username = "callie";
  home.homeDirectory = "/home/callie";

  home.packages = with pkgs; [
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
  };
  home.stateVersion = "26.05";
}
