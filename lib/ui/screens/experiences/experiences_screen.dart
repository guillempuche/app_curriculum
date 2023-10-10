import '../../../../../common_libs.dart';
import '../../common/controls/app_page_indicator.dart';
import '../../common/themed_text.dart';
import '../../common/utils/app_haptics.dart';
import '../../experience_illustrations/common/animated_clouds.dart';
import '../../experience_illustrations/common/experience_illustration.dart';
import '../../experience_illustrations/common/wonder_illustration_config.dart';
import '../../experience_illustrations/common/experience_title_text.dart';

part '_vertical_swipe_controller.dart';
part 'widgets/_animated_arrow_button.dart';

class ExperiencesScreen extends StatefulWidget with GetItStatefulWidgetMixin {
  ExperiencesScreen({Key? key}) : super(key: key);

  @override
  State<ExperiencesScreen> createState() => _ExperiencesScreenState();
}

/// Shows a horizontally scrollable list PageView sandwiched between Foreground and Background layers
/// arranged in a parallax style.
class _ExperiencesScreenState extends State<ExperiencesScreen> with SingleTickerProviderStateMixin {
  late final PageController _pageController;
  List<ExperienceData> get _experiences => experiencesLogic.all;

  /// Set initial experienceIndex
  int _experienceIndex = 0;

  int get _numExperiences => _experiences.length;

  /// Used to polish the transition when leaving this page for the details view.
  /// Used to capture the _swipeAmt at the time of transition, and freeze the wonder foreground in place as we transition away.
  double? _swipeOverride;

  /// Used to let the foreground fade in when this view is returned to (from details)
  bool _fadeInOnNextBuild = false;

  /// All of the items that should fade in when returning from details view.
  /// Using individual tweens is more efficient than tween the entire parent
  final _fadeAnims = <AnimationController>[];

  ExperienceData get currentExperience => _experiences[_experienceIndex];

  late final _VerticalSwipeController _swipeController =
      _VerticalSwipeController(this, () => _showDetailsPage(context));

  bool _isSelected(ExperienceType t) => t == currentExperience.type;

  @override
  void initState() {
    super.initState();

    // Create page controller,
    // allow 'infinite' scrolling by starting at a very high page, or remember the previous value
    final initialPage = _numExperiences * 9999;
    _pageController = PageController(viewportFraction: 1, initialPage: initialPage);
    _experienceIndex = initialPage % _numExperiences;
  }

