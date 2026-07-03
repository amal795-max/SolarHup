part of 'blog_detail_bloc.dart';

@immutable
sealed class BlogDetailEvent extends Equatable {
  const BlogDetailEvent();

  @override
  List<Object?> get props => [];
}

final class LoadBlogDetailEvent extends BlogDetailEvent {
  final String articleId;

  const LoadBlogDetailEvent({required this.articleId});

  @override
  List<Object?> get props => [articleId];
}
