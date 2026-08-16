import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:untitled1/core/api/errors/exceptions.dart';
import 'package:untitled1/features/blog/data/models/faq_model.dart';
import 'package:untitled1/features/blog/data/repositories/blog_repository.dart';

part 'faq_state.dart';

class FaqCubit extends Cubit<FaqState> {
  final BlogRepository repository;

  FaqCubit(this.repository) : super(FaqInitial());

  Future<void> getFaqs() async {
    emit(FaqLoading());
    final result = await repository.getFaqs();
    result.fold(
      (failure) => emit(FaqError(message: mapFailureToMessage(failure))),
      (faqs) => emit(FaqSuccess(faqs: faqs)),
    );
  }

  void updateSearch(String query) {
    if (state is FaqSuccess) {
      final currentState = state as FaqSuccess;
      emit(currentState.copyWith(searchQuery: query));
    }
  }
}
