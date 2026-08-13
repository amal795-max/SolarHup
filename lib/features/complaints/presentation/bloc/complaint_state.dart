part of 'complaint_cubit.dart';

abstract class ComplaintState extends Equatable {
  const ComplaintState();

  @override
  List<Object?> get props => [];
}

class ComplaintInitial extends ComplaintState {}

class ComplaintLoading extends ComplaintState {}

class ComplaintSuccess extends ComplaintState {
  final List<ComplaintModel> complaints;

  const ComplaintSuccess({required this.complaints,});

  @override
  List<Object?> get props => [complaints];
}

class ComplaintDetailsLoading extends ComplaintState {}
class ComplaintActionSuccess extends ComplaintState {
  final String message;

  const ComplaintActionSuccess({required this.message});


@override
List<Object?> get props => [message];
}

class ComplaintDetailsSuccess extends ComplaintState {
  final ComplaintModel complaint;
  final bool isSendingMessage;
  final String? messageError;

  const ComplaintDetailsSuccess({
    required this.complaint,
    this.isSendingMessage = false,
    this.messageError,
  });

  ComplaintDetailsSuccess copyWith({
    ComplaintModel? complaint,
    bool? isSendingMessage,
    String? messageError,
    bool clearMessageError = false,
  }) {
    return ComplaintDetailsSuccess(
      complaint: complaint ?? this.complaint,
      isSendingMessage: isSendingMessage ?? this.isSendingMessage,
      messageError:
      clearMessageError ? null : messageError ?? this.messageError,
    );
  }

  @override
  List<Object?> get props => [
    complaint,
    isSendingMessage,
    messageError,
  ];
}

class ComplaintError extends ComplaintState {
  final String message;

  const ComplaintError({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}