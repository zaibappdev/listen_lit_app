# Listen Lit

**A clean, theme-aware music player for your device and licensed online music.**

Listen Lit is a Flutter portfolio project by **Zaibappdev**. It combines an on-device music library with a Jamendo Creative Commons catalog and Android background playback.

> This project is actively being developed. See [Known limitations](#known-limitations) before using it as a release build.

## Screenshots

Screenshots and a short demo GIF belong in [`docs/screenshots/`](docs/screenshots/). The folder includes capture guidance; no device screenshots are included yet.

## Features

- Local audio library discovery using `on_audio_query`.
- Jamendo online catalog adapter for featured and searched tracks. Tracks show artist, provider and license credits.
- Background playback, Android media notification, lock-screen controls, audio focus and headset controls.
- Light, Dark and System appearance settings.
- Favorites, recent tracks, profile and settings screens.
- Local settings and user data stored with Hive.

## Tech stack

| Area | Packages / platform |
| --- | --- |
| UI and state | Flutter Material 3, Provider |
| Audio | `just_audio`, `audio_service`, `audio_session` |
| Device library | `on_audio_query`, `permission_handler` |
| Persistence | Hive, `shared_preferences` |
| Online catalog | Jamendo API v3 over `http` |
| Artwork | Flutter image providers, cached local notification artwork |

### Third-party credits

The app uses Flutter, Provider, just_audio, audio_service, audio_session, Hive, path_provider, permission_handler, on_audio_query, palette_generator, shared_preferences, share_plus and http. Their respective package pages and licenses are available through [pub.dev](https://pub.dev/).

Online tracks come from Jamendo. The app displays each track's artist and Creative Commons license URL. Jamendo content remains the responsibility of its respective rights holders; review the [Jamendo API terms](https://devportal.jamendo.com/api_terms_of_use) and each track's license before distribution or monetization. The app does not download tracks.

The UI currently uses the system font and Material icons; no external font package is bundled.

## Architecture

The project uses a feature-first structure and Provider view models:

```text
lib/
  core/                 theme and shared constants
  data/
    models/             user and song models
    repositories/       licensed online catalog adapters
    services/           audio handler, permissions, Hive storage
  features/             auth, home, library, music, profile, search, settings
  shared/widgets/       reusable loading, error and image widgets
```

`OnlineMusicRepository` is the provider boundary. `JamendoMusicRepository` implements it, so another licensed provider can be substituted without coupling UI widgets to API response objects.

## Requirements

- Flutter **3.44 or later** and Dart **3.12 or later** (matching the resolved package lockfile).
- Android Studio with Android SDK and JDK 17.
- A Jamendo API client ID from the [Jamendo developer portal](https://devportal.jamendo.com/).

## Setup

1. Clone the repository and install dependencies:

   ```sh
   flutter pub get
   ```

2. Copy `.env.example` to `.env.local` and add your Jamendo client ID. `.env.local` is ignored by Git. Pass the value at build time; do not commit API credentials:

   **PowerShell**
   ```powershell
   $env:JAMENDO_CLIENT_ID = "your-client-id"
   flutter run --dart-define=JAMENDO_CLIENT_ID=$env:JAMENDO_CLIENT_ID
   ```

   **Bash**
   ```sh
   export JAMENDO_CLIENT_ID="your-client-id"
   flutter run --dart-define=JAMENDO_CLIENT_ID="$JAMENDO_CLIENT_ID"
   ```

   The Jamendo client ID is embedded in the client application and is not a server secret. Register the app with Jamendo and follow its current API usage terms. Without the define, local playback remains available and the online catalog shows a setup message.

3. Run checks:

   ```sh
   dart format .
   flutter analyze
   flutter test
   ```

## Android build

```sh
flutter build apk --release --dart-define=JAMENDO_CLIENT_ID=your-client-id
```

Before publishing, create an upload keystore and copy `android/key.properties.example` to `android/key.properties`, replacing every placeholder. The release build uses debug signing only when the private file is absent; that APK is for local verification, not store publishing. Do not commit keystores, `key.properties`, Google service configuration, or signing credentials. Test the notification, notification permission, lock screen and battery optimization behavior on physical Android devices.

## Roadmap

- Add editable playlists and device folder filters.
- Complete device folder filters, playlists and 24-hour history behavior.
- Search local and online libraries together, with related-result ranking.
- Add release signing instructions, app-store artwork and device QA screenshots.
- Improve accessibility, responsive layouts and widget-level rebuild granularity.

## Known limitations

- Jamendo requires the developer-provided client ID at build time.
- Online favorites and history are not yet fully reconstructed from stored online track metadata.
- Folder management, offline downloads, equalizer, lyrics, backup/restore, localization and advanced listening analytics are not implemented.
- Android debug APK build and physical device QA have not been verified in this environment.
- The older `on_audio_query_android` dependency needs the namespace compatibility adjustment in `android/build.gradle.kts` for AGP 8+.

## License

The application source is licensed under the MIT License. Music fetched from Jamendo is separately licensed; the app license does not apply to third-party tracks.

## Author

**Zaibappdev**

- LinkedIn: [add your profile URL]
- Facebook: [add your page URL]
- Instagram: [add your profile URL]
- TikTok: [add your profile URL]
