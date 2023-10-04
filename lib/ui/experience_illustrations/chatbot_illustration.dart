import '../../common_libs.dart';
import '../common/fade_color_transition.dart';
import './common/illustration_piece.dart';
import './common/paint_textures.dart';
import './common/experience_illustration_builder.dart';
import './common/wonder_illustration_config.dart';

class GreatWallIllustration extends StatelessWidget {
  GreatWallIllustration({Key? key, required this.config}) : super(key: key);
  final WonderIllustrationConfig config;
  final String assetPath = ExperienceType.chatbot.assetPath;
  final fgColor = ExperienceType.chatbot.fgColor;
  final bgColor = ExperienceType.chatbot.bgColor;

  @override
  Widget build(BuildContext context) {
    return ExperienceIllustrationBuilder(
      config: config,
      bgBuilder: _buildBg,
      mgBuilder: _buildMg,
      fgBuilder: _buildFg,
      experienceType: ExperienceType.chatbot,
    );
  }

  List<Widget> _buildBg(BuildContext context, Animation<double> anim) {
    return [
      FadeColorTransition(animation: anim, color: $styles.colors.shift(fgColor, .15)),
      Positioned.fill(
        child: IllustrationTexture(
          ImagePaths.roller2,
          flipX: true,
          color: Color(0xff688750),
          opacity: anim.drive(Tween(begin: 0, end: 1)),
          scale: config.shortMode ? 4 : 1.15,
        ),
      ),
      IllustrationPiece(
        fileName: 'sun.png',
        initialOffset: Offset(0, 50),
        enableHero: true,
        heightFactor: config.shortMode ? .07 : .25,
        minHeight: 120,
        offset: config.shortMode ? Offset(-40, context.heightPx * -.06) : Offset(-65, context.heightPx * -.3),
      ),
    ];
  }

  List<Widget> _buildMg(BuildContext context, Animation<double> anim) {
    return [
      IllustrationPiece(
        fileName: 'quirky-customer-support-1.png',
        heightFactor: config.shortMode ? .45 : .65,
        minHeight: 250,
        zoomAmt: .05,
        enableHero: true,
        fractionalOffset: Offset(0, config.shortMode ? .15 : -.15),
      ),
    ];
  }

  List<Widget> _buildFg(BuildContext context, Animation<double> anim) {
    return [
      IllustrationPiece(
        fileName: 'quirky-phone-in-a-hand-1.png',
        alignment: Alignment.bottomCenter,
        initialScale: .9,
        initialOffset: Offset(-40, 60),
        heightFactor: .85,
        fractionalOffset: Offset(-.4, .45),
        zoomAmt: .25,
        dynamicHzOffset: -150,
      ),
      IllustrationPiece(
        fileName: 'quirky-twenty-four-hours-service-1.png',
        alignment: Alignment.bottomCenter,
        initialOffset: Offset(20, 40),
        initialScale: .95,
        heightFactor: 1,
        fractionalOffset: Offset(.4, .3),
        zoomAmt: .1,
        dynamicHzOffset: 150,
      ),
    ];
  }
}
