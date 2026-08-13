part of 'workshop_detail_cubit.dart';

sealed class WorkshopDetailState extends Equatable {
  const WorkshopDetailState();

  @override
  List<Object?> get props => [];
}

final class WorkshopDetailInitial extends WorkshopDetailState {}

final class WorkshopDetailLoading extends WorkshopDetailState {}

final class WorkshopDetailLoaded extends WorkshopDetailState {
  final WorkshopDetailModel workshop;
  final List<WorkshopServiceModel> services;

  const WorkshopDetailLoaded({
    required this.workshop,
    required this.services,
  });

  @override
  List<Object?> get props => [workshop, services];
}

final class WorkshopDetailError extends WorkshopDetailState {
  final String message;

  const WorkshopDetailError({required this.message});

  @override
  List<Object?> get props => [message];
}
