part of '../projects_carousel_screen.dart';

class _BottomTextContent extends StatelessWidget {
  const _BottomTextContent(
      {Key? key, required this.project, required this.height, required this.state, required this.shortMode})
      : super(key: key);

  final ProjectData project;
  final double height;
  final _ProjectsCarouselScreenState state;
  final bool shortMode;
  int get _currentPage => state._currentPage.value.round();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: $styles.sizes.maxContentWidth2,
      height: height,
      padding: EdgeInsets.symmetric(horizontal: $styles.insets.md),
      alignment: Alignment.center,
      child: Stack(
        children: [
          /// Text
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Gap($styles.insets.md),
              Column(
                children: [
                  if (!shortMode)
                    AppPageIndicator(
                      count: state._projects.length,
                      controller: state._pageController!,
                      semanticPageTitle: $strings.projectSemanticProject,
                    ),
                  Gap($styles.insets.sm),
                  IgnorePointer(
                    ignoringSemantics: false,
                    child: Semantics(
                      button: true,
                      onIncrease: () => state._handleProjectTap(_currentPage + 1),
                      onDecrease: () => state._handleProjectTap(_currentPage - 1),
                      onTap: () => state._handleProjectTap(_currentPage),
                      liveRegion: true,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // Force column to stretch horizontally so text is centered
                          const SizedBox(width: double.infinity),

                          // Stop text from scaling to make layout a little easier, it's already quite large
                          StaticTextScale(
                            child: Text(
                              project.title,
                              overflow: TextOverflow.ellipsis,
                              style: $styles.text.h2.copyWith(color: $styles.colors.black, height: 1.2, fontSize: 32),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                            ),
                          ),
                          // if (!shortMode) ...[
                          //   Gap($styles.insets.xxs),
                          //   Text(
                          //     project.date.isEmpty ? '--' : project.date,
                          //     style: $styles.text.body,
                          //     textAlign: TextAlign.center,
                          //   ),
                          // ]
                        ],
                      ).animate(key: ValueKey(project.id)).fadeIn(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
