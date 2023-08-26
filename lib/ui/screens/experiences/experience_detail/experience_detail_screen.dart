import 'dart:async';

import 'package:drop_cap_text/drop_cap_text.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_circular_text/circular_text.dart';
import 'package:guillem_curriculum/ui/common/markdown_renderer.dart';

import '../../../../../common_libs.dart';
import '../../../../logic/common/string_utils.dart';
import '../../../../logic/data/experience_data.dart';
import '../../../../logic/data/wonder_data.dart';
import '../../../common/app_icons.dart';
import '../../../common/blend_mask.dart';
import '../../../common/centered_box.dart';
import '../../../common/compass_divider.dart';
import '../../../common/controls/app_header.dart';
import '../../../common/curved_clippers.dart';
import '../../../common/gradient_container.dart';
import '../../../common/hidden_collectible.dart';
import '../../../common/pop_router_on_over_scroll.dart';
import '../../../common/scaling_list_item.dart';
import '../../../common/static_text_scale.dart';
import '../../../common/themed_text.dart';
import '../../../common/utils/context_utils.dart';
import '../../../wonder_illustrations/common/experience_illustration.dart';
import '../../../wonder_illustrations/common/wonder_illustration_config.dart';
import '../../../wonder_illustrations/common/experience_title_text.dart';

part 'widgets/_app_bar.dart';
part 'widgets/_callout.dart';
part 'widgets/_circular_title_bar.dart';
part 'widgets/_collapsing_pull_quote_image.dart';
part 'widgets/_large_simple_quote.dart';
part 'widgets/_scrolling_content.dart';
part 'widgets/_section_divider.dart';
part 'widgets/_sliding_image_stack.dart';
part 'widgets/_title_text.dart';
part 'widgets/_top_illustration.dart';

class ExperienceDetailScreen extends StatefulWidget {
  const ExperienceDetailScreen(
    this.type, {
    Key? key,
    // required this.contentPadding,
  }) : super(key: key);
  final ExperienceType type;

  @override
  State<ExperienceDetailScreen> createState() => _ExperienceDetailScreenState();
}

