import 'package:ai_hair_official/app/app_router.dart';
import 'package:ai_hair_official/core/locator.dart';
import 'package:ai_hair_official/features/hair/presentation/cubits/hair_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HairCubit>(
          create: (_) => getIt<HairCubit>(),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: router,
      ),
    );
  }
}
