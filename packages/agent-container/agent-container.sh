# Build the agent-base docker image (see docker/agent-base in dot_nixos) and
# run a coding agent (pi or claude) in it.

set -Eeuo pipefail
shopt -s inherit_errexit

flake_dir="${NH_FLAKE:-$HOME/git/dot_nixos}"
ca_file="${AGENT_CONTAINER_CA:-$HOME/.local/share/certs/zscaler.cer}"
pi_dir="$HOME/.pi/agent"
home=/home/agent

usage() {
  cat <<EOF
Usage:
  agent-container build [--uid N] [--gid N] [docker-build-args...]
  agent-container pi|claude [--image IMG] [--network NET] [--] [agent-args...]
  agent-container prune-cache [docker-buildx-prune-args...]
  agent-container -h|--help

Commands:
  build               Build agent-base:latest from \$NH_FLAKE (now: $flake_dir).
  pi                  Run pi in the current directory (mounted at the same path),
                      with ~/.pi/agent state and ~/.gradle mounted.
  claude              Run claude (via Bedrock) in the current directory; only
                      AWS credentials, the CA, GitHub token and git author
                      are passed in.
  prune-cache         Remove the nix build cache of the image (cache mounts;
                      the next build starts from zero). E.g. -f: no prompt.

Build options:
  --uid N             uid of the agent user (default: $(id -u))
  --gid N             gid of the agent user (default: $(id -g))

Run options:
  --image IMG         Image to run (default: agent-base:latest)
  --network NET       Docker network to attach to
  --                  Pass all remaining arguments to the agent

Environment:
  NH_FLAKE            dot_nixos checkout (build context)
  AGENT_CONTAINER_CA  Corporate CA, read-only mount (now: $ca_file)
  AWS_*               Forwarded to the container; AWS_PROFILE is resolved to
                      credentials via 'aws configure export-credentials'
  ANTHROPIC_*MODEL    Forwarded for claude (model selection)
  GH_TOKEN, GH_ENTERPRISE_TOKEN, GH_HOST
                      Forwarded; without a token, it comes from
                      'gh auth token' for \$GH_HOST, else for the one host
                      that 'gh auth status' reports as logged in
  GIT_{AUTHOR,COMMITTER}_{NAME,EMAIL}
                      Forwarded; default: git config user.name/user.email
EOF
}

die() {
  echo "agent-container: $*" >&2
  exit 1
}

require_docker() {
  command -v docker >/dev/null || die "docker not found in PATH"
  docker info >/dev/null 2>&1 || die "docker daemon not reachable (is colima running?)"
}

# docker run arguments, filled by the functions below
args=()

# forward every given variable that is set
forward_env() {
  local var
  for var in "$@"; do
    if [ -n "${!var:-}" ]; then
      args+=(-e "$var")
    fi
  done
}

cmd_build() {
  local uid gid
  uid="$(id -u)"
  gid="$(id -g)"
  while [ $# -gt 0 ]; do
    case "$1" in
      --uid) uid="$2"; shift 2 ;;
      --gid) gid="$2"; shift 2 ;;
      -h | --help) usage; exit 0 ;;
      *) break ;;
    esac
  done
  require_docker

  local secret=()
  if [ -r "$ca_file" ]; then
    secret=(--secret "id=ca,src=$ca_file")
  fi

  exec docker build \
    --build-arg "AGENT_UID=$uid" \
    --build-arg "AGENT_GID=$gid" \
    "${secret[@]}" \
    -t agent-base:latest \
    -f "$flake_dir/docker/agent-base/Dockerfile" \
    "$@" \
    "$flake_dir"
}

cmd_prune-cache() {
  case "${1:-}" in
    -h | --help) usage; exit 0 ;;
  esac
  require_docker
  # `docker build` uses the builder of the current context, so prune that one
  exec docker buildx prune --builder "$(docker context show)" \
    --filter type=exec.cachemount --filter description~=agent-base-nix "$@"
}