  @override
  Widget build(BuildContext context) {
    if (_fadeInOnNextBuild == true) {
      _startDelayedFgFade();
      _fadeInOnNextBuild = false;
    }

    return VerticalSwipeNavigator(
      backDirection: TransitionDirection.bottomToTop,
      forwardDirection: TransitionDirection.topToBottom,
      goBackPath: ScreenPaths.intro,
      goForwardPath: ScreenPaths.projects,
      child: Container(
        color: $styles.colors.black,
        child: Stack(
          children: [
            Stack(
              children: [
                /// Background illustrations
                ..._buildBgAndClouds(),

                /// Foregound illustrations (main content)
                _buildMgPageView(),

                /// Foreground illustrations and gradients
                _buildFgAndGradients(),

                /// Controls that float on top of the various illustrations
                _buildFloatingUi(),
              ],
            ).animate().fadeIn(),
          ],
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _showDetailsPage(BuildContext context) async {
    _swipeOverride = _swipeController.swipeAmt.value;
    _swipeOverride = null;
    _fadeInOnNextBuild = true;
    context.push(ScreenPaths.experienceDetails(currentExperience.type));
  }

  void _handlePageChanged(value) {
    if (mounted) {
      AppHaptics.lightImpact();
      setState(() => _experienceIndex = value % _numExperiences);
    }
  }

  void _handlePageIndicatorDotPressed(int index) => _setPageIndex(index);

  void _setPageIndex(int index) {
    if (index == _experienceIndex) return;

    // To support infinite scrolling, we can't jump directly to the pressed index. Instead, make it relative to our current position.
    final pos = ((_pageController.page ?? 0) / _numExperiences).floor() * _numExperiences;
    _pageController.jumpToPage(pos + index);
  }

  void _handleFadeAnimInit(AnimationController controller) {
    _fadeAnims.add(controller);
    controller.value = 1;
  }

  void _startDelayedFgFade() async {
    try {
      for (var a in _fadeAnims) {
        a.value = 0;
      }
      await Future.delayed(300.ms);
      for (var a in _fadeAnims) {
        if (mounted) {
          a.forward();
        }
      }
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }

  Widget _buildMgPageView() {
    return ExcludeSemantics(
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: _handlePageChanged,
        itemBuilder: (_, index) {
          final experience = _experiences[index % _experiences.length];
          final experienceType = experience.type;
          bool isShowing = _isSelected(experienceType);

          return _swipeController.buildListener(
            builder: (swipeAmt, _, child) {
              final config = WonderIllustrationConfig.mg(
                isShowing: isShowing,
                zoom: .05 * swipeAmt,
              );
              return ExperienceIllustration(experienceType, config: config);
            },
          );
        },
      ),
    );
  }

  List<Widget> _buildBgAndClouds() {
    return [
      // Background
      ..._experiences.map((e) {
        final config = WonderIllustrationConfig.bg(isShowing: _isSelected(e.type));
        return ExperienceIllustration(e.type, config: config);
      }).toList(),

      // Clouds
      FractionallySizedBox(
        widthFactor: 1,
        heightFactor: .5,
        child: AnimatedClouds(experienceType: currentExperience.type, opacity: 1),
      )
    ];
  }

  Widget _buildFgAndGradients() {
    const gradientColor = Color(0xFF1C4D46);

    Widget buildSwipeableBgGradient(Color fgColor) {
      return _swipeController.buildListener(builder: (swipeAmt, isPointerDown, _) {
        return IgnorePointer(
          child: FractionallySizedBox(
            heightFactor: .6,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    fgColor.withOpacity(0),
                    fgColor.withOpacity(.5 + fgColor.opacity * .25 + (isPointerDown ? .05 : 0) + swipeAmt * .20),
                  ],
                  stops: const [0, 1],
                ),
              ),
            ),
          ),
        );
      });
    }

    return Stack(children: [
      /// Foreground gradient-1, gets darker when swiping up
      BottomCenter(
        child: buildSwipeableBgGradient(gradientColor.withOpacity(.65)),
      ),

      /// Foreground decorators
      ..._experiences.map((e) {
        return _swipeController.buildListener(builder: (swipeAmt, _, child) {
          final config = WonderIllustrationConfig.fg(
            isShowing: _isSelected(e.type),
            zoom: .4 * (_swipeOverride ?? swipeAmt),
          );
          return Animate(
              effects: const [FadeEffect()],
              onPlay: _handleFadeAnimInit,
              child: IgnorePointer(child: ExperienceIllustration(e.type, config: config)));
        });
      }).toList(),

      /// Foreground gradient-2, gets darker when swiping up
      BottomCenter(
        child: buildSwipeableBgGradient(gradientColor),
      ),
    ]);
  }

  Widget _buildFloatingUi() {
    return Stack(children: [
      /// Floating controls / UI
      AnimatedSwitcher(
        duration: $styles.times.fast,
        child: AnimatedOpacity(
          opacity: 1,
          duration: $styles.times.med,
          child: RepaintBoundary(
            child: OverflowBox(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(width: double.infinity),
                  const Spacer(flex: 1),

                  /// Title Content
                  Column(
                    children: [
                      LightText(
                        child: Transform.translate(
                          offset: const Offset(0, 30),
                          child: Column(
                            children: [
                              /// Disable the title click to allow the horizontal page navigation
                              IgnorePointer(
                                child: Semantics(
                                  liveRegion: true,
                                  button: true,
                                  header: true,
                                  onIncrease: () => _setPageIndex(_experienceIndex + 1),
                                  onDecrease: () => _setPageIndex(_experienceIndex - 1),
                                  // Hide the title when the menu is open for visual polish
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: ExperienceTitleText(currentExperience, enableShadows: true),
                                  ),
                                ),
                              ),
                              Gap($styles.insets.md),
                              TextButton(
                                style: TextButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.primary),
                                child: Text(
                                  'Read more',
                                  style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                                ),
                                onPressed: () => _showDetailsPage(context),
                              ),
                              Gap($styles.insets.md),
                              PlatformInfo.isSwipeEnabled(context)
                                  ? AppPageIndicator(
                                      count: _numExperiences,
                                      controller: _pageController,
                                      onDotPressed: _handlePageIndicatorDotPressed,
                                      semanticPageTitle: $strings.homeSemanticWonder,
                                    )
                                  : PageNavButtons(
                                      onStartButtonPressed: () => _setPageIndex(_experienceIndex - 1),
                                      onEndButtonPressed: () => _setPageIndex(_experienceIndex + 1),
                                      child: AppPageIndicator(
                                        count: _numExperiences,
                                        controller: _pageController,
                                        onDotPressed: _handlePageIndicatorDotPressed,
                                        semanticPageTitle: $strings.homeSemanticWonder,
                                      ),
                                    ),
                              Gap($styles.insets.md),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 120),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ]);
  }
}
