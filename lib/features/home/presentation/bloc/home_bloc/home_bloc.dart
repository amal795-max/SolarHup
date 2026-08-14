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

  Future<void> _fetchAll(Emitter<HomeState> emit) async {
    final layoutResult = await repository.getHomeLayout();
    final usedResult = await repository.getUsedProducts();
    final newResult = await repository.getNewOffers();
    final blogResult = await repository.getBlogPosts();
    final tipsResult = await repository.getRandomTips();

    String? error;
    List<HomeLayoutModel> homeLayout = [];
    List<UsedProductModel> usedProducts = [];
    List<ProductModel> newOffers = [];
    List<BlogModel> blogPosts = [];
    List<TipModel> tips = [];

    layoutResult.fold(
      (f) => error = _mapFailureToMessage(f),
      (data) => homeLayout = data,
    );
    if (error != null) {
      emit(HomeError(message: error!));
      return;
    }

    usedResult.fold(
      (f) => error = _mapFailureToMessage(f),
      (data) => usedProducts = data,
    );
    if (error != null) {
      emit(HomeError(message: error!));
      return;
    }

    newResult.fold(
      (f) => error = _mapFailureToMessage(f),
      (data) => newOffers = data,
    );
    if (error != null) {
      emit(HomeError(message: error!));
      return;
    }

    blogResult.fold(
      (_) => blogPosts = [],
      (data) => blogPosts = data,
    );

    tipsResult.fold(
      (_) => tips = [],
      (data) => tips = data,
    );

    emit(HomeLoaded(
      usedProducts: usedProducts,
      newOffers: newOffers,
      blogPosts: blogPosts,
      tips: tips,
      homeLayout: homeLayout,
    ));
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
