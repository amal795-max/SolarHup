part of 'service_address_bloc.dart';

@immutable
sealed class ServiceAddressEvent extends Equatable {
  const ServiceAddressEvent();

  @override
  List<Object?> get props => [];
}

final class LoadServiceAddressEvent extends ServiceAddressEvent {
  final String serviceId;
  final double servicePrice;

  const LoadServiceAddressEvent(this.serviceId, {this.servicePrice = 0});

  @override
  List<Object?> get props => [serviceId, servicePrice];
}

final class UpdateServiceFullNameEvent extends ServiceAddressEvent {
  final String value;

  const UpdateServiceFullNameEvent(this.value);

  @override
  List<Object?> get props => [value];
}

final class UpdateServiceStreetEvent extends ServiceAddressEvent {
  final String value;

  const UpdateServiceStreetEvent(this.value);

  @override
  List<Object?> get props => [value];
}

final class UpdateServiceCityEvent extends ServiceAddressEvent {
  final String value;

  const UpdateServiceCityEvent(this.value);

  @override
  List<Object?> get props => [value];
}

final class UpdateServiceBuildingEvent extends ServiceAddressEvent {
  final String value;

  const UpdateServiceBuildingEvent(this.value);

  @override
  List<Object?> get props => [value];
}

final class UpdateServiceFloorEvent extends ServiceAddressEvent {
  final String value;

  const UpdateServiceFloorEvent(this.value);

  @override
  List<Object?> get props => [value];
}
