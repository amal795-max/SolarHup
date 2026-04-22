class EnvironmentConfig {
  static const String apiEndpoint = String.fromEnvironment(
    "API_ENDPOINT",
    defaultValue: "https://api-dev.spotless-app.net/api/v1/",
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

  static const String googleEnv = String.fromEnvironment(
    "GOOGLE_KEY",
    defaultValue: "AIzaSyCwu8YTOraof3p38DS57OJFA3dxHmjZS2c",
  );
}
