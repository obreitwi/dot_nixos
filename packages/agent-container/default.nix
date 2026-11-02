{
  writeShellApplication,
  jq,
}:
writeShellApplication {
  name = "agent-container";
  runtimeInputs = [jq];
  # docker, aws, gh and git are taken from the host PATH
  text = builtins.readFile ./agent-container.sh;
}
