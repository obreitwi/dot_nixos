{
  writeShellApplication,
  jq,
  git,
}:
writeShellApplication {
  name = "pi-resume";
  runtimeInputs = [jq git];
  text = ''
    toplevel="$(git rev-parse --show-toplevel)"
    sessions_dir="$toplevel/.pi/sessions"
    current_cwd="$(pwd)"

    if [ ! -d "$sessions_dir" ]; then
      echo "No sessions directory found at $sessions_dir" >&2
      exit 1
    fi

    # Iterate session files from most recent (lexicographic sort, newest last → reverse)
    for session_file in $(find "$sessions_dir" -name '*.jsonl' 2>/dev/null | sort -r); do
      # Extract cwd and id from the first JSON object
      first_line="$(head -n1 "$session_file")"
      session_cwd="$(echo "$first_line" | jq -r '.cwd // empty')"

      if [ "$session_cwd" = "$current_cwd" ]; then
        session_id="$(echo "$first_line" | jq -r '.id')"
        echo "Resuming session: $session_id" >&2
        exec pi --session-dir "$sessions_dir" --session "$session_id"
      fi
    done

    echo "No session found for cwd: $current_cwd" >&2
    exit 1
  '';
}
