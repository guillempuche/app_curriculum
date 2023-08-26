import '../../../common_libs.dart';

class ProjectData {
  ProjectData({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.description,
  });

  static ProjectData? fromId(String? id) => id == null ? null : _projects.firstWhereOrNull((o) => o.id == id);
  static List<ProjectData> get all => _projects;

  final String id;
  final String title;
  final String imageUrl;
  final String description;
}

List<ProjectData> _projects = [
  ProjectData(
    id: '1',
    title: 'Crypto Mobile Web Wallet',
    imageUrl: 'https://res.cloudinary.com/guillempuche/image/upload/v1691154177/app_curriculum/crypto_screens.png',
    description: 'This is a description for Project 1.',
  ),
  ProjectData(
    id: '2',
    title: 'App Personal Quotes',
    imageUrl: 'https://res.cloudinary.com/guillempuche/image/upload/v1691154647/app_curriculum/app_quotes_screens.png',
    description: 'This is a description for Project 2.',
  ),
  ProjectData(
    id: '3',
    title: 'Project 3',
    imageUrl: 'https://res.cloudinary.com/guillempuche/image/upload/v1691154647/app_curriculum/app_quotes_screens.png',
    description: 'This is a description for Project 3.',
  ),
];