# GitHub token and git identity of the host
github_git_args() {
  if [ -z "${GH_TOKEN:-}${GH_ENTERPRISE_TOKEN:-}" ] && command -v gh >/dev/null; then
    local host="${GH_HOST:-}"
    if [ -z "$host" ]; then
      # hosts with an active account, as reported by gh itself
      local hosts
      hosts="$(gh auth status --json hosts 2>/dev/null | jq -r '.hosts | to_entries[] | select(any(.value[]; .active)) | .key')"
      case "$(printf '%s' "$hosts" | grep -c .)" in
        0) echo "agent-container: gh is not logged in to any host, no GitHub token passed" >&2 ;;
        1) host="$hosts" ;;
        *) die "gh is logged in to several hosts ($(echo "$hosts" | paste -sd, -)), select one via GH_HOST" ;;
      esac
    fi
    if [ -n "$host" ]; then
      local token
      token="$(gh auth token --hostname "$host")" || die "gh has no token for $host (gh auth login -h $host)"
      export GH_HOST="$host"
      # gh reads GH_TOKEN for github.com, GH_ENTERPRISE_TOKEN for enterprise hosts
      case "$host" in
        github.com | *.ghe.com) export GH_TOKEN="$token" ;;
        *) export GH_ENTERPRISE_TOKEN="$token" ;;
      esac
    fi
  fi
  forward_env GH_TOKEN GH_ENTERPRISE_TOKEN GH_HOST

  export GIT_AUTHOR_NAME="${GIT_AUTHOR_NAME:-$(git config user.name || true)}"
  export GIT_AUTHOR_EMAIL="${GIT_AUTHOR_EMAIL:-$(git config user.email || true)}"
  export GIT_COMMITTER_NAME="${GIT_COMMITTER_NAME:-$GIT_AUTHOR_NAME}"
  export GIT_COMMITTER_EMAIL="${GIT_COMMITTER_EMAIL:-$GIT_AUTHOR_EMAIL}"
  forward_env GIT_AUTHOR_NAME GIT_AUTHOR_EMAIL GIT_COMMITTER_NAME GIT_COMMITTER_EMAIL
}

pi_args() {
  # Create the mount sources, else docker creates them as root-owned directories.
  mkdir -p "$pi_dir/sessions" "$pi_dir/skills" "$pi_dir/pi-subagents" "$HOME/.gradle"
  if [ ! -e "$pi_dir/auth.json" ]; then
    (umask 077 && echo '{}' >"$pi_dir/auth.json")
  fi
  args+=(
    -v "$pi_dir/sessions:$home/.pi/agent/sessions"
    -v "$pi_dir/auth.json:$home/.pi/agent/auth.json"
    -v "$pi_dir/skills:$home/.pi/agent/skills:ro"
    -v "$pi_dir/pi-subagents:$home/.pi/agent/pi-subagents"
    -v "$HOME/.gradle:$home/.gradle"
  )
  if [ -e "$pi_dir/caveman.json" ]; then
    args+=(-v "$pi_dir/caveman.json:$home/.pi/agent/caveman.json")
  fi
}

claude_args() {
  args+=(-e CLAUDE_CODE_USE_BEDROCK=1)
  forward_env ANTHROPIC_MODEL ANTHROPIC_SMALL_FAST_MODEL \
    ANTHROPIC_DEFAULT_OPUS_MODEL ANTHROPIC_DEFAULT_SONNET_MODEL ANTHROPIC_DEFAULT_HAIKU_MODEL
}

cmd_run() {
  local agent="$1"
  shift
  local image="agent-base:latest"
  local network=()
  while [ $# -gt 0 ]; do
    case "$1" in
      --image) image="$2"; shift 2 ;;
      --network) network=(--network "$2"); shift 2 ;;
      -h | --help) usage; exit 0 ;;
      --) shift; break ;;
      *) break ;;
    esac
  done
  require_docker

  args+=(-v "$PWD:$PWD" -w "$PWD")
  if [ -r "$ca_file" ]; then
    args+=(-v "$ca_file:/run/secrets/ca:ro")
  fi
  "${agent}_args"
  github_git_args

  # Resolve an AWS profile to plain env credentials; config files are not mounted.
  if [ -n "${AWS_PROFILE:-}" ] && [ -z "${AWS_ACCESS_KEY_ID:-}" ] && command -v aws >/dev/null; then
    local creds
    creds="$(aws configure export-credentials --profile "$AWS_PROFILE" --format env)"
    eval "$creds"
  fi
  forward_env AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN \
    AWS_REGION AWS_DEFAULT_REGION AWS_BEARER_TOKEN_BEDROCK

  local tty=()
  if [ -t 0 ] && [ -t 1 ]; then
    tty=(-it)
  fi

  exec docker run --rm "${tty[@]}" "${network[@]}" "${args[@]}" "$image" "$agent" "$@"
}

case "${1:-}" in
  build) shift; cmd_build "$@" ;;
  prune-cache) shift; cmd_prune-cache "$@" ;;
  pi | claude) cmd_run "$@" ;;
  -h | --help) usage ;;
  "") usage >&2; exit 1 ;;
  *) die "unknown command '$1' (expected build, prune-cache, pi or claude; see --help)" ;;
esac
