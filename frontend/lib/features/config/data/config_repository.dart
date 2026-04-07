import '../../../core/network/api_client.dart';
import '../../../core/storage/local_storage_service.dart';
import '../../../shared/models/app_config.dart';

class ConfigRepository {
  ConfigRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<AppConfig> fetchRemoteConfig() async {
    final data = await _apiClient.get('/config') as Map<String, dynamic>;
    final config = AppConfig.fromJson(data);
    await LocalStorageService.saveConfig(config.toJson());
    return config;
  }

  AppConfig? getCachedConfig() {
    final cached = LocalStorageService.cachedConfig;
    if (cached == null) {
      return null;
    }
    return AppConfig.fromJson(cached);
  }
}
