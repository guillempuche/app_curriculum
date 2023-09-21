import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:guillem_curriculum/logic/common/string_utils.dart';
import 'package:guillem_curriculum/ui/common/markdown_renderer.dart';

import '../../../../common_libs.dart';
import '../../../common/compass_divider.dart';
import '../../../common/controls/app_header.dart';
import '../../../common/gradient_container.dart';
import '../../../common/modals/fullscreen_url_img_viewer.dart';

part '_image_btn.dart';

class ProjectDetailsScreen extends StatefulWidget {
  const ProjectDetailsScreen({Key? key, required this.projectId}) : super(key: key);
  final String projectId;

  @override
  State<ProjectDetailsScreen> createState() => _ProjectDetailsScreenState();
}

class _ProjectDetailsScreenState extends State<ProjectDetailsScreen> {
  late final ProjectData project;
  final ScrollController _scroller = ScrollController();

  @override
  void initState() {
    super.initState();

    project = projectsLogic.getById(widget.projectId);
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: $styles.colors.greyStrong,
      child: Stack(children: [
        context.isLandscape
            ?
            // Dual view for big screens
            Row(children: [
                Expanded(child: _ImageBtn(data: project)),
                Expanded(
                  child: Center(
                    child: SizedBox(
                      width: 600,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: $styles.insets.lg),
                        child: CustomScrollView(
                          controller: _scroller,
                          scrollBehavior: ScrollConfiguration.of(context).copyWith(),
                          slivers: _content(),
                        ),
                      ),
                    ),
                  ),
                ),
              ])
            :
            // Vertical view for smaller screens
            Padding(
                padding: EdgeInsets.symmetric(horizontal: $styles.insets.md),
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(child: _ImageBtn(data: project)),
                    ..._content(),
                  ],
                ),
              ),
        const AppHeader(isTransparent: true),
      ]),
    );
  }

  List<Widget> _content() => [
        SliverToBoxAdapter(child: Gap($styles.insets.xl)),
        SliverAppBar(
          pinned: true,
          backgroundColor: $styles.colors.greyStrong,
          automaticallyImplyLeading: false,
          collapsedHeight: 110,
          flexibleSpace: Semantics(
            header: true,
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(context.isLandscape ? 0 : 20, 20, 0, 0),
              child: Text(
                project.title,
                textAlign: TextAlign.center,
                style: $styles.text.h2.copyWith(color: $styles.colors.offWhite, height: 1.2),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ).animate().fade(delay: 250.ms, duration: 600.ms),
            ),
          ),
        ),
        SliverToBoxAdapter(child: Gap($styles.insets.md)),
        if (project.date != null)
          SliverToBoxAdapter(
            child: Center(
              child: Text(
                StringUtils.formatYrMth(project.date!),
                style: $styles.text.body.copyWith(color: $styles.colors.offWhite),
              ),
            ),
          ),
        SliverToBoxAdapter(child: Gap($styles.insets.md)),
        SliverToBoxAdapter(
          child: Animate().toggle(
              delay: 500.ms,
              builder: (_, value, __) {
                return CompassDivider(isExpanded: !value, duration: $styles.times.med);
              }),
        ),
        SliverToBoxAdapter(child: Gap($styles.insets.lg)),
        SliverToBoxAdapter(
          child: Center(
            child: MarkdownRenderer(
              project.text,
              scroller: _scroller,
              style: generatorMarkdownStyle($styles.colors.offWhite),
            ),
          ),
        ),
        SliverToBoxAdapter(child: Gap($styles.insets.offset)),
      ];

  // Animate _buildError() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.center,
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       Center(
  //           child: Icon(
  //         Icons.warning_amber_outlined,
  //         color: $styles.colors.accent1,
  //         size: $styles.insets.lg,
  //       )),
  //       Gap($styles.insets.xs),
  //       SizedBox(
  //         width: $styles.insets.xxl * 3,
  //         child: Text(
  //           $strings.projectDetailsErrorNotFound(widget.projectId),
  //           style: $styles.text.body.copyWith(color: $styles.colors.offWhite),
  //           textAlign: TextAlign.center,
  //         ),
  //       ),
  //     ],
  //   ).animate().fadeIn();
  // }
}
