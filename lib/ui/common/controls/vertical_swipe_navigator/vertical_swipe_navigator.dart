import '../../../../common_libs.dart';

part '_animated_arrow_button.dart';
part '_vertical_swipe_controller.dart';

enum TransitionDirection {
  topToBottom,
  bottomToTop,
}

class VerticalSwipeNavigator extends StatelessWidget {
  const VerticalSwipeNavigator({
    Key? key,
    required this.child,
    this.backDirection,
    this.forwardDirection,
    this.goBackPath,
    this.goForwardPath,
  }) : super(key: key);

  final Widget child;
  final TransitionDirection? backDirection;
  final TransitionDirection? forwardDirection;
  final String? goBackPath;
  final String? goForwardPath;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragEnd: (details) {
        // When velocity is negative, means swipe goes from top to bottom.
        if (forwardDirection != null && goForwardPath != null && details.primaryVelocity! < 0) {
          _navigate(context, goForwardPath!, forwardDirection!);
        } else if (backDirection != null && goBackPath != null && details.primaryVelocity! > 0) {
          _navigate(context, goBackPath!, backDirection!);
        }
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          child,
          if (goBackPath != null && backDirection != null)
            Positioned(
              top: 20,
              child: _AnimatedArrowButton(
                direction: _ButtonDirection.top,
                onTap: () => _navigate(context, goBackPath!, backDirection!),
                //semanticTitle: currentWonder.title,
              ),
            ),
          if (goForwardPath != null && forwardDirection != null)
            Positioned(
              bottom: 20,
              child: _AnimatedArrowButton(
                direction: _ButtonDirection.bottom,
                onTap: () => _navigate(context, goForwardPath!, forwardDirection!),
              ),
            ),
        ],
      ),
    );
  }

  void _navigate(BuildContext context, String screenPath, TransitionDirection direction) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => ScreenUtility.screenForPath(screenPath),
        transitionsBuilder: (context, animation, secondaryAnimation, nextChild) {
          Offset begin;
          Offset end = Offset.zero;
          switch (direction) {
            case TransitionDirection.topToBottom:
              begin = const Offset(0.0, 1.0);
              break;
            case TransitionDirection.bottomToTop:
              begin = const Offset(0.0, -1.0);
              break;
          }

          final currentSlidePosition = Tween(begin: end, end: begin);
          final nextSlidePosition = Tween(begin: begin, end: end);

          final currentSlideAnimation = CurvedAnimation(
            parent: secondaryAnimation,
            curve: Curves.easeOutCirc,
          ).drive(currentSlidePosition);

          final nextSlideAnimation = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCirc,
          ).drive(nextSlidePosition);

          return Stack(
            children: [
              SlideTransition(position: currentSlideAnimation, child: child),
              Visibility(
                // visible: currentSlideAnimation.value < begin,
                visible: true,
                child: SlideTransition(position: nextSlideAnimation, child: nextChild),
              ),
              // Offstage(
              //     offstage:
              //         currentSlideAnimation.status != AnimationStatus.forward,
              //     child: SlideTransition(
              //         position: currentSlideAnimation, child: child)),
              // Offstage(
              //     offstage:
              //         nextSlideAnimation.status != AnimationStatus.forward,
              //     child: SlideTransition(
              //         position: nextSlideAnimation, child: nextChild)),
            ],
          );
        },
      ),
    );
  }
}
