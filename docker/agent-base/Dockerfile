# agent-base: pi coding agent with its home-manager config from this flake.
# Build via `agent-container build` (context: root of this repository).
FROM nixos/nix:2.35.4

ARG AGENT_UID=501
ARG AGENT_GID=20

COPY docker/agent-base/entrypoint /opt/agent-base/entrypoint

RUN echo "experimental-features = nix-command flakes" >>/etc/nix/nix.conf

# The cache mounts persist between builds (inside colima), see build-root.sh.
RUN --mount=type=bind,target=/src \
    --mount=type=secret,id=ca \
    --mount=type=cache,id=agent-base-nix,target=/nix-cache \
    --mount=type=cache,id=agent-base-nix-fetcher,target=/root/.cache/nix \
    AGENT_UID="$AGENT_UID" AGENT_GID="$AGENT_GID" \
    /opt/agent-base/entrypoint sh /src/docker/agent-base/build-root.sh

ENV USER=agent \
    PATH=/home/agent/.nix-profile/bin:/nix/var/nix/profiles/default/bin
USER agent
WORKDIR /home/agent

# pre-install the pi packages from settings.json so pi starts without network
RUN --mount=type=secret,id=ca,uid=$AGENT_UID \
    /opt/agent-base/entrypoint pi update --extensions

ENTRYPOINT ["/opt/agent-base/entrypoint"]
CMD ["pi"]
