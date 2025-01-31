import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:o2/core/theme/app_theme.dart';
import 'package:o2/core/utils/permission_manager.dart';
import 'package:o2/firebase_options.dart';
import 'package:o2/presentation/screens/chat/chat_list_screen.dart';
import 'package:o2/presentation/screens/chat/chat_room_screen.dart';
import 'package:o2/presentation/screens/home_screen.dart';
import 'package:o2/presentation/screens/product/detail_screen.dart';
import 'package:o2/presentation/screens/product/write_screen.dart';
import 'package:o2/presentation/screens/search/search_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NaverMapSdk.instance.initialize();
  await PermissionManager().requestLocationPermission();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
    });

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: AppTheme.light(),
    );
  }
}

final GoRouter router = GoRouter(
  initialLocation: "/",
  routes: <RouteBase>[
    GoRoute(
      path: "/",
      builder: (context, state) => const HomeScreen(),
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
            path: ':id',
            builder: (context, state) =>
                ChatRoomScreen(chatRoomId: state.pathParameters['id']!),
          ),
        ],
    ),
  ],
);
