import 'dart:collection';

import '../common_libs.dart';
import './common/http_client.dart';
import './data/project_data.dart';
import './projects_api_service.dart';

class ProjectsAPILogic {
  final HashMap<String, ProjectData?> _projectCache = HashMap();

  ProjectsAPIService get service => GetIt.I.get<ProjectsAPIService>();

  /// Returns project data by ID.
  ///
  /// Returns null if project cannot be found.
  Future<ProjectData?> getProjectByID(String id) async {
    if (_projectCache.containsKey(id)) return _projectCache[id];

    ServiceResult<ProjectData?> result = (await service.getObjectByID(id));

    if (!result.success) throw $strings.projectDetailsErrorNotFound(id);

    ProjectData? project = result.content;

    return _projectCache[id] = project;
  }
}
