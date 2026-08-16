import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:untitled1/core/api/errors/exceptions.dart';
import 'package:untitled1/features/consultation/data/models/expert_consultation_model.dart';
import 'package:untitled1/features/consultation/data/repositories/expert_consultation_repository.dart';

part 'expert_consultation_state.dart';

class ExpertConsultationCubit extends Cubit<ExpertConsultationState> {
  final ExpertConsultationRepository repository;

  ExpertConsultationCubit(this.repository) : super(ExpertConsultationInitial());

  Future<void> getMyQuestions() async {
    emit(ExpertConsultationLoading());
    final result = await repository.getMyQuestions();
    result.fold(
      (failure) =>
          emit(ExpertConsultationError(message: mapFailureToMessage(failure))),
      (questions) => emit(ExpertConsultationSuccess(questions: questions)),
    );
  }

  Future<void> sendQuestion(String question) async {
    emit(ExpertConsultationSending());
    final result = await repository.sendQuestion(question);
    result.fold(
      (failure) =>
          emit(ExpertConsultationError(message: mapFailureToMessage(failure))),
      (data) => emit(ExpertConsultationSent(question: data)),
    );
  }
}
