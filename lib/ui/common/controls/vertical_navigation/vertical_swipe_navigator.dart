import '../../../../common_libs.dart';

part '_animated_arrow_button.dart';
part '_vertical_swipe_controller.dart';

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
          context.go(goForwardPath!, extra: forwardDirection!);
        } else if (backDirection != null && goBackPath != null && details.primaryVelocity! > 0) {
          context.go(goBackPath!, extra: backDirection!);
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
                //semanticTitle: currentWonder.title,
                direction: _ButtonDirection.top,
                onTap: () => context.go(goBackPath!, extra: backDirection!),
              ),
            ),
          if (goForwardPath != null && forwardDirection != null)
            Positioned(
              bottom: 20,
              child: _AnimatedArrowButton(
                direction: _ButtonDirection.bottom,
                onTap: () => context.go(goForwardPath!, extra: forwardDirection!),
              ),
            ),
        ],
      ),
    );
  }
}
