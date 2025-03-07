import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_select_chat/bloc/home/home_event.dart';
import 'package:personal_select_chat/bloc/home/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc()
      : super(HomeFormState(filterType: ['모두', '인기', '근처', '생활', '동네', '느낌'])) {
    on<HomeFormEvent>((event, emit) {
      final homeState = state as HomeFormState;

      emit(homeState.copyWith(
        filterType: event.filterType ?? homeState.filterType,
        selectedIndex: event.selectedIndex ?? homeState.selectedIndex,
        pageIndex: event.pageIndex ?? homeState.pageIndex,
        starIndex: event.starIndex ?? homeState.starIndex,
      ));
    });
  }
}
