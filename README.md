# Guillem Currriculm App

Curriculum of Guillem.

## Getting Started

Developed on Flutter 3.10.6

Run the app:

1. Run on the project directory `flutter pub get`.
2. Open a simulators (iOS or Android).
3. `flutter run` will automatically generated [translations](https://docs.flutter.dev/accessibility-and-localization/internationalization).

## Deploy on web

1. Copy `main` branch to a new branch, e.g. `web`.
2. Duplicate `example.env` to a file called `.env` replacing the example values.
3. Run `flutter build web` or `flutter build web --release` to make the size smaller.
4. Setup Github Actions to auto deployment as Github Page, for more look at this project branch `web`, folder `/.github/workflows/actions.yml`.

## Acknowledgements

App based on [Wonderous app](https://github.com/gskinnerTeam/flutter-wonderous-app).
