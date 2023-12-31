import '../ui/screens/experiences/experience_detail/experience_detail_screen.dart';
import 'common_libs.dart';
import 'logic/common/platform_specific.dart' if (dart.library.html) 'logic/common/platform_specific_web.dart';
import 'ui/screens/about/about.dart';
import 'ui/screens/projects/project_details/project_details_screen.dart';
import 'ui/screens/projects/projects_carousel/projects_carousel_screen.dart';
import 'ui/screens/experiences/experiences_screen.dart';
import 'ui/screens/intro/intro_screen.dart';

/// Shared paths / urls used across the app
class ScreenPaths {
  static String splash = '/';
  static String intro = '/introduction';
  static String experiences = '/experiences';
  static String experienceRoot = '/experience/';
  static String experienceDetails(ExperienceType type) => '${ScreenPaths.experienceRoot}${type.name}';
  static String projects = '/projects';
  // static String library = '/library';
  static String about = '/about';
  static String video(String id) => '/video/$id';
  static String highlights(WonderType type) => '/highlights/${type.name}';
  static String search(WonderType type) => '/search/${type.name}';
  static String projectRoot = '/project/';
  static String project(String id) => '${ScreenPaths.projectRoot}$id';
  static String collection(String id) => '/collection?id=$id';
  // static String maps(WonderType type) => '/maps/${type.name}';
  static String timeline(WonderType? type) => '/timeline?type=${type?.name ?? ''}';
  static String wallpaperPhoto(WonderType type) => '/wallpaperPhoto/${type.name}';
}

Map<String, String> getScreenTitles = {
  ScreenPaths.splash: 'Splash Screen',
  ScreenPaths.intro: 'Introduction',
  ScreenPaths.experiences: 'Experiences',
  ScreenPaths.projects: 'Projects',
};

class ScreenUtility {
  static Widget screenForPath(String path, {ExperienceType type = ExperienceType.softwareDeveloper, String? id}) {
    if (path == ScreenPaths.splash) {
      return Container(color: $styles.colors.greyStrong);
    } else if (path == ScreenPaths.intro) {
      return const IntroScreen();
    } else if (path == ScreenPaths.experiences) {
      return ExperiencesScreen();
    } else if (path.startsWith(ScreenPaths.experienceRoot)) {
      return ExperienceDetailScreen(type);
    } else if (path == ScreenPaths.projects) {
      return const ProjectsCarouselScreen();
    } else if (path.startsWith(ScreenPaths.projectRoot) && id != null) {
      return ProjectDetailsScreen(projectId: id);
    } else if (path == ScreenPaths.about) {
      return const AboutScreen();
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
            pageBuilder: pageBuilder,
          ),
          GoRoute(
            path: ScreenPaths.intro,
            pageBuilder: pageBuilder,
          ),
          GoRoute(
            path: ScreenPaths.experiences,
            pageBuilder: pageBuilder,
          ),
          GoRoute(
            path: ScreenPaths.projects,
            pageBuilder: pageBuilder,
          ),
          GoRoute(
            path: '/experience/:type',
            pageBuilder: pageBuilder,
          ),
          GoRoute(
            path: '/project/:id',
            pageBuilder: pageBuilder,
          ),
          GoRoute(
            path: ScreenPaths.about,
            pageBuilder: pageBuilder,
          ),
        ]),
  ],
);

Page<dynamic> pageBuilder(
  BuildContext context,
  GoRouterState state,
) {
  if (PlatformInfo.isWeb) {
    final title = getScreenTitles[state.path!];

    if (title != null) {
      PlatformSpecificImpl.setPageTitle(title);
    }
  }

  final type = state.pathParameters['type'];
  final id = state.pathParameters['id'];

  return GoRouterTransitionPage.verticalAxis(
    direction: state.extra is TransitionDirection ? state.extra as TransitionDirection : null,
    child: Material(child: ScreenUtility.screenForPath(state.path!, type: _parseExperienceType(type), id: id)),
  );
}

String? _handleRedirect(_, GoRouterState state) {
  // When opening the root path, redirect to intro screen.
  if (state.uri.toString() == ScreenPaths.splash) {
    return ScreenPaths.intro;
  }

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

// More transition animations on https://github.com/yeonvora/serendy-app/blob/1562a5f64c28d2fdd5295781de8f4fab5678f073/lib/src/configs/router/go_router_transition_page.dart
class GoRouterTransitionPage extends CustomTransitionPage {
  const GoRouterTransitionPage({
    required super.child,
    required super.transitionsBuilder,
    super.transitionDuration,
    super.maintainState,
    super.fullscreenDialog,
    super.key,
  });

  factory GoRouterTransitionPage.verticalAxis({
    required Widget child,
    bool maintainState = true,
    bool fullscreenDialog = true,
    TransitionDirection? direction,
  }) {
    return GoRouterTransitionPage(
      maintainState: maintainState,
      fullscreenDialog: fullscreenDialog,
      transitionsBuilder: (context, animation, secondaryAnimation, child) => VerticalTransition(
        direction: direction ?? TransitionDirection.topToBottom,
        animation: animation,
        secondaryAnimation: secondaryAnimation,
        child: child,
      ),
      child: child,
    );
  }
}
