import 'package:flutter/cupertino.dart';
import 'package:guillem_curriculum/ui/screens/experiences/experience_detail/experience_detail_screen.dart';

import 'logic/data/experience_data.dart';
import 'common_libs.dart';
import 'ui/common/modals/fullscreen_video_viewer.dart';
import 'ui/screens/projects/projects_carousel/projects_carousel_screen.dart';
import 'ui/screens/projects/project_details/project_details_screen.dart';
import 'ui/screens/artifact/artifact_search/artifact_search_screen.dart';
import 'ui/screens/collection/collection_screen.dart';
import 'ui/screens/experiences/experiences_screen.dart';
import 'ui/screens/intro/intro_screen.dart';
import 'ui/screens/timeline/timeline_screen.dart';
import 'ui/screens/wallpaper_photo/wallpaper_photo_screen.dart';
import 'ui/screens/wonder_details/wonders_details_screen.dart';
import 'ui/screens/library/library_screen.dart';

/// Shared paths / urls used across the app
class ScreenPaths {
  static String splash = '/';
  static String intro = '/introduction';
  static String experiences = '/experiences';
  static String projects = '/projects';
  static String library = '/library';
  static String settings = '/settings';
  static String experienceRoot = '/experience/';
  static String experienceDetails(ExperienceType type) => '${ScreenPaths.experienceRoot}${type.name}';
  // static String experienceDetails(ExperienceType type, {int tabIndex = 0}) =>
  //     '/experience/${type.name}?tabIndex=$tabIndex';
  static String video(String id) => '/video/$id';
  static String highlights(WonderType type) => '/highlights/${type.name}';
  static String search(WonderType type) => '/search/${type.name}';
  static String project(String id) => '/project/$id';
  static String collection(String id) => '/collection?id=$id';
  // static String maps(WonderType type) => '/maps/${type.name}';
  static String timeline(WonderType? type) => '/timeline?type=${type?.name ?? ''}';
  static String wallpaperPhoto(WonderType type) => '/wallpaperPhoto/${type.name}';
}

class ScreenUtility {
  static Widget screenForPath(String path, {ExperienceType type = ExperienceType.softwareDeveloper}) {
    if (path == ScreenPaths.splash) {
      return Container(color: $styles.colors.greyStrong);
    } else if (path == ScreenPaths.intro) {
      return const IntroScreen();
    } else if (path == ScreenPaths.experiences) {
      return ExperiencesScreen();
    } else if (path.startsWith(ScreenPaths.experienceRoot)) {
      return ExperienceDetailScreen(_parseExperienceType(path));
    } else if (path == ScreenPaths.projects) {
      return const ProjectsCarouselScreen();
    } else if (path == ScreenPaths.library) {
      return const LibraryScreen();
    } else {
      throw Exception('Invalid path: $path');
    }
  }
}

