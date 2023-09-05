import 'package:supabase_flutter/supabase_flutter.dart';

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
    List<dynamic> allProjects = await Supabase.instance.client.from('projects').select('*').order(
          'id',
          ascending: true,
        );

    all = allProjects.map((data) {
      return _projectFromJson(data);
    }).toList();
  }
}

ProjectData _projectFromJson(Map<String, dynamic> json) => ProjectData(
      id: json['id'].toString(),
      title: json['title'],
      imageUrl: json['image'],
      text: json['text'],
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
    );
