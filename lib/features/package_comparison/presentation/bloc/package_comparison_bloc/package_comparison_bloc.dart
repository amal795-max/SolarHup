import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:untitled1/core/api/errors/failures.dart';
import 'package:untitled1/features/package_comparison/data/models/package_comparison_model.dart';
import 'package:untitled1/features/package_comparison/data/repositories/package_comparison_repository.dart';

part 'package_comparison_event.dart';
part 'package_comparison_state.dart';

class PackageComparisonBloc
    extends Bloc<PackageComparisonEvent, PackageComparisonState> {
  final PackageComparisonRepository repository;

  PackageComparisonBloc(this.repository) : super(PackageComparisonInitial()) {
    on<LoadPackageComparisonEvent>(_onLoad);
    on<AddStarterPackageEvent>(_onAddStarter);
    on<AddPremiumPackageEvent>(_onAddPremium);
  }

  Future<void> _onLoad(
    LoadPackageComparisonEvent event,
    Emitter<PackageComparisonState> emit,
  ) async {
    emit(PackageComparisonLoading());
    final result = await repository.getPackageComparison();
    result.fold(
      (failure) =>
          emit(PackageComparisonError(message: _mapFailureToMessage(failure))),
      (data) => emit(PackageComparisonLoaded(comparison: data)),
    );
  }

  Future<void> _onAddStarter(
    AddStarterPackageEvent event,
    Emitter<PackageComparisonState> emit,
  ) async {
    final current = state;
    if (current is! PackageComparisonLoaded) return;
    await _addPackage(current, current.comparison.starter.id, emit);
  }

  Future<void> _onAddPremium(
    AddPremiumPackageEvent event,
    Emitter<PackageComparisonState> emit,
  ) async {
    final current = state;
    if (current is! PackageComparisonLoaded) return;
    await _addPackage(current, current.comparison.premium.id, emit);
  }

  Future<void> _addPackage(
    PackageComparisonLoaded current,
    String packageId,
    Emitter<PackageComparisonState> emit,
  ) async {
    emit(current.copyWith(isAddingToCart: true, addingPackageId: packageId));
    final result = await repository.addPackageToCart(packageId);
    result.fold(
      (failure) => emit(
        current.copyWith(
          isAddingToCart: false,
          addingPackageId: null,
          cartMessage: _mapFailureToMessage(failure),
        ),
      ),
      (_) => emit(
        current.copyWith(
          isAddingToCart: false,
          addingPackageId: null,
          cartMessage: 'Added to cart',
        ),
      ),
    );
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
