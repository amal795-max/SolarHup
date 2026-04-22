// import "dart:convert";
//
// UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));
//
// class UserModel {
//   UserModel({
//     this.id,
//     this.name,
//     this.email,
//     this.phone,
//   });
//
//   @override
//   String toString() {
//     return "UserModel{id: $id, name: $name, email: $email, phone: $phone,}";
//   }
//
//   int? id;
//   String? name;
//   String? email;
//   String? phone;
//
//   factory UserModel.fromJson(Map<String, dynamic> json) {
//     return UserModel(
//       id: json["id"],
//       name: json["name"],
//       email: json["email"],
//       phone: json["phone"],
//     );
//   }
// }
class UserModel {
  String? sId;
  String? name;
  String? phone;
  String? email;

  UserModel({
    this.sId,
    this.name,
    this.phone,
    this.email,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['phone'] = phone;
    data['email'] = email;
    return data;
  }
}

class Verified {
  bool? email;
  bool? phone;

  Verified({this.email, this.phone});

  Verified.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['phone'] = phone;
    return data;
  }
}

class Roles {
  String? roleType;
  bool? isActive;

  Roles({this.roleType, this.isActive});

  Roles.fromJson(Map<String, dynamic> json) {
    roleType = json['roleType'];
    isActive = json['isActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['roleType'] = roleType;
    data['isActive'] = isActive;
    return data;
  }
}
