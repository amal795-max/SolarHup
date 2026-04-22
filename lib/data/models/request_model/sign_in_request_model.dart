class LogInRequestModel {
  final String email;
  final String password;
  final DeviceInfo device;
  final String roleType;

  LogInRequestModel({
    required this.email,
    required this.password,
    required  this.device,
    required this.roleType,
  });

  Map<String, dynamic> toJson() => {
    "email": email,
    "password": password,
    "device": device,
    "roleType": roleType,
  };
}

class EmailLoginRequestModel {
  final String email;
  final String password;
  final String roleType;
  final DeviceInfo device;

  EmailLoginRequestModel({
    required this.email,
    required this.password,
    required this.roleType,
    required this.device,
  });

  Map<String, dynamic> toJson() => {
    "email": email,
    "password": password,
    "roleType": roleType,
    "device": device.toJson(),
  };
}

class DeviceInfo {
  final String token;
  final String udid;
  final String platform;
  final String deviceModel;

  DeviceInfo({
    required this.token,
    required this.udid,
    required this.platform,
    required this.deviceModel,
  });

  Map<String, dynamic> toJson() => {
    "token": token,
    "udid": udid,
    "platform": platform,
    "deviceModel": deviceModel,
  };
}
