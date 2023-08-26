import '../../../../common_libs.dart';
import '../../../../logic/data/project_data.dart';
import '../../../common/compass_divider.dart';
import '../../../common/controls/app_header.dart';
import '../../../common/controls/app_loading_indicator.dart';
import '../../../common/gradient_container.dart';
import '../../../common/modals/fullscreen_url_img_viewer.dart';

part 'widgets/_info_column.dart';
part 'widgets/_image_btn.dart';

class ProjectDetailsScreen extends StatefulWidget {
  const ProjectDetailsScreen({Key? key, required this.projectId}) : super(key: key);
  final String projectId;

  @override
  State<ProjectDetailsScreen> createState() => _ProjectDetailsScreenState();
}

class _ProjectDetailsScreenState extends State<ProjectDetailsScreen> {
  late final _future = projectsAPILogic.getProjectByID(widget.projectId);

  @override
  Widget build(BuildContext context) {
    bool hzMode = context.isLandscape;
    return ColoredBox(
      color: $styles.colors.greyStrong,
      child: FutureBuilder<ProjectData?>(
        future: _future,
        builder: (_, snapshot) {
          final data = snapshot.data;
          late Widget content;
          if (snapshot.hasError || (snapshot.hasData && data == null)) {
            content = _buildError();
          } else if (!snapshot.hasData) {
            content = const Center(child: AppLoadingIndicator());
          } else {
            content = hzMode
                ? Row(children: [
                    Expanded(child: _ImageBtn(data: data!)),
                    Expanded(child: Center(child: SizedBox(width: 600, child: _InfoColumn(data: data)))),
                  ])
                : CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        pinned: true,
                        elevation: 0,
                        leading: const SizedBox.shrink(),
                        expandedHeight: context.heightPx * .5,
                        collapsedHeight: context.heightPx * .35,
                        flexibleSpace: _ImageBtn(data: data!),
                      ),
                      SliverToBoxAdapter(child: _InfoColumn(data: data)),
                    ],
                  );
          }

          return Stack(children: [
            content,
            const AppHeader(isTransparent: true),
          ]);
        },
      ),
    );
  }

  Animate _buildError() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
            child: Icon(
          Icons.warning_amber_outlined,
          color: $styles.colors.accent1,
          size: $styles.insets.lg,
        )),
        Gap($styles.insets.xs),
        SizedBox(
          width: $styles.insets.xxl * 3,
          child: Text(
            $strings.projectDetailsErrorNotFound(widget.projectId),
            style: $styles.text.body.copyWith(color: $styles.colors.offWhite),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    ).animate().fadeIn();
  }
}
