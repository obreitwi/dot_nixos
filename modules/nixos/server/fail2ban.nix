{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    my.server.fail2ban = {
      enable = lib.mkOption {
        default = true;
        type = lib.types.bool;
      };
    };
  };

  config = {
    environment.etc = lib.mkIf config.my.server.fail2ban.enable {
      # Defines a filter that detects URL probing by reading the Nginx access log
      "fail2ban/filter.d/nginx-url-probe.local".text = pkgs.lib.mkDefault (
        pkgs.lib.mkAfter ''
          [Definition]
          failregex = ^.*, client: <HOST>,.*, request: "GET /(wp-|admin|boaform|phpmyadmin|\.env|\.git)|\.(dll|so|cfm|asp)|(\?|&)(=PHPB8B5F2A0-3C92-11d3-A3A9-4C7B08C10000|=PHPE9568F36-D428-11d2-A769-00AA001ACF42|=PHPE9568F35-D428-11d2-A769-00AA001ACF42|=PHPE9568F34-D428-11d2-A769-00AA001ACF42)|\\x[0-9a-zA-Z]{2}"
        ''
      );
    };

    services.fail2ban = {
      enable = config.my.server.fail2ban.enable;
      # Ban IP after 5 failures
      maxretry = 5;
      ignoreIP = [
        # Whitelist some subnets
        "nas.zqnr.de" # resolve the IP via DNS
      ];
      bantime = "1h"; # Ban IPs for one day on the first ban
      bantime-increment = {
        enable = true; # Enable increment of bantime after each violation
        # formula = "ban.Time * math.exp(float(ban.Count+1)*banFactor)/math.exp(1*banFactor)";
        multipliers = "1 2 4 8 16 32 64";
        maxtime = "168h"; # Do not ban for more than 1 week
        overalljails = true; # Calculate the bantime based on all the violations
      };
      jails = {
        sshd = {
          enabled = true;
          settings = {
            mode = "aggressive";
            publickey = "invalid";
          };
        };
        nginx-url-probe.settings = {
          enabled = true;
          filter = "nginx-url-probe";
          action = "%(action_)s[blocktype=DROP]";
          backend = "systemd"; # Do not forget to specify this if your jail uses a log file
          journalmatch = "_SYSTEMD_UNIT=nginx.service";
          findtime = 600;
        };
        nginx-botsearch.settings = {
          enabled = true;
          filter = "nginx-botsearch";
          action = "%(action_)s[blocktype=DROP]";
          backend = "systemd"; # Do not forget to specify this if your jail uses a log file
          journalmatch = "_SYSTEMD_UNIT=nginx.service";
          findtime = 600;
        };
        php-url-fopen.settings = {
          enabled = true;
          filter = "php-url-fopen";
          action = "%(action_)s[blocktype=DROP]";
          backend = "systemd"; # Do not forget to specify this if your jail uses a log file
          journalmatch = "_SYSTEMD_UNIT=nginx.service";
          findtime = 600;
        };
        postfix = {
          enabled = true;
        };
        postfix-sasl = {
          enabled = true;
        };
      };
    };
  };
}
