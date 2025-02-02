import 'package:go_router/go_router.dart';
import 'package:o2/presentation/screens/map/add_shop_page.dart';
import 'package:o2/presentation/screens/map/like_shop_page.dart';
import 'package:o2/presentation/screens/map/map_screen.dart';
import 'package:o2/presentation/screens/product/widgets/product_list_view.dart';
import 'presentation/screens/auth/sign_up/sign_up_screen.dart';
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
      path: "/product",
      builder: (context, state) => const ProductListView(),
    ),
    GoRoute(
      path: "/map",
      builder: (context, state) => const MapScreen(),
      routes: [
        GoRoute(
          path: "/addShop",
          builder: (context, state) => const AddShopPage(),
        ),
        GoRoute(
          path: "/likeShop",
          builder: (context, state) => const LikeShopPage(),
        ),
      ]
    ),
  ],
);
