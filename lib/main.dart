import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'common_libs.dart';
import 'firebase_options.dart';
import 'logic/projects_logic.dart';
import 'logic/collectibles_logic.dart';
import 'logic/experiences_logic.dart';
import 'logic/locale_logic.dart';
import 'logic/timeline_logic.dart';
import 'logic/unsplash_logic.dart';
import 'logic/wallpaper_logic.dart';
import 'logic/wonders_logic.dart';

void main() async {
  // Handle asynchronous errors.
  //
  // More info here https://dart.dev/articles/archive/zones and https://docs.flutter.dev/testing/errors
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
    // // Keep native splash screen up until app is finished bootstrapping
    // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

    // The Flutter framework catches errors that occur during callbacks triggered
    // by the framework itself, including errors encountered during the build,
    // layout, and paint phases. Errors that don’t occur within Flutter’s
    // callbacks can’t be caught by the framework.
    //
    // More info on https://docs.flutter.dev/testing/errors.
    //
    // The app sends these errors to Firebase Crashlytics.
    //
    // Not all errors will be caught here, eg. asynchronous functions errors that come from Dart (an
    // exception happen inside the onPressed of a button).
    FlutterError.onError = (details) async {
      // If automatic data collection is disabled for Crashlytics, crash reports
      // are stored on the device. To check for reports, use the `checkForUnsentReports`
      // method. Use `sendUnsentReports` to upload existing reports even when
      // automatic data collection is disabled. Use [deleteUnsentReports] to
      // delete any reports stored on the device without sending them to
      // Crashlytics.
      //
      // Temporarily toggle this to true if you want to test crash reporting in
      // your app.
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(!kDebugMode);

      if (kReleaseMode && !PlatformInfo.isWeb) {
        await FirebaseCrashlytics.instance.recordError(
          details.exception,
          details.stack,
          information: details.context != null ? [details.context!] : const [],
        );
      }
      // Debug and rest of profile modes.
      else {
        // Log the error on the IDE's console.
        FlutterError.presentError(details);
      }
    };

    //   // Keep native splash screen up until app is finished bootstrapping
    // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

    registerSingletons();

    runApp(App());

    await appLogic.bootstrap();

    // // Remove splash screen when bootstrap is complete
    // FlutterNativeSplash.remove();
  }, (error, stack) {
    if (kReleaseMode && !PlatformInfo.isWeb) {
      FirebaseCrashlytics.instance.recordError(error, stack);
    }
    // Debug and rest of profile modes.
    else {
      // Log the error on the IDE's console.
      FlutterError.presentError(FlutterErrorDetails(exception: error, stack: stack));
    }
  });
}

/// Creates an app using the [MaterialApp.router] constructor and the global `appRouter`, an instance of [GoRouter].
class App extends StatelessWidget with GetItMixin {
  App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locale = watchX((SettingsLogic s) => s.currentLocale);

    return FutureBuilder(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return MaterialApp.router(
              routeInformationProvider: appRouter.routeInformationProvider,
              routeInformationParser: appRouter.routeInformationParser,
              routerDelegate: appRouter.routerDelegate,
              title: 'Guillem Curriculum',
              theme: ThemeData(
                fontFamily: $styles.text.body.fontFamily,
                useMaterial3: true,
              ),
              locale: locale == null ? null : Locale(locale),
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: AppLocalizations.supportedLocales,
              debugShowCheckedModeBanner: false,
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          return Center(child: CircularProgressIndicator());
        });
  }

  Future<void> fetchData() async {
    await experiencesLogic.init();
    await projectsLogic.init();
  }
}

/// Create singletons (logic and services) that can be shared across the app.
void registerSingletons() {
  // Top level app controller
  GetIt.I.registerLazySingleton<AppLogic>(() => AppLogic());
  // Experiences
  GetIt.I.registerLazySingleton<ExperiencesLogic>(() => ExperiencesLogic());
  // Projects
  GetIt.I.registerLazySingleton<ProjectsLogic>(() => ProjectsLogic());
  // Wonders
  GetIt.I.registerLazySingleton<WondersLogic>(() => WondersLogic());
  // Timeline / Events
  GetIt.I.registerLazySingleton<TimelineLogic>(() => TimelineLogic());
  // Settings
  GetIt.I.registerLazySingleton<SettingsLogic>(() => SettingsLogic());
  // Unsplash
  GetIt.I.registerLazySingleton<UnsplashLogic>(() => UnsplashLogic());
  // Collectibles
  GetIt.I.registerLazySingleton<CollectiblesLogic>(() => CollectiblesLogic());
  // Localizations
  GetIt.I.registerLazySingleton<LocaleLogic>(() => LocaleLogic());
}

/// Add syntax sugar for quickly accessing the main "logic" controllers in the app
/// We deliberately do not create shortcuts for services, to discourage their use directly in the view/widget layer.
AppLogic get appLogic => GetIt.I.get<AppLogic>();
ExperiencesLogic get experiencesLogic => GetIt.I.get<ExperiencesLogic>();
ProjectsLogic get projectsLogic => GetIt.I.get<ProjectsLogic>();
WondersLogic get wondersLogic => GetIt.I.get<WondersLogic>();
TimelineLogic get timelineLogic => GetIt.I.get<TimelineLogic>();
SettingsLogic get settingsLogic => GetIt.I.get<SettingsLogic>();
UnsplashLogic get unsplashLogic => GetIt.I.get<UnsplashLogic>();
CollectiblesLogic get collectiblesLogic => GetIt.I.get<CollectiblesLogic>();
WallPaperLogic get wallpaperLogic => GetIt.I.get<WallPaperLogic>();
LocaleLogic get localeLogic => GetIt.I.get<LocaleLogic>();

/// Global helpers for readability
AppLocalizations get $strings => localeLogic.strings;
AppStyle get $styles => AppScaffold.style;
