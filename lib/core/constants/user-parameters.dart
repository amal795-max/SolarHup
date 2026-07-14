class AuthenticationParams {
  final String phoneNumber;

  AuthenticationParams(this.phoneNumber);


  Map<String, dynamic> toJson() => {
    'phone_number': phoneNumber,
  };
}


class RegisterParams {
  final String phoneNumber;
  final String password;
  final String role;
  RegisterParams(this.phoneNumber,this.password, this.role);


  Map<String, dynamic> toJson() => {
    'phone_number': phoneNumber,
    'password': password,
    'role': role,
  };
}

class LoginParams {
  final String phoneNumber;
  final String password;
  LoginParams(this.phoneNumber, this.password,);

  Map<String, dynamic> toJson() => {
    'phone_number': phoneNumber,
    'password': password,
  };
}

