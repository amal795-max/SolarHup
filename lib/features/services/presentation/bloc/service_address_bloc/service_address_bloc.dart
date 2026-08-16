import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
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
    on<UpdateServiceCouponCodeEvent>(_onUpdateCouponCode);
    on<ApplyServiceCouponEvent>(_onApplyCoupon);
    on<ClearServiceCouponEvent>(_onClearCoupon);
  }

  Future<void> _onLoad(
    LoadServiceAddressEvent event,
    Emitter<ServiceAddressState> emit,
  ) async {
    emit(ServiceAddressLoading());
    emit(
      ServiceAddressLoaded(
        address: ServiceAddressModel(
          serviceId: event.serviceId,
          defaultFullName: '',
          defaultStreetAddress: '',
          defaultCity: '',
          defaultBuilding: '',
          defaultFloor: '',
          originalTotal: event.servicePrice,
          grandTotal: event.servicePrice,
        ),
        fullName: '',
        streetAddress: '',
        city: '',
        building: '',
        floor: '',
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

  void _onUpdateCouponCode(
    UpdateServiceCouponCodeEvent event,
    Emitter<ServiceAddressState> emit,
  ) {
    final current = state;
    if (current is! ServiceAddressLoaded) return;
    emit(
      current.copyWith(
        couponCode: event.value,
        clearCouponError: true,
      ),
    );
  }

  void _onApplyCoupon(
    ApplyServiceCouponEvent event,
    Emitter<ServiceAddressState> emit,
  ) {
    final current = state;
    if (current is! ServiceAddressLoaded) return;

    final code = current.couponCode.trim();
    if (code.isEmpty) {
      emit(current.copyWith(couponError: 'service_coupon_required'));
      return;
    }

    emit(
      current.copyWith(
        couponCode: code,
        clearCouponError: true,
        address: current.address.copyWith(appliedCouponCode: code),
      ),
    );
  }

  void _onClearCoupon(
    ClearServiceCouponEvent event,
    Emitter<ServiceAddressState> emit,
  ) {
    final current = state;
    if (current is! ServiceAddressLoaded) return;

    emit(
      current.copyWith(
        couponCode: '',
        clearCouponError: true,
        address: current.address.copyWith(
          grandTotal: current.address.originalTotal,
          discountAmount: 0,
          clearAppliedCouponCode: true,
        ),
      ),
    );
  }
}
