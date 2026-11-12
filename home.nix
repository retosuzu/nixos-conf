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
    wootility
    osu-lazer-bin
    wireguard-tools
    proton-vpn
    yt-dlp
    grimblast
    inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    settings = {
    exec-once = [
      "ashell"
      "fcitx5 -d"
      "waybar"
      "mako"
      "hyprpaper"
    ];
    "$mod" = "SUPER";
    bind =
      [
        "$mod, F, exec, firefox"
        ", Print, exec, grimblast copy area"
          "$mod, Return, exec, ghostty"
          "$mod, D, exec, rofi -show drun"
          "$mod, Q, killactive,"
          "$mod SHIFT, E, exit,"
      ]
      ++ (
        # workspaces
        # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
        builtins.concatLists (builtins.genList (i:
            let ws = i + 1;
            in [
              "$mod, code:1${toString i}, workspace, ${toString ws}"
              "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
            ]
          )
          9)
      );
    };
  };


  programs = {
    ghostty.enable = true;
    home-manager.enable = true;
    fastfetch.enable = true;
    rofi.enable = true;
    waybar.enable = true;
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

  services = {
    hyprpaper = {
      enable = true;
      settings = {
        preload = [
          "/home/callie/Downloads/cocoween.png"
          "/home/callie/Downloads/HWIND0SaMAAepyD.jpeg"
        ];
        wallpaper = [
          "DP-1,/home/callie/Downloads/cocoween.png"
          "HDMI-A-1,/home/callie/Downloads/HWIND0SaMAAepyD.jpeg"
        ];
      };
    };
    mako = {
      enable = true;
      settings = {
        font = "JetBrains Mono 10";
        background-color = "#2e3440";
        text-color = "#d8dee9";
        border-color = "#5e81ac";
        border-radius = 6;
        default-timeout = 5000;
    };
  };
};
  home.stateVersion = "26.05";
}
