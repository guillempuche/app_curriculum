import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'common_libs.dart';
import 'logic/projects_logic.dart';
import 'logic/collectibles_logic.dart';
import 'logic/experiences_logic.dart';
import 'logic/locale_logic.dart';
import 'logic/timeline_logic.dart';
import 'logic/unsplash_logic.dart';
import 'logic/wallpaper_logic.dart';
import 'logic/wonders_logic.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // Keep native splash screen up until app is finished bootstrapping
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await dotenv.load(fileName: ".env");

  await Supabase.initialize(url: dotenv.env['API_SUPABASE']!, anonKey: dotenv.env['API_SUPABASE_KEY']!);

  registerSingletons();

  usePathUrlStrategy();

  await appLogic.bootstrap();
  runApp(App());

  // Remove splash screen when bootstrap is complete
  FlutterNativeSplash.remove();
}

/// Creates an app using the [MaterialApp.router] constructor and the global `appRouter`, an instance of [GoRouter].
class App extends StatelessWidget with GetItMixin {
  App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locale = watchX((SettingsLogic s) => s.currentLocale);

    return MaterialApp.router(
      routeInformationProvider: appRouter.routeInformationProvider,
      routeInformationParser: appRouter.routeInformationParser,
      routerDelegate: appRouter.routerDelegate,
      title: 'Guillem Curriculum',
      // onGenerateTitle: (context) {
      //   return getScreenTitles[GoRouter.of(context)..toString()] ?? 'Guillem Curriculum';
      // },
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
