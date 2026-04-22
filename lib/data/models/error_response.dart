import "dart:convert";

ErrorResponse errorResponseFromJson(String str) =>
    ErrorResponse.fromJson(json.decode(str));

class ErrorResponse {
  ErrorResponse({this.errors});

  final Map<String, dynamic>? errors;

  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return ErrorResponse(errors: json);
  }

  String get value {
    String msg = "";
    for (int i = 0; i < errors!.length - 1; i++) {
      msg += "${errors!.values.elementAt(i).toString()}\n"
          .replaceAll("]", "")
          .replaceAll("[", "");
    }
    msg += errors!.values.last
        .toString()
        .replaceAll("]", "")
        .replaceAll("[", "");
    return msg;
  }
}

class Errors {
  Errors({this.errorKeys, this.errorJson, this.errorValues});

  final List<String>? errorKeys;
  final Map<String, dynamic>? errorJson;
  final List<String>? errorValues;

  factory Errors.fromJson(Map<String, dynamic> json) => Errors(
    errorKeys: json.keys.toList(),
    errorJson: json,
    errorValues: getErrorMessages(json.keys.toList(), json),
  );

  Map<String, dynamic> toJson() => {
    "errorKeys": errorKeys,
    "errorJson": errorJson,
    "errorValues": errorValues,
  };

  static List<String> getErrorMessages(
    List<String> errorKeys,
    Map<String, dynamic> errorJson,
  ) {
    List<String> list = <String>[];
    try {
      for (String error in errorKeys) {
        var value = errorJson[error][0];
        list.add(value);
      }
    } catch (e) {
      rethrow;
    }
    return list;
  }
}
