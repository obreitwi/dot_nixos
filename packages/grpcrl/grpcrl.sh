#!/usr/bin/env bash

set -Eeuo pipefail
shopt -s inherit_errexit

GIT_ROOT=$(git rev-parse --show-toplevel)

mapfile -t all_protofiles < <(find "$GIT_ROOT/services" \( -type d -name internal -prune -false \) -or -type f \( -name "api.proto" -or -name "internal.proto" \) | sort | uniq)

folders=(
    "$GIT_ROOT"
    "$GIT_ROOT/services"
    "$GIT_ROOT/pkg"
    "$GIT_ROOT/proto"
)

grpcurl_args=(
    -plaintext
    -d "@"
)

for fld in "${folders[@]}"; do
    if [ -e "$fld" ]; then
        grpcurl_args+=( -import-path "$fld" )
    fi
done

for proto in "${all_protofiles[@]}"; do
    grpcurl_args+=( -proto "$proto" )
done

if [ -n "${GRPCRL_DEBUG:-}" ]; then
    echo "# Executing:" grpcurl "${grpcurl_args[@]}" "$@" >/dev/stderr
fi

grpcurl "${grpcurl_args[@]}" "$@"
