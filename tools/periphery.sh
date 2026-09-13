#!/bin/bash
set -euo pipefail

version=3.8.0
checksum=07d4e286e31dd79164df39097e0b59f533c94badbe18158464a455ea88a166d7
repo_root="$(cd "$(dirname "$0")/.." && pwd)"
periphery_dir="$(mktemp -d "${TMPDIR:-/tmp}/moneta-periphery.XXXXXX")"
trap 'rm -rf "$periphery_dir"' EXIT
curl --fail --silent --show-error --location --retry 3 \
  "https://github.com/peripheryapp/periphery/releases/download/${version}/periphery-${version}.zip" \
  --output "$periphery_dir/periphery.zip"
printf '%s  %s\n' "$checksum" "$periphery_dir/periphery.zip" | shasum --algorithm 256 --check
unzip -q "$periphery_dir/periphery.zip" -d "$periphery_dir"
cd "$repo_root"
"$periphery_dir/periphery" scan --config .periphery.yml --strict \
  -- -destination 'generic/platform=iOS Simulator' CODE_SIGNING_ALLOWED=NO
