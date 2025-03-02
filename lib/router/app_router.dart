import 'package:go_router/go_router.dart';
import 'package:personal_select_chat/presentation/screens/favorite_screen.dart';
import 'package:personal_select_chat/presentation/screens/home_screen.dart';
import 'package:personal_select_chat/presentation/screens/main_screen.dart';
import 'package:personal_select_chat/presentation/screens/profile_screen.dart';
import 'package:personal_select_chat/router/router_state.dart';
import '../presentation/screens/chat_screen.dart';
import 'router_bloc.dart';

class AppRouter {
  static const String main = '/';
  static const String home = '/home';
  static const String favorite = '/favorite';
  static const String chat = '/chat';
  static const String profile = '/profile';

  static GoRouter createRouter(RouterBloc routerBloc) {
    return GoRouter(
      initialLocation: routerBloc.state is RouterAuthenticated ? main : main,
      routes: [
        GoRoute(
          path: main,
          builder: (context, state) => MainScreen(),
        ),
        GoRoute(
          path: home,
          builder: (context, state) => HomeScreen(),
        ),
        GoRoute(
          path: favorite,
          builder: (context, state) => FavoriteScreen(),
        ),
        GoRoute(
          path: chat,
          builder: (context, state) => ChatScreen(),
        ),
        GoRoute(
          path: profile,
          builder: (context, state) => ProfileScreen(),
        ),
      ],
    );
  }
}
