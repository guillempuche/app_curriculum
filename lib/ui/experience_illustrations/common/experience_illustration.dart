import '../../../common_libs.dart';
import '../software_illustration.dart';
import '../crypto_illustration.dart';
import '../marketing_illustration.dart';
import '../common/wonder_illustration_config.dart';
import '../chatbot_illustration.dart';
import '../others_illustration.dart';

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
