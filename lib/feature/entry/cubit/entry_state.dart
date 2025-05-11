import 'package:equatable/equatable.dart';

class EntryState extends Equatable {
  final int currentIndex;

  const EntryState({
    this.currentIndex = 0,
  });

  EntryState copyWith({
    int? currentIndex,
  }) {
    return EntryState(
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }

  @override
  List<Object?> get props => [
        currentIndex,
      ];
}
