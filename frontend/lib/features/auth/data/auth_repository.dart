import '../../../core/network/api_client.dart';
import '../../../core/storage/local_storage_service.dart';
import '../../../shared/models/user_profile.dart';

class AuthRepository {
  AuthRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<UserProfile> login(String name) async {
    final data =
        await _apiClient.post('/auth/login', {'name': name})
            as Map<String, dynamic>;
    final user = UserProfile.fromJson(data);
    await LocalStorageService.saveUser(user.toJson());
    return user;
  }

  UserProfile? getCachedUser() {
    final cached = LocalStorageService.cachedUser;
    if (cached == null) {
      return null;
    }
    return UserProfile.fromJson(cached);
  }
}
