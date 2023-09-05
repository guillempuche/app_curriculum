import '../../../../common_libs.dart';

enum TransitionDirection {
  topToBottom,
  bottomToTop,
}

/// A slight modification of vertical animation in [Animaitons](https://pub.dev/packages/animations) package.
class VerticalTransition extends StatelessWidget {
  /// Creates a [VerticalTransition].
  ///
  /// The [animation] and [secondaryAnimation] argument are required and must
  /// not be null.
  const VerticalTransition({
    super.key,
    required this.animation,
    required this.secondaryAnimation,
    required this.direction,
    this.fillColor,
    this.child,
  });

  /// The animation that drives the [child]'s entrance and exit.
  ///
  /// See also:
  ///
  ///  * [TransitionRoute.animate], which is the value given to this property
  ///    when it is used as a page transition.
  final Animation<double> animation;

  /// The animation that transitions [child] when new content is pushed on top
  /// of it.
  ///
  /// See also:
  ///
  ///  * [TransitionRoute.secondaryAnimation], which is the value given to this
  ///    property when the it is used as a page transition.
  final Animation<double> secondaryAnimation;

  /// The color to use for the background color during the transition.
  ///
  /// This defaults to the [Theme]'s [ThemeData.canvasColor].
  final Color? fillColor;

  /// The widget below this widget in the tree.
  ///
  /// This widget will transition in and out as driven by [animation] and
  /// [secondaryAnimation].
  final Widget? child;

  final TransitionDirection direction;

  @override
  Widget build(BuildContext context) {
    final Color color = fillColor ?? Theme.of(context).canvasColor;

    return DualTransitionBuilder(
      animation: animation,
      forwardBuilder: (
        BuildContext context,
        Animation<double> animation,
        Widget? child,
      ) {
        return _EnterTransition(
          reverse: direction == TransitionDirection.bottomToTop,
          animation: animation,
          child: child,
        );
      },
      reverseBuilder: (
        BuildContext context,
        Animation<double> animation,
        Widget? child,
      ) {
        return _ExitTransition(
          reverse: direction == TransitionDirection.bottomToTop,
          animation: animation,
          fillColor: color,
          child: child,
        );
      },
      child: DualTransitionBuilder(
        animation: ReverseAnimation(secondaryAnimation),
        forwardBuilder: (
          BuildContext context,
          Animation<double> animation,
          Widget? child,
        ) {
          return _EnterTransition(
            animation: animation,
            reverse: direction == TransitionDirection.topToBottom,
            child: child,
          );
        },
        reverseBuilder: (
          BuildContext context,
          Animation<double> animation,
          Widget? child,
        ) {
          return _ExitTransition(
            animation: animation,
            reverse: direction == TransitionDirection.topToBottom,
            fillColor: color,
            child: child,
          );
        },
        child: child,
      ),
    );
  }
}

class _EnterTransition extends StatelessWidget {
  const _EnterTransition({
    required this.animation,
    this.reverse = false,
    this.child,
  });

  final Animation<double> animation;
  final Widget? child;
  final bool reverse;

  static final Animatable<double> _fadeInTransition = CurveTween(
    curve: decelerateEasing,
  ).chain(CurveTween(curve: const Interval(0.3, 1.0)));

  @override
  Widget build(BuildContext context) {
    final Animatable<Offset> slideInTransition = Tween<Offset>(
      begin: Offset(0.0, !reverse ? 30.0 : -30.0),
      end: Offset.zero,
    ).chain(CurveTween(curve: standardEasing));

    return FadeTransition(
      opacity: _fadeInTransition.animate(animation),
      child: AnimatedBuilder(
        animation: animation,
        builder: (BuildContext context, Widget? child) {
          return Transform.translate(
            offset: slideInTransition.evaluate(animation),
            child: child,
          );
        },
        child: child,
      ),
    );
  }
}

class _ExitTransition extends StatelessWidget {
  const _ExitTransition({
    required this.animation,
    this.reverse = false,
    required this.fillColor,
    this.child,
  });

  final Animation<double> animation;
  final bool reverse;
  final Color fillColor;
  final Widget? child;

  static final Animatable<double> _fadeOutTransition = _FlippedCurveTween(
    curve: accelerateEasing,
  ).chain(CurveTween(curve: const Interval(0.0, 0.3)));

  @override
  Widget build(BuildContext context) {
    final Animatable<Offset> slideOutTransition = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(0.0, !reverse ? -30.0 : 30.0),
    ).chain(CurveTween(curve: standardEasing));

    return FadeTransition(
      opacity: _fadeOutTransition.animate(animation),
      child: Container(
        color: fillColor,
        child: AnimatedBuilder(
          animation: animation,
          builder: (BuildContext context, Widget? child) {
            return Transform.translate(
              offset: slideOutTransition.evaluate(animation),
              child: child,
            );
          },
          child: child,
        ),
      ),
    );
  }
}

/// Enables creating a flipped [CurveTween].
///
/// This creates a [CurveTween] that evaluates to a result that flips the
/// tween vertically.
///
/// This tween sequence assumes that the evaluated result has to be a double
/// between 0.0 and 1.0.
class _FlippedCurveTween extends CurveTween {
  /// Creates a vertically flipped [CurveTween].
  _FlippedCurveTween({
    required super.curve,
  });

  @override
  double transform(double t) => 1.0 - super.transform(t);
}
