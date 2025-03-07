import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_select_chat/core/app/provider/app_bloc_provider.dart';
import 'package:personal_select_chat/core/app/router/app_router.dart';
import 'package:personal_select_chat/core/app/router/router_bloc.dart';
import 'package:personal_select_chat/core/app/router/router_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(AppBlocProviders(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
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
