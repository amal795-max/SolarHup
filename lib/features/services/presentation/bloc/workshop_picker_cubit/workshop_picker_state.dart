part of 'workshop_picker_cubit.dart';

sealed class WorkshopPickerState extends Equatable {
  const WorkshopPickerState();

  @override
  List<Object?> get props => [];
}

final class WorkshopPickerInitial extends WorkshopPickerState {}

final class WorkshopPickerLoading extends WorkshopPickerState {
  final String categoryName;

  const WorkshopPickerLoading({required this.categoryName});

  @override
  List<Object?> get props => [categoryName];
}

final class WorkshopPickerLoaded extends WorkshopPickerState {
  final int categoryId;
  final String categoryName;
  final List<WorkshopOfferingModel> offerings;

  const WorkshopPickerLoaded({
    required this.categoryId,
    required this.categoryName,
    required this.offerings,
  });

  @override
  List<Object?> get props => [categoryId, categoryName, offerings];
}

final class WorkshopPickerError extends WorkshopPickerState {
  final String categoryName;
  final String message;

  const WorkshopPickerError({
    required this.categoryName,
    required this.message,
  });

  @override
  List<Object?> get props => [categoryName, message];
}
