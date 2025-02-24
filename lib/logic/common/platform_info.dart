import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../common_libs.dart';

class PlatformInfo {
  static const _desktopPlatforms = [TargetPlatform.macOS, TargetPlatform.windows, TargetPlatform.linux];
  static const _mobilePlatforms = [TargetPlatform.android, TargetPlatform.iOS];

  static bool get isDesktop => _desktopPlatforms.contains(defaultTargetPlatform) && !kIsWeb;
  static bool get isDesktopOrWeb => isDesktop || kIsWeb;
  static bool get isMobile => _mobilePlatforms.contains(defaultTargetPlatform) && !kIsWeb;

  static double get pixelRatio => WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;

  static bool get isWindows => defaultTargetPlatform == TargetPlatform.windows;
  static bool get isLinux => defaultTargetPlatform == TargetPlatform.linux;
  static bool get isMacOS => defaultTargetPlatform == TargetPlatform.macOS;
  static bool get isAndroid => defaultTargetPlatform == TargetPlatform.android;
  static bool get isIOS => defaultTargetPlatform == TargetPlatform.iOS;
  static bool get isWeb => kIsWeb;

  static Future<bool> get isConnected async => await InternetConnectionChecker.instance.hasConnection;
  static Future<bool> get isDisconnected async => (await isConnected) == false;

  /// Only desktop & medium and large screen won't show swipe page navigation.
  static bool isSwipeEnabled(BuildContext context) => !(PlatformInfo.isWeb && ScreenInfo.isMediumOrLarge(context));
}

/// Screen screen gives some information of the screen of the device.
///
/// The screens supported are constrained by:
/// - small (smartphones)
/// - medium (tablets)
/// - large (computers)
///
/// # How to use it
///
/// ```dart
/// const screenInfo = ScreenInfo.of(context);
/// const screenWidth = ScreenInfo.of(context).screenWidth;
/// const isSmall = ScreenInfo.of(context).isSmall;
/// const screenType = ScreenInfo.of(context).screenType;
/// ```
///
/// # Resources
///
/// The calculations behind it can be found on Flutter's explanation
/// about the [logical pixels](https://api.flutter.dev/flutter/widgets/MediaQueryData/size.html).
class ScreenInfo {
  ScreenInfo._();

  static ScreenInfoData of(BuildContext context) => ScreenInfoData(
        screenWidth: screenWidth(context),
        isSmall: isSmall(context),
        isMedium: isMedium(context),
        isLarge: isLarge(context),
        isSmallOrMedium: isSmallOrMedium(context),
        isMediumOrLarge: isMediumOrLarge(context),
        screenType: getScreenType(context),
      );

  static double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;

  static ScreenInfoType getScreenType(BuildContext context) {
    if (isSmall(context)) {
      return ScreenInfoType.small;
    } else if (isMedium(context)) {
      return ScreenInfoType.medium;
    }

    return ScreenInfoType.large;
  }

  /// Small screens. They're usally smartphones below 7 inches, like:
  /// - iPhone 14 Pro Max with 6.7" (released in 2022)
  /// - Samsung Galaxy S22 with 6.1" (released in 2022)
  static bool isSmall(BuildContext context) => MediaQuery.of(context).size.width < 600;

  /// Medium screens. They aren't smartphones, but tablets between 7 and 13 inches, like:
  /// - iPad Air Mini with 8.3" (released in 2021)
  /// - iPad Air with 10.9" (released in 2022)
  /// - iPad Pro 12.9 with 12.9" (released in 2021)
  static bool isMedium(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600 && MediaQuery.of(context).size.width <= 1300;

  /// Larg screens. They're usually computers.
  static bool isLarge(BuildContext context) => MediaQuery.of(context).size.width > 1300;

  static bool isSmallOrMedium(BuildContext context) => isSmall(context) || isMedium(context);

  static bool isMediumOrLarge(BuildContext context) => isMedium(context) || isLarge(context);
}

/// For the understanding of each measurement, look at the class [ScreenInfo].
enum ScreenInfoType {
  small,
  medium,
  large,
}

class ScreenInfoData {
  const ScreenInfoData({
    required this.screenWidth,
    required this.isSmall,
    required this.isMedium,
    required this.isLarge,
    required this.isSmallOrMedium,
    required this.isMediumOrLarge,
    required this.screenType,
  });

  final double screenWidth;
  final bool isSmall;
  final bool isMedium;
  final bool isLarge;
  final bool isSmallOrMedium;
  final bool isMediumOrLarge;
  final ScreenInfoType screenType;
}
