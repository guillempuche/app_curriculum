import '../../../common_libs.dart';
import '../../../logic/data/experience_data.dart';
import '../chichen_itza_illustration.dart';
import '../christ_redeemer_illustration.dart';
import '../colosseum_illustration.dart';
import '../common/wonder_illustration_config.dart';
import '../great_wall_illustration.dart';
import '../machu_picchu_illustration.dart';

/// Convenience class for showing an illustration when all you have is the type.
class ExperienceIllustration extends StatelessWidget {
  const ExperienceIllustration(this.type, {Key? key, required this.config}) : super(key: key);
  final WonderIllustrationConfig config;
  final ExperienceType type;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case ExperienceType.softwareDeveloper:
        return ChichenItzaIllustration(config: config);
      case ExperienceType.crypto:
        return ChristRedeemerIllustration(config: config);
      case ExperienceType.marketing:
        return ColosseumIllustration(config: config);
      case ExperienceType.chatbot:
        return GreatWallIllustration(config: config);
      case ExperienceType.others:
        return MachuPicchuIllustration(config: config);
    }
  }
}
