# home manager config for xmobar config
{
  lib,
  config,
  pkgs,
  hostname,
  ...
}: let
  num_cpus = {
    nimir = 4;
    mimir = 12;
    mucku = 16;
  };

  trayWidth = config.my.stalonetray.num-icons * config.my.stalonetray.slot-size;
  barHeight = config.my.stalonetray.slot-size;

  cpu = lib.strings.concatStrings (builtins.genList (i: "<total${toString i}>") num_cpus.${hostname});

  padding = {
    default = " ";
    mucku = " ";
  };

  pad = padding.${hostname} or padding.default;

  temp_sensors = {
    mucku =
      /*
      haskell
      */
      ''
        , Run Com "bash" [ "-c", "sensors -u k10temp-pci-00c3 | awk '/temp1_input:/ { printf(\"%.0f°C\", $2) }'"] "temp_cpu" 10
        , Run Com "bash" [ "-c", "sensors -u amdgpu-pci-0a00 | awk '/temp1_input:/ { printf(\"%.0f°C\", $2) }'"] "temp_gpu" 10
      '';
    default =
      /*
      haskell
      */
      ''
        , Run CoreTemp [ "-t", "<core0>C", "-L", "40", "-H", "60", "--normal", "#CEFFAC", "--high", "#FFB6B0", "-w", "2", "-c", "${pad}" ] 10
      '';
  };

  battery = {
    mimir =
      /*
      haskell
      */
      ''
        , Run Battery ["-t", "AC <acstatus>, <left>% / <timeleft>", "-H", "80", "-L", "20", "-l", "#FFB6B0", "-h", "#CEFFAC", "-n", "#FFFFCC"] 600
      '';
  };

  wireless_name = {
    mimir = "wlan0";
    mucku = "wlp12s0f3u1";
  };
  wirename = wireless_name.${hostname} or "";

  info_wl =
    if (wirename == "")
    then ""
    else " :: %${wirename}wi%";

  wireless =
    if (wirename == "")
    then ""
    else
      /*
      haskell
      */
      ''
        , Run Wireless "${wirename}" ["-t", "<quality>%", "-H", "80", "-L", "20", "-l", "#FFB6B0", "-h", "#CEFFAC", "-n", "#FFFFCC", "-m", "3", "-c", "${pad}"] 5
      '';

  info_coretemp = {
    default = " %coretemp%";
    mucku = " %temp_cpu% %temp_gpu%";
  };

  info_ct = info_coretemp.${hostname} or info_coretemp.default;

  bat = battery.${hostname} or "";

  info_bat =
    if (bat == "")
    then ""
    else "%battery%%draining%";
  temp = temp_sensors.${hostname} or temp_sensors.default;

in {
  options.my.xmobar.enable = lib.mkOption {
    default = true;
    type = lib.types.bool;
  };

  config = lib.mkIf config.my.xmobar.enable {
    home.packages = with pkgs; [
      ttf-envy-code-r # xmobar
    ];

    programs.xmobar = {
      enable = true;
      extraConfig =
        /*
        haskell
        */
        ''
          Config { font = "Envy Code R Bold 8"
              , bgColor = "#000000"
              , fgColor = "#ffffff"
              -- <height> <left> <right> <top> <bottom>
              , position = TopHM ${toString barHeight} 0 ${toString trayWidth} 0 0
              , lowerOnStart = True
              , commands = [
              Run MultiCpu ["-t", "${cpu}", "-L", "3", "-H", "50", "--normal", "#CEFFAC", "--high", "#FFB6B0", "-w", "4", "-c", "${pad}"] 10
              ${temp}
              , Run DynNetwork ["-t", "<rx> / <tx>", "-H", "3500", "-L", "100", "-h", "#FFB6B0", "-l", "#CEFFAC", "-n", "#FFFFCC", "-m", "6", "-c", "${pad}"] 10
              , Run Memory ["-t", "<used>M"] 10
              ${wireless}
              ${bat}
              , Run Com "bash" ["-c", "awk '!/^0$/ { print \" @ \" $1/1000 \" mW\"}'  /sys/class/power_supply/*/power_now"] "draining" 20
              , Run NamedXPropertyLog "_XMONAD_LOG" "MyPropertyLog"
              , Run Com "date" ["+%d.%m.%y %H:%M:%S"] "mydate" 10
              , Run Swap ["-t", "<usedratio>%"] 10
              ]
              , sepChar = "%"
              , alignSep = "}{"
              , template = "}%MyPropertyLog%{ %multicpu%${info_ct}   %memory% %swap%   %dynnetwork%${info_wl}  ${info_bat}  <fc=#FFFFCC>%mydate%</fc>"
            }
        '';
    };
  };
}
