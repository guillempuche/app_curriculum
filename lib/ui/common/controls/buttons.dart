import '../../../common_libs.dart';

class FilledBtn extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onPressed;

  const FilledBtn({
    required this.icon,
    required this.text,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18),
            Gap($styles.insets.xs),
            Text(text, style: $styles.text.btn),
          ],
        ),
      ),
    );
  }
}

/// Shared methods across button types
Widget _buildIcon(BuildContext context, IconData icon, {required bool isSecondary, required double? size}) => Icon(
      icon,
      size: size ?? 18,
      color: isSecondary ? $styles.colors.black : $styles.colors.offWhite,
    );

/// The core button that drives all other buttons.
class AppBtn extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  AppBtn({
    Key? key,
    required this.onPressed,
    required this.semanticLabel,
    this.enableFeedback = true,
    this.pressEffect = true,
    this.child,
    this.padding,
    this.expand = false,
    this.isSecondary = false,
    this.circular = false,
    this.minimumSize,
    this.bgColor,
    this.border,
  })  : _builder = null,
        super(key: key);

  AppBtn.from({
    Key? key,
    required this.onPressed,
    this.enableFeedback = true,
    this.pressEffect = true,
    this.padding,
    this.expand = false,
    this.isSecondary = false,
    this.minimumSize,
    this.bgColor,
    this.border,
    String? semanticLabel,
    String? text,
    IconData? icon,
    double? iconSize,
  })  : child = null,
        circular = false,
        super(key: key) {
    if (semanticLabel == null && text == null) throw ('AppBtn.from must include either text or semanticLabel');

    this.semanticLabel = semanticLabel ?? text ?? '';

    _builder = (context) {
      if (text == null && icon == null) return const SizedBox.shrink();

      Text? txt = text == null
          ? null
          : Text(text.toUpperCase(),
              style: $styles.text.btn, textHeightBehavior: const TextHeightBehavior(applyHeightToFirstAscent: false));

      Widget? icn = icon == null
          ? null
          : _buildIcon(
              context,
              icon,
              isSecondary: isSecondary,
              size: iconSize,
            );

      if (txt != null && icn != null) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            icn,
            Gap($styles.insets.xs),
            txt,
          ],
        );
      } else {
        return (txt ?? icn)!;
      }
    };
  }

  // ignore: prefer_const_constructors_in_immutables
  AppBtn.basic({
    Key? key,
    required this.onPressed,
    this.semanticLabel,
    this.enableFeedback = true,
    this.pressEffect = true,
    this.child,
    this.padding = EdgeInsets.zero,
    this.isSecondary = false,
    this.circular = false,
    this.minimumSize,
  })  : expand = false,
        bgColor = Colors.transparent,
        border = null,
        _builder = null,
        super(key: key);

  // interaction:
  final VoidCallback? onPressed;
  late final String? semanticLabel;
  final bool enableFeedback;

  // content:
  late final Widget? child;
  late final WidgetBuilder? _builder;

  // layout:
  final EdgeInsets? padding;
  final bool expand;
  final bool circular;
  final Size? minimumSize;

  // style:
  final bool isSecondary;
  final BorderSide? border;
  final Color? bgColor;
  final bool pressEffect;

  @override
  Widget build(BuildContext context) {
    Color defaultColor = isSecondary ? $styles.colors.white : $styles.colors.greyStrong;
    Color textColor = isSecondary ? $styles.colors.black : $styles.colors.white;
    BorderSide side = border ?? BorderSide.none;

    Widget content = _builder?.call(context) ?? child ?? const SizedBox.shrink();
    if (expand) content = Center(child: content);

    OutlinedBorder shape = circular
        ? CircleBorder(side: side)
        : RoundedRectangleBorder(side: side, borderRadius: BorderRadius.circular($styles.corners.md));

    ButtonStyle style = ButtonStyle(
      minimumSize: ButtonStyleButton.allOrNull<Size>(minimumSize ?? Size.zero),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      splashFactory: NoSplash.splashFactory,
      backgroundColor: ButtonStyleButton.allOrNull<Color>(bgColor ?? defaultColor),
      overlayColor: ButtonStyleButton.allOrNull<Color>(Colors.transparent), // disable default press effect
      shape: ButtonStyleButton.allOrNull<OutlinedBorder>(shape),
      padding: ButtonStyleButton.allOrNull<EdgeInsetsGeometry>(padding ?? EdgeInsets.all($styles.insets.md)),

      enableFeedback: enableFeedback,
    );

    Widget button = _CustomFocusBuilder(
      builder: (context, focus) => Stack(
        children: [
          TextButton(
            onPressed: onPressed,
            style: style,
            focusNode: focus,
            child: DefaultTextStyle(
              style: DefaultTextStyle.of(context).style.copyWith(color: textColor),
              child: content,
            ),
          ),
          if (focus.hasFocus)
            Positioned.fill(
              child: IgnorePointer(
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular($styles.corners.md),
                        border: Border.all(color: $styles.colors.accent1, width: 3))),
              ),
            )
        ],
      ),
    );

    // add press effect:
    if (pressEffect) button = _ButtonPressEffect(button);

    // add semantics?
    if (semanticLabel?.isEmpty == true) return button;
    return Semantics(
      label: semanticLabel,
      button: true,
      container: true,
      child: ExcludeSemantics(child: button),
    );
  }
}

/// //////////////////////////////////////////////////
/// _ButtonDecorator
/// Add a transparency-based press effect to buttons.
/// //////////////////////////////////////////////////
class _ButtonPressEffect extends StatefulWidget {
  const _ButtonPressEffect(this.child, {Key? key}) : super(key: key);
  final Widget child;

