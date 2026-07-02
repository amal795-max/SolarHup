part of 'blog_bloc.dart';

@immutable
sealed class BlogEvent extends Equatable {
  const BlogEvent();

  @override
  List<Object?> get props => [];
}

final class LoadBlogEvent extends BlogEvent {
  const LoadBlogEvent();
}

final class UpdateBlogSearchEvent extends BlogEvent {
  final String query;

  const UpdateBlogSearchEvent(this.query);

  @override
  List<Object?> get props => [query];
}

final class SelectBlogCategoryEvent extends BlogEvent {
  final int categoryIndex;

  const SelectBlogCategoryEvent(this.categoryIndex);

  @override
  List<Object?> get props => [categoryIndex];
}

final class BlogPreviousPageEvent extends BlogEvent {
  const BlogPreviousPageEvent();
}

final class BlogNextPageEvent extends BlogEvent {
  const BlogNextPageEvent();
}
