import 'package:go_router/go_router.dart';
import 'package:o2/presentation/screens/auth/sign_in/sign_in_screen.dart';
import 'package:o2/presentation/screens/auth/sign_up/sign_up_screen.dart';
import 'package:o2/presentation/screens/map/add_shop_page.dart';
import 'package:o2/presentation/screens/map/like_shop_page.dart';
import 'package:o2/presentation/screens/map/map_screen.dart';
import 'package:o2/presentation/screens/my/my_favorite_screen.dart';
import 'package:o2/presentation/screens/my/my_purchase_history_screen.dart';
import 'package:o2/presentation/screens/my/my_sales_history_screen.dart';
import 'package:o2/presentation/screens/my/my_screen.dart';
import 'package:o2/presentation/screens/product/widgets/product_list_view.dart';
import 'presentation/screens/chat/chat_list_screen.dart';
import 'presentation/screens/chat/chat_room_screen.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/screens/product/detail_screen.dart';
import 'presentation/screens/product/write_screen.dart';
import 'presentation/screens/search/search_screen.dart';

GoRouter get router => _router;

final GoRouter _router = GoRouter(
  initialLocation: "/signIn",
  routes: <RouteBase>[
    GoRoute(
      path: "/signIn",
      builder: (context, state) => const SignInScreen(),
    ),
    GoRoute(
      path: "/signUp",
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      path: "/home",
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
      builder: (context, state) => const ChatListScreen(),
      routes: [
        GoRoute(
          path: '/chat_room',
          builder: (context, state) {
            final chatRoomId =
                (state.extra as Map<String, String>)['chatRoomId'];
            final otherUserId =
                (state.extra as Map<String, String>)['otherUserId']!;

            return ChatRoomScreen(
              chatRoomId: chatRoomId,
              otherUserId: otherUserId,
            );
          },
        ),
      ],
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
        ]),
    GoRoute(
        path: "/my",
        builder: (context, state) => const MyScreen(),
        routes: [
          GoRoute(
            path: "/favorite",
            builder: (context, state) => const MyFavoriteScreen(),
          ),
          GoRoute(
            path: "/salesHistory",
            builder: (context, state) => const MySalesHistoryScreen(),
          ),
          GoRoute(
            path: "/purchaseHistory",
            builder: (context, state) => const MyPurchaseHistoryScreen(),
          )
        ]),
  ],
);
