import 'package:go_router/go_router.dart';

import 'presentation/screens/auth/sign_up/sign_up_screen.dart';
import 'presentation/screens/chat/chat_list_screen.dart';
import 'presentation/screens/chat/chat_room_screen.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/screens/product/detail_screen.dart';
import 'presentation/screens/product/write_screen.dart';
import 'presentation/screens/search/search_screen.dart';

GoRouter get router => _router;

final GoRouter _router = GoRouter(
  initialLocation: "/",
  routes: <RouteBase>[
    GoRoute(
      path: "/",
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: "/signUp",
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      path: "/write",
      builder: (context, state) => const WriteScreen(),
    ),
    GoRoute(
      path: "/detail/:id",
      builder: (context, state) => const ProductDetailScreen(),
    ),
    GoRoute(
      path: "/search",
      builder: (context, state) => const SearchScreen(),
    ),
    GoRoute(
      path: "/chats",
      builder: (context, state) => ChatListScreen(),
      routes: [
        GoRoute(
          path: '/chat_room',
          builder: (context, state) {
            final chatRoomId = (state.extra as Map<String, String>)['chatRoomId'];
            final otherUserId = (state.extra as Map<String, String>)['otherUserId']!;

            return ChatRoomScreen(
              chatRoomId: chatRoomId,
              otherUserId: otherUserId,
            );
          },
        ),
      ],
    ),
  ],
);
