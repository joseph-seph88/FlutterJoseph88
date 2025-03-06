import 'package:equatable/equatable.dart';

abstract class HomeState extends Equatable {
  @override
  List<Object> get props => [];
}

class HomeFormState extends HomeState {
  final List<String> filterType;
  final int selectedIndex;
  final int pageIndex;
  final int starIndex;

  HomeFormState({
    required this.filterType,
    this.selectedIndex = 0,
    this.pageIndex = 0,
    this.starIndex = 0,
  });

  HomeFormState copyWith({
    List<String>? filterType,
    int? selectedIndex,
    int? pageIndex,
    int? starIndex,
  }) {
    return HomeFormState(
      filterType: filterType ?? this.filterType,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      pageIndex: pageIndex ?? this.pageIndex,
      starIndex: starIndex ?? this.starIndex,
    );
  }

  @override
  List<Object> get props => [filterType, selectedIndex, pageIndex, starIndex];
}
