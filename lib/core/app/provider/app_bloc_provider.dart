import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_select_chat/bloc/chat/chat_bloc.dart';
import 'package:personal_select_chat/bloc/home/home_bloc.dart';
import 'package:personal_select_chat/bloc/login/login_bloc.dart';
import 'package:personal_select_chat/core/app/router/router_bloc.dart';
import 'package:flutter/material.dart';
  
class AppBlocProviders extends StatelessWidget {
  const AppBlocProviders({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => RouterBloc()),
        BlocProvider(create: (context) => ChatBloc()),
        BlocProvider(create: (context) => LoginBloc()),
        BlocProvider(create: (context) => HomeBloc()),
      ],
      child: child,
    );
  }
}
