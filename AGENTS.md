# Bridge2Babble

Native iOS (SwiftUI, iOS 26) push-to-talk translator. Speech, translation and
text-to-speech all run on the device. The Xcode project is generated from
`project.yml` with `xcodegen`.

## Kane CLI tests

Kane files live in `.testmuai/`, which is a hidden folder, and evidence packs
are gitignored. Default searches (`rg`, `fd`, many file globs) skip both, so
search with `rg --hidden --no-ignore` or list the folder directly.

- `.testmuai/tests/*_test.md`: Kane tests
- `.testmuai/tests/output-<name>/Result.md`: latest result for each test
- `.testmuai/evidence/*.evidence`: evidence packs (screenshots, step logs)
- `build/kane-last.ndjson` / `build/kane-last.stderr`: output of the last
  `scripts/verify.sh` run

## Verifying a change

Run `scripts/verify.sh` after each change. It builds the app for the iOS
simulator, runs every Kane test, and exits 0 only when all of them pass.

- `scripts/verify.sh --build-only`: build only
- `MATCH=type_translate scripts/verify.sh`: run a subset

On a failure, read the failing step and its remark, then decide what kind of
failure it is before editing anything:

- App bug: fix the code and rerun.
- Environment: for example, Apple Intelligence is off on the Mac, or a
  language pack isn't installed. Report it; don't change the code.
- Requirement changed: update the requirement and redesign the test. Don't
  weaken an assertion so it passes.

## Simulator notes

Apple Translation doesn't run in the simulator, so there the app always uses
the Apple Intelligence fallback. That needs Apple Intelligence turned on on
the host Mac. Translations can be worded differently each time, so Kane
assertions check meaning, not exact text.
