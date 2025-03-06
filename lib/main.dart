import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_select_chat/bloc/chat/chat_bloc.dart';
import 'package:personal_select_chat/bloc/home/home_bloc.dart';
import 'package:personal_select_chat/bloc/login/login_bloc.dart';
import 'package:personal_select_chat/router/app_router.dart';
import 'package:personal_select_chat/router/router_bloc.dart';
import 'package:personal_select_chat/router/router_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiBlocProvider(providers: [
    BlocProvider(create: (context) => RouterBloc()),
    BlocProvider(create: (context) => ChatBloc()),
    BlocProvider(create: (context) => LoginBloc()),
    BlocProvider(create: (context) => HomeBloc()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(systemNavigationBarColor: Colors.black));
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    return BlocBuilder<RouterBloc, RouterState>(builder: (context, state) {
      final routerBloc = context.read<RouterBloc>();
      final router = AppRouter.createRouter(routerBloc);

      return MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: router,
      );
    });
  }
}