/// Routing table, matches string paths to UI Screens, optionally parses params from the paths
final appRouter = GoRouter(
  redirect: _handleRedirect,
  routes: [
    ShellRoute(
        builder: (context, router, navigator) {
          return AppScaffold(child: navigator);
        },
        routes: [
          // This will be hidden
          GoRoute(
            path: ScreenPaths.splash,
            pageBuilder: (_, __) => MaterialPage(child: ScreenUtility.screenForPath(ScreenPaths.splash)),
          ),
          GoRoute(
            path: ScreenPaths.intro,
            pageBuilder: (_, __) => MaterialPage(child: ScreenUtility.screenForPath(ScreenPaths.intro)),
          ),
          GoRoute(
            path: ScreenPaths.experiences,
            pageBuilder: (_, __) => MaterialPage(child: ScreenUtility.screenForPath(ScreenPaths.experiences)),
          ),
          GoRoute(
            path: ScreenPaths.projects,
            pageBuilder: (_, __) => MaterialPage(child: ScreenUtility.screenForPath(ScreenPaths.projects)),
          ),
          GoRoute(
            path: ScreenPaths.library,
            pageBuilder: (_, __) => MaterialPage(child: ScreenUtility.screenForPath(ScreenPaths.library)),
          ),

          // AppRoute(ScreenPaths.experiences, (_) => ExperiencesScreen()),
          // AppRoute(ScreenPaths.intro, (_) => const IntroScreen()),
          // AppRoute(ScreenPaths.projects, (_) => const ProjectsCarouselScreen()),
          // AppRoute('/wonder/:type', (s) {
          //   int tab = int.tryParse(s.uri.queryParameters['t'] ?? '') ?? 0;
          //   return WonderDetailsScreen(
          //     type: _parseExperienceType(s.pathParameters['type']),
          //     initialTabIndex: tab,
          //   );
          // }, useFade: true),
          GoRoute(
            path: '/experience/:type',
            pageBuilder: (context, state) {
              final type = state.pathParameters['type'];
              // final tabIndex = int.tryParse(state.uri.queryParameters['tabIndex'] ?? '') ?? 0;

              return MaterialPage(
                child: ScreenUtility.screenForPath(ScreenPaths.experienceDetails(
                  _parseExperienceType(type),
                  // tabIndex: tabIndex,
                )),
              );
            },
          ),
          // AppRoute('/timeline', (s) {
          //   return TimelineScreen(type: _tryParseWonderType(s.uri.queryParameters['type']!));
          // }),
          // AppRoute('/video/:id', (s) {
          //   return FullscreenVideoViewer(id: s.pathParameters['id']!);
          // }),
          // AppRoute(
          //   '/highlights/:type',
          //   (s) => const ProjectsCarouselScreen(
          //       // type: _parseWonderType(s.pathParameters['type'])
          //       ),
          // ),
          // AppRoute('/search/:type', (s) {
          //   return ArtifactSearchScreen(type: _parseWonderType(s.pathParameters['type']));
          // }),
          AppRoute('/project/:id', (s) {
            return ProjectDetailsScreen(projectId: s.pathParameters['id']!);
          }),
          // AppRoute('/collection', (s) {
          //   return CollectionScreen(fromId: s.uri.queryParameters['id'] ?? '');
          // }),
          // AppRoute('/wallpaperPhoto/:type', (s) {
          //   return WallpaperPhotoScreen(type: _parseWonderType(s.pathParameters['type']));
          // }),
        ]),
  ],
);

/// Custom GoRoute sub-class to make the router declaration easier to read
class AppRoute extends GoRoute {
  AppRoute(String path, Widget Function(GoRouterState s) builder,
      {List<GoRoute> routes = const [], this.useFade = false})
      : super(
          path: path,
          routes: routes,
          pageBuilder: (context, state) {
            final pageContent = Scaffold(
              body: builder(state),
              resizeToAvoidBottomInset: false,
            );
            if (useFade) {
              return CustomTransitionPage(
                key: state.pageKey,
                child: pageContent,
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  // return FadeTransition(opacity: animation, child: child);
                  return SlideTransition(
                    key: state.pageKey,
                    position: Tween<Offset>(
                      begin: const Offset(0.0, 1.0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  );
                },
              );
            }
            return CupertinoPage(child: pageContent);
          },
        );
  final bool useFade;
}

String? _handleRedirect(BuildContext context, GoRouterState state) {
  // Prevent anyone from navigating away from `/` if app is starting up.
  if (!appLogic.isBootstrapComplete && state.uri.toString() != ScreenPaths.splash) {
    return ScreenPaths.splash;
  }
  debugPrint('Navigate to: ${state.uri.toString()}');

  // Do nothing
  return null;
}

ExperienceType _parseExperienceType(String? value) {
  const fallback = ExperienceType.softwareDeveloper;

  if (value == null) return fallback;
  final parse = _tryParseExperienceType(value.replaceFirst(ScreenPaths.experienceRoot, ''));
  final fin = parse ?? fallback;
  return fin;
}

ExperienceType? _tryParseExperienceType(String value) => ExperienceType.values.asNameMap()[value];
