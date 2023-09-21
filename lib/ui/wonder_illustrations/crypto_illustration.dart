import 'package:guillem_curriculum/ui/wonder_illustrations/common/experience_illustration_builder.dart';

import '../../common_libs.dart';
import '../common/fade_color_transition.dart';
import './common/illustration_piece.dart';
import './common/paint_textures.dart';
import './common/experience_illustration.dart';
import './common/wonder_illustration_config.dart';

class ChristRedeemerIllustration extends StatelessWidget {
  ChristRedeemerIllustration({Key? key, required this.config}) : super(key: key);
  final WonderIllustrationConfig config;
  final String assetPath = ExperienceType.crypto.assetPath;
  final fgColor = ExperienceType.crypto.fgColor;

  @override
  Widget build(BuildContext context) {
    return ExperienceIllustrationBuilder(
      config: config,
      bgBuilder: _buildBg,
      mgBuilder: _buildMg,
      fgBuilder: _buildFg,
      experienceType: ExperienceType.crypto,
    );
  }

  List<Widget> _buildBg(BuildContext context, Animation<double> anim) {
    return [
      FadeColorTransition(animation: anim, color: fgColor),
      Positioned.fill(
        child: IllustrationTexture(
          ImagePaths.roller1,
          color: Color(0xffFAE5C8),
          flipX: false,
          opacity: anim.drive(Tween(begin: 0, end: .8)),
          scale: config.shortMode ? 3.5 : 1.15,
        ),
      ),
      IllustrationPiece(
        fileName: 'sun.png',
        initialOffset: Offset(0, 50),
        enableHero: true,
        heightFactor: .25,
        minHeight: 120,
        fractionalOffset: Offset(.7, config.shortMode ? -.5 : -1.35),
      ),
    ];
  }

  List<Widget> _buildMg(BuildContext context, Animation<double> anim) {
    return [
      ClipRect(
        clipBehavior: config.shortMode ? Clip.hardEdge : Clip.none,
        child: IllustrationPiece(
          fileName: 'bonny-dollar-bitcoin-and-crypto-currency-symbols-1.png',
          enableHero: true,
          heightFactor: .5,
          alignment: Alignment.bottomCenter,
          fractionalOffset: Offset(0, config.shortMode ? .5 : -.5),
          zoomAmt: .7,
        ),
      )
      //
    ];
  }

  List<Widget> _buildFg(BuildContext context, Animation<double> anim) {
    return [
      IllustrationPiece(
        fileName: 'quirky-key-opening-a-lock-1.png',
        alignment: Alignment.bottomCenter,
        initialScale: .95,
        initialOffset: Offset(-140, 40),
        heightFactor: .5,
        fractionalOffset: Offset(-.35, .05),
        zoomAmt: .15,
        dynamicHzOffset: -100,
      ),
      IllustrationPiece(
        fileName: 'quirky-safe-deposit-with-banknotes-and-coins-1.png',
        alignment: Alignment.bottomCenter,
        initialOffset: Offset(120, 40),
        initialScale: .9,
        heightFactor: .55,
        fractionalOffset: Offset(.35, .2),
        zoomAmt: .1,
        dynamicHzOffset: 100,
      ),
    ];
  }
}
