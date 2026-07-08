# pi-lens ↔ detekt integration

This directory wires the project's **detekt** standards into
[pi-lens](https://github.com/apmantza/pi-lens) so that violations (most notably
`MultilineRawStringIndentation` on the multi-line SQL strings in the repository
classes) are flagged **while code is being written/edited**, instead of only
failing later in `./gradlew :check`.

## What was configured

1. **Config discovery — `detekt.yml` at the repo root.**
   pi-lens ships a built-in, enabled-by-default detekt runner, but it only
   auto-discovers a config named `detekt.yml` / `.detekt.yml` /
   `config/detekt/detekt.yml` / `detekt/detekt.yml`. Our canonical config is
   `detekt-config.yml`, so pi-lens never saw it. `detekt.yml` is a **symlink**
   to `detekt-config.yml` — one source of truth, discovered by both pi-lens and
   (optionally) the Gradle plugin.

2. **`config.validation: false` in `detekt-config.yml`.**
   The Gradle build loads the `formatting` (ktlint) and `libraries` rule sets via
   the `detekt:all` bundle. The **standalone detekt CLI** that pi-lens invokes
   does not, so it would abort with *"Property 'formatting' is misspelled or does
   not exist"*. Disabling property validation lets the CLI run the core rule sets
   (style/complexity/etc., including `MultilineRawStringIndentation`) and ignore
   the plugin-only sections. All rules still run under Gradle exactly as before.

3. **`detekt` shim on PATH (this directory).**
   pi-lens's detekt output parser expects the compiler-style line format
   `File.kt:LINE:COL: <severity>: <message> [RuleId]`, but the detekt 1.23.x CLI
   console reporter omits the `warning:`/`error:` severity token. Without it,
   pi-lens parses **zero** findings. The `detekt` script here runs the real
   detekt and injects a `warning:` token into each finding line so pi-lens can
   read it. It is transparent to humans and to Gradle, which call detekt
   directly.

## Activation (required for the shim)

pi-lens resolves a bare `detekt` from `PATH`. Prepend this directory to `PATH`
in whatever launches your `pi`/pi-lens session so the shim shadows the plain
detekt binary:

```sh
export PATH="$(git rev-parse --show-toplevel)/util/pi-lens:$PATH"
```

Wire that into your dev shell / direnv `.envrc` / shell rc. Verify with:

```sh
command -v detekt          # -> .../util/pi-lens/detekt
detekt --version           # -> 1.23.8 (unchanged; shim is transparent here)
```

> Note: pi-lens's `.venv/bin` / `venv/bin` auto-discovery path is **not** usable
> for the shim — pi-lens double-quotes venv-resolved tool paths on non-Windows
> hosts, which breaks the spawn. PATH is the supported route.
