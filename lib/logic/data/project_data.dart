import 'package:equatable/equatable.dart';

class ProjectData extends Equatable {
  const ProjectData({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.text,
    this.date,
  });

  final String id;
  final String title;
  final String imageUrl;
  final String text;
  final DateTime? date;

  @override
  List<Object?> get props => [
        id,
        title,
        imageUrl,
        text,
        date,
      ];
}
