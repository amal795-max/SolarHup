part of 'services_bloc.dart';

@immutable
sealed class ServicesEvent extends Equatable {
  const ServicesEvent();

  @override
  List<Object?> get props => [];
}

final class LoadServicesEvent extends ServicesEvent {
  const LoadServicesEvent();
}

final class UpdateServicesSearchEvent extends ServicesEvent {
  final String query;

  const UpdateServicesSearchEvent(this.query);

  @override
  List<Object?> get props => [query];
}

final class SelectServicesCategoryEvent extends ServicesEvent {
  final int categoryIndex;

  const SelectServicesCategoryEvent(this.categoryIndex);

  @override
  List<Object?> get props => [categoryIndex];
}
