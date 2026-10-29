#!/usr/bin/env bash
# Build Bridge2Babble for the iOS simulator, zip it, and run the Kane CLI suite.
# Exit 0 only when every Kane flow passes. Prints a short summary that an
# agent can read and act on (see .claude/settings.json Stop hook).
#
#   scripts/verify.sh               # build + run every Kane assurance test
#   scripts/verify.sh --build-only  # just produce build/Bridge2Babble.zip
#   MATCH='type_translate' scripts/verify.sh   # run a subset
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

DEVICE="${KANE_DEVICE:-iPhone 17 Pro}"
OS_VERSION="${KANE_OS:-26.5}"
MATCH="${MATCH:-}"
BUILD_DIR="$ROOT/build"
APP="$BUILD_DIR/Build/Products/Debug-iphonesimulator/Bridge2Babble.app"
ZIP="$BUILD_DIR/Bridge2Babble.zip"
LOG="$BUILD_DIR/kane-last.ndjson"

mkdir -p "$BUILD_DIR"

if [[ ! -d Bridge2Babble.xcodeproj || project.yml -nt Bridge2Babble.xcodeproj/project.pbxproj ]]; then
  xcodegen generate --quiet
fi

echo "▸ Building Bridge2Babble for the simulator…"
if ! xcodebuild -project Bridge2Babble.xcodeproj -scheme Bridge2Babble \
    -sdk iphonesimulator -configuration Debug \
    -destination "generic/platform=iOS Simulator" \
    -derivedDataPath "$BUILD_DIR" -quiet build 2>&1 | grep -E 'error:|warning: .*deprecated' ; then
  :
fi
if [[ ! -d "$APP" ]]; then
  echo "✗ BUILD FAILED (no .app produced). Fix the compiler errors above."
  exit 1
fi

rm -f "$ZIP"
(cd "$(dirname "$APP")" && zip -qr "$ZIP" "$(basename "$APP")")
echo "▸ Built $ZIP"

[[ "${1:-}" == "--build-only" ]] && exit 0

shopt -s nullglob
# Keep only Kane's requirement-linked tests. The prior handwritten test remains
# as historical evidence but must not be counted as assurance coverage.
TESTS=()
for candidate in .testmuai/tests/*_test.md; do
  if [[ -n "$MATCH" && "$candidate" != *"$MATCH"* ]]; then
    continue
  fi
  if rg -q '^assurance:' "$candidate"; then
    TESTS+=("$candidate")
  fi
done
if (( ${#TESTS[@]} == 0 )); then
  echo "✗ No Kane assurance tests found in .testmuai/tests/"
  exit 1
fi

echo "▸ Running ${#TESTS[@]} Kane flow(s) on $DEVICE / iOS $OS_VERSION…"
set +e
KANE_CLI_USER_AGENT="${KANE_CLI_USER_AGENT:-codex}" kane-cli config set-target simulator >/dev/null
KANE_CLI_USER_AGENT="${KANE_CLI_USER_AGENT:-codex}" kane-cli config set-device-name "$DEVICE" >/dev/null
KANE_CLI_USER_AGENT="${KANE_CLI_USER_AGENT:-codex}" kane-cli config set-os-version "$OS_VERSION" >/dev/null
KANE_CLI_USER_AGENT="${KANE_CLI_USER_AGENT:-codex}" kane-cli config set-app "$ZIP" >/dev/null
KANE_CLI_USER_AGENT="${KANE_CLI_USER_AGENT:-codex}" kane-cli testrun run "${TESTS[@]}" \
  --agent < /dev/null > "$LOG" 2> "$BUILD_DIR/kane-last.stderr"
KANE_EXIT=$?
set -e

# Per-test results, then the suite verdict.
jq -r 'select(.type=="testrun_member_end" or .type=="testrun_authored_member_end")
       | "  \(if .status=="passed" then "✓" else "✗" end) \(.path // "test"): \(.status)\(if .failure.message then " — \(.failure.message)" else "" end)"' "$LOG" 2>/dev/null || true
jq -r 'select(.status=="failed" and .step) | "    failed step \(.step): \(.remark)"' "$LOG" 2>/dev/null | head -20 || true
jq -r 'select(.type=="testrun_summary") | "▸ Suite: passed \(.totals.passed) / failed \(.totals.failed) / broken \(.totals.broken)"' "$LOG" 2>/dev/null || true

if (( KANE_EXIT != 0 )); then
  echo "✗ KANE FAILED (exit $KANE_EXIT). Full stream: $LOG"
  tail -5 "$BUILD_DIR/kane-last.stderr" 2>/dev/null || true
  exit 1
fi
echo "✓ All Kane flows passed."
