import 'package:go_router/go_router.dart';
import 'package:o2/presentation/screens/auth/sign_in/sign_in_screen.dart';
import 'package:o2/presentation/screens/auth/sign_up/sign_up_screen.dart';
import 'package:o2/presentation/screens/chat/send_location_screen.dart';
import 'package:o2/presentation/screens/home_screen.dart';
import 'package:o2/presentation/screens/map/add_shop_page.dart';
import 'package:o2/presentation/screens/map/recommended_shop_page.dart';
import 'package:o2/presentation/screens/map/map_screen.dart';
import 'package:o2/presentation/screens/map/search_address_page.dart';
import 'package:o2/presentation/screens/map/star_rating_page.dart';
import 'package:o2/presentation/screens/map/transaction_location_page.dart';
import 'package:o2/presentation/screens/my/my_favorite_screen.dart';
import 'package:o2/presentation/screens/my/my_profile_screen.dart';
import 'package:o2/presentation/screens/my/my_purchase_history_screen.dart';
import 'package:o2/presentation/screens/my/my_sales_history_screen.dart';
import 'package:o2/presentation/screens/my/my_screen.dart';
import 'package:o2/presentation/screens/my/my_setting_screen.dart';
import 'package:o2/presentation/screens/product/widgets/product_list_view.dart';
import 'presentation/screens/chat/chat_list_screen.dart';
import 'presentation/screens/chat/chat_room_screen.dart';
import 'presentation/screens/product/detail_screen.dart';
import 'presentation/screens/product/write_screen.dart';
import 'presentation/screens/search/search_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:o2/presentation/providers/auth_provider.dart';

final routerProvider = Provider<GoRouter>(
  (ref) {
    final auth = ref.watch(authProvider);

    return GoRouter(
      initialLocation: "/home",
      redirect: (context, state) {
        if (auth != null && state.matchedLocation == "/signIn") {
          return "/home";
        }

        if (auth == null &&
            state.matchedLocation != "/signIn" &&
            state.matchedLocation != "/signUp") {
          return "/signIn";
        }

        return null;
      },
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
        ),
        GoRoute(
          path: "/chat_room",
          builder: (context, state) {
            final chatRoomId =
                (state.extra as Map<String, String>)['chatRoomId'];
            final otherUserId =
                (state.extra as Map<String, String>)['otherUserId']!;
            final productID =
                (state.extra as Map<String, String>)['productID']!;

            return ChatRoomScreen(
              chatRoomId: chatRoomId,
              otherUserId: otherUserId,
              productID: productID,
            );
          },
        ),
        GoRoute(
          path: "/send_location",
          builder: (context, state) {
            final chatRoomId = (state.extra as Map<String, String>)['chatRoomId'];
            final otherUserId = (state.extra as Map<String, String>)['otherUserId']!;
            final productID = (state.extra as Map<String, String>)['productID']!;

            return SendLocationScreen(
              chatRoomId: chatRoomId,
              otherUserId: otherUserId,
              productID: productID,
            );
          },
        ),
        GoRoute(
          path: "/product",
          builder: (context, state) => const ProductListView(),
        ),
        GoRoute(
          path: "/transactionMap",
          builder: (context, state) => const TransactionLocationPage(),
        ),
        GoRoute(
            path: "/map",
            builder: (context, state) => const MapScreen(),
            routes: [
              GoRoute(
                  path: "/addShop",
                  builder: (context, state) => const AddShopPage(),
                  routes: [
                    GoRoute(
                      path: "/searchAddr",
                      builder: (context, state) => const SearchAddressPage(),
                    ),
                  ]),
              GoRoute(
                  path: "/recommendShop",
                  builder: (context, state) => RecommendedShopPage(),
                  routes: [
                    GoRoute(
                      path: "/starRating",
                      builder: (context, state) => StarRatingPage(),
                    ),
                  ]),
            ]),
        GoRoute(
          path: "/my",
          builder: (context, state) => const MyScreen(),
          routes: [
            GoRoute(
              path: "/setting",
              builder: (context, state) => const MySettingScreen(),
            ),
            GoRoute(
              path: "/profile",
              builder: (context, state) => const MyProfileScreen(),
            ),
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
          ],
        ),
      ],
    );
  },
);
