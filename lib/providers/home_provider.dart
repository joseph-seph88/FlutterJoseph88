import 'package:flutter_riverpod/flutter_riverpod.dart';

class BottomNavigationNotifier extends StateNotifier<int> {
  BottomNavigationNotifier() : super(0);

  void setSelectedIndex(int index) {
    state = index;
  }
}

final bottomNavigationProvider = StateNotifierProvider<BottomNavigationNotifier, int>(
      (ref) => BottomNavigationNotifier(),
);
