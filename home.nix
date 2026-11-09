{ config, pkgs, ... }:

{
    home.username = "callie";
    home.homeDirectory = "/home/callie";

    home.packages = with pkgs; [
        btop
        git
        zsh
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
};
    home.stateVersion = "26.05";
}