  @override
  State<_ButtonPressEffect> createState() => _ButtonPressEffectState();
}

class _ButtonPressEffectState extends State<_ButtonPressEffect> {
  bool _isDown = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      excludeFromSemantics: true,
      onTapDown: (_) => setState(() => _isDown = true),
      onTapUp: (_) => setState(() => _isDown = false), // not called, TextButton swallows this.
      onTapCancel: () => setState(() => _isDown = false),
      behavior: HitTestBehavior.translucent,
      child: Opacity(
        opacity: _isDown ? 0.7 : 1,
        child: ExcludeSemantics(child: widget.child),
      ),
    );
  }
}

class _CustomFocusBuilder extends StatefulWidget {
  const _CustomFocusBuilder({Key? key, required this.builder}) : super(key: key);
  final Widget Function(BuildContext context, FocusNode focus) builder;

  @override
  State<_CustomFocusBuilder> createState() => _CustomFocusBuilderState();
}

class _CustomFocusBuilderState extends State<_CustomFocusBuilder> {
  late final _focusNode = FocusNode()..addListener(() => setState(() {}));

  @override
  Widget build(BuildContext context) {
    return widget.builder.call(context, _focusNode);
  }
}

class PageNavButtons extends StatefulWidget {
  const PageNavButtons({
    required this.onStartButtonPressed,
    required this.onEndButtonPressed,
    this.child,
    this.showStartButton = true,
    this.showEndButton = true,
    this.color,
    Key? key,
  }) : super(key: key);

  final bool showStartButton;
  final bool showEndButton;
  // Widget is position between the navigation buttons.
  final Widget? child;
  final VoidCallback onStartButtonPressed;
  final VoidCallback onEndButtonPressed;
  final Color? color;

  @override
  State<PageNavButtons> createState() => _PageNavButtonsState();
}

class _PageNavButtonsState extends State<PageNavButtons> with TickerProviderStateMixin {
  late final AnimationController _buttonStartController;
  late final AnimationController _buttonEndController;

  @override
  void initState() {
    super.initState();

    _buttonStartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _buttonEndController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _setButtonAnimations();
  }

  @override
  void didUpdateWidget(PageNavButtons oldWidget) {
    super.didUpdateWidget(oldWidget);
    _setButtonAnimations();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FadeTransition(
            opacity: _buttonStartController,
            child: IgnorePointer(
              ignoring: !widget.showStartButton,
              child: Tooltip(
                message: 'Click to go to the previous element',
                child: CircleIconBtn(
                  icon: Icons.chevron_left,
                  bgColor: widget.color ?? $styles.colors.accent1,
                  onPressed: widget.onStartButtonPressed,
                ),
              ),
            ),
          ),
          if (widget.child != null)
            Padding(
              padding: EdgeInsetsDirectional.symmetric(horizontal: $styles.insets.xxs),
              child: Container(child: widget.child),
            )
          else
            Gap($styles.insets.md),
          FadeTransition(
            opacity: _buttonEndController,
            child: IgnorePointer(
              ignoring: !widget.showEndButton,
              child: Tooltip(
                message: 'Click to go to the next element',
                child: CircleIconBtn(
                  icon: Icons.chevron_right,
                  bgColor: widget.color ?? $styles.colors.accent1,
                  onPressed: widget.onEndButtonPressed,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _buttonStartController.dispose();
    _buttonEndController.dispose();
    super.dispose();
  }

  void _setButtonAnimations() {
    if (widget.showStartButton) {
      _buttonStartController.forward();
    } else {
      _buttonStartController.reverse();
    }

    if (widget.showEndButton) {
      _buttonEndController.forward();
    } else {
      _buttonEndController.reverse();
    }
  }
}

class CircleIconBtn extends StatelessWidget {
  const CircleIconBtn({
    Key? key,
    required this.icon,
    required this.onPressed,
    // this.border,
    this.bgColor,
    this.color,
    this.size,
    this.iconSize,
    this.semanticLabel,
  }) : super(key: key);

  static double defaultSize = 28;

  final IconData icon;
  final VoidCallback onPressed;
  // final BorderSide? border;
  final Color? bgColor;
  final Color? color;
  final String? semanticLabel;
  final double? size;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    Color defaultColor = $styles.colors.greyStrong;

    return IconButton(
      icon: Icon(icon),
      color: bgColor ?? defaultColor,
      iconSize: size,
      onPressed: onPressed,
    );
  }
}

class BackBtn extends StatelessWidget {
  const BackBtn({
    Key? key,
    // this.icon = AppIcons.prev,
    this.icon = Icons.arrow_back,
    this.onPressed,
    this.semanticLabel,
    this.bgColor,
    this.iconColor,
  }) : super(key: key);

  final Color? bgColor;
  final Color? iconColor;
  // final AppIcons icon;
  final IconData icon;
  final VoidCallback? onPressed;
  final String? semanticLabel;

  BackBtn.close({Key? key, VoidCallback? onPressed, Color? bgColor, Color? iconColor})
      : this(
            key: key,
            // icon: AppIcons.close,
            icon: Icons.close,
            onPressed: onPressed,
            semanticLabel: $strings.circleButtonsSemanticClose,
            bgColor: bgColor,
            iconColor: iconColor);

  @override
  Widget build(BuildContext context) {
    double size = 48;
    return AppBtn(
      onPressed: onPressed ?? () => Navigator.pop(context),
      semanticLabel: semanticLabel,
      minimumSize: Size(size, size),
      padding: EdgeInsets.zero,
      circular: true,
      bgColor: bgColor,
      child: Icon(
        icon,
        color: iconColor ?? $styles.colors.white,
      ),
    );
  }
}
