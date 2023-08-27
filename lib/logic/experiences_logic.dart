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
    // if (dotenv.env['API_LOCALHOST'] == 'false') {
    // final response = await http.get(Uri.parse(dotenv.env['API_EXPERIENCES']!));
    // final response = await http.get(Uri.parse(dotenv.env['API_EXPERIENCES']!));
    // List<dynamic> allExperiences = await Supabase.instance.client.from('experiences').select('*');
    List<dynamic> allExperiences = await Supabase.instance.client.from('experiences').select('*');
    print(allExperiences.runtimeType);
    // List<dynamic> jsonResponse = json.decode(data);
    // final jsonResponse = json.decode(allExperiences);
    // List<Map<String, dynamic>> decodedList = List<Map<String, dynamic>>.from(jsonDecode(allExperiences));
    // final convertion = jsonDecode(allExperiences);
    // final first = allExperiences.first;
    // final title = first['start_date'];
    all = allExperiences.map((data) {
      // print(data);
      return _experienceFromJson(data);
    }).toList();
    // print(allExperiences[0]['title']);

    // if (response.statusCode == 200) {
    //   List<dynamic> jsonResponse = json.decode(response.body);
    //   all = jsonResponse.map((data) => _experienceFromJson(data)).toList();
    // } else {
    //   throw Exception('Failed to load experiences');
    // }
    // } else {
    //   final jsonData = await _loadMockJson();
    //   all = jsonData.map((data) => _experienceFromJson(data)).toList();
    // }
  }
}

ExperienceData _experienceFromJson(Map<String, dynamic> json) {
  final lang = json['languages'].runtimeType;
  return ExperienceData(
    id: json['experience_id'],
    type: _mapIdToExperienceType(json['experience_id']),
    title: json['title'],
    languages: _getLocales(json['languages']),
    // languages: [],
    image: json['image'],
    text: json['text'],
    // startDate: json['start_date'] != null ? DateTime.fromMillisecondsSinceEpoch(json['start_date']) : null,
    // endDate: json['end_date'] != null ? DateTime.fromMillisecondsSinceEpoch(json['end_date']) : null,
    startDate: json['start_date'] != null ? DateTime.parse(json['start_date']) : null,
    endDate: json['end_date'] != null ? DateTime.parse(json['end_date']) : null,
    location: json['location'],
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

List<Locale> _getLocales(List<dynamic> languages) => languages.map((locale) {
      var parts = locale.split('-');
      return Locale(parts[0], parts[1]);
    }).toList();
