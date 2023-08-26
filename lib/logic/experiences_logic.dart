import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

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
    if (dotenv.env['API_LOCALHOST'] == 'false') {
      final response = await http.get(Uri.parse(dotenv.env['API_EXPERIENCES']!));

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        all = jsonResponse.map((data) => _experienceFromJson(data)).toList();
      } else {
        throw Exception('Failed to load experiences');
      }
    } else {
      final jsonData = await _loadMockJson();
      all = jsonData.map((data) => _experienceFromJson(data)).toList();
    }
  }
}

ExperienceData _experienceFromJson(Map<String, dynamic> json) {
  return ExperienceData(
    id: json['id'],
    type: _mapIdToExperienceType(json['id']),
    title: json['title'],
    languages: (json['languages'] as String).split(',').map((lang) => Locale(lang.toLowerCase())).toList(),
    image: json['image'],
    text: json['text'],
    startDate: json['start_date'] != null ? DateTime.fromMillisecondsSinceEpoch(json['start_date']) : null,
    endDate: json['end_date'] != null ? DateTime.fromMillisecondsSinceEpoch(json['end_date']) : null,
  );
}

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

/// Load mock data and parse JSON
Future<List<dynamic>> _loadMockJson() async {
  final data = await rootBundle.loadString('assets/mock_data/experiences.mock.json');
  return json.decode(data);
}
