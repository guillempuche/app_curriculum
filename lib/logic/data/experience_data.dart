import 'package:equatable/equatable.dart';

import '../../../common_libs.dart';

enum ExperienceType {
  softwareDeveloper,
  crypto,
  marketing,
  chatbot,
  others,
}

class ExperienceData extends Equatable {
  const ExperienceData({
    required this.id,
    required this.type,
    required this.title,
    required this.languages,
    required this.image,
    required this.text,
    this.endDate,
    this.startDate,
    this.location,
  });

  final String id;
  final ExperienceType type;
  final String title;
  final List<Locale> languages;
  final String image;
  final String text;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? location;

  @override
  List<Object?> get props => [
        id,
        type,
        title,
        languages,
        image,
        text,
        startDate,
        endDate,
        location,
      ];
}
