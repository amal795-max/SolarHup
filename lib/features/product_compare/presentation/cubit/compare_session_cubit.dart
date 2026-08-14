import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:untitled1/core/api/errors/failures.dart';
import 'package:untitled1/features/product_compare/data/models/compare_product_model.dart';
import 'package:untitled1/features/stores/data/repositories/product_detail_repository.dart';
import 'package:untitled1/features/stores/data/repositories/stores_repository.dart';

part 'compare_session_state.dart';

class CompareSessionCubit extends Cubit<CompareSessionState> {
  final ProductDetailRepository productDetailRepository;
  final StoresRepository storesRepository;

  CompareSessionCubit({
    required this.productDetailRepository,
    required this.storesRepository,
  }) : super(const CompareSessionState());

  Future<CompareAddResult> addProduct({
    required int businessId,
    required String productId,
    String? storeName,
    CompareSlot? forceSlot,
    bool replaceExisting = false,
  }) async {
    if (state.containsProduct(businessId: businessId, productId: productId)) {
      return CompareAddResult.alreadyInCompare;
    }

    emit(state.copyWith(isLoading: true, clearError: true));

    final detailResult = await productDetailRepository.getProductDetail(
      businessId: businessId,
      productId: productId,
    );

    return await detailResult.fold(
      (failure) async {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: _mapFailureToMessage(failure),
          ),
        );
        return CompareAddResult.loadFailed;
      },
      (detail) async {
        final resolvedStoreName = storeName?.isNotEmpty == true
            ? storeName!
            : await _resolveStoreName(businessId);
        final product = CompareProduct(
          businessId: businessId,
          productId: productId,
          storeName: resolvedStoreName,
          detail: detail,
        );

        final lockedCategory = state.lockedCategory;
        if (lockedCategory != null &&
            lockedCategory.toLowerCase() != detail.category.toLowerCase()) {
          emit(state.copyWith(isLoading: false));
          return CompareAddResult.categoryMismatch;
        }

        if (forceSlot == CompareSlot.first) {
          emit(
            state.copyWith(
              firstProduct: product,
              isLoading: false,
              clearError: true,
            ),
          );
          return CompareAddResult.addedToFirstSlot;
        }

        if (forceSlot == CompareSlot.second) {
          emit(
            state.copyWith(
              secondProduct: product,
              isLoading: false,
              clearError: true,
            ),
          );
          return CompareAddResult.addedToSecondSlot;
        }

        if (state.firstProduct == null) {
          emit(
            state.copyWith(
              firstProduct: product,
              isLoading: false,
              clearError: true,
            ),
          );
          return CompareAddResult.addedToFirstSlot;
        }

        if (state.secondProduct == null) {
          emit(
            state.copyWith(
              secondProduct: product,
              isLoading: false,
              clearError: true,
            ),
          );
          return CompareAddResult.addedToSecondSlot;
        }

        if (replaceExisting) {
          emit(
            state.copyWith(
              secondProduct: product,
              isLoading: false,
              clearError: true,
            ),
          );
          return CompareAddResult.addedToSecondSlot;
        }

        emit(state.copyWith(isLoading: false));
        return CompareAddResult.bothSlotsFull;
      },
    );
  }

  void setProductForSlot(CompareSlot slot, CompareProduct product) {
    final lockedCategory = state.lockedCategory;
    if (lockedCategory != null &&
        lockedCategory.toLowerCase() != product.category.toLowerCase()) {
      return;
    }

    switch (slot) {
      case CompareSlot.first:
        emit(state.copyWith(firstProduct: product, clearError: true));
      case CompareSlot.second:
        emit(state.copyWith(secondProduct: product, clearError: true));
    }
  }

  void removeFromSlot(CompareSlot slot) {
    switch (slot) {
      case CompareSlot.first:
        emit(state.copyWith(clearFirst: true, clearError: true));
      case CompareSlot.second:
        emit(state.copyWith(clearSecond: true, clearError: true));
    }
  }

  void swapProducts() {
    emit(
      CompareSessionState(
        firstProduct: state.secondProduct,
        secondProduct: state.firstProduct,
      ),
    );
  }

  void clear() {
    emit(const CompareSessionState());
  }

  Future<void> refreshSelectedProducts() async {
    if (state.firstProduct == null && state.secondProduct == null) {
      return;
    }

    emit(state.copyWith(isLoading: true, clearError: true));

    final refreshedFirst = state.firstProduct == null
        ? null
        : await _reloadProduct(state.firstProduct!);
    final refreshedSecond = state.secondProduct == null
        ? null
        : await _reloadProduct(state.secondProduct!);

    emit(
      state.copyWith(
        firstProduct: refreshedFirst,
        secondProduct: refreshedSecond,
        isLoading: false,
        clearError: true,
      ),
    );
  }

  Future<CompareProduct?> _reloadProduct(CompareProduct product) async {
    final result = await productDetailRepository.getProductDetail(
      businessId: product.businessId,
      productId: product.productId,
    );

    return result.fold(
      (_) => product,
      (detail) => CompareProduct(
        businessId: product.businessId,
        productId: product.productId,
        storeName: product.storeName,
        detail: detail,
      ),
    );
  }

  Future<String> _resolveStoreName(int businessId) async {
    final result = await storesRepository.getStore(businessId);
    return result.fold((_) => 'Store', (store) => store.name);
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case const (OfflineFailure):
        return 'No internet connection';
      case const (ServerFailure):
        return (failure as ServerFailure).message;
      default:
        return 'Unexpected error occurred';
    }
  }
}
