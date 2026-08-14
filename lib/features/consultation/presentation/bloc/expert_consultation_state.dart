part of 'expert_consultation_cubit.dart';

abstract class ExpertConsultationState extends Equatable {
  const ExpertConsultationState();

  @override
  List<Object?> get props => [];
}

class ExpertConsultationInitial extends ExpertConsultationState {}

class ExpertConsultationLoading extends ExpertConsultationState {}

class ExpertConsultationSuccess extends ExpertConsultationState {
  final List<ExpertConsultationModel> questions;

  const ExpertConsultationSuccess({required this.questions});

  @override
  List<Object?> get props => [questions];
}

class ExpertConsultationSending extends ExpertConsultationState {}

class ExpertConsultationSent extends ExpertConsultationState {
  final ExpertConsultationModel question;

  const ExpertConsultationSent({required this.question});

  @override
  List<Object?> get props => [question];
}

class ExpertConsultationError extends ExpertConsultationState {
  final String message;

  const ExpertConsultationError({required this.message});

  @override
  List<Object?> get props => [message];
}
