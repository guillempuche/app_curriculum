import './common_libs.dart';

/// Consolidates raster image paths used across the app
class ImagePaths {
  static String root = 'assets/images';
  static String common = 'assets/images/_common';
  static String cloud = '$common/cloud-white.png';

  static String particle = '$common/particle-21x23.png';
  static String ribbonEnd = '$common/ribbon-end.png';

  static String textures = '$common/texture';
  static String icons = '$common/icons';

  static String roller1 = '$textures/roller-1-white.gif';
  static String roller2 = '$textures/roller-2-white.gif';
}

/// Consolidates SCG image paths in their own class, hints to the UI to use an SvgPicture to render
class SvgPaths {
  static String compassFull = '${ImagePaths.common}/compass-full.svg';
  static String compassSimple = '${ImagePaths.common}/compass-simple.svg';
}

// /// For wonder specific assets, add an extension to [WonderType] for easy lookup
// extension WonderAssetExtensions on WonderType {
//   String get assetPath {
//     switch (this) {
//       case WonderType.pyramidsGiza:
//         return '${ImagePaths.root}/pyramids';
//       case WonderType.greatWall:
//         return '${ImagePaths.root}/great_wall_of_china';
//       case WonderType.petra:
//         return '${ImagePaths.root}/petra';
//       case WonderType.colosseum:
//         return '${ImagePaths.root}/colosseum';
//       case WonderType.chichenItza:
//         return '${ImagePaths.root}/chichen_itza';
//       case WonderType.machuPicchu:
//         return '${ImagePaths.root}/machu_picchu';
//       case WonderType.tajMahal:
//         return '${ImagePaths.root}/taj_mahal';
//       case WonderType.christRedeemer:
//         return '${ImagePaths.root}/christ_the_redeemer';
//     }
//   }

//   String get homeBtn => '$assetPath/wonder-button.png';
//   String get photo1 => '$assetPath/photo-1.jpg';
//   String get photo2 => '$assetPath/photo-2.jpg';
//   String get photo3 => '$assetPath/photo-3.jpg';
//   String get photo4 => '$assetPath/photo-4.jpg';
//   String get flattened => '$assetPath/flattened.jpg';
// }

/// For experience specific assets, add an extension to [ExperienceType] for easy lookup
extension ExperienceAssetExtensions on ExperienceType {
  String get assetPath {
    switch (this) {
      case ExperienceType.softwareDeveloper:
        return '${ImagePaths.root}/software';
      case ExperienceType.crypto:
        return '${ImagePaths.root}/crypto';
      case ExperienceType.marketing:
        return '${ImagePaths.root}/marketing';
      case ExperienceType.chatbot:
        return '${ImagePaths.root}/chatbot';
      case ExperienceType.others:
        return '${ImagePaths.root}/others';
    }
  }
}
