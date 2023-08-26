import '../../../../../common_libs.dart';
import '../../../../logic/data/experience_data.dart';
import '../../../../logic/data/wonder_data.dart';
import '../../common/app_icons.dart';
import '../../common/controls/app_header.dart';
import '../../common/controls/app_page_indicator.dart';
import '../../common/gradient_container.dart';
import '../../common/themed_text.dart';
import '../../common/utils/app_haptics.dart';
import '../../wonder_illustrations/common/animated_clouds.dart';
import '../../wonder_illustrations/common/experience_illustration.dart';
import '../../wonder_illustrations/common/wonder_illustration_config.dart';
import '../../wonder_illustrations/common/experience_title_text.dart';
import '../home_menu/home_menu.dart';

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
  bool _isMenuOpen = false;

  /// Set initial experienceIndex
  late int _experienceIndex = 0;

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
    _swipeController.dispose();
    super.dispose();
  }

  void _showDetailsPage(BuildContext context) async {
    _swipeOverride = _swipeController.swipeAmt.value;
    await Future.delayed(100.ms);
    _swipeOverride = null;
    _fadeInOnNextBuild = true;
    context.push(ScreenPaths.experienceDetails(currentExperience.type));
  }

  void _handlePageChanged(value) {
    setState(() {
      _experienceIndex = value % _numExperiences;
    });
    AppHaptics.lightImpact();
  }

  void _handlePageIndicatorDotPressed(int index) => _setPageIndex(index);

  void _setPageIndex(int index) {
    if (index == _experienceIndex) return;

    // To support infinite scrolling, we can't jump directly to the pressed index. Instead, make it relative to our current position.
    final pos = ((_pageController.page ?? 0) / _numExperiences).floor() * _numExperiences;
    _pageController.jumpToPage(pos + index);
  }

  // void _handleOpenMenuPressed() async {
  //   setState(() => _isMenuOpen = true);
  //   WonderType? pickedWonder = await appLogic.showFullscreenDialogRoute<WonderType>(
  //     context,
  //     HomeMenu(data: currentExperience),
  //     transparent: true,
  //   );
  //   setState(() => _isMenuOpen = false);
  //   if (pickedWonder != null) {
  //     _setPageIndex(_experiences.indexWhere((w) => w.type == pickedWonder));
  //   }
  // }

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
        child: AnimatedClouds(wonderType: currentExperience.type, opacity: 1),
      )
    ];
  }

  Widget _buildFgAndGradients() {
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

    // final gradientColor = currentExperience.type.bgColor;
    final gradientColor = Colors.red;

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
          opacity: _isMenuOpen ? 0 : 1,
          duration: $styles.times.med,
          child: RepaintBoundary(
            child: OverflowBox(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(width: double.infinity),
                  const Spacer(),

                  // _swipeController.wrapGestureDetector(

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
                                  // onTap: () => _showDetailsPage(context),
                                  // Hide the title when the menu is open for visual polish
                                  child: ExperienceTitleText(currentExperience, enableShadows: true),
                                ),
                              ),
                              Gap($styles.insets.md),
                              TextButton(onPressed: () => _showDetailsPage(context), child: Text('Read more')),
                              Gap($styles.insets.md),
                              AppPageIndicator(
                                count: _numExperiences,
                                controller: _pageController,
                                color: $styles.colors.white,
                                dotSize: 8,
                                onDotPressed: _handlePageIndicatorDotPressed,
                                semanticPageTitle: $strings.homeSemanticWonder,
                              ),
                              Gap($styles.insets.md),
                            ],
                          ),
                        ),
                      ),

                      /// Animated arrow and background
                      /// Wrap in a container that is full-width to make it easier to find for screen readers
                      // Container(
                      //   width: double.infinity,
                      //   alignment: Alignment.center,

                      //   /// Lose state of child objects when index changes, this will re-run all the animated switcher and the arrow anim
                      //   key: ValueKey(_experienceIndex),
                      //   child: Stack(
                      //     children: [
                      //       /// Expanding rounded rect that grows in height as user swipes up
                      //       Positioned.fill(
                      //           child: _swipeController.buildListener(
                      //         builder: (swipeAmt, _, child) {
                      //           double heightFactor = .5 + .5 * (1 + swipeAmt * 4);
                      //           return FractionallySizedBox(
                      //             alignment: Alignment.bottomCenter,
                      //             heightFactor: heightFactor,
                      //             child: Opacity(opacity: swipeAmt * .5, child: child),
                      //           );
                      //         },
                      //         child: VtGradient(
                      //           [$styles.colors.white.withOpacity(0), $styles.colors.white.withOpacity(1)],
                      //           const [.3, 1],
                      //           borderRadius: BorderRadius.circular(99),
                      //         ),
                      //       )),

                      //       /// Arrow Btn that fades in and out
                      //       _AnimatedArrowButton(
                      //         onTap: () => context.push(ScreenPaths.projects),
                      //         semanticTitle: currentWonder.title,
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      const SizedBox(height: 150),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      // /// Menu Btn
      // BottomLeft(
      //   child: AnimatedOpacity(
      //     duration: $styles.times.fast,
      //     opacity: _isMenuOpen ? 0 : 1,
      //     child: AppHeader(
      //       backIcon: AppIcons.menu,
      //       backBtnSemantics: $strings.homeSemanticOpenMain,
      //       onBack: _handleOpenMenuPressed,
      //       isTransparent: true,
      //     ),
      //   ),
      // ),
    ]);
  }
}
