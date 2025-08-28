{
  programs.waybar = {
    enable = true;
    settings = [
      {
        layer = "top";
        height = 42;
        spacing = 6;
        margin-left = 10;
        margin-right = 10;
        modules-left = [
          "sway/workspaces"
          "sway/window"
        ];
        modules-center = [
          "mpris"
        ];
        modules-right = [
          "tray"
          "cava"
          "network"
          "wireplumber"
          "battery"
          "group/system-status"
          "clock"
        ];
        "sway/workspaces" = {
          all-outputs = true;
          format = "{icon}";
          format-icons = {
            "1" = "";
            "2" = "󰈹";
            "3" = "";
          };
        };
        "sway/window" = {
          all-outputs = true;
          max-length = 35;
          icon = true;
          icon-size = 20;
        };
        "group/system-status" = {
          orientation = "inherit";
          modules = [
            "power-profiles-daemon"
            "cpu"
            "memory"
          ];
          drawer = {
            click-to-reveal = false;
            transition-left-to-right = false;
          };
        };
        mpris = {
          format = "{status_icon} {title}";
          format-stopped = "";
          tooltip-format = "{player} {player_icon}\n{title}\nBy {artist}\n{album}\n{position} ・ {length} ({status})";
          status-icons = {
            paused = "";
            playing = "";
          };
          player-icons = {
            Spot = "󰓇";
          };
        };
        "custom/mpris2" = {
          format = "{}";
          exec = "~/.config/waybar/custom_scripts/playerctl-waybar";
          return-type = "json";
          on-click = "playerctl play-pause";
          on-click-right = "playerctl stop";
          on-click-middle = "music-start";
          on-scroll-down = "playerctl previous";
          on-scroll-up = "playerctl next";
        };
        "custom/notification" = {
          tooltip = false;
          format = "{icon}";
          format-icons = {
            notification = "<span foreground='red'><sup></sup></span>";
            none = "";
            dnd-notification = "<span foreground='red'><sup></sup></span>";
            dnd-none = "";
            inhibited-notification = "<span foreground='red'><sup></sup></span>";
            inhibited-none = "";
            dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>";
            dnd-inhibited-none = "";
          };
          return-type = "json";
          exec-if = "which swaync-client";
          exec = "swaync-client -swb";
          on-click = "swaync-client -t -sw";
          on-click-right = "swaync-client -d -sw";
          escape = true;
        };
        cpu = {
          format = " {usage}%";
          tooltip-format = "{icon0}{icon1}{icon2}{icon3}{icon4}{icon5}{icon6}{icon7}";
          format-icons = [
            "<span color='#69ff94'>▁</span>"
            "<span color='#2aa9ff'>▂</span>"
            "<span color='#f8f8f2'>▃</span>"
            "<span color='#f8f8f2'>▄</span>"
            "<span color='#ffffa5'>▅</span>"
            "<span color='#ffffa5'>▆</span>"
            "<span color='#ff9977'>▇</span>"
            "<span color='#dd532e'>█</span>"
          ];
          interval = 20;
        };
        memory = {
          format = " {used:0.1f}GiB";
          interval = 10;
          tooltip-format = "{swapPercentage}% ({swapUsed}GiB) swap used";
        };
        wireplumber = {
          scroll-step = 1;
          smooth-scrolling-threshold = 2;
          format = "{icon} {volume}%";
          format-muted = "";
          on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          on-click-right = "flatpak run com.saivert.pwvucontrol";
          format-icons = {
            default = [
              ""
              ""
              ""
            ];
          };
          max-volume = 130;
        };
        network = {
          format-wifi = "{icon} {essid}";
          format-ethernet = "󰈀 {gwaddr} via {ifname}";
          format-alt = " {bandwidthUpBytes}  {bandwidthDownBytes}";
          format-icons = {
            default = [
              "󰤟"
              "󰤢"
              "󰤥"
              "󰤨"
            ];
          };
        };
        battery = {
          interval = 30;
          states = {
            warning = 35;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-alt = "{icon} {time} ({power:0.1f}W)";
          format-icons = [
            "󰁺"
            "󰁻"
            "󰁼"
            "󰁽"
            "󰁾"
            "󰁿"
            "󰂀"
            "󰂁"
            "󰂂"
            "󰁹"
          ];
        };
        power-profiles-daemon = {
          format = "{icon}";
          format-icons = {
            default = "";
            performance = "";
            balanced = "";
            power-saver = "";
          };
        };
        cava = {
          framerate = 60;
          autosens = 1;
          sensitivity = 3;
          bars = 8;
          lower_cutoff_freq = 50;
          higher_cutoff_freq = 10000;
          method = "pulse";
          source = "auto";
          stereo = false;
          reverse = false;
          bar_delimiter = 0;
          monstercat = true;
          waves = true;
          noise_reduction = { };
          input_delay = 0;
          format-icons = [
            "▁"
            "▂"
            "▃"
            "▄"
            "▅"
            "▆"
            "▇"
            "█"
          ];
        };
      }
    ];
    style = ./style.css;
  };
}
