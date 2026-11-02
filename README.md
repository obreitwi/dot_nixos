<div align="center">
  
# .nixos - central configuration for all my machines 

</div>

`nixpkgs` is used in several ways:
* As nixOS installation on desktops and my root.
* Via home-manager on top of Ubuntu.
* as standalone-`nixvim` configuration to be used everywhere else

### Install

#### NixOS
* Install NixOS via install medium.
* Activate flake. 

#### Non-NixOS
* Install nix
  Note to add yourself to `nix-users` on arch…

* Enable experimental features: nix-command flakes
  Add to `/etc/nix/nix.conf`:
```
experimental-features = nix-command flakes
```

* Run `./utils/install-non-nixos.sh`

### agent-base docker image

`docker/agent-base` builds a docker image with `pi` and its home-manager config
(`modules/home/pi-coding-agent`, Bedrock settings, pi packages pre-installed)
plus `claude`. Nix runs inside `docker build`, so no Linux builder is needed on
the host. The `agent-container` wrapper (`packages/agent-container`) comes with
the pi module (host only).

* `agent-container build`: build `agent-base:latest` for the host arch, with the uid/gid
  of the calling user. A corporate CA (`$AGENT_CONTAINER_CA`, default
  `~/.local/share/certs/zscaler.cer`) is passed as a build secret.
  Built and fetched nix paths persist in a docker build cache mount. It is a
  signed local binary cache (see `docker/agent-base/build-root.sh`), so rebuilds
  do not fetch or compile again. Clear it via `agent-container prune`.
* `agent-container pi|claude [--image IMG] [--network NET] [--] [agent-args...]`:
  run the agent in the current directory. The directory is mounted at the same
  path as on the host, the CA read-only. AWS credentials are forwarded as env
  variables (an `AWS_PROFILE` is resolved via `aws configure export-credentials`).
  The GitHub token (`GH_TOKEN`/`GH_ENTERPRISE_TOKEN`, else `gh auth token`),
  `GH_HOST` and the git author (`GIT_AUTHOR_*`/`GIT_COMMITTER_*`, else
  `git config user.{name,email}`) are forwarded as well.
  * `pi` also mounts `~/.pi/agent/{sessions,auth.json,skills,pi-subagents,caveman.json}`
    and `~/.gradle`.
  * `claude` gets nothing else: it runs via Bedrock (`CLAUDE_CODE_USE_BEDROCK=1`,
    `ANTHROPIC_*MODEL` forwarded) and keeps no state between runs.

Derived (project) images: `FROM agent-base:latest`, switch to `USER root` to build
dev dependencies with nix (`nix-command flakes` enabled), put them on `PATH`,
then switch back to `USER agent`. The entrypoint
(`/opt/agent-base/entrypoint`) loads the session variables and the CA.
