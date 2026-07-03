part of 'package_comparison_bloc.dart';

sealed class PackageComparisonEvent extends Equatable {
  const PackageComparisonEvent();

  @override
  List<Object?> get props => [];
}

final class LoadPackageComparisonEvent extends PackageComparisonEvent {
  const LoadPackageComparisonEvent();
}

final class AddStarterPackageEvent extends PackageComparisonEvent {
  const AddStarterPackageEvent();
}

final class AddPremiumPackageEvent extends PackageComparisonEvent {
  const AddPremiumPackageEvent();
}
