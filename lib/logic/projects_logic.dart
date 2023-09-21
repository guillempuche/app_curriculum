import 'dart:convert';

import 'package:http/http.dart' as http;

import '../common_libs.dart';
import 'data/project_data.dart';

class ProjectsLogic {
  List<ProjectData> all = [];

  ProjectData getById(String projectId) {
    ProjectData? result = all.firstWhereOrNull((e) => e.id == projectId);
    if (result == null) throw ('Could not find data for experience type $projectId');
    return result;
  }

  Future<void> init() async {
    final url = Uri.parse(
        'https://worker-app-curriculum-database.guillempuche.workers.dev?table=projects&order=id.asc.nullslast');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response, parse the JSON.
      List<dynamic> listProjects = json.decode(response.body);
      all = listProjects.map((project) {
        return _projectFromJson(project);
      }).toList();
    } else {
      // If the server did not return a 200 OK response, throw an exception.
      throw Exception(response.reasonPhrase);
    }
  }
}

ProjectData _projectFromJson(Map<String, dynamic> json) => ProjectData(
      id: json['id'].toString(),
      title: json['title'],
      imageUrl: json['image'],
      text: json['text'],
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
    );
