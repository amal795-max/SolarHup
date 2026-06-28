class EnvironmentConfig {
  static const String apiEndpoint = String.fromEnvironment(
    'API_ENDPOINT',
    defaultValue: 'http://209.42.26.67:9000/api/v1/',
  );

  static const String androidAppSecret = String.fromEnvironment(
    'APP_SECRET',
    defaultValue: 'amal',
  );



}
