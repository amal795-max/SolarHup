

class DataModel {
  final String name;
  final String email;
  final int id;
  const DataModel({required this.name, required this.email,required this.id});


  factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(
        name: json['name'],
        email: json['email'],
        id: json['id']);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'id': id, 'name': name, 'email': email,};
  }
}