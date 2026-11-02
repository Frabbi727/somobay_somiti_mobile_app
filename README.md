# Somobay Somiti — member app

Flutter app for members of a savings society (somiti). It talks to the Somiti Manager backend
(`/api/v1`); the backend is the source of truth and the app never calculates money.

API documentation: [`docs/`](docs/) (start with `MEMBER_API_SPECIFICATION.md`).

## Environments

There are no Android flavors: the environment is chosen with the `-t` entry file.

| Environment | Entry file | API server |
|---|---|---|
| Development | `lib/main_development.dart` | `API_BASE_URL` if given, else `http://10.0.2.2:8002` (Android emulator) |
| Staging | `lib/main_staging.dart` | `https://shomiti.techrealify.com` |
| Production | `lib/main_production.dart` | `https://shomiti.techrealify.com` |

All three use the same application ID, so installing one replaces the other on a phone.

## Run during development

```bash
flutter pub get

# Android emulator (backend on the Mac at port 8002)
flutter run -t lib/main_development.dart

# Real phone over USB: forward the phone's port 8002 to the Mac
adb reverse tcp:8002 tcp:8002
flutter run -t lib/main_development.dart --dart-define=API_BASE_URL=http://127.0.0.1:8002

# iOS simulator
flutter run -t lib/main_development.dart --dart-define=API_BASE_URL=http://localhost:8002
```

## Release APK (install directly on phones)

```bash
# Development — real phone on the same Wi-Fi as the backend machine (use its IP)
flutter build apk --release -t lib/main_development.dart --dart-define=API_BASE_URL=http://192.168.x.x:8002

# Development — Android emulator (default URL)
flutter build apk --release -t lib/main_development.dart

# Staging
flutter build apk --release -t lib/main_staging.dart

# Production
flutter build apk --release -t lib/main_production.dart --build-name=1.0.0 --build-number=1
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

The single APK contains every CPU architecture (~55 MB). For smaller files, build one APK per
architecture (most phones need `app-arm64-v8a-release.apk`):

```bash
flutter build apk --release --split-per-abi -t lib/main_production.dart
```

## App Bundle (AAB, for the Play Store)

```bash
# Staging (e.g. Play Console internal testing)
flutter build appbundle --release -t lib/main_staging.dart

# Production
flutter build appbundle --release -t lib/main_production.dart --build-name=1.0.0 --build-number=1
```

Output: `build/app/outputs/bundle/release/app-release.aab`

## Before a Play Store upload

1. **Signing.** Release builds are currently signed with the debug key
   (`android/app/build.gradle.kts`), which the Play Store rejects. Create an upload keystore and
   an `android/key.properties` (never commit either) and point the `release` signing config at it.
2. **Version.** Every upload needs a higher `--build-number` (1, 2, 3, …); `--build-name` is the
   version members see. Without the flags, `version:` in `pubspec.yaml` is used.
3. **Backend first.** Deploy the matching backend to the server before releasing the app.
4. **Optional.** Add `--obfuscate --split-debug-info=build/symbols` to production builds and keep
   `build/symbols` to read crash stack traces.

## Tests

```bash
flutter test
flutter analyze

# Opt-in contract check against a running backend (seeded test members)
LIVE_API_URL=http://127.0.0.1:8002 flutter test test/live --tags live
```
