import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_select_chat/core/app/provider/app_bloc_provider.dart';
import 'package:personal_select_chat/core/app/router/app_router.dart';
import 'package:personal_select_chat/presentation/login/screens/login_screen.dart';
import 'package:personal_select_chat/presentation/profile/profile_screen.dart';

void main() {
  testWidgets("profile Rendering Check", (WidgetTester tester) async {
    debugPrint("[1] profile Rendering Check 시작");

    await tester.pumpWidget(AppBlocProviders(
        child: MaterialApp(
      home: ProfileScreen(),
    )));

    await tester.pumpAndSettle();

    debugPrint("# 화면의 모든 텍스트:");
    for (var widget in find.byType(Text).evaluate()) {
      debugPrint("- ${(widget.widget as Text).data}");
    }

    expect(find.text("내 정보"), findsOneWidget);
    expect(find.text("내 관심사"), findsOneWidget);

    await tester.pump(Duration(milliseconds: 500));
    debugPrint("[1] profile Rendering Check 종료");
  });

  testWidgets("profile Rendering Check", (WidgetTester tester) async {
    debugPrint("[2] profile 화면 전환 시작");
    tester.view.physicalSize = Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;

    final GoRouter router = GoRouter(
      initialLocation: AppRouter.profile,
      routes: [
        GoRoute(
          path: AppRouter.profile,
          builder: (context, state) => ProfileScreen(),
        ),
        GoRoute(
          path: AppRouter.login,
          builder: (context, state) => LoginScreen(),
        ),
      ],
    );

    await tester.pumpWidget(AppBlocProviders(
        child: MaterialApp.router(
      routerConfig: router,
    )));

    await tester.pumpAndSettle();

    final logoutButton = find.byKey(Key('logoutButton'));
    expect(logoutButton, findsOneWidget);
    await tester.tap(logoutButton);
    await tester.pump(Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    debugPrint("# 화면의 모든 텍스트:");
    for (var widget in find.byType(Text).evaluate()) {
      debugPrint("- ${(widget.widget as Text).data}");
    }

    expect(find.text("로그인"), findsOneWidget);

    addTearDown(tester.view.resetPhysicalSize);
    await tester.pump(Duration(milliseconds: 500));
    debugPrint("[2] profile 화면 전환 종료");
  });
}
