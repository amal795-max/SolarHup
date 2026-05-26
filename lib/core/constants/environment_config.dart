class EnvironmentConfig {
  static const String apiEndpoint = String.fromEnvironment(
    'API_ENDPOINT',
    defaultValue: 'https://',
  );

  static const String androidAppSecret = String.fromEnvironment(
    'APP_SECRET',
    defaultValue: 'ramez',
  );



}
