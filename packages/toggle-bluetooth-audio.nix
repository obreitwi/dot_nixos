{
  pkgs,
  writeShellApplication,
  ...
}:
writeShellApplication {
  name = "toggle-bluetooth-audio";
  runtimeInputs = with pkgs; [jq pulseaudio];
  text = ''
    json=$(pactl --format=json list cards | jq -c '.[] | select(.name | startswith("bluez_card")) | {name, active_profile}')
    card=$(jq -r '.name' <<<"$json")
    profile=$(jq -r '.active_profile' <<<"$json")
    if [[ "$profile" == "a2dp-sink" ]]; then
      pactl set-card-profile "$card" headset-head-unit
    else
      pactl set-card-profile "$card" a2dp-sink
    fi
  '';
}
