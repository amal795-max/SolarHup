import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/core/api/errors/failures.dart';
import 'package:untitled1/features/blog/data/models/blog_article_detail_model.dart';
import 'package:untitled1/features/blog/data/repositories/blog_detail_repository.dart';

part 'blog_detail_event.dart';
part 'blog_detail_state.dart';

class BlogDetailBloc extends Bloc<BlogDetailEvent, BlogDetailState> {
  final BlogDetailRepository repository;

  BlogDetailBloc(this.repository) : super(BlogDetailInitial()) {
    on<LoadBlogDetailEvent>(_onLoad);
  }

  Future<void> _onLoad(
    LoadBlogDetailEvent event,
    Emitter<BlogDetailState> emit,
  ) async {
    emit(BlogDetailLoading());
    final result = await repository.getArticleDetail(event.articleId);
    result.fold(
      (failure) =>
          emit(BlogDetailError(message: _mapFailureToMessage(failure))),
      (article) => emit(BlogDetailLoaded(article: article)),
    );
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
