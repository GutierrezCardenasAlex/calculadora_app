import '../../../core/network/api_client.dart';
import '../../../shared/models/progress_entry.dart';

class ProgressRepository {
  ProgressRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<void> saveProgress({
    required int userId,
    required int topicId,
    required int score,
  }) async {
    await _apiClient.post('/progress', {
      'user_id': userId,
      'topic_id': topicId,
      'score': score,
    });
  }

  Future<List<ProgressEntry>> getProgress(int userId) async {
    final data = await _apiClient.get('/progress/$userId') as List<dynamic>;
    return data
        .map(
          (item) =>
              ProgressEntry.fromJson(Map<String, dynamic>.from(item as Map)),
        )
        .toList();
  }
}
