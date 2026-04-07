import 'package:hive_flutter/hive_flutter.dart';

class LocalStorageService {
  LocalStorageService._();

  static const _appBoxName = 'app_box';
  static late Box _appBox;

  static Future<void> initialize() async {
    _appBox = await Hive.openBox(_appBoxName);
  }

  static Map<String, dynamic>? get cachedUser {
    final value = _appBox.get('user');
    return value is Map ? Map<String, dynamic>.from(value) : null;
  }

  static Future<void> saveUser(Map<String, dynamic> user) async {
    await _appBox.put('user', user);
  }

  static Future<void> clearUser() async {
    await _appBox.delete('user');
  }

  static Map<String, dynamic>? get cachedConfig {
    final value = _appBox.get('config');
    return value is Map ? Map<String, dynamic>.from(value) : null;
  }

  static Future<void> saveConfig(Map<String, dynamic> config) async {
    await _appBox.put('config', config);
  }
}
