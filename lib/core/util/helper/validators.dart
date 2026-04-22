import "package:get/get.dart";

String? phoneValid(String? phone) {
  if (phone == null) {
    return "This field is required".tr;
  } else if (phone.isEmpty) {
    return "Please enter your phone number".tr;
  } else if (phone.length < 10 || phone.length > 10) {
    return "Invalid phone number".tr;
  }
  return null;
}

String? requiredValidator(String? value) {
  if (value == null || value.isEmpty) {
    return "This field is required".tr;
  }
  return null;
}

String? notRequiredValidator(String? value) {
  if (value == null || value.isEmpty) {
    return null;
  }
  return null;
}

String? emailValidator(String? email) {
  if (email == null || email.isEmpty) {
    return "Email is required".tr;
  }
  final RegExp emailRegex = RegExp(r"^[\w-.]+@([\w-]+\.)+[\w-]{2,}$");

  if (!emailRegex.hasMatch(email)) {
    return "Invalid email format".tr;
  }
  return null;
}

String? passwordValidator(String? val) {
  return val!.isEmpty || val.length < 6
      ? "Password is required and minimum 6 characters".tr
      : null;
}

String? nameValidator(String? name) {
  if (name == null || name.isEmpty) {
    return "Name is required".tr;
  }
  return null;
}

String? phoneValidate(String? phone) {
  if (phone == null || phone.isEmpty || phone.isEmpty) {
    return "Phone number is required".tr;
  }
  return null;
}
