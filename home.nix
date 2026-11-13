{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: let
  screenshot = pkgs.writeShellScriptBin "screenshot" ''
    #!/usr/bin/env bash

    RANDOM_NAME=$(tr -dc 'a-zA-Z0-9' </dev/urandom | head -c 6)
    SCREENSHOT_PATH="/home/callie/Pictures/Screenshots/$RANDOM_NAME.png"
    ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" "$SCREENSHOT_PATH"

    if [ ! -f "$SCREENSHOT_PATH" ]; then
      ${pkgs.libnotify}/bin/notify-send "Screenshot Upload" "Screenshot failed!" -u critical
      exit 1
    fi

    if command -v ${pkgs.wl-clipboard}/bin/wl-copy &>/dev/null; then
      ${pkgs.wl-clipboard}/bin/wl-copy < "$SCREENSHOT_PATH"
    fi

     ${pkgs.libnotify}/bin/notify-send "Upload successful! Link copied to clipboard" \
        -u normal -i "$SCREENSHOT_PATH" -a "Screenshot Upload"

  '';
in {
  home.username = "callie";
  home.homeDirectory = "/home/callie";
  imports = [
    inputs.noctalia.homeModules.default
  ];
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
    grim
    slurp
    wl-clipboard
    inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    systemd.enable = false;
    settings = {
      bind =
        [
          {
            _args = [
              "Print"
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${lib.getExe screenshot}\")")
            ];
          }
          {
            _args = [
              "SUPER + Return"
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"ghostty\")")
            ];
          }
          {
            _args = [
              "SUPER + mouse:272"
              (lib.generators.mkLuaInline "hl.dsp.window.drag()")
              {mouse = true;}
            ];
          }
          {
            _args = [
              "SUPER + mouse:273"
              (lib.generators.mkLuaInline "hl.dsp.window.resize()")
              {mouse = true;}
            ];
          }

          {_args = ["SUPER + h" (lib.generators.mkLuaInline ''hl.dsp.focus({ direction = "l" })'')];}
          {_args = ["SUPER + j" (lib.generators.mkLuaInline ''hl.dsp.focus({ direction = "d" })'')];}
          {_args = ["SUPER + k" (lib.generators.mkLuaInline ''hl.dsp.focus({ direction = "u" })'')];}
          {_args = ["SUPER + l" (lib.generators.mkLuaInline ''hl.dsp.focus({ direction = "r" })'')];}

          {_args = ["SUPER + c" (lib.generators.mkLuaInline "hl.dsp.window.close()")];}

          {_args = ["SUPER + S" (lib.generators.mkLuaInline ''hl.dsp.workspace.toggle_special("magic")'')];}
          {_args = ["SUPER + SHIFT + S" (lib.generators.mkLuaInline ''hl.dsp.window.move({ workspace = "special:magic" })'')];}

          {_args = ["SUPER + CTRL + h" (lib.generators.mkLuaInline "hl.dsp.window.resize({ x = -20, y = 0, relative = true })")];}
          {_args = ["SUPER + CTRL + j" (lib.generators.mkLuaInline "hl.dsp.window.resize({ x = 0, y = 20, relative = true })")];}
          {_args = ["SUPER + CTRL + k" (lib.generators.mkLuaInline "hl.dsp.window.resize({ x = 0, y = -20, relative = true })")];}
          {_args = ["SUPER + CTRL + l" (lib.generators.mkLuaInline "hl.dsp.window.resize({ x = 20, y = 0, relative = true })")];}
        ]
        ++ builtins.genList (i: {
          _args = [
            "SUPER + ${toString (i + 1)}"
            (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = ${toString (i + 1)} })")
          ];
        })
        9
        ++ builtins.genList (i: {
          _args = [
            "SUPER + SHIFT + ${toString (i + 1)}"
            (lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = ${toString (i + 1)} })")
          ];
        })
        9;

      monitor = [
        {
          output = "DP-1";
          mode = "1920x1080@240";
          position = "0x0";
          scale = 1;
        }
        {
          output = "HDMI-A-1";
          mode = "1920x1080@60";
          position = "1920x0";
          scale = 1;
        }
      ];
    };
  };

  programs = {
    ghostty.enable = true;
    home-manager.enable = true;
    fastfetch.enable = true;
    rofi.enable = true;
    noctalia = {
      enable = true;
      systemd.enable = true;
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
