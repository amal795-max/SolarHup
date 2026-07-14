part of 'blog_cubit.dart';

@immutable
sealed class BlogState extends Equatable {
  const BlogState();

  @override
  List<Object?> get props => [];
}

final class BlogInitial extends BlogState {}

final class BlogLoading extends BlogState {}

final class BlogLoaded extends BlogState {
  static const int pageSize = 3;

  final BlogArticleModel featured;
  final List<BlogArticleModel> allArticles;
  final int apiTotalPages;
  final String searchQuery;
  final int selectedCategoryIndex;
  final int currentPage;

  const BlogLoaded({
    required this.featured,
    required this.allArticles,
    required this.apiTotalPages,
    this.searchQuery = '',
    this.selectedCategoryIndex = 0,
    this.currentPage = 1,
  });

  List<BlogArticleModel> get filteredArticles {
    final query = searchQuery.trim().toLowerCase();
    return allArticles.where((article) {
      final matchesCategory = switch (selectedCategoryIndex) {
        1 => article.categoryKey == 'panels',
        2 => article.categoryKey == 'inverters',
        3 => article.categoryKey == 'batteries',
        _ => true,
      };
      if (!matchesCategory) return false;
      if (query.isEmpty) return true;
      return article.title.toLowerCase().contains(query) ||
          article.excerpt.toLowerCase().contains(query) ||
          article.categoryLabel.toLowerCase().contains(query);
    }).toList();
  }

  List<BlogArticleModel> get paginatedArticles {
    final start = (currentPage - 1) * pageSize;
    if (start >= filteredArticles.length) return const [];
    final end = (start + pageSize).clamp(0, filteredArticles.length);
    return filteredArticles.sublist(start, end);
  }

  int get totalPages {
    final computed = filteredArticles.isEmpty
        ? 1
        : (filteredArticles.length / pageSize).ceil();
    return computed.clamp(1, apiTotalPages);
  }

  bool get canGoPrevious => currentPage > 1;

  bool get canGoNext => currentPage < totalPages;

  BlogLoaded copyWith({
    BlogArticleModel? featured,
    List<BlogArticleModel>? allArticles,
    int? apiTotalPages,
    String? searchQuery,
    int? selectedCategoryIndex,
    int? currentPage,
  }) {
    return BlogLoaded(
      featured: featured ?? this.featured,
      allArticles: allArticles ?? this.allArticles,
      apiTotalPages: apiTotalPages ?? this.apiTotalPages,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategoryIndex:
          selectedCategoryIndex ?? this.selectedCategoryIndex,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  @override
  List<Object?> get props => [
        featured,
        allArticles,
        apiTotalPages,
        searchQuery,
        selectedCategoryIndex,
        currentPage,
      ];
}

final class BlogError extends BlogState {
  final String message;

  const BlogError({required this.message});

  @override
  List<Object?> get props => [message];
}
