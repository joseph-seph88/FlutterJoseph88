import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:personal_select_chat/core/app/provider/app_bloc_provider.dart';
import 'package:personal_select_chat/core/utils/app_constant.dart';
import 'package:personal_select_chat/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('App Flow Test', (tester) async {
    debugPrint("[1] App Flow Test 시작");

    await tester.pumpWidget(AppBlocProviders(child: MyApp()));
    await tester.pumpAndSettle();

    expect(find.text("로그인"), findsOneWidget);
    final emailField = find.byKey(Key('emailField'));
    final passwordField = find.byKey(Key('passwordField'));
    final loginButton = find.text('로그인');
    await tester.enterText(emailField, 'admin');
    await tester.enterText(passwordField, 'admin');

    await tester.tap(loginButton);
    await tester.pump(Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    expect(find.text('발견하기'), findsOneWidget);
    expect(find.text(AppString.favorite), findsOneWidget);
    final favoriteLabel = find.text(AppString.favorite);

    await tester.tap(favoriteLabel);
    await tester.pump(Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    expect(find.text('관심있는 사람 찾기'), findsOneWidget);
    expect(find.text(AppString.message), findsOneWidget);
    final messageLabel = find.text(AppString.message);

    await tester.tap(messageLabel);
    await tester.pump(Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    expect(find.text('메시지 입력..'), findsOneWidget);
    expect(find.text(AppString.profile), findsOneWidget);
    final profileLabel = find.text(AppString.profile);

    await tester.tap(profileLabel);
    await tester.pump(Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    expect(find.text('김프릭, 28'), findsOneWidget);

    final scrollView = find.byKey(Key("profileScrollView"));
    await tester.drag(scrollView, Offset(0, -600));
    await tester.pump(Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    final logoutButton = find.byKey(Key('logoutButton'));
    expect(logoutButton, findsOneWidget);
    await tester.tap(logoutButton);
    await tester.pump(Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    expect(find.text("로그인"), findsOneWidget);
    debugPrint("[1] App Flow Test 종료");
  });
}
