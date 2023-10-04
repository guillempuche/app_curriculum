part of 'vertical_swipe_navigator.dart';

enum _ButtonDirection {
  top,
  bottom,
}

/// An arrow that fades out, then fades back in and slides down, ending in it's original position with full opacity.
class _AnimatedArrowButton extends StatelessWidget {
  _AnimatedArrowButton({
    Key? key,
    required this.onTap,
    this.direction = _ButtonDirection.top,
    this.isSwipeText = true,
    this.semanticTitle,
  }) : super(key: key);

  final VoidCallback onTap;
  final _ButtonDirection direction;
  final bool isSwipeText;
  final String? semanticTitle;

  @override
  Widget build(BuildContext context) {
    final btnLbl = semanticTitle != null ? $strings.animatedArrowSemanticSwipe(semanticTitle!) : null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppBtn.basic(
          semanticLabel: btnLbl,
          onPressed: onTap,
          child: Column(
            children: [
              Transform.rotate(
                angle: direction == _ButtonDirection.top ? (pi * .5) : (-pi * .5),
                child: Icon(
                  Icons.chevron_right,
                  size: 42,
                  color: $styles.colors.accent1,
                ),
              ),
              Text(
                direction == _ButtonDirection.top
                    ? (isSwipeText ? 'Swipe down' : 'Click for previous section')
                    : (isSwipeText ? 'Swipe up' : 'Click for next section'),
                style: TextStyle(color: $styles.colors.accent1),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
