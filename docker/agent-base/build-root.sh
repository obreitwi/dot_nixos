#!/bin/sh
# Root part of the agent-base image build: build the home-manager config of the
# container, create the agent user and link its home.
set -eu

# /nix-cache is a docker build cache mount that outlives single builds: a
# signed local binary cache, so a rebuild does not fetch or compile again.
cache=/nix-cache
key="$cache/signing-key.sec"
if [ ! -f "$key" ]; then
  nix key generate-secret --key-name agent-base-cache >"$key"
fi
pub="$(nix key convert-secret-to-public <"$key")"

system="$(uname -m)-linux"
nix build --print-build-logs --no-write-lock-file \
  --option extra-substituters "file://$cache" \
  --option extra-trusted-public-keys "$pub" \
  -o /opt/agent-base/home "path:/src#packages.${system}.agent-base-home"

# keep build-time paths (nixpkgs sources, toolchains) in the cache as well
nix copy --all --to "file://$cache?compression=zstd&secret-key=$key"

if ! grep -q "^[^:]*:[^:]*:${AGENT_GID}:" /etc/group; then
  echo "agent:x:${AGENT_GID}:" >>/etc/group
fi
echo "agent:x:${AGENT_UID}:${AGENT_GID}:pi agent:/home/agent:/nix/var/nix/profiles/default/bin/bash" >>/etc/passwd

home=/home/agent
hm="$(readlink -f /opt/agent-base/home)"
mkdir -p "$home"
cp -rsT "$(readlink -f "$hm/home-files")" "$home"
find "$home" -type d -exec chmod u+w {} + # copied dirs inherit store permissions
ln -s "$(readlink -f "$hm/home-path")" "$home/.nix-profile"
chown -hR "${AGENT_UID}:${AGENT_GID}" "$home"

nix-collect-garbage
