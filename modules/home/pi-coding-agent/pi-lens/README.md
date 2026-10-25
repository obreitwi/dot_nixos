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

## pi-lens ↔ memelint integration

memelint (Simplified Technical English linter) has no LSP mode and pi-lens has
no generic "CLI runner" hook. So `default.nix` does the following:

- Generates `~/.pi-lens/config.json` from the nix store (`home.file`). It
  overrides the launcher of the built-in `marksman` server.
- The override starts `marksman-memelint`: `rass` (rassumfrassum, LSP
  multiplexer) runs `marksman server` **and** `efm-langserver`. efm runs
  `memelint check <file>` and reports the findings as diagnostics with severity
  *error* and source `memelint`, so that pi-lens reports them to the agent
  (warnings are not picked up).
- pi-lens still sees one primary server (`marksman`) with its original
  capabilities. memelint only adds diagnostics. marksman diagnostics are
  streamed by `rass` without waiting for memelint.

Notes:

- A failing `memelint` call is ignored by efm (it publishes empty diagnostics
  at once, so the file is not left unconfirmed). But if the efm *process* dies,
  `rass` exits and so does marksman (pi-lens then sees a failed server).
- Code/config files: a custom pi-lens server `memelint` (plain
  `efm-langserver`, extensions in `memelintExtensions`) is registered via
  `lsp.servers`. pi-lens cannot make custom servers *auxiliary* (their `role`
  is ignored), and write-time checks only run the first built-in server of a
  file. So for files that have a built-in server (e.g. `.py`, `.kt`, `.nix`)
  memelint only runs in full scans (`lens_diagnostics mode=full`), not on
  every write. It is the primary (and checked at write time) only for
  extensions without a built-in server: `.scala`, `.sql`, `.hcl`.
- memelint does not lint `.yaml`, `.html` or `.tf`, so they are not listed.
- memelint cannot lint Typst (`.typ`) yet, so tinymist is not wrapped.
- An existing hand-written `~/.pi-lens/config.json` must be moved away before
  the first `home-manager switch`.

Verify: `effective_config file=README.md` shows the `marksman` override; write a
`.md` file containing a contraction (e.g. "don't") and expect a `memelint`
error next to marksman's diagnostics.
