{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.custom;
in
  lib.mkIf (builtins.all (self: self) [
    pkgs.stdenv.hostPlatform.isLinux
    cfg.machine.graphics
    (cfg.linux.window-manager == "sway")
  ]) {
    home.packages = with pkgs; [
      walker
      autotiling-rs
      mako
      xwayland-satellite
      grim
      brightnessctl
      sway-contrib.inactive-windows-transparency
      sway-contrib.grimshot

      # fonts used
      nerd-fonts.fantasque-sans-mono
    ];

    wayland.windowManager.sway = {
      enable = true;
      package = pkgs.swayfx;

      # Workaround #5379 in nix-community/home-manager specifically
      # with pkgs.swayfx
      checkConfig = false;

      wrapperFeatures = {
        base = true;
        gtk = true;
      };

      xwayland = false; # using xwayland-satellite for XWayland support (deals better with scaling compared to Sway)

      config = {
        modifier = "Mod4"; # Mod4 is the 'Super' key, often known as the Windows key on Windows or the Command key on MacOS
        terminal = "${config.programs.alacritty.package}/bin/alacritty";
        menu = "${pkgs.walker}/bin/walker";

        window.titlebar = false;

        bars = [{command = "${pkgs.waybar}/bin/waybar";}];
        focus = {
          followMouse = "yes";
        };

        output = {
          "*" = {
            # sets background to all screens
            background = "${../../../../themes/background/pink/astronaut-space.png} fill";
          };

          eDP-1 = {
            # internal display settings (TODO: map differently depending on device/get specific name for Macbook display)
            scale = "1.5";
            allow_tearing = "yes";
          };
        };

        input = {
          "type:touchpad" = {
            dwt = "disabled";
            natural_scroll = "enabled";
            middle_emulation = "enabled";
            accel_profile = "adaptive";
            events = "disabled_on_external_mouse";
          };
        };

        gaps = {
          inner = 5;
          outer = 5;
        };

        startup = [
          {command = "${pkgs.autotiling-rs}/bin/autotiling-rs";}
          {command = "${pkgs.xwayland-satellite}/bin/xwayland-satellite";}
          {command = "${lib.getExe pkgs.sway-contrib.inactive-windows-transparency} -o 0.85";}
        ];

        fonts = {
          names = ["FantasqueSansM Nerd Font Mono"];
          size = 13.0;
        };

        window.commands = [
          {
            command = "floating enable";
            criteria = {window_role = "pop-up";};
          }
          {
            command = "floating enable";
            criteria = {window_role = "bubble";};
          }
          {
            command = "floating enable";
            criteria = {window_role = "dialog";};
          }
          {
            command = "floating enable, resize set width 1030 height 710";
            criteria = {title = "(?:Open|Save) (?:File|Folder|As)";};
          }
        ];

        keybindings = let
          modifier = config.wayland.windowManager.sway.config.modifier;
          launcher = config.wayland.windowManager.sway.config.menu;
          terminal = config.wayland.windowManager.sway.config.terminal;
        in {
          # special keyboard bindings (media keys, etc.)
          "XF86AudioRaiseVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
          "XF86AudioLowerVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
          "XF86MonBrightnessUp" = "exec ${lib.getExe pkgs.brightnessctl} set 2.5%+";
          "XF86MonBrightnessDown" = "exec ${lib.getExe pkgs.brightnessctl} set 2.5%-";
          "XF86AudioMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          "XF86AudioMicMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
          "XF86AudioPlay" = "exec playerctl play-pause";
          "XF86AudioPause" = "exec playerctl play-pause";
          "XF86Search" = "exec ${launcher}";

          # standard bindings
          "${modifier}+Q" = "kill"; # Command + Q (MacOS-like kill shortcut)
          "Mod1+F4" = "kill"; # Alt+F4 (Windows-like kill shortcut)

          "F11" = "fullscreen";
          "${modifier}+F" = "floating toggle";
          "${modifier}+T" = "layout tabbed";
          "${modifier}+E" = "layout toggle split";

          # workspace bindings
          "${modifier}+1" = "workspace 1";
          "${modifier}+2" = "workspace 2";
          "${modifier}+3" = "workspace 3";
          "${modifier}+4" = "workspace 4";
          "${modifier}+5" = "workspace 5";
          "${modifier}+6" = "workspace 6";
          "${modifier}+7" = "workspace 7";
          "${modifier}+8" = "workspace 8";
          "${modifier}+9" = "workspace 9";
          "${modifier}+0" = "workspace 10";

          # moving windows between workspaces
          "${modifier}+Shift+1" = "move container to workspace 1";
          "${modifier}+Shift+2" = "move container to workspace 2";
          "${modifier}+Shift+3" = "move container to workspace 3";
          "${modifier}+Shift+4" = "move container to workspace 4";
          "${modifier}+Shift+5" = "move container to workspace 5";
          "${modifier}+Shift+6" = "move container to workspace 6";
          "${modifier}+Shift+7" = "move container to workspace 7";
          "${modifier}+Shift+8" = "move container to workspace 8";
          "${modifier}+Shift+9" = "move container to workspace 9";
          "${modifier}+Shift+0" = "move container to workspace 10";

          # change focus from windows
          "${modifier}+Left" = "focus left";
          "${modifier}+Down" = "focus down";
          "${modifier}+Up" = "focus up";
          "${modifier}+Right" = "focus right";

          # moving windows around
          "${modifier}+Shift+Left" = "move left";
          "${modifier}+Shift+Down" = "move down";
          "${modifier}+Shift+Up" = "move up";
          "${modifier}+Shift+Right" = "move right";

          # application binds
          "${modifier}+F2" = "workspace 2; exec ${pkgs.firefox}/bin/firefox";
          "${modifier}+F3" = "workspace 3; exec ${terminal}";

          "${modifier}+Return" = "exec ${terminal}";
          "${modifier}+Space" = "exec ${launcher}";

          # sketchpad binds
          "${modifier}+Shift+Minus" = "move scratchpad";
          "${modifier}+Minus" = "scratchpad show";
        };
      };
      extraConfig = ''
        # This part should only show if the window manager is the SwayFX fork.
        # lib.mkIf (config.wayland.windowManager.sway.package == pkgs.swayfx)
          blur enable
          corner_radius 5

        # Colors
        set $crust #11111b
        set $rosewater #f5e0dc
        set $flamingo #f2cdcd
        set $pink #f5c2e7
        set $mauve #cba6f7
        set $red #f38ba8
        set $maroon #eba0ac
        set $peach #fab387
        set $yellow #f9e2af
        set $green #a6e3a1
        set $teal #94e2d5
        set $sky #89dceb
        set $sapphire #74c7ec
        set $blue #89b4fa
        set $lavender #b4befe
        set $text #cdd6f4
        set $subtext1 #bac2de
        set $subtext0 #a6adc8
        set $overlay2 #9399b2
        set $overlay1 #7f849c
        set $overlay0 #6c7086
        set $surface2 #585b70
        set $surface1 #45475a
        set $surface0 #313244
        set $base #1e1e2e
        set $mantle #181825

        client.focused           $lavender $base $text  $rosewater $lavender
        client.focused_inactive  $overlay0 $base $text  $rosewater $overlay0
        client.unfocused         $overlay0 $base $text  $rosewater $overlay0
        client.urgent            $peach    $base $peach $overlay0  $peach
        client.placeholder       $overlay0 $base $text  $overlay0  $overlay0

        # Gesture binding (trackpad)
        bindgesture swipe:3:up move up
        bindgesture swipe:3:down move down
        bindgesture swipe:3:left move left
        bindgesture swipe:3:right move right
      '';
    };

    home.pointerCursor = let
      getFrom = url: hash: name: {
        inherit name;

        gtk.enable = true;
        x11.enable = true;
        sway.enable = true;
        hyprcursor.enable = true;

        size = 48;
        package = pkgs.runCommand "moveUp" {} ''
          mkdir -p $out/share/icons
          ln -s ${
            pkgs.fetchzip {
              url = url;
              hash = hash;
            }
          }/dist $out/share/icons/${name}
        '';
      };
    in
      getFrom "https://github.com/yeyushengfan258/Future-cursors/archive/refs/heads/master.zip"
      "sha512-bQIr08VFngPe+5bYOcFSsmkTEH5VyQISXw+pU7tNZDq9ipUeEhyEBkp2QEcZdGeWyuTYz/D0oshmKOHP2eEAvg=="
      "Future-cursors";

    programs.swaylock = {
      enable = true;
    };

    services.swayidle = {
      enable = true;
      events = [
        {
          event = "after-resume";
          command = "${config.wayland.windowManager.sway.package}/bin/swaymsg \"output * dpms on\"";
        }
        {
          event = "before-sleep";
          command = "${pkgs.swaylock}/bin/swaylock";
        }
      ];
      timeouts = [
        {
          timeout = 300; # five minutes
          command = "${pkgs.swaylock}/bin/swaylock";
        }
        {
          timeout = 600; # ten minutes
          command = "${config.wayland.windowManager.sway.package}/bin/swaymsg \"output * dpms off\"";
          resumeCommand = "${config.wayland.windowManager.sway.package}/bin/swaymsg \"output * dpms on\"";
        }
      ];
    };
  }
