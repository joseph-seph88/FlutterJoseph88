import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class HomeFormEvent extends HomeEvent {
  final List<String>? filterType;
  final int? selectedIndex;
  final int? pageIndex;
  final int? starIndex;

  HomeFormEvent({
    this.filterType,
    this.selectedIndex,
    this.pageIndex,
    this.starIndex,
  });

  @override
  List<Object?> get props => [filterType, selectedIndex, pageIndex, starIndex];
}

class ResetHomeFormEvent extends HomeEvent {}
