import '../../../core/network/api_client.dart';
import '../../../shared/models/level.dart';
import '../../../shared/models/question.dart';
import '../../../shared/models/topic.dart';

class CatalogRepository {
  CatalogRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<List<Level>> getLevels() async {
    final data = await _apiClient.get('/levels') as List<dynamic>;
    return data
        .map((item) => Level.fromJson(Map<String, dynamic>.from(item as Map)))
        .toList();
  }

  Future<List<Topic>> getTopics(int levelId) async {
    final data = await _apiClient.get('/topics/$levelId') as List<dynamic>;
    return data
        .map((item) => Topic.fromJson(Map<String, dynamic>.from(item as Map)))
        .toList();
  }

  Future<List<Question>> getQuestions(int topicId) async {
    final data = await _apiClient.get('/questions/$topicId') as List<dynamic>;
    return data
        .map(
          (item) => Question.fromJson(Map<String, dynamic>.from(item as Map)),
        )
        .toList();
  }
}
