part of 'services_bloc.dart';

@immutable
sealed class ServicesState extends Equatable {
  const ServicesState();

  @override
  List<Object?> get props => [];
}

final class ServicesInitial extends ServicesState {}

final class ServicesLoading extends ServicesState {}

final class ServicesLoaded extends ServicesState {
  final List<ExpertServiceModel> allServices;
  final ExpertServiceModel? featured;
  final String searchQuery;
  final int selectedCategoryIndex;

  const ServicesLoaded({
    required this.allServices,
    this.featured,
    this.searchQuery = '',
    this.selectedCategoryIndex = 0,
  });

  List<ExpertServiceModel> get filteredServices {
    final query = searchQuery.trim().toLowerCase();
    return allServices.where((service) {
      final matchesCategory = switch (selectedCategoryIndex) {
        1 => service.categoryKey == 'maintenance',
        2 => service.categoryKey == 'installation',
        _ => true,
      };
      if (!matchesCategory) return false;
      if (query.isEmpty) return true;
      return service.title.toLowerCase().contains(query) ||
          service.badges.any((b) => b.toLowerCase().contains(query));
    }).toList();
  }

  ServicesLoaded copyWith({
    List<ExpertServiceModel>? allServices,
    ExpertServiceModel? featured,
    String? searchQuery,
    int? selectedCategoryIndex,
  }) {
    return ServicesLoaded(
      allServices: allServices ?? this.allServices,
      featured: featured ?? this.featured,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategoryIndex:
          selectedCategoryIndex ?? this.selectedCategoryIndex,
    );
  }

  @override
  List<Object?> get props => [
        allServices,
        featured,
        searchQuery,
        selectedCategoryIndex,
      ];
}

final class ServicesError extends ServicesState {
  final String message;

  const ServicesError({required this.message});

  @override
  List<Object?> get props => [message];
}
