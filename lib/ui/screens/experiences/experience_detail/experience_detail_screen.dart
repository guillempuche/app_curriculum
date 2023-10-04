import 'dart:async';

import 'package:flutter/rendering.dart';
import 'package:guillem_curriculum/ui/common/markdown_renderer.dart';

import '../../../../../common_libs.dart';
import '../../../../logic/common/string_utils.dart';
import '../../../common/compass_divider.dart';
import '../../../common/controls/app_header.dart';
import '../../../common/pop_router_on_over_scroll.dart';
import '../../../common/static_text_scale.dart';
import '../../../common/themed_text.dart';
import '../../../common/utils/context_utils.dart';
import '../../../experience_illustrations/common/experience_illustration.dart';
import '../../../experience_illustrations/common/wonder_illustration_config.dart';
import '../../../experience_illustrations/common/experience_title_text.dart';

part 'widgets/_callout.dart';
part 'widgets/_section_divider.dart';
part 'widgets/_title_text.dart';
part 'widgets/_top_illustration.dart';

class ExperienceDetailScreen extends StatefulWidget {
  const ExperienceDetailScreen(
    this.type, {
    Key? key,
  }) : super(key: key);
  final ExperienceType type;

  @override
  State<ExperienceDetailScreen> createState() => _ExperienceDetailScreenState();
}

class _ExperienceDetailScreenState extends State<ExperienceDetailScreen> {
  late final ScrollController _scroller = ScrollController()..addListener(_handleScrollChanged);
  final _scrollPos = ValueNotifier(0.0);
  final EdgeInsets contentPadding = EdgeInsets.all($styles.insets.md);
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

      return PopRouterOnOverScroll(
        controller: _scroller,
        child: ColoredBox(
          color: $styles.colors.offWhite,
          child: Stack(
            children: [
              /// Background
              Positioned.fill(
                child: ColoredBox(color: $styles.colors.black),
              ),

              /// Top Illustration - Sits underneath the scrolling content, fades out as it scrolls
              SizedBox(
                height: illustrationHeight,
                child: ValueListenableBuilder<double>(
                  valueListenable: _scrollPos,
                  builder: (_, value, child) {
                    // get some value between 0 and 1, based on the amt scrolled
                    double opacity = (1 - value / 300).clamp(0, 1);
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
                                double offsetAmt = max(0, value * .4);
                                double opacity = (1 - offsetAmt / 150).clamp(0, 1);

                                return Transform.translate(
                                  offset: Offset(0, offsetAmt),
                                  child: Opacity(opacity: opacity, child: child),
                                );
                              },
                              child: _TitleText(experience, scroller: _scroller),
                            ),
                          ),

                          SliverToBoxAdapter(
                            child: Center(
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: ScreenInfo.isMediumOrLarge(context) ? 600 : double.infinity,
                                ),
                                child: MarkdownRenderer(
                                  experience.text,
                                  scroller: _scroller,
                                  style: generatorMarkdownStyle($styles.colors.offWhite),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // const AppHeader(backIcon: AppIcons.north, isTransparent: true)
              const AppHeader(backIcon: Icons.arrow_upward, isTransparent: true)
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
