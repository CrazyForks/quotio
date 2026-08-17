# Scripts

Quotio has two self-contained script entrypoints:

- `build_and_run.sh`: build Debug, stop any running Quotio process, and launch the fresh app. Optional flags: `--debug`, `--logs`, `--telemetry`, `--verify`.
- `build_dmg.sh`: build a Release archive, verify the bundled proxy, and create ZIP and DMG artifacts.

For a local release build:

```bash
./scripts/build_dmg.sh
```

The release workflow also uses this entrypoint to prepare the requested version and generate the signed Sparkle appcast:

```bash
SPARKLE_PRIVATE_KEY=... ./scripts/build_dmg.sh --version 1.2.3 --generate-appcast
```
