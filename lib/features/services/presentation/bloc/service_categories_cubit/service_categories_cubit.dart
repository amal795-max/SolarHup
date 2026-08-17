import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:untitled1/core/api/errors/failures.dart';
import 'package:untitled1/features/services/data/repositories/workshops_repository.dart';
import 'package:untitled1/features/stores/data/models/store_category_model.dart';

part 'service_categories_state.dart';

class ServiceCategoriesCubit extends Cubit<ServiceCategoriesState> {
  final WorkshopsRepository repository;

  ServiceCategoriesCubit(this.repository) : super(ServiceCategoriesInitial());

  Future<void> loadCategories({bool showLoading = false}) async {
    if (showLoading || state is! ServiceCategoriesLoaded) {
      emit(ServiceCategoriesLoading());
    }
    final result = await repository.getWorkshopCategories();
    result.fold(
      (failure) => emit(ServiceCategoriesError(message: _mapFailure(failure))),
      (categories) => emit(ServiceCategoriesLoaded(categories: categories)),
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
