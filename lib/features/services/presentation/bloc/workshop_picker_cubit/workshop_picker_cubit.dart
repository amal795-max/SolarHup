import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:untitled1/core/api/errors/failures.dart';
import 'package:untitled1/features/services/data/models/workshop_offering_model.dart';
import 'package:untitled1/features/services/data/repositories/workshops_repository.dart';

part 'workshop_picker_state.dart';

class WorkshopPickerCubit extends Cubit<WorkshopPickerState> {
  final WorkshopsRepository repository;

  WorkshopPickerCubit(this.repository) : super(WorkshopPickerInitial());

  Future<void> loadOfferings({
    required int categoryId,
    required String categoryName,
    bool showLoading = false,
  }) async {
    if (showLoading || state is! WorkshopPickerLoaded) {
      emit(WorkshopPickerLoading(categoryName: categoryName));
    }
    final result = await repository.getOfferingsForCategory(categoryId);
    result.fold(
      (failure) => emit(
        WorkshopPickerError(
          categoryName: categoryName,
          message: _mapFailure(failure),
        ),
      ),
      (offerings) => emit(
        WorkshopPickerLoaded(
          categoryId: categoryId,
          categoryName: categoryName,
          offerings: offerings,
        ),
      ),
    );
  }

  String _mapFailure(Failure failure) {
    return switch (failure) {
      ServerFailure(:final message) => message,
      OfflineFailure() => 'No internet connection',
      _ => 'Something went wrong',
    };
  }
}
