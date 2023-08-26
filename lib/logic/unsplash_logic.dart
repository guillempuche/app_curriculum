import '../common_libs.dart';
import './data/unsplash_photo_data.dart';
import './unsplash_service.dart';

class UnsplashLogic {
  final Map<String, List<String>> _idsByCollection =
      UnsplashPhotoData.photosByCollectionId;

  UnsplashService get service => GetIt.I.get<UnsplashService>();

  List<String>? getCollectionPhotos(String collectionId) =>
      _idsByCollection[collectionId];
}
