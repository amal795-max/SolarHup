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
    if (event.showLoading) {
      emit(HomeLoading());
    }
    await _fetchAll(emit);
  }

  Future<void> _onRefreshHomeData(
    RefreshHomeDataEvent event,
    Emitter<HomeState> emit,
  ) async {
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
    final (
      layoutResult,
      usedResult,
      topSellingResult,
      newResult,
      blogResult,
      tipsResult,
    ) = await (
      repository.getHomeLayout(),
      repository.getUsedProducts(),
      repository.getTopSellingProducts(),
      repository.getNewOffers(),
      repository.getBlogPosts(),
      repository.getRandomTips(),
    ).wait;

    List<HomeLayoutModel> homeLayout = HomeLayoutModel.defaultLayout;
    List<UsedProductModel> usedProducts = [];
    String? usedProductsError;
    List<ProductModel> topSellingProducts = [];
    String? topSellingProductsError;
    List<ProductModel> newOffers = [];
    String? newOffersError;
    List<BlogModel> blogPosts = [];
    String? blogPostsError;
    List<TipModel> tips = [];
    String? tipsError;

    layoutResult.fold(
      (_) {},
      (data) {
        if (data.isNotEmpty) homeLayout = data;
      },
    );

    usedResult.fold(
      (failure) => usedProductsError = _mapFailureToMessage(failure),
      (data) => usedProducts = data,
    );

    topSellingResult.fold(
      (failure) => topSellingProductsError = _mapFailureToMessage(failure),
      (data) => topSellingProducts = data,
    );

    newResult.fold(
      (failure) => newOffersError = _mapFailureToMessage(failure),
      (data) => newOffers = data,
    );

    blogResult.fold(
      (failure) => blogPostsError = _mapFailureToMessage(failure),
      (data) => blogPosts = data,
    );

    tipsResult.fold(
      (failure) => tipsError = _mapFailureToMessage(failure),
      (data) => tips = data,
    );

    final nextRefreshToken =
        state is HomeLoaded ? (state as HomeLoaded).refreshToken + 1 : 1;

    emit(
      HomeLoaded(
        usedProducts: usedProducts,
        usedProductsError: usedProductsError,
        topSellingProducts: topSellingProducts,
        topSellingProductsError: topSellingProductsError,
        newOffers: newOffers,
        newOffersError: newOffersError,
        blogPosts: blogPosts,
        blogPostsError: blogPostsError,
        tips: tips,
        tipsError: tipsError,
        homeLayout: homeLayout,
        refreshToken: nextRefreshToken,
      ),
    );
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
