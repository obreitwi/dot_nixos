{...}: {
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.extraCommands = ''
    # Silence refusal of Ubiquiti Inform updates
        iptables \
        --insert nixos-fw-log-refuse 1 \
        --source 192.168.0.2 \
        --protocol tcp \
        --dport 8080 \
        --jump nixos-fw-refuse
  '';
}
