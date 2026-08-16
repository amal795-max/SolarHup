import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/core/api/errors/exceptions.dart';
import 'package:untitled1/features/blog/data/models/blog_article_detail_model.dart';
import 'package:untitled1/features/blog/data/repositories/blog_detail_repository.dart';

part 'blog_detail_state.dart';

class BlogDetailCubit extends Cubit<BlogDetailState> {
  final BlogDetailRepository repository;

  BlogDetailCubit(this.repository) : super(BlogDetailInitial());

  Future<void> loadArticleDetail(String articleId) async {
    emit(BlogDetailLoading());
    final result = await repository.getArticleDetail(articleId);
    result.fold(
      (failure) => emit(BlogDetailError(message: mapFailureToMessage(failure))),
      (article) => emit(BlogDetailLoaded(article: article)),
    );
  }
}
