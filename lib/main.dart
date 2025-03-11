import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_select_chat/core/app/dependency_injection/get_it_setup.dart';
import 'package:personal_select_chat/core/app/router/app_router.dart';
import 'package:personal_select_chat/core/app/router/router_bloc.dart';
import 'package:personal_select_chat/core/app/router/router_state.dart';
import 'core/app/app_bloc/app_bloc_provider.dart';
import 'core/firebase/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.wait([
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
    GetItSetup().setup(),
  ]);
  runApp(AppBlocProviders(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    return BlocBuilder<RouterBloc, RouterState>(
      builder: (context, state) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig:
              AppRouter.createRouter(BlocProvider.of<RouterBloc>(context)),
        );
      },
    );
  }
}
