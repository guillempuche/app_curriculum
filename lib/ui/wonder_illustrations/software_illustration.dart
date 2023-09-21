import '../../../common_libs.dart';
import '../common/fade_color_transition.dart';
import './common/illustration_piece.dart';
import './common/paint_textures.dart';
import './common/experience_illustration_builder.dart';
import './common/wonder_illustration_config.dart';

class ChichenItzaIllustration extends StatelessWidget {
  ChichenItzaIllustration({Key? key, required this.config}) : super(key: key);
  final WonderIllustrationConfig config;
  final assetPath = ExperienceType.softwareDeveloper.assetPath;
  final fgColor = ExperienceType.softwareDeveloper.fgColor;

  @override
  Widget build(BuildContext context) {
    return ExperienceIllustrationBuilder(
      config: config,
      bgBuilder: _buildBg,
      mgBuilder: _buildMg,
      fgBuilder: _buildFg,
      experienceType: ExperienceType.softwareDeveloper,
    );
  }

  List<Widget> _buildBg(BuildContext context, Animation<double> anim) {
    return [
      FadeColorTransition(animation: anim, color: fgColor),
      Positioned.fill(
        child: IllustrationTexture(
          ImagePaths.roller2,
          color: Color(0xffDC762A),
          opacity: anim.drive(Tween(begin: 0, end: .5)),
          flipY: true,
          scale: config.shortMode ? 4 : 1.15,
        ),
      ),
      IllustrationPiece(
        fileName: 'sun.png',
        initialOffset: Offset(0, 50),
        enableHero: true,
        heightFactor: .4,
        minHeight: 200,
        fractionalOffset: Offset(.55, config.shortMode ? .2 : -.35),
      ),
    ];
  }

  List<Widget> _buildMg(BuildContext context, Animation<double> anim) {
    // We want to size to the shortest side
    return [
      Transform.translate(
        offset: Offset(0, config.shortMode ? 70 : -30),
        child: IllustrationPiece(
          fileName: 'quirky-programming-on-a-laptop-1.png',
          heightFactor: .7,
          minHeight: 180,
          zoomAmt: -.1,
          enableHero: true,
        ),
      ),
    ];
  }

  List<Widget> _buildFg(BuildContext context, Animation<double> anim) {
    return [
      IllustrationPiece(
        fileName: 'quirky-blue-smartphone.png',
        alignment: Alignment.bottomCenter,
        initialOffset: Offset(20, 40),
        initialScale: .95,
        heightFactor: .3,
        fractionalOffset: Offset(.5, -.1),
        zoomAmt: .1,
        dynamicHzOffset: 250,
      ),
      IllustrationPiece(
        fileName: 'quirky-cloud-storage-1.png',
        alignment: Alignment.bottomCenter,
        initialScale: .9,
        initialOffset: Offset(-40, 60),
        heightFactor: .65,
        fractionalOffset: Offset(-.4, .2),
        zoomAmt: .25,
        dynamicHzOffset: -250,
      ),
      IllustrationPiece(
        fileName: 'quirky-drawing-on-a-tablet-1.png',
        alignment: Alignment.topLeft,
        initialScale: .9,
        initialOffset: Offset(-40, 60),
        heightFactor: .65,
        fractionalOffset: Offset(-.4, -.4),
        zoomAmt: .05,
        dynamicHzOffset: 100,
      ),
      IllustrationPiece(
        fileName: 'quirky-laptop-with-graphs.png',
        alignment: Alignment.topRight,
        initialOffset: Offset(20, 40),
        initialScale: .95,
        heightFactor: .65,
        fractionalOffset: Offset(.35, -.4),
        zoomAmt: .05,
        dynamicHzOffset: -100,
      ),
    ];
  }
}
