import 'package:equatable/equatable.dart';

class ConsultationAttachmentModel extends Equatable {
  final String id;
  final String path;
  final String name;

  const ConsultationAttachmentModel({
    required this.id,
    required this.path,
    required this.name,
  });

  @override
  List<Object?> get props => [id, path, name];
}
