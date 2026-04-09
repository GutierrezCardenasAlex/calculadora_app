class AppEnvironment {
  const AppEnvironment({required this.apiBaseUrl});

  final String apiBaseUrl;

  factory AppEnvironment.fromDartDefine() {
    return const AppEnvironment(
      apiBaseUrl: String.fromEnvironment(
        'API_BASE_URL',
        defaultValue: 'http://62.171.186.246:3000',
      ),
    );
  }
}
