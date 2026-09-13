#!/bin/bash
set -euo pipefail

# Use the same verified release locally and in CI.
version=0.65.1
checksum=c1e429b0599cf1b516f369a2d9ec04eaf0e436f3c12b637df8851fa52ff694d0
repo_root="$(cd "$(dirname "$0")/.." && pwd)"
swiftlint_dir="$(mktemp -d "${TMPDIR:-/tmp}/moneta-swiftlint.XXXXXX")"
trap 'rm -rf "$swiftlint_dir"' EXIT

curl --fail --silent --show-error --location --retry 3 \
  "https://github.com/realm/SwiftLint/releases/download/${version}/portable_swiftlint.zip" \
  --output "$swiftlint_dir/swiftlint.zip"
printf '%s  %s\n' "$checksum" "$swiftlint_dir/swiftlint.zip" | shasum --algorithm 256 --check
unzip -q "$swiftlint_dir/swiftlint.zip" -d "$swiftlint_dir"
cd "$repo_root"
"$swiftlint_dir/swiftlint" lint --strict --no-cache --config .swiftlint.yml "$@"
