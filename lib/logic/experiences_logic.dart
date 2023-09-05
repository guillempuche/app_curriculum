import 'package:supabase_flutter/supabase_flutter.dart';

import '../common_libs.dart';
import 'data/experience_data.dart';

class ExperiencesLogic {
  List<ExperienceData> all = [];

  ExperienceData getData(ExperienceType value) {
    ExperienceData? result = all.firstWhereOrNull((e) => e.type == value);
    if (result == null) throw ('Could not find data for experience type $value');
    return result;
  }

  Future<void> init() async {
    List<dynamic> allExperiences = await Supabase.instance.client
        .from('experiences')
        .select('*')
        .order(
          'end_date',
          ascending: false,
        )
        .order(
          'start_date',
          ascending: false,
        );
    all = allExperiences.map((data) {
      return _experienceFromJson(data);
    }).toList();
  }
}

ExperienceData _experienceFromJson(Map<String, dynamic> json) => ExperienceData(
      id: json['experience_id'],
      type: _mapIdToExperienceType(json['experience_id']),
      title: json['title'],
      languages: _getLocales(json['languages']),
      image: json['image'],
      text: json['text'],
      startDate: json['start_date'] != null ? DateTime.parse(json['start_date']) : null,
      endDate: json['end_date'] != null ? DateTime.parse(json['end_date']) : null,
      location: json['location'],
    );

ExperienceType _mapIdToExperienceType(String id) {
  switch (id) {
    case 'software_developer':
      return ExperienceType.softwareDeveloper;
    case 'blockchain':
      return ExperienceType.crypto;
    case 'marketing_specialist':
      return ExperienceType.marketing;
    case 'chatbot':
      return ExperienceType.chatbot;
    case 'others':
      return ExperienceType.others;
    default:
      throw Exception('Unknown experience type');
  }
}

List<Locale> _getLocales(List<dynamic> languages) => languages.map((locale) {
      var parts = locale.split('-');
      return Locale(parts[0], parts[1]);
    }).toList();
