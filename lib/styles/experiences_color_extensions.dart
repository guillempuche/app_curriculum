import '../common_libs.dart';

extension ExperienceColorExtensions on ExperienceType {
  Color get bgColor {
    switch (this) {
      case ExperienceType.softwareDeveloper:
        return const Color(0xFF16184D);
      case ExperienceType.chatbot:
        return const Color(0xFF642828);
      // case ExperienceType.crypto:
      //   return const Color(0xFF444B9B);
      case ExperienceType.marketing:
        return const Color(0xFF1E736D);
      case ExperienceType.others:
        return const Color(0xFF164F2A);
      // case ExperienceType.machuPicchu:
      //   return const Color(0xFF0E4064);
      case ExperienceType.crypto:
        return const Color(0xFFC96454);
      // case ExperienceType.christRedeemer:
      //   return const Color(0xFF1C4D46);
    }
  }

  Color get fgColor {
    switch (this) {
      case ExperienceType.softwareDeveloper:
        return const Color(0xFF444B9B);
      case ExperienceType.chatbot:
        return const Color(0xFF688750);
      // case ExperienceType.petra:
      //   return const Color(0xFF1B1A65);
      case ExperienceType.marketing:
        return const Color(0xFF4AA39D);
      case ExperienceType.others:
        return const Color(0xFFE2CFBB);
      // case ExperienceType.machuPicchu:
      //   return const Color(0xFFC1D9D1);
      case ExperienceType.crypto:
        return const Color(0xFF642828);
      // case ExperienceType.christRedeemer:
      //   return const Color(0xFFED7967);
    }
  }
}

extension ColorFilterOnColor on Color {
  ColorFilter get colorFilter => ColorFilter.mode(this, BlendMode.srcIn);
}
