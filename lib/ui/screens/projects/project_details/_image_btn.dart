part of 'project_details_screen.dart';

class _ImageBtn extends StatelessWidget {
  const _ImageBtn({Key? key, required this.data}) : super(key: key);
  final ProjectData data;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BottomCenter(
          child: Transform.translate(
            offset: Offset(0, $styles.insets.xl - 1),
            child: VtGradient(
              [$styles.colors.greyStrong, $styles.colors.greyStrong.withOpacity(0)],
              const [0, 1],
              height: $styles.insets.xl,
            ),
          ),
        ),
        Container(
          color: $styles.colors.black,
          alignment: Alignment.center,
          child: AppBtn.basic(
            semanticLabel: $strings.projectDetailsSemanticThumbnail,
            onPressed: () => _handleImagePressed(context),
            child: SafeArea(
              bottom: false,
              minimum: EdgeInsets.symmetric(vertical: $styles.insets.sm),
              child: Hero(
                tag: data.imageUrl,
                child: AppImage(
                  image: NetworkImage(data.imageUrl),
                  fit: BoxFit.cover,
                  distractor: true,
                  scale: FullscreenUrlImgViewer.imageScale, // so the image isn't reloaded
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _handleImagePressed(BuildContext context) {
    appLogic.showFullscreenDialogRoute(context, FullscreenUrlImgViewer(urls: [data.imageUrl]));
  }
}
