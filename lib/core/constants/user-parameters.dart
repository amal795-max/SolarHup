class RegisterParams {
  final String name;
  final String email;
  final String password;
  final String password_confirmation;
  RegisterParams(this.name, this.email, this.password, this.password_confirmation);
}

class LoginParams {
  final String email;
  final String password;
  LoginParams(this.email, this.password,);
}
class VerifyCodeParams {
  final String email;
  final String code;
  VerifyCodeParams(this.email, this.code,);

  Map<String,dynamic> toJson() {
    return <String, dynamic>{
      email:email,
      code:code
    };
  }


}
class UpdatePasswordParams {
  final String email;
  final String password;
  UpdatePasswordParams(this.email, this.password,);
}

class AddReservationParams {
  final bool payment;
  final int restaurant_id;
  final String reservation_name;
  final String contact_number;
  final String date;
  final String time;
  final int number_of_people;

  AddReservationParams({required this.payment,required this.reservation_name, required this.contact_number, required this.restaurant_id, required this.date, required this.time, required this.number_of_people});
}
