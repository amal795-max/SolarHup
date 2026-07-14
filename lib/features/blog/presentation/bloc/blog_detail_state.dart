part of 'blog_detail_cubit.dart';

@immutable
sealed class BlogDetailState extends Equatable {
  const BlogDetailState();

  @override
  List<Object?> get props => [];
}

final class BlogDetailInitial extends BlogDetailState {}

final class BlogDetailLoading extends BlogDetailState {}

final class BlogDetailLoaded extends BlogDetailState {
  final BlogArticleDetailModel article;

  const BlogDetailLoaded({required this.article});

  @override
  List<Object?> get props => [article];
}

final class BlogDetailError extends BlogDetailState {
  final String message;

  const BlogDetailError({required this.message});

  @override
  List<Object?> get props => [message];
}
