part of 'service_address_bloc.dart';

@immutable
sealed class ServiceAddressState extends Equatable {
  const ServiceAddressState();

  @override
  List<Object?> get props => [];
}

final class ServiceAddressInitial extends ServiceAddressState {}

final class ServiceAddressLoading extends ServiceAddressState {}

final class ServiceAddressLoaded extends ServiceAddressState {
  final ServiceAddressModel address;
  final String fullName;
  final String streetAddress;
  final String city;
  final String building;
  final String floor;

  const ServiceAddressLoaded({
    required this.address,
    required this.fullName,
    required this.streetAddress,
    required this.city,
    required this.building,
    required this.floor,
  });

  ServiceAddressLoaded copyWith({
    ServiceAddressModel? address,
    String? fullName,
    String? streetAddress,
    String? city,
    String? building,
    String? floor,
  }) {
    return ServiceAddressLoaded(
      address: address ?? this.address,
      fullName: fullName ?? this.fullName,
      streetAddress: streetAddress ?? this.streetAddress,
      city: city ?? this.city,
      building: building ?? this.building,
      floor: floor ?? this.floor,
    );
  }

  @override
  List<Object?> get props => [
        address,
        fullName,
        streetAddress,
        city,
        building,
        floor,
      ];
}

final class ServiceAddressError extends ServiceAddressState {
  final String message;

  const ServiceAddressError({required this.message});

  @override
  List<Object?> get props => [message];
}
