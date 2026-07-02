import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/core/api/errors/failures.dart';
import 'package:untitled1/features/blog/data/models/blog_article_model.dart';
import 'package:untitled1/features/blog/data/repositories/blog_repository.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final BlogRepository repository;

  BlogBloc(this.repository) : super(BlogInitial()) {
    on<LoadBlogEvent>(_onLoad);
    on<UpdateBlogSearchEvent>(_onUpdateSearch);
    on<SelectBlogCategoryEvent>(_onSelectCategory);
    on<BlogPreviousPageEvent>(_onPreviousPage);
    on<BlogNextPageEvent>(_onNextPage);
  }

  Future<void> _onLoad(LoadBlogEvent event, Emitter<BlogState> emit) async {
    emit(BlogLoading());
    final result = await repository.getBlogFeed();
    result.fold(
      (failure) => emit(BlogError(message: _mapFailureToMessage(failure))),
      (data) => emit(
        BlogLoaded(
          featured: data.featured,
          allArticles: data.articles,
          apiTotalPages: data.totalPages,
        ),
      ),
    );
  }

  void _onUpdateSearch(UpdateBlogSearchEvent event, Emitter<BlogState> emit) {
    final current = state;
    if (current is! BlogLoaded) return;
    emit(current.copyWith(searchQuery: event.query, currentPage: 1));
  }

  void _onSelectCategory(
    SelectBlogCategoryEvent event,
    Emitter<BlogState> emit,
  ) {
    final current = state;
    if (current is! BlogLoaded) return;
    emit(
      current.copyWith(
        selectedCategoryIndex: event.categoryIndex,
        currentPage: 1,
      ),
    );
  }

  void _onPreviousPage(BlogPreviousPageEvent event, Emitter<BlogState> emit) {
    final current = state;
    if (current is! BlogLoaded || !current.canGoPrevious) return;
    emit(current.copyWith(currentPage: current.currentPage - 1));
  }

  void _onNextPage(BlogNextPageEvent event, Emitter<BlogState> emit) {
    final current = state;
    if (current is! BlogLoaded || !current.canGoNext) return;
    emit(current.copyWith(currentPage: current.currentPage + 1));
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
