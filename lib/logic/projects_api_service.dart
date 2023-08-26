import './common/http_client.dart';
import './data/project_data.dart';

class ProjectsAPIService {
  final String _baseProjectsUrl = 'https://collectionapi.metmuseum.org/public/collection/v1';

  Future<ServiceResult<ProjectData?>> getObjectByID(String id) async {
    HttpResponse? response = await HttpClient.send('$_baseProjectsUrl/objects/$id');
    return ServiceResult<ProjectData?>(response, _parseProjectData);
  }

  ProjectData? _parseProjectData(Map<String, dynamic> content) {
    // Source: https://metmuseum.github.io/
    return ProjectData(
      id: content['objectID'].toString(),
      title: content['title'] ?? '',
      description: content['description'] ?? '',
      imageUrl: content['primaryImage'] ?? '',
    );
  }
}
