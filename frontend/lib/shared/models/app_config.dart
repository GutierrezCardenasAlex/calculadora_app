class AppConfig {
  const AppConfig({
    required this.maintenance,
    required this.forceUpdate,
    required this.appMessage,
  });

  final bool maintenance;
  final bool forceUpdate;
  final String appMessage;

  factory AppConfig.fromJson(Map<String, dynamic> json) {
    return AppConfig(
      maintenance: json['maintenance'] as bool? ?? false,
      forceUpdate: json['force_update'] as bool? ?? false,
      appMessage: json['app_message'] as String? ?? 'Bienvenido',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'maintenance': maintenance,
      'force_update': forceUpdate,
      'app_message': appMessage,
    };
  }
}
