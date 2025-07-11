import 'package:ai_hair_official/features/hair/presentation/pages/photo_upload_page.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  // initialLocation: '/',
  // redirect: (context, state) {
  //   return null;
  // },
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => PhotoUploadPage(),
    ),
  ],
);
