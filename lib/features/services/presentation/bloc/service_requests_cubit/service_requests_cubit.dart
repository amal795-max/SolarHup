import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:untitled1/core/api/errors/failures.dart';
import 'package:untitled1/features/services/data/models/service_request_create_payload.dart';
import 'package:untitled1/features/services/data/models/service_request_model.dart';
import 'package:untitled1/features/services/data/repositories/service_requests_repository.dart';

part 'service_requests_state.dart';

class ServiceRequestsCubit extends Cubit<ServiceRequestsState> {
  final ServiceRequestsRepository repository;

  ServiceRequestsCubit(this.repository) : super(ServiceRequestsInitial());

  List<ServiceRequestModel> _cachedRequests = [];

  List<ServiceRequestModel> get cachedRequests => _cachedRequests;

  Future<void> loadMyRequests({bool showLoading = false}) async {
    if (showLoading || _cachedRequests.isEmpty) {
      emit(ServiceRequestsLoading());
    }
    final result = await repository.getMyServiceRequests();
    result.fold(
      (failure) => emit(ServiceRequestsError(message: _mapFailure(failure))),
      (requests) {
        _cachedRequests = requests;
        emit(ServiceRequestsLoaded(requests: requests));
      },
    );
  }

  Future<ServiceRequestModel?> requestService(
    ServiceRequestCreatePayload payload,
  ) async {
    emit(ServiceRequestsSubmitting());
    final result = await repository.createServiceRequest(payload);
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

  Future<void> loadRequestDetail(int requestId, {bool showLoading = false}) async {
    if (showLoading || state is! ServiceRequestDetailsLoaded) {
      emit(ServiceRequestDetailsLoading());
    }
    final result = await repository.getServiceRequest(requestId);
    result.fold(
      (failure) =>
          emit(ServiceRequestDetailsError(message: _mapFailure(failure))),
      (request) {
        final index = _cachedRequests.indexWhere((o) => o.id == requestId);
        if (index != -1) {
          _cachedRequests[index] = request;
        }
        emit(ServiceRequestDetailsLoaded(request: request));
      },
    );
  }

  Future<bool> cancelRequest(int requestId) async {
    final previousState = state;
    final previousRequest = _findRequest(requestId);
    if (previousRequest == null) return false;

    emit(ServiceRequestCancelling(request: previousRequest));

    final result = await repository.cancelServiceRequest(requestId);
    return result.fold(
      (failure) {
        _restoreStateAfterCancelFailure(previousState, previousRequest);
        return false;
      },
      (request) {
        _cachedRequests = _cachedRequests
            .map((item) => item.id == requestId ? request : item)
            .toList();
        emit(ServiceRequestDetailsLoaded(request: request));
        return true;
      },
    );
  }

  ServiceRequestModel? _findRequest(int requestId) {
    final current = state;
    final fromState = switch (current) {
      ServiceRequestDetailsLoaded(:final request) when request.id == requestId =>
        request,
      ServiceRequestCancelling(:final request) when request.id == requestId =>
        request,
      _ => null,
    };
    if (fromState != null) return fromState;

    for (final request in _cachedRequests) {
      if (request.id == requestId) return request;
    }
    return null;
  }

  void _restoreStateAfterCancelFailure(
    ServiceRequestsState previousState,
    ServiceRequestModel request,
  ) {
    switch (previousState) {
      case ServiceRequestsLoaded():
        emit(ServiceRequestsLoaded(requests: List.of(_cachedRequests)));
      case ServiceRequestDetailsLoaded():
      case ServiceRequestCancelling():
        emit(ServiceRequestDetailsLoaded(request: request));
      default:
        emit(ServiceRequestDetailsLoaded(request: request));
    }
  }

  String _mapFailure(Failure failure) {
    return switch (failure) {
      ServerFailure(:final message) => message,
      OfflineFailure() => 'No internet connection',
      _ => 'Something went wrong',
    };
  }
}
