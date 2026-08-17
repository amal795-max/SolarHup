import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/core/api/errors/failures.dart';
import 'package:untitled1/features/home/data/models/blog_model.dart';
import 'package:untitled1/features/home/data/models/product_model.dart';
import 'package:untitled1/features/home/data/models/tip_model.dart';
import 'package:untitled1/features/home/data/repositories/home_repository.dart';
import 'package:untitled1/features/used_system/data/model/used_product_model.dart';

import '../../../data/models/home_layout_model.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository repository;

  HomeBloc(this.repository) : super(HomeInitial()) {
    on<LoadHomeDataEvent>(_onLoadHomeData);
    on<RefreshHomeDataEvent>(_onRefreshHomeData);
    on<RetryHomeSectionEvent>(_onRetryHomeSection);
  }

  Future<void> _onLoadHomeData(
    LoadHomeDataEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(const HomeLoaded(
      usedProducts: [],
      loadingUsedProducts: true,
      topSellingProducts: [],
      loadingTopSellingProducts: true,
      newOffers: [],
      loadingNewOffers: true,
      blogPosts: [],
      loadingBlogPosts: true,
      tips: [],
      loadingTips: true,
      homeLayout: HomeLayoutModel.defaultLayout,
      loadingLayout: true,
    ));
    await _fetchAll(emit);
  }

  Future<void> _onRefreshHomeData(
    RefreshHomeDataEvent event,
    Emitter<HomeState> emit,
  ) async {
    final current = state;
    if (current is HomeLoaded) {
      emit(current.copyWith(
        loadingUsedProducts: true,
        loadingTopSellingProducts: true,
        loadingNewOffers: true,
        loadingBlogPosts: true,
        loadingTips: true,
        loadingLayout: true,
        refreshToken: current.refreshToken + 1,
      ));
    }
    await _fetchAll(emit);
  }

  Future<void> _onRetryHomeSection(
    RetryHomeSectionEvent event,
    Emitter<HomeState> emit,
  ) async {
    final current = state;
    if (current is! HomeLoaded) return;

    switch (event.sectionKey) {
      case 'used_systems':
        final result = await repository.getUsedProducts();
        result.fold(
          (failure) => emit(
            current.copyWith(
              usedProducts: const [],
              usedProductsError: _mapFailureToMessage(failure),
            ),
          ),
          (data) => emit(
            current.copyWith(
              usedProducts: data,
              clearUsedProductsError: true,
            ),
          ),
        );
      case 'best_sellers':
        final result = await repository.getTopSellingProducts();
        result.fold(
          (failure) => emit(
            current.copyWith(
              topSellingProducts: const [],
              topSellingProductsError: _mapFailureToMessage(failure),
            ),
          ),
          (data) => emit(
            current.copyWith(
              topSellingProducts: data,
              clearTopSellingProductsError: true,
            ),
          ),
        );
      case 'promotions':
        final result = await repository.getNewOffers();
        result.fold(
          (failure) => emit(
            current.copyWith(
              newOffers: const [],
              newOffersError: _mapFailureToMessage(failure),
            ),
          ),
          (data) => emit(
            current.copyWith(
              newOffers: data,
              clearNewOffersError: true,
            ),
          ),
        );
      case 'blog_highlights':
        final result = await repository.getBlogPosts();
        result.fold(
          (failure) => emit(
            current.copyWith(
              blogPosts: const [],
              blogPostsError: _mapFailureToMessage(failure),
            ),
          ),
          (data) => emit(
            current.copyWith(
              blogPosts: data,
              clearBlogPostsError: true,
            ),
          ),
        );
      case 'tips':
        final result = await repository.getRandomTips();
        result.fold(
          (failure) => emit(
            current.copyWith(
              tips: const [],
              tipsError: _mapFailureToMessage(failure),
            ),
          ),
          (data) => emit(
            current.copyWith(
              tips: data,
              clearTipsError: true,
            ),
          ),
        );
    }
  }

  Future<void> _fetchAll(Emitter<HomeState> emit) async {
    final futures = [
      _fetchLayout(emit),
      _fetchUsedProducts(emit),
      _fetchTopSelling(emit),
      _fetchNewOffers(emit),
      _fetchBlogPosts(emit),
      _fetchTips(emit),
    ];

    await Future.wait(futures);
  }

  Future<void> _fetchLayout(Emitter<HomeState> emit) async {
    final result = await repository.getHomeLayout();
    final current = state;
    if (current is HomeLoaded) {
      result.fold(
        (_) => emit(current.copyWith(loadingLayout: false)),
        (data) => emit(current.copyWith(
          homeLayout: data.isNotEmpty ? data : HomeLayoutModel.defaultLayout,
          loadingLayout: false,
        )),
      );
    }
  }

  Future<void> _fetchUsedProducts(Emitter<HomeState> emit) async {
    final result = await repository.getUsedProducts();
    final current = state;
    if (current is HomeLoaded) {
      result.fold(
        (failure) => emit(current.copyWith(
          usedProductsError: _mapFailureToMessage(failure),
          loadingUsedProducts: false,
        )),
        (data) => emit(current.copyWith(
          usedProducts: data,
          loadingUsedProducts: false,
          clearUsedProductsError: true,
        )),
      );
    }
  }

  Future<void> _fetchTopSelling(Emitter<HomeState> emit) async {
    final result = await repository.getTopSellingProducts();
    final current = state;
    if (current is HomeLoaded) {
      result.fold(
        (failure) => emit(current.copyWith(
          topSellingProductsError: _mapFailureToMessage(failure),
          loadingTopSellingProducts: false,
        )),
        (data) => emit(current.copyWith(
          topSellingProducts: data,
          loadingTopSellingProducts: false,
          clearTopSellingProductsError: true,
        )),
      );
    }
  }

  Future<void> _fetchNewOffers(Emitter<HomeState> emit) async {
    final result = await repository.getNewOffers();
    final current = state;
    if (current is HomeLoaded) {
      result.fold(
        (failure) => emit(current.copyWith(
          newOffersError: _mapFailureToMessage(failure),
          loadingNewOffers: false,
        )),
        (data) => emit(current.copyWith(
          newOffers: data,
          loadingNewOffers: false,
          clearNewOffersError: true,
        )),
      );
    }
  }

  Future<void> _fetchBlogPosts(Emitter<HomeState> emit) async {
    final result = await repository.getBlogPosts();
    final current = state;
    if (current is HomeLoaded) {
      result.fold(
        (failure) => emit(current.copyWith(
          blogPostsError: _mapFailureToMessage(failure),
          loadingBlogPosts: false,
        )),
        (data) => emit(current.copyWith(
          blogPosts: data,
          loadingBlogPosts: false,
          clearBlogPostsError: true,
        )),
      );
    }
  }

  Future<void> _fetchTips(Emitter<HomeState> emit) async {
    final result = await repository.getRandomTips();
    final current = state;
    if (current is HomeLoaded) {
      result.fold(
        (failure) => emit(current.copyWith(
          tipsError: _mapFailureToMessage(failure),
          loadingTips: false,
        )),
        (data) => emit(current.copyWith(
          tips: data,
          loadingTips: false,
          clearTipsError: true,
        )),
      );
    }
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case const (OfflineFailure):
        return 'network_error';
      case const (ServerFailure):
        return (failure as ServerFailure).message;
      default:
        return 'error_unexpected';
    }
  }
}
