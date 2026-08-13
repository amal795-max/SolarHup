part of 'complaint_cubit.dart';

abstract class ComplaintState extends Equatable {
  const ComplaintState();

  @override
  List<Object?> get props => [];
}

class ComplaintInitial extends ComplaintState {}

class ComplaintLoading extends ComplaintState {}

class ComplaintActionLoading extends ComplaintState {}

class ComplaintDetailsLoading extends ComplaintState {}

class ComplaintSuccess extends ComplaintState {
  final List<ComplaintModel> complaints;

  const ComplaintSuccess({required this.complaints});

  @override
  List<Object?> get props => [complaints];
}

class ComplaintDetailsSuccess extends ComplaintState {
  final ComplaintModel complaint;

  const ComplaintDetailsSuccess({required this.complaint});

  @override
  List<Object?> get props => [complaint];
}

class ComplaintActionSuccess extends ComplaintState {
  final String message;
  final ComplaintModel complaint;

  const ComplaintActionSuccess({required this.message, required this.complaint});

  @override
  List<Object?> get props => [message, complaint];
}

class ComplaintError extends ComplaintState {
  final String message;

  const ComplaintError({required this.message});

  @override
  List<Object?> get props => [message];
}
