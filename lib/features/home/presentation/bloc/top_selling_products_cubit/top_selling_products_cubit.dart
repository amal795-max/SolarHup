import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:untitled1/core/api/errors/exceptions.dart';
import 'package:untitled1/features/home/data/models/product_model.dart';
import 'package:untitled1/features/home/data/repositories/home_repository.dart';

part 'top_selling_products_state.dart';

class TopSellingProductsCubit extends Cubit<TopSellingProductsState> {
  static const int viewAllLimit = 50;

  final HomeRepository repository;

  TopSellingProductsCubit(this.repository) : super(TopSellingProductsInitial());

  Future<void> loadTopSellingProducts({bool showLoading = false}) async {
    if (showLoading || state is! TopSellingProductsLoaded) {
      emit(TopSellingProductsLoading());
    }
    final result = await repository.getTopSellingProductsForViewAll(
      limit: viewAllLimit,
    );
    result.fold(
      (failure) =>
          emit(TopSellingProductsError(message: mapFailureToMessage(failure))),
      (products) => emit(TopSellingProductsLoaded(products: products)),
    );
  }
}
