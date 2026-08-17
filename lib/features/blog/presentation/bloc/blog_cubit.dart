import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/core/api/errors/exceptions.dart';
import 'package:untitled1/features/blog/data/models/blog_article_model.dart';
import 'package:untitled1/features/blog/data/repositories/blog_repository.dart';

part 'blog_state.dart';

class BlogCubit extends Cubit<BlogState> {
  final BlogRepository repository;

  BlogCubit(this.repository) : super(BlogInitial());

  Future<void> loadBlog({bool showLoading = false}) async {
    if (showLoading || state is! BlogLoaded) {
      emit(BlogLoading());
    }
    final result = await repository.getBlogFeed();
    result.fold(
      (failure) => emit(BlogError(message: mapFailureToMessage(failure))),
      (data) => emit(
        BlogLoaded(
          featured: data.featured,
          allArticles: data.articles,
          apiTotalPages: data.totalPages,
        ),
      ),
    );
  }

  void updateSearch(String query) {
    final current = state;
    if (current is! BlogLoaded) return;
    emit(current.copyWith(searchQuery: query, currentPage: 1));
  }

  void goToPreviousPage() {
    final current = state;
    if (current is! BlogLoaded || !current.canGoPrevious) return;
    emit(current.copyWith(currentPage: current.currentPage - 1));
  }

  void goToNextPage() {
    final current = state;
    if (current is! BlogLoaded || !current.canGoNext) return;
    emit(current.copyWith(currentPage: current.currentPage + 1));
  }
}
