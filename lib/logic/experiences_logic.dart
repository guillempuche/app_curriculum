import 'dart:convert';

import 'package:http/http.dart' as http;

import '../common_libs.dart';

class ExperiencesLogic {
  List<ExperienceData> all = [];

  ExperienceData getData(ExperienceType value) {
    ExperienceData? result = all.firstWhereOrNull((e) => e.type == value);
    if (result == null) throw ('Could not find data for experience type $value');
    return result;
  }

  Future<void> init() async {
    final response = await http.get(Uri.parse(
        'https://worker-app-curriculum-database.guillempuche.workers.dev/?table=experiences&order=end_date.desc.nullslast,start_date.desc.nullslast'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response, parse the JSON.
      List<dynamic> listExperiences = json.decode(response.body);
      all = listExperiences.map((experience) {
        return _experienceFromJson(experience);
      }).toList();
    } else {
      // If the server did not return a 200 OK response, throw an exception.
      throw Exception(response.reasonPhrase);
    }
  }
}

ExperienceData _experienceFromJson(Map<String, dynamic> data) => ExperienceData(
      id: data['experience_id'],
      type: _mapIdToExperienceType(data['experience_id']),
      title: data['title'],
      languages: _getLocales(data['languages']),
      text: data['text'],
      startDate: data['start_date'] != null ? DateTime.parse(data['start_date']) : null,
      endDate: data['end_date'] != null ? DateTime.parse(data['end_date']) : null,
      location: data['location'],
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
