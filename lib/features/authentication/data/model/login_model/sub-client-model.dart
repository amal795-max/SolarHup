
class ClientModel {
  final String name;
  final String email;
  final int id;
  const ClientModel({required this.name, required this.email,required this.id});


  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(
        name: json['name'],
        email: json['email'],
        id: json['id']);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'id': id, 'name': name, 'email': email,};
  }
}