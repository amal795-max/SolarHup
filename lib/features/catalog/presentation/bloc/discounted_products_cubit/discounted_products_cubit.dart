import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:untitled1/core/api/errors/exceptions.dart';
import 'package:untitled1/features/catalog/data/models/discounted_product_model.dart';
import 'package:untitled1/features/catalog/data/repositories/catalog_repository.dart';
import 'package:untitled1/features/orders/services/promotion_eligibility_service.dart';

part 'discounted_products_state.dart';

class DiscountedProductsCubit extends Cubit<DiscountedProductsState> {
  final CatalogRepository repository;
  final PromotionEligibilityService promotionEligibility;

  DiscountedProductsCubit(this.repository, this.promotionEligibility)
      : super(DiscountedProductsInitial());

  Future<void> loadDiscountedProducts({bool showLoading = false}) async {
    if (showLoading || state is! DiscountedProductsLoaded) {
      emit(DiscountedProductsLoading());
    }
    await promotionEligibility.ensureSynced();
    final result = await repository.getDiscountedProducts(businessType: 'store');
    result.fold(
      (failure) => emit(
        DiscountedProductsError(message: mapFailureToMessage(failure)),
      ),
      (products) => emit(DiscountedProductsLoaded(products: products)),
    );
  }
}
