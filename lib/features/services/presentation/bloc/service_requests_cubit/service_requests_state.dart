part of 'service_requests_cubit.dart';

sealed class ServiceRequestsState extends Equatable {
  const ServiceRequestsState();

  @override
  List<Object?> get props => [];
}

final class ServiceRequestsInitial extends ServiceRequestsState {}

final class ServiceRequestsLoading extends ServiceRequestsState {}

final class ServiceRequestsSubmitting extends ServiceRequestsState {}

final class ServiceRequestsLoaded extends ServiceRequestsState {
  final List<ServiceRequestModel> requests;

  const ServiceRequestsLoaded({required this.requests});

  @override
  List<Object?> get props => [requests];
}

final class ServiceRequestsError extends ServiceRequestsState {
  final String message;

  const ServiceRequestsError({required this.message});

  @override
  List<Object?> get props => [message];
}

final class ServiceRequestDetailsLoading extends ServiceRequestsState {}

final class ServiceRequestDetailsLoaded extends ServiceRequestsState {
  final ServiceRequestModel request;

  const ServiceRequestDetailsLoaded({required this.request});

  @override
  List<Object?> get props => [request];
}

final class ServiceRequestDetailsError extends ServiceRequestsState {
  final String message;

  const ServiceRequestDetailsError({required this.message});

  @override
  List<Object?> get props => [message];
}

final class ServiceRequestCancelling extends ServiceRequestsState {
  final ServiceRequestModel request;

  const ServiceRequestCancelling({required this.request});

  @override
  List<Object?> get props => [request];
}
