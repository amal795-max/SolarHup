import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:untitled1/core/api/errors/failures.dart';
import 'package:untitled1/features/services/data/models/service_request_model.dart';
import 'package:untitled1/features/services/data/repositories/service_requests_repository.dart';

part 'service_requests_state.dart';

class ServiceRequestsCubit extends Cubit<ServiceRequestsState> {
  final ServiceRequestsRepository repository;

  ServiceRequestsCubit(this.repository) : super(ServiceRequestsInitial());

  List<ServiceRequestModel> _cachedRequests = [];

  List<ServiceRequestModel> get cachedRequests => _cachedRequests;

  Future<void> loadMyRequests() async {
    emit(ServiceRequestsLoading());
    final result = await repository.getMyServiceRequests();
    result.fold(
      (failure) => emit(ServiceRequestsError(message: _mapFailure(failure))),
      (requests) {
        _cachedRequests = requests;
        emit(ServiceRequestsLoaded(requests: requests));
      },
    );
  }

  Future<ServiceRequestModel?> requestService(int serviceId) async {
    emit(ServiceRequestsSubmitting());
    final result = await repository.createServiceRequest(serviceId);
    return result.fold(
      (failure) {
        emit(ServiceRequestsError(message: _mapFailure(failure)));
        return null;
      },
      (request) {
        _cachedRequests = [request, ..._cachedRequests];
        emit(ServiceRequestsLoaded(requests: _cachedRequests));
        return request;
      },
    );
  }

  String _mapFailure(Failure failure) {
    return switch (failure) {
      ServerFailure(:final message) => message,
      OfflineFailure() => 'No internet connection',
      _ => 'Something went wrong',
    };
  }
}
