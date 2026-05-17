import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable{}

class OfflineFailure extends Failure{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ServerFailure extends Failure {
  final String message;

  ServerFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class EmptyCacheFailure extends Failure{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}