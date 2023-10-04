import 'package:url_launcher/url_launcher.dart';

import '../../../../../common_libs.dart';
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
  static const double _imageSize = 300;
  static const double _textHeight = 140;
  static const double _pageIndicatorHeight = 55;

  final pageData = [
    const _PageData(
      'Hi, I\'m Guillem Puche',
      'Purpose-driven  service-minded, entrepreneur, first principles, customer-focused',
      'silhouette.png',
      '1',
    ),
    const _PageData(
      'Not Merely A Resume, But A Journey',
      'Engage, explore, and enjoy my curated professional journey in app & web form',
      'airplane.png',
      '2',
    ),
    const _PageData(
      'Download Curriculum\'s Native App',
      null,
      'mobile.png',
      '3',
    )
  ];

  late final PageController _pageController = PageController()..addListener(_handlePageChanged);
  final ValueNotifier<int> _currentPage = ValueNotifier(0);
  bool _isOnFirstPage([int? value]) => value != null ? value == 0 : _currentPage.value == 0;
  bool _isOnLastPage([int? value]) =>
      value != null ? value.round() == pageData.length - 1 : _currentPage.value.round() == pageData.length - 1;

  @override
  Widget build(BuildContext context) {
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
                  // page view with title & description
                  MergeSemantics(
                    child: Semantics(
                      onIncrease: () => _handlePageNavigation(_currentPage.value + 1),
                      onDecrease: () => _handlePageNavigation(_currentPage.value - 1),
                      child: PageView(
                        controller: _pageController,
                        physics: PlatformInfo.isWeb && ScreenInfo.isMediumOrLarge(context)
                            ? const NeverScrollableScrollPhysics()
                            : const AlwaysScrollableScrollPhysics(),
                        onPageChanged: (_) => AppHaptics.lightImpact(),
                        children: pages,
                      ),
                    ),
                  ),

                  IgnorePointer(
                    ignoring: PlatformInfo.isSwipeEnabled(context),
                    child: Column(children: [
                      const Spacer(),

                      // image
                      SizedBox(
                        height: _imageSize,
                        child: ValueListenableBuilder<int>(
                          valueListenable: _currentPage,
                          builder: (_, value, __) {
                            return AnimatedSwitcher(
                              duration: $styles.times.slow,
                              child: KeyedSubtree(
                                key: ValueKey(value), // so AnimatedSwitcher sees it as a different child.
                                child: SizedBox.expand(
                                  child: Image.asset(
                                    '${ImagePaths.common}/${pageData[value].img}',
                                    fit: BoxFit.fitHeight,
                                    alignment: Alignment.center,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      // placeholder gap for text
                      const Gap(_IntroScreenState._textHeight),

                      // page indicator
                      if (PlatformInfo.isSwipeEnabled(context)) ...[
                        Container(
                          height: _pageIndicatorHeight,
                          alignment: const Alignment(0, 0),
                          child: AppPageIndicator(
                            count: pageData.length,
                            controller: _pageController,
                          ),
                        ),
                        _buildNavHelperText(context)
                      ] else
                        ValueListenableBuilder<int>(
                          valueListenable: _currentPage,
                          builder: (_, pageIndex, __) => PageNavButtons(
                            showStartButton: !_isOnFirstPage(pageIndex),
                            onStartButtonPressed: () => _handlePageNavigation(pageIndex - 1),
                            showEndButton: !_isOnLastPage(pageIndex),
                            onEndButtonPressed: () => _handlePageNavigation(pageIndex + 1),
                            child: AppPageIndicator(
                              count: pageData.length,
                              controller: _pageController,
                            ),
                          ),
                        ),
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

  void _handlePageChanged() => _currentPage.value = _pageController.page?.round() ?? 0;

  void _handlePageNavigation(int index) {
    if (index < 0) return;
    if (index > pageData.length - 1) return;

    _pageController.animateToPage(
      index,
      duration: $styles.times.fast,
      curve: Curves.easeOut,
    );
  }

  Widget _buildHzGradientOverlay({bool left = false}) {
    return Align(
      alignment: Alignment(left ? -1 : 1, 0),
      child: FractionallySizedBox(
        widthFactor: .4,
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
          child: Text(
            'Swipe right or left',
            style: $styles.text.bodySmall.copyWith(color: $styles.colors.accent1),
          ),
        );
      },
    );
  }
}

class _PageData {
  const _PageData(
    this.title,
    this.desc,
    this.img,
    this.mask,
  );

  final String title;

  /// If description is null, then app stores links will be shown.
  final String? desc;
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
            width: 570,
            child: StaticTextScale(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(data.title, style: $styles.text.experienceTitle.copyWith(fontSize: 24 * $styles.scale)),
                  Gap($styles.insets.sm),
                  if (data.desc != null)
                    Text(data.desc!, style: $styles.text.body, textAlign: TextAlign.center)
                  else
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () async {
                              final androidLink = Uri.parse(
                                  'https://play.google.com/store/apps/details?id=com.guillempuche.guillem_curriculum');
                              if (await canLaunchUrl(androidLink)) {
                                await launchUrl(androidLink);
                              }
                            },
                            child: Image.asset(
                              '${ImagePaths.common}/google-play-badge.png',
                              height: 45,
                            ),
                          ),
                        ),
                        Gap($styles.insets.md),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () async {
                              // final iOsLink = Uri.parse(
                              //     'https://play.google.com/store/apps/details?id=com.guillempuche.guillem_curriculum');
                              // if (await canLaunchUrl(androidLink)) {
                              //   await launchUrl(androidLink);
                              // }
                            },
                            child: Image.asset(
                              '${ImagePaths.common}/app-store-badge.png',
                              height: 45,
                            ),
                          ),
                        ),
                      ],
                    ),
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
