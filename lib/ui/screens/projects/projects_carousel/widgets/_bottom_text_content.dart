part of '../projects_carousel_screen.dart';

class _BottomTextContent extends StatelessWidget {
  const _BottomTextContent({
    Key? key,
    required this.project,
    required this.height,
    required this.state,
  }) : super(key: key);

  final ProjectData project;
  final double height;
  final _ProjectsCarouselScreenState state;

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
              Gap($styles.insets.sm),
              Column(
                children: [
                  if (PlatformInfo.isSwipeEnabled(context))
                    AppPageIndicator(
                      count: state._projects.length,
                      controller: state._pageController!,
                      semanticPageTitle: $strings.projectSemanticProject,
                    )
                  else
                    PageNavButtons(
                      onStartButtonPressed: () => state._handleProjectTap(_currentPage - 1),
                      onEndButtonPressed: () => state._handleProjectTap(_currentPage + 1),
                      child: AppPageIndicator(
                        count: state._projects.length,
                        controller: state._pageController!,
                        semanticPageTitle: $strings.projectSemanticProject,
                      ),
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
                              // style: $styles.text.h2.copyWith(color: $styles.colors.black, height: 1.2, fontSize: 32),
                              style: $styles.text.h3.copyWith(color: $styles.colors.black),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                            ),
                          ),
                          Gap($styles.insets.sm),
                          TextButton(
                            style: TextButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.primary),
                            child: Text(
                              'Read more',
                              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                            ),
                            onPressed: () => state._handleProjectTap(_currentPage),
                          )
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
