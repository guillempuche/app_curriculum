import 'dart:ui';

import 'package:guillem_curriculum/logic/data/project_data.dart';
import 'package:guillem_curriculum/logic/projects_logic.dart';

import '../../../../common_libs.dart';
import '../../../common/controls/app_page_indicator.dart';
import '../../../common/static_text_scale.dart';

part 'widgets/_blurred_image_bg.dart';
part 'widgets/_bottom_text_content.dart';
part 'widgets/_collapsing_carousel_item.dart';

class ProjectsCarouselScreen extends StatefulWidget {
  const ProjectsCarouselScreen({
    Key? key,
    // required this.type,
    this.contentPadding = EdgeInsets.zero,
  }) : super(key: key);
  // final WonderType type;
  final EdgeInsets contentPadding;

  @override
  State<ProjectsCarouselScreen> createState() => _ProjectsCarouselScreenState();
}

class _ProjectsCarouselScreenState extends State<ProjectsCarouselScreen> {
  PageController? _pageController;
  final _currentPage = ValueNotifier<double>(9999);

  List<ProjectData> get _projects => projectsLogic.all;
  // late final List<HighlightData> _artifacts = HighlightData.forWonder(widget.type);

  late final _currentArtifactIndex = ValueNotifier<int>(_wrappedPageIndex);

  int get _wrappedPageIndex => _currentPage.value.round() % _projects.length;

  void _handlePageChanged() {
    _currentPage.value = _pageController?.page ?? 0;
    _currentArtifactIndex.value = _wrappedPageIndex;
  }

  // void _handleSearchTap() => context.push(ScreenPaths.search(widget.type));

  void _handleProjectTap(int index) {
    int delta = index - _currentPage.value.round();
    if (delta == 0) {
      ProjectData data = _projects[index % _projects.length];
      context.push(ScreenPaths.project(data.id));
    } else {
      _pageController?.animateToPage(
        _currentPage.value.round() + delta,
        duration: $styles.times.fast,
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    bool shortMode = context.heightPx <= 800;
    final double bottomHeight = context.heightPx / 2.75; // Prev 340, dynamic seems to work better
    // Allow objects to become wider as the screen becomes tall, this allows
    // them to grow taller as well, filling the available space better.
    double itemHeight = (context.heightPx - 200 - bottomHeight).clamp(250, 400);
    double itemWidth = itemHeight * .666;
    // TODO: This could be optimized to only run if the size has changed.
    _pageController?.dispose();
    _pageController = PageController(
      viewportFraction: itemWidth / context.widthPx,
      initialPage: _currentPage.value.round(),
    );
    _pageController?.addListener(_handlePageChanged);
    final pages = _projects.map((e) {
      return Padding(
        padding: const EdgeInsets.all(10),
        child: _DoubleBorderImage(e),
      );
    }).toList();

    return VerticalSwipeNavigator(
      backDirection: TransitionDirection.bottomToTop,
      goBackPath: ScreenPaths.experiences,
      child: Stack(
        children: [
          /// Blurred Bg
          Positioned.fill(
            child: ValueListenableBuilder<int>(
                valueListenable: _currentArtifactIndex,
                builder: (_, value, __) {
                  return _BlurredImageBg(url: _projects[value].imageUrl);
                }),
          ),

          Padding(
              padding: widget.contentPadding,
              child: Stack(
                children: [
                  /// BgCircle
                  _buildBgCircle(bottomHeight),

                  /// Carousel Items
                  PageView.builder(
                    controller: _pageController,
                    itemBuilder: (_, index) {
                      final wrappedIndex = index % pages.length;
                      final child = pages[wrappedIndex];
                      return ValueListenableBuilder<double>(
                        valueListenable: _currentPage,
                        builder: (_, value, __) {
                          final int offset = (value.round() - index).abs();
                          return _CollapsingCarouselItem(
                            width: itemWidth,
                            indexOffset: min(3, offset),
                            onPressed: () => _handleProjectTap(index),
                            title: _projects[wrappedIndex].title,
                            child: child,
                          );
                        },
                      );
                    },
                  ),

                  /// Bottom Text
                  BottomCenter(
                    child: ValueListenableBuilder<int>(
                      valueListenable: _currentArtifactIndex,
                      builder: (_, value, __) => _BottomTextContent(
                        project: _projects[value],
                        height: bottomHeight,
                        shortMode: shortMode,
                        state: this,
                      ),
                    ),
                  ),
                ],
              ))
        ],
      ),
    );
  }

  OverflowBox _buildBgCircle(double height) {
    const double size = 2000;
    return OverflowBox(
      maxWidth: size,
      maxHeight: size,
      child: Transform.translate(
        offset: const Offset(0, size / 2),
        child: Container(
          decoration: BoxDecoration(
            color: $styles.colors.offWhite.withOpacity(0.8),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(size)),
          ),
        ),
      ),
    );
  }
}
