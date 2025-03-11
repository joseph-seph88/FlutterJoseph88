import 'package:go_router/go_router.dart';
import 'package:personal_select_chat/presentation/favorite/favorite_screen.dart';
import 'package:personal_select_chat/presentation/profile/profile_screen.dart';
import 'package:personal_select_chat/presentation/home/screens/home_screen.dart';
import 'package:personal_select_chat/presentation/login/screens/login_screen.dart';
import 'package:personal_select_chat/presentation/entry/entry_screen.dart';
import 'package:personal_select_chat/presentation/login/screens/register_screen.dart';
import 'package:personal_select_chat/core/app/router/router_state.dart';
import '../../../presentation/chat/screens/chat_screen.dart';
import 'router_bloc.dart';

class AppRouter {
  static const String entry = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String favorite = '/favorite';
  static const String chat = '/chat';
  static const String profile = '/profile';

  static GoRouter createRouter(RouterBloc routerBloc) {
    return GoRouter(
      initialLocation: routerBloc.state is RouterAuthenticatedState ? home : login,
      redirect: (context, state) {
        final isAuthenticated = routerBloc.state is RouterAuthenticatedState;
        final isUnAuthenticated =
            routerBloc.state is RouterUnAuthenticatedState;
        final isLoginRoute = state.matchedLocation == login;

        if (isAuthenticated && isLoginRoute) {
          return entry;
        } else if (isUnAuthenticated && isLoginRoute) {
          return login;
        }
        return null;
      },
      routes: [
        GoRoute(path: login, builder: (context, state) => LoginScreen()),
        GoRoute(path: register, builder: (context, state) => RegisterScreen()),
        GoRoute(path: entry, builder: (context, state) => EntryScreen()),
        GoRoute(path: home, builder: (context, state) => HomeScreen()),
        GoRoute(path: favorite, builder: (context, state) => FavoriteScreen()),
        GoRoute(path: chat, builder: (context, state) => ChatScreen()),
        GoRoute(path: profile, builder: (context, state) => ProfileScreen()),
      ],
    );
  }
}
