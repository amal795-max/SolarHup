class EnvironmentConfig {
  static const String apiEndpoint = String.fromEnvironment(
    'API_ENDPOINT',
    defaultValue: 'https://solar-hub.tech/api/v1/',
  );

  static const String androidAppSecret = String.fromEnvironment(
    'APP_SECRET',
    defaultValue: 'amal',
  );



}
