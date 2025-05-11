import 'package:go_router/go_router.dart';
import 'package:project_login/app/router/route_name.dart';
import 'package:project_login/feature/auth/presentation/pages/login_page.dart';
import 'package:project_login/feature/auth/presentation/pages/sign_up_page.dart';
import 'package:project_login/feature/entry/pages/entry_page.dart';
import 'package:project_login/feature/home/pages/home_page.dart';

final List<GoRoute> appRoutes = [
  GoRoute(
    path: '/',
    name: RouteNames.entry,
    builder: (context, state) => EntryPage(),
  ),
  GoRoute(
    path: '/home',
    name: RouteNames.home,
    builder: (context, state) => HomePage(),
  ),
  GoRoute(
    path: '/login',
    name: RouteNames.login,
    builder: (context, state) => LoginPage(),
  ),
  GoRoute(
    path: '/signUp',
    name: RouteNames.signUp,
    builder: (context, state) => SignUpPage(),
  ),
];
