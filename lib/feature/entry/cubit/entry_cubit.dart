import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_login/feature/entry/cubit/entry_state.dart';

class EntryCubit extends Cubit<EntryState> {
  EntryCubit() : super(EntryState());

  void pageNavigation(int currentIndex) {
    emit(state.copyWith(currentIndex: currentIndex));
    print("Routing Index $currentIndex");
  }
}
