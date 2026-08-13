part of 'service_categories_cubit.dart';

sealed class ServiceCategoriesState extends Equatable {
  const ServiceCategoriesState();

  @override
  List<Object?> get props => [];
}

final class ServiceCategoriesInitial extends ServiceCategoriesState {}

final class ServiceCategoriesLoading extends ServiceCategoriesState {}

final class ServiceCategoriesLoaded extends ServiceCategoriesState {
  final List<StoreCategoryModel> categories;

  const ServiceCategoriesLoaded({required this.categories});

  @override
  List<Object?> get props => [categories];
}

final class ServiceCategoriesError extends ServiceCategoriesState {
  final String message;

  const ServiceCategoriesError({required this.message});

  @override
  List<Object?> get props => [message];
}
