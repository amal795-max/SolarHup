import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/core/api/errors/failures.dart';
import 'package:untitled1/features/services/data/models/service_address_model.dart';
import 'package:untitled1/features/services/data/repositories/service_address_repository.dart';

part 'service_address_event.dart';
part 'service_address_state.dart';

class ServiceAddressBloc extends Bloc<ServiceAddressEvent, ServiceAddressState> {
  final ServiceAddressRepository repository;

  ServiceAddressBloc(this.repository) : super(ServiceAddressInitial()) {
    on<LoadServiceAddressEvent>(_onLoad);
    on<UpdateServiceFullNameEvent>(_onUpdateFullName);
    on<UpdateServiceStreetEvent>(_onUpdateStreet);
    on<UpdateServiceCityEvent>(_onUpdateCity);
    on<UpdateServiceBuildingEvent>(_onUpdateBuilding);
    on<UpdateServiceFloorEvent>(_onUpdateFloor);
  }

  Future<void> _onLoad(
    LoadServiceAddressEvent event,
    Emitter<ServiceAddressState> emit,
  ) async {
    emit(ServiceAddressLoading());
    final result = await repository.getServiceAddress(event.serviceId);
    result.fold(
      (failure) =>
          emit(ServiceAddressError(message: _mapFailureToMessage(failure))),
      (data) => emit(
        ServiceAddressLoaded(
          address: data,
          fullName: '',
          streetAddress: '',
          city: '',
          building: '',
          floor: '',
        ),
      ),
    );
  }

  void _onUpdateFullName(
    UpdateServiceFullNameEvent event,
    Emitter<ServiceAddressState> emit,
  ) {
    final current = state;
    if (current is! ServiceAddressLoaded) return;
    emit(current.copyWith(fullName: event.value));
  }

  void _onUpdateStreet(
    UpdateServiceStreetEvent event,
    Emitter<ServiceAddressState> emit,
  ) {
    final current = state;
    if (current is! ServiceAddressLoaded) return;
    emit(current.copyWith(streetAddress: event.value));
  }

  void _onUpdateCity(
    UpdateServiceCityEvent event,
    Emitter<ServiceAddressState> emit,
  ) {
    final current = state;
    if (current is! ServiceAddressLoaded) return;
    emit(current.copyWith(city: event.value));
  }

  void _onUpdateBuilding(
    UpdateServiceBuildingEvent event,
    Emitter<ServiceAddressState> emit,
  ) {
    final current = state;
    if (current is! ServiceAddressLoaded) return;
    emit(current.copyWith(building: event.value));
  }

  void _onUpdateFloor(
    UpdateServiceFloorEvent event,
    Emitter<ServiceAddressState> emit,
  ) {
    final current = state;
    if (current is! ServiceAddressLoaded) return;
    emit(current.copyWith(floor: event.value));
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case const (OfflineFailure):
        return 'No internet connection';
      case const (ServerFailure):
        return (failure as ServerFailure).message;
      default:
        return 'Unexpected error occurred';
    }
  }
}
