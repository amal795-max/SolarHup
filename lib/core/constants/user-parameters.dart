

class AuthenticationParams {
  final String phoneNumber;

  AuthenticationParams(this.phoneNumber);

  Map<String, dynamic> toJson() => {'phone_number': phoneNumber};
}

class RegisterParams {
  final String phoneNumber;
  final String password;
  final String role;

  RegisterParams(this.phoneNumber, this.password, this.role);

  Map<String, dynamic> toJson() => {
    'phone_number': phoneNumber,
    'password': password,
    'role': role,
  };
}

class LoginParams {
  final String phoneNumber;
  final String password;

  LoginParams(this.phoneNumber, this.password);

  Map<String, dynamic> toJson() => {
    'phone_number': phoneNumber,
    'password': password,
  };
}

class OtpParams {
  final String phoneNumber;
  final bool isReset;

  OtpParams(this.phoneNumber,{required this.isReset});

  Map<String, dynamic> toJson() => {
    'phone_number': phoneNumber,
    'purpose': isReset ? 'reset' : 'verify',
  };
}

class ConfirmOtpParams {
  final String phoneNumber;
  final String resetCode;
  final bool isReset;

  ConfirmOtpParams(this.phoneNumber, this.resetCode, this.isReset);

  Map<String, dynamic> toJson() => {
    'phone_number': phoneNumber,
    'otp_code': resetCode,
    'purpose': isReset ? 'reset' : 'verify',
  };
}

class ResetPasswordParams {
  final String phoneNumber;
  final String resetToken;
  final String newPassword;

  ResetPasswordParams({
    required this.phoneNumber,
    required this.resetToken,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() => {
    'phone_number': phoneNumber,
    'reset_token': resetToken,
    'new_password': newPassword,
  };
}

class ChangePasswordParams {
  final String currentPassword;
  final String newPassword;

  ChangePasswordParams({
    required this.currentPassword,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() => {
    'current_password': currentPassword,
    'new_password': newPassword,
  };
}

class RecommendParams {
  final String message;
  final String? image;
  final String? budget;
  final int? conversationId;

  RecommendParams({
    required this.message,
    this.image,
    this.budget,
    this.conversationId,
  });

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      if (image != null) 'image': image,
      if (budget != null) 'budget': budget,
      if (conversationId != null) 'conversation_id': conversationId,
    };
  }
}

class AddUsedProductParams {
  final String name;
  final String description;
  final String category;
  final String condition;
  final double price;
  final String region;
  final List<String> images;

  AddUsedProductParams({
    required this.name,
    required this.description,
    required this.category,
    required this.condition,
    required this.price,
    required this.region,
    required this.images,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'category': category,
    'condition': condition,
    'price': price,
    'region': region,
    'images': images,
  };
}

class AddProductToCartParams {
  final int id;
  final int quantity;


  AddProductToCartParams({
    required this.id,
    required this.quantity,

  });

  Map<String, dynamic> toJson() => {
    'product_id': id,
    'quantity': quantity,

  };
}class ShippingInformationParams {
  final String fullName;
  final String city;
  final String street;
  final String building;
  final String floor;

  ShippingInformationParams({

   required this.fullName, required this.city, required this.street, required this.building, required this.floor});

  Map<String, dynamic> toJson() => {
      'full_name': fullName,
      'city': city,
      'street': street,
      'building': building,
      'floor': floor

  };
}
