part of 'stores_bloc.dart';

@immutable
sealed class StoresEvent extends Equatable {
  const StoresEvent();

  @override
  List<Object?> get props => [];
}

final class LoadStoresEvent extends StoresEvent {
  final bool showLoading;

  const LoadStoresEvent({this.showLoading = true});

  @override
  List<Object?> get props => [showLoading];
}

final class RefreshStoresEvent extends StoresEvent {
  const RefreshStoresEvent();
}
