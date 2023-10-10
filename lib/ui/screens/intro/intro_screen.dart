import 'package:url_launcher/url_launcher.dart';

import '../../../../../common_libs.dart';
import '../../common/controls/app_page_indicator.dart';
import '../../common/themed_text.dart';
import '../../common/utils/app_haptics.dart';

const double _maxImageHeightMin = 300;

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final List<PageData> pageData = PageData.data;
  late final PageController _pageController = PageController()..addListener(_handlePageChanged);
  final ValueNotifier<int> _currentPage = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

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
              child: Center(
                child: SizedBox(
                  width: 600,
                  child: Column(
                    children: [
                      Flexible(
                        child: Pages(
                          controller: _pageController,
                          pageData: pageData,
                        ),
                      ),
                      Gap($styles.insets.md),
                      NavigationControls(
                        controller: _pageController,
                        pageData: pageData,
                      ),
                      SizedBox(height: screenHeight * 0.2),
                    ],
                  ),
                ),
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
}

class PageData {
  const PageData({
    required this.title,
    required this.image,
    required this.mask,
    required this.imageHeight,
    this.desc,
  });

  final String title;
  final String image;
  final String mask;
  final double imageHeight;

  /// If description is null, then app stores links will be shown.
  final String? desc;

  static List<PageData> get data => [
        const PageData(
          title: 'Hi, I\'m Guillem Puche',
          desc: 'Purpose-driven service-minded, entrepreneur, first principles, customer-focused',
          image: 'silhouette.png',
          mask: '1',
          imageHeight: _maxImageHeightMin,
        ),
        const PageData(
          title: 'Not Merely A Resume, But A Journey',
          desc:
              'Engage, explore, and enjoy my curated professional journey in app & web form that took +150 hours to complete',
          image: 'airplane.png',
          mask: '2',
          imageHeight: _maxImageHeightMin - 50,
        ),
        const PageData(
          title: 'Download The App For The Best Experience',
          image: 'mobile.png',
          mask: '3',
          imageHeight: _maxImageHeightMin - 50,
        )
      ];
}

class Pages extends StatelessWidget {
  const Pages({
    super.key,
    required this.controller,
    required this.pageData,
  });

  final PageController controller;
  final List<PageData> pageData;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = pageData.map((e) => PageContent(data: e)).toList();

    return PageView(
      controller: controller,
      // Disable the swipe navigation
      physics: !PlatformInfo.isSwipeEnabled(context)
          ? const NeverScrollableScrollPhysics()
          : const AlwaysScrollableScrollPhysics(),
      onPageChanged: (_) => AppHaptics.lightImpact(),
      children: pages,
    );
  }
}

class PageContent extends StatelessWidget {
  PageContent({
    super.key,
    required this.data,
  });

  final PageData data;

  final androidLink = Uri.parse('https://play.google.com/store/apps/details?id=com.guillempuche.guillem_curriculum');
  final _storeBadeHeight = 45.0;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      child: AnimatedSwitcher(
        duration: $styles.times.slow,
        child: KeyedSubtree(
          key: ValueKey(data.image),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: data.imageHeight,
                  child: Image.asset(
                    height: data.imageHeight,
                    '${ImagePaths.common}/${data.image}',
                    alignment: Alignment.center,
                  ),
                ),
                Gap($styles.insets.sm),
                Text(
                  data.title,
                  style: $styles.text.h2,
                  textAlign: TextAlign.center,
                ),
                Gap($styles.insets.sm),
                if (data.desc != null)
                  Text(
                    data.desc!,
                    style: $styles.text.body,
                    textAlign: TextAlign.center,
                  )
                else
                  _storeBadges(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _storeBadges() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () async {
                if (await canLaunchUrl(androidLink)) {
                  await launchUrl(
                    androidLink,
                    mode: LaunchMode.externalApplication,
                  );
                }
              },
              child: Image.asset(
                '${ImagePaths.common}/google-play-badge.png',
                height: _storeBadeHeight,
              ),
            ),
          ),
          Gap($styles.insets.md),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () async {
                // if (await canLaunchUrl(androidLink)) {
                //   await launchUrl(iOsLink,mode: LaunchMode.externalApplication,);
                // }
              },
              child: Image.asset(
                '${ImagePaths.common}/app-store-badge.png',
                height: _storeBadeHeight,
              ),
            ),
          ),
        ],
      );
}

class NavigationControls extends StatelessWidget {
  const NavigationControls({
    super.key,
    required this.controller,
    required this.pageData,
  });

  final PageController controller;
  final List<PageData> pageData;
  bool _isOnFirstPage([int? value]) => value != null ? value == 0 : controller.page == 0;
  bool _isOnLastPage([int? value]) =>
      value != null ? value.round() == pageData.length - 1 : controller.page == pageData.length - 1;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        int pageIndex = controller.page?.round() ?? 0;

        return Column(
          children: [
            if (PlatformInfo.isSwipeEnabled(context))
              AppPageIndicator(
                count: pageData.length,
                onDotPressed: _handlePageNavigation,
                controller: controller,
              )
            else
              PageNavButtons(
                showStartButton: !_isOnFirstPage(pageIndex),
                onStartButtonPressed: () => _handlePageNavigation(pageIndex - 1),
                showEndButton: !_isOnLastPage(pageIndex),
                onEndButtonPressed: () => _handlePageNavigation(pageIndex + 1),
                child: AppPageIndicator(
                  count: pageData.length,
                  onDotPressed: _handlePageNavigation,
                  controller: controller,
                ),
              ),
            if (PlatformInfo.isSwipeEnabled(context))
              AnimatedOpacity(
                opacity: pageIndex == pageData.length - 1 ? 0 : 1,
                duration: $styles.times.fast,
                child: Text(
                  'Swipe right or left',
                  style: $styles.text.bodySmall.copyWith(color: $styles.colors.accent1),
                ),
              ),
          ],
        );
      },
    );
  }

  void _handlePageNavigation(int index) {
    if (index < 0) return;
    if (index > pageData.length - 1) return;

    controller.animateToPage(
      index,
      duration: $styles.times.fast,
      curve: Curves.easeOut,
    );
  }
}
