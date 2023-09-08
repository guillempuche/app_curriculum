import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../common_libs.dart';
import '../../../logic/common/platform_info.dart';
import '../../common/app_icons.dart';
import '../../common/controls/app_page_indicator.dart';
import '../../common/gradient_container.dart';
import '../../common/static_text_scale.dart';
import '../../common/themed_text.dart';
import '../../common/utils/app_haptics.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  static const double _imageSize = 250;
  // static const double _logoHeight = 126;
  static const double _textHeight = 120;
  static const double _pageIndicatorHeight = 55;

  static List<_PageData> pageData = [];

  late final PageController _pageController = PageController()..addListener(_handlePageChanged);
  final ValueNotifier<int> _currentPage = ValueNotifier(0);
  bool get _isOnLastPage => _currentPage.value.round() == pageData.length - 1;

  @override
  void initState() {
    super.initState();

    // Fetch data
    experiencesLogic.init();
    projectsLogic.init();
  }

  @override
  Widget build(BuildContext context) {
    // Set the page data, as strings may have changed based on locale
    pageData = [
      _PageData($strings.introMyself, $strings.introDescriptionNavigate, 'camel', '1'),
      _PageData($strings.introTitleExplore, $strings.introDescriptionUncover, 'petra', '2'),
      _PageData($strings.introTitleDiscover, $strings.introDescriptionLearn, 'statue', '3'),
    ];

    // This view uses a full screen PageView to enable swipe navigation.
    // However, we only want the title / description to actually swipe,
    // so we stack a PageView with that content over top of all the other
    // content, and line up their layouts.
    final List<Widget> pages = pageData.map((e) => _Page(data: e)).toList();

    return VerticalSwipeNavigator(
      forwardDirection: TransitionDirection.topToBottom,
      goForwardPath: ScreenPaths.experiences,
      child: DefaultTextColor(
        color: $styles.colors.offWhite,
        child: Container(
          color: $styles.colors.black,
          child: SafeArea(
            child: Animate(
              delay: 500.ms,
              effects: const [FadeEffect()],
              child: Stack(
                children: [
                  // page view with title & description:
                  MergeSemantics(
                    child: Semantics(
                      onIncrease: () => _handleSemanticSwipe(1),
                      onDecrease: () => _handleSemanticSwipe(-1),
                      child: PageView(
                        controller: _pageController,
                        children: pages,
                        onPageChanged: (_) => AppHaptics.lightImpact(),
                      ),
                    ),
                  ),

                  IgnorePointer(
                    ignoringSemantics: false,
                    child: Column(children: [
                      const Spacer(),

                      // masked image:
                      SizedBox(
                        height: _imageSize,
                        width: _imageSize,
                        child: ValueListenableBuilder<int>(
                          valueListenable: _currentPage,
                          builder: (_, value, __) {
                            return AnimatedSwitcher(
                              duration: $styles.times.slow,
                              child: KeyedSubtree(
                                key: ValueKey(value), // so AnimatedSwitcher sees it as a different child.
                                child: _PageImage(data: pageData[value]),
                              ),
                            );
                          },
                        ),
                      ),

                      // placeholder gap for text:
                      const Gap(_IntroScreenState._textHeight),

                      // page indicator:
                      Container(
                        height: _pageIndicatorHeight,
                        alignment: const Alignment(0, 0),
                        child: AppPageIndicator(
                          count: pageData.length,
                          controller: _pageController,
                          color: $styles.colors.offWhite,
                        ),
                      ),

                      _buildNavHelperText(context),

                      const Spacer(flex: 2),
                    ]),
                  ),

                  // Build a cpl overlays to hide the content when swiping on very wide screens
                  _buildHzGradientOverlay(left: true),
                  _buildHzGradientOverlay(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _handlePageChanged() {
    int newPage = _pageController.page?.round() ?? 0;
    _currentPage.value = newPage;
  }

  void _handleSemanticSwipe(int dir) {
    _pageController.animateToPage((_pageController.page ?? 0).round() + dir,
        duration: $styles.times.fast, curve: Curves.easeOut);
  }

  void _handleNavTextDoubleTapped() {
    final int current = _pageController.page!.round();
    if (_isOnLastPage) return;
    _pageController.animateToPage(current + 1, duration: 250.ms, curve: Curves.easeIn);
  }

  Widget _buildHzGradientOverlay({bool left = false}) {
    return Align(
      alignment: Alignment(left ? -1 : 1, 0),
      child: FractionallySizedBox(
        widthFactor: .5,
        child: Padding(
          padding: EdgeInsets.only(left: left ? 0 : 200, right: left ? 200 : 0),
          child: Transform.scale(
              scaleX: left ? -1 : 1,
              child: HzGradient([
                $styles.colors.black.withOpacity(0),
                $styles.colors.black,
              ], const [
                0,
                .2
              ])),
        ),
      ),
    );
  }

  Widget _buildNavHelperText(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _currentPage,
      builder: (_, pageIndex, __) {
        return AnimatedOpacity(
          opacity: pageIndex == pageData.length - 1 ? 0 : 1,
          duration: $styles.times.fast,
          child: Semantics(
            onTapHint: $strings.introSemanticNavigate,
            onTap: _isOnLastPage ? null : _handleNavTextDoubleTapped,
            child: Text(
              PlatformInfo.isWeb && ScreenInfo.isMediumOrLarge(context)
                  ? 'Scroll down to continue'
                  : 'Swipe left to continue',
              style: $styles.text.bodySmall,
            ),
          ),
        );
      },
    );
  }
}

@immutable
class _PageData {
  const _PageData(this.title, this.desc, this.img, this.mask);

  final String title;
  final String desc;
  final String img;
  final String mask;
}

class _Page extends StatelessWidget {
  const _Page({Key? key, required this.data}) : super(key: key);

  final _PageData data;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: $styles.insets.md),
        child: Column(children: [
          const Spacer(),
          const Gap(_IntroScreenState._imageSize),
          SizedBox(
            height: _IntroScreenState._textHeight,
            width: 500,
            child: StaticTextScale(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(data.title, style: $styles.text.wonderTitle.copyWith(fontSize: 24 * $styles.scale)),
                  Gap($styles.insets.sm),
                  Text(data.desc, style: $styles.text.body, textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
          const Gap(_IntroScreenState._pageIndicatorHeight),
          const Spacer(flex: 2),
        ]),
      ),
    );
  }
}

class _PageImage extends StatelessWidget {
  const _PageImage({Key? key, required this.data}) : super(key: key);

  final _PageData data;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox.expand(
          child: Image.asset(
            '${ImagePaths.common}/intro-${data.img}.jpg',
            fit: BoxFit.cover,
            alignment: Alignment.centerRight,
          ),
        ),
        Positioned.fill(
            child: Image.asset(
          '${ImagePaths.common}/intro-mask-${data.mask}.png',
          fit: BoxFit.fill,
        )),
      ],
    );
  }
}
