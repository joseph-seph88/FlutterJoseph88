import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:project_login/app/router/route_name.dart';
import 'package:project_login/app/router/routes.dart';
import 'package:project_login/feature/auth/cubit/login_cubit.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
  routes: appRoutes,
  // redirect: (context, state) {
  //   final authState = context.read<LoginCubit>().state;
  //   if (authState.status != FormzSubmissionStatus.success &&
  //       state.uri.toString() != RouteNames.login) {
  //     debugPrint(
  //         "[ROUTNG_INFO] ${state.uri.toString()} // ${authState.status}");
  //     return '/login';
  //   }
  //   return null;
  // },
  // errorBuilder: (context, state) => ErrorScreen(state.error),
);
