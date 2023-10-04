import '../../../common_libs.dart';

class ExperienceTitleText extends StatelessWidget {
  const ExperienceTitleText(
    this.data, {
    Key? key,
    this.enableShadows = false,
    this.enableHero = true,
  }) : super(key: key);
  final ExperienceData data;
  final bool enableShadows;
  final bool enableHero;

  @override
  Widget build(BuildContext context) {
    var textStyle = $styles.text.experienceTitle.copyWith(color: $styles.colors.offWhite);

    // Split on spaces, later, add either a linebreak or a space back in.
    final title = data.title;
    List<String> pieces = title.split(' ');

    // TextSpan builder, figures out whether to use small text, and adds linebreak or space (or nothing).
    TextSpan buildTextSpan(String text) {
      int i = pieces.indexOf(text);
      bool addLinebreak = i == 0 && pieces.length > 1;
      bool addSpace = !addLinebreak && i < pieces.length - 1;

      return TextSpan(
        text: '$text${addLinebreak ? '\n' : addSpace ? ' ' : ''}',
        style: textStyle,
      );
    }

    List<Shadow> shadows = enableShadows ? $styles.shadows.textSoft : [];

    var content = RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: textStyle.copyWith(shadows: shadows),
        children: pieces.map(buildTextSpan).toList(),
      ),
    );

    return enableHero
        ? Hero(
            tag: 'experience-$title',
            child: content,
          )
        : content;
  }
}
