// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:o2/core/utils/permission_manager.dart';
// import 'package:o2/firebase_options.dart';
import 'package:o2/presentation/screens/home_screen.dart';
import 'package:o2/presentation/screens/home_screen2.dart';
import 'package:o2/presentation/screens/map/add_shop_page.dart';
import 'package:o2/presentation/screens/map/like_shop_page.dart';
import 'package:o2/presentation/screens/map/map_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NaverMapSdk.instance.initialize();
  await PermissionManager().requestLocationPermission();

  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

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
    );
  }
}

final GoRouter router = GoRouter(
  initialLocation: "/",
  routes: <RouteBase>[
    GoRoute(
      path: "/",
      builder: (context, state) {
        return const HomeScreen2();
      },
    ),
    GoRoute(
      path: "/map",
      builder: (context, state) {
        return MapScreen();
      },
    ),
    GoRoute(
      path: "/addShop",
      builder: (context, state) {
        return AddShopPage();
      },
    ),
    GoRoute(
      path: "/likeShop",
      builder: (context, state) {
        return const LikeShopPage();
      },
    ),
  ],
);
