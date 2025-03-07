import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_select_chat/core/app/router/router_event.dart';
import 'package:personal_select_chat/core/app/router/router_state.dart';

class RouterBloc extends Bloc<RouterEvent, RouterState>{
  RouterBloc() : super(RouterInitial()){
    on<RouterLoginEvent>((event, emit){
      emit(RouterAuthenticated());
    });

    on<RouterLogoutEvent>((event, emit){
      emit(RouterUnAuthenticated());
    });

  }
}