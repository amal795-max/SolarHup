class EnvironmentConfig {
  static const String apiEndpoint = String.fromEnvironment(
    "API_ENDPOINT",
    defaultValue: "https://api",
  );

  static const String androidAppSecret = String.fromEnvironment(
    "APP_SECRET",
    defaultValue: "ramez",
  );

  static const String iosAppSecret = String.fromEnvironment(
    "APP_SECRET",
    defaultValue: "ramez",
  );

  static const String appEnv = String.fromEnvironment(
    "APP_ENV",
    defaultValue: "development",
  );


}
