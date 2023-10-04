import '../../../common_libs.dart';
import '../common/fade_color_transition.dart';
import './common/illustration_piece.dart';
import './common/paint_textures.dart';
import './common/experience_illustration_builder.dart';
import './common/wonder_illustration_config.dart';

class MachuPicchuIllustration extends StatelessWidget {
  MachuPicchuIllustration({Key? key, required this.config}) : super(key: key);
  final WonderIllustrationConfig config;
  final String assetPath = ExperienceType.others.assetPath;
  final fgColor = ExperienceType.others.fgColor;
  final bgColor = ExperienceType.others.bgColor;

  @override
  Widget build(BuildContext context) {
    return ExperienceIllustrationBuilder(
      config: config,
      bgBuilder: _buildBg,
      mgBuilder: _buildMg,
      fgBuilder: _buildFg,
      experienceType: ExperienceType.others,
    );
  }

  List<Widget> _buildBg(BuildContext context, Animation<double> anim) {
    return [
      FadeColorTransition(animation: anim, color: fgColor),
      Positioned.fill(
        child: IllustrationTexture(
          ImagePaths.roller1,
          flipX: false,
          color: Color(0xff1E736D),
          opacity: anim.drive(Tween(begin: 0, end: .5)),
          scale: config.shortMode ? 3 : 1,
        ),
      ),
      IllustrationPiece(
        fileName: 'sun.png',
        initialOffset: Offset(0, 50),
        enableHero: true,
        heightFactor: config.shortMode ? .15 : .15,
        minHeight: 100,
        offset: config.shortMode ? Offset(150, context.heightPx * -.08) : Offset(150, context.heightPx * -.35),
      ),
    ];
  }

  List<Widget> _buildMg(BuildContext context, Animation<double> anim) => [
        IllustrationPiece(
          fileName: 'quirky-wrench-and-screwdriver-1.png',
          heightFactor: .6,
          minHeight: 230,
          zoomAmt: config.shortMode ? .1 : -1,
          enableHero: true,
          fractionalOffset: Offset(config.shortMode ? 0 : -.05, config.shortMode ? 0.12 : -.1),
        ),
      ];

  List<Widget> _buildFg(BuildContext context, Animation<double> anim) {
    return [
      IllustrationPiece(
        fileName: 'quirky-t-shirt-and-stack-of-clothes-1.png',
        alignment: Alignment.bottomCenter,
        initialScale: .9,
        initialOffset: Offset(0, 60),
        heightFactor: .6,
        fractionalOffset: Offset(0, .2),
        zoomAmt: .05,
        dynamicHzOffset: 150,
      ),
      IllustrationPiece(
        fileName: 'quirky-calendar-with-notes-1.png',
        alignment: Alignment.bottomCenter,
        initialOffset: Offset(20, 40),
        heightFactor: .6,
        initialScale: 1.2,
        fractionalOffset: Offset(-.5, .1),
        zoomAmt: .2,
        dynamicHzOffset: -50,
      ),
    ];
  }
}