class _ExperienceDetailScreenState extends State<ExperienceDetailScreen> {
  late final ScrollController _scroller = ScrollController()..addListener(_handleScrollChanged);
  final _scrollPos = ValueNotifier(0.0);
  final EdgeInsets contentPadding = EdgeInsets.all($styles.insets.sm);
  // final _sectionIndex = ValueNotifier(0);
  late ExperienceData experience;
  @override
  void initState() {
    super.initState();
    experience = experiencesLogic.getData(widget.type);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, constraints) {
      bool shortMode = constraints.biggest.height < 700;
      double illustrationHeight = shortMode ? 250 : 280;
      double minAppBarHeight = shortMode ? 80 : 150;

      /// Attempt to maintain a similar aspect ratio for the image within the app-bar
      double maxAppBarHeight = min(context.widthPx, $styles.sizes.maxContentWidth1) * 1.2;
      bool showBackBtn = appLogic.shouldUseNavRail() == false;

      return PopRouterOnOverScroll(
        controller: _scroller,
        child: ColoredBox(
          color: $styles.colors.offWhite,
          child: Stack(
            children: [
              /// Background
              Positioned.fill(
                // child: ColoredBox(color: widget.data.type.bgColor),
                child: ColoredBox(color: Colors.green),
              ),

              /// Top Illustration - Sits underneath the scrolling content, fades out as it scrolls
              SizedBox(
                height: illustrationHeight,
                child: ValueListenableBuilder<double>(
                  valueListenable: _scrollPos,
                  builder: (_, value, child) {
                    // get some value between 0 and 1, based on the amt scrolled
                    double opacity = (1 - value / 700).clamp(0, 1);
                    return Opacity(opacity: opacity, child: child);
                  },
                  // This is due to a bug: https://github.com/flutter/flutter/issues/101872
                  child: RepaintBoundary(
                      child: _TopIllustration(
                    widget.type,
                    // Polish: Inject the content padding into the illustration as an offset, so it can center itself relative to the content
                    // this allows the background to extend underneath the vertical side nav when it has rounded corners.
                    fgOffset: Offset(contentPadding.left / 2, 0),
                  )),
                ),
              ),

              /// Scrolling content - Includes an invisible gap at the top, and then scrolls over the illustration
              TopCenter(
                child: Padding(
                  padding: contentPadding,
                  child: SizedBox(
                    child: FocusTraversalGroup(
                      child: CustomScrollView(
                        key: PageStorageKey(experience.id),
                        // primary: false,
                        controller: _scroller,
                        scrollBehavior: ScrollConfiguration.of(context).copyWith(),
                        slivers: [
                          /// Invisible padding at the top of the list, so the illustration shows through the btm
                          SliverToBoxAdapter(child: SizedBox(height: illustrationHeight)),

                          /// Text content, animates itself to hide behind the app bar as it scrolls up
                          SliverToBoxAdapter(
                            child: ValueListenableBuilder<double>(
                              valueListenable: _scrollPos,
                              builder: (_, value, child) {
                                double offsetAmt = max(0, value * .3);
                                double opacity = (1 - offsetAmt / 150).clamp(0, 1);

                                return Transform.translate(
                                  offset: Offset(0, offsetAmt),
                                  child: Opacity(opacity: opacity, child: child),
                                );
                              },
                              child: _TitleText(experience, scroller: _scroller),
                            ),
                          ),

                          /// Collapsing App bar, pins to the top of the list
                          SliverAppBar(
                            pinned: true,
                            collapsedHeight: minAppBarHeight,
                            // collapsedHeight: 20,
                            // toolbarHeight: minAppBarHeight,
                            // toolbarHeight: 20,
                            expandedHeight: maxAppBarHeight,
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            leading: const SizedBox.shrink(),
                            flexibleSpace: SizedBox.expand(
                              child: _AppBar(
                                experience,
                                scrollPos: _scrollPos,
                                // sectionIndex: _sectionIndex,
                              ),
                            ),
                          ),

                          // /// Editorial content (text and images)
                          // _ScrollingContent(widget.data, scrollPos: _scrollPos, sectionNotifier: _sectionIndex),
                          SliverBackgroundColor(
                            color: $styles.colors.offWhite,
                            sliver: SliverToBoxAdapter(
                              child: SizedBox(
                                height: 800,
                                child: MarkdownRenderer(experience.text),
                              ),
                            ),
                          ),
                          // SliverToBoxAdapter(
                          //   child: IntrinsicHeight(
                          //     child: MarkdownRenderer(experience.text),
                          //   ),
                          // ),
                          // SliverToBoxAdapter(
                          //   child: ShrinkWrappingViewport(
                          //     offset: ViewportOffset.zero(),
                          //     slivers: [SliverToBoxAdapter(child: MarkdownRenderer(experience.text))],
                          //   ),
                          // ),
                          // SliverToBoxAdapter(
                          //   key: ValueKey(experience.title),
                          //   child: SingleChildScrollView(
                          //     child: MarkdownRenderer(experience.text),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              /// Home Btn
              if (showBackBtn)
                // AnimatedBuilder(
                //     animation: _scroller,
                //     builder: (_, child) {
                //       return AnimatedOpacity(
                //         opacity: _scrollPos.value > 0 ? 0 : 1,
                //         duration: $styles.times.med,
                //         child: child,
                //       );
                //     },
                //     child: const AppHeader(backIcon: AppIcons.north, isTransparent: true))
                const AppHeader(backIcon: AppIcons.north, isTransparent: true)
            ],
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    _scroller.dispose();
    super.dispose();
  }

  /// Various [ValueListenableBuilders] are mapped to the _scrollPos and will rebuild when it changes
  void _handleScrollChanged() {
    _scrollPos.value = _scroller.position.pixels;
  }
}
