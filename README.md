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
- We only want the build directory of this branch on Github to then be hosted on Github Pages. We want to ignore the git publishing of the rest of the files in this branch. Replace `/.gitignore` for this:
```*
!.gitignore
!.github/workflows/
!/build/
!/build/web/
!/build/web/**
```

- Change `<base href="/">` for `<base href=“./“>`
- If you use environmental variables (in file extensions `.env`) like in this project for Supebase SDK, follow this step. Change file `/.env` for:
API_DATABASE_URL=${API_DATABASE_URL}
We use the syntax `${…}` because Github Action [replace-env](https://github.com/marketplace/actions/replace-env) is going to replace it in the Github workflow.

Else delete `dotenv` package and the code related, then replace usage of environmental variables with your API URL or SDK


## Acknowledgements

Designs based on [Wonderous app](https://github.com/gskinnerTeam/flutter-wonderous-app).
