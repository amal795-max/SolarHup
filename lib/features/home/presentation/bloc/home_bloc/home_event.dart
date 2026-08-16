part of 'home_bloc.dart';

@immutable
sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

final class LoadHomeDataEvent extends HomeEvent {
  final bool showLoading;

  const LoadHomeDataEvent({this.showLoading = true});

  @override
  List<Object?> get props => [showLoading];
}

final class RefreshHomeDataEvent extends HomeEvent {
  const RefreshHomeDataEvent();
}

final class RetryHomeSectionEvent extends HomeEvent {
  final String sectionKey;

  const RetryHomeSectionEvent(this.sectionKey);

  @override
  List<Object?> get props => [sectionKey];
}
