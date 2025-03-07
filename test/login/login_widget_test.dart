import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_select_chat/bloc/login/login_bloc.dart';
import 'package:personal_select_chat/bloc/login/login_event.dart';
import 'package:personal_select_chat/bloc/login/login_state.dart';
import 'package:personal_select_chat/core/app/provider/app_bloc_provider.dart';
import 'package:personal_select_chat/core/app/router/app_router.dart';
import 'package:personal_select_chat/presentation/entry/entry_screen.dart';
import 'package:personal_select_chat/presentation/login/screens/login_screen.dart';
import 'package:personal_select_chat/presentation/login/screens/register_screen.dart';

void main() {
  group("로그인 화면 테스트", () {
    testWidgets("UI Rendering Check", (WidgetTester tester) async {
      debugPrint("[1] UI Rendering Check 시작");

      await tester.pumpWidget(AppBlocProviders(
          child: MaterialApp(
        home: LoginScreen(),
      )));

      debugPrint("# 화면의 모든 텍스트:");
      for (var widget in find.byType(Text).evaluate()) {
        debugPrint("- ${(widget.widget as Text).data}");
      }

      expect(find.text("로그인"), findsOneWidget);
      expect(find.text("비밀번호를 잊으셨나요?"), findsOneWidget);
      expect(find.text("회원가입"), findsOneWidget);
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
      expect(find.byIcon(Icons.g_mobiledata), findsOneWidget);
      expect(find.byIcon(Icons.phone_android), findsOneWidget);
      expect(find.byIcon(Icons.chat_bubble), findsOneWidget);

      await tester.pump(Duration(milliseconds: 500));
      debugPrint("[1] UI Rendering Check 종료");
    });

    testWidgets("Validator Check", (WidgetTester tester) async {
      debugPrint("[2] Validator Check 시작");

      await tester.pumpWidget(AppBlocProviders(
          child: MaterialApp(
        home: LoginScreen(),
      )));

      final loginButton = find.text("로그인");

      await tester.tap(loginButton);
      await tester.pump();

      expect(find.text("이메일을 입력해주세요"), findsOneWidget);
      expect(find.text("비밀번호를 입력해주세요"), findsOneWidget);

      await tester.pump(Duration(milliseconds: 500));
      debugPrint("[2] Validator Check 종료");
    });

    testWidgets("Password Visible Button Check", (WidgetTester tester) async {
      debugPrint("[3] Password Visible Button Check 시작");

      await tester.pumpWidget(AppBlocProviders(
          child: MaterialApp(
        home: LoginScreen(),
      )));

      final passwordField = find.byKey(Key('passwordField'));
      await tester.enterText(passwordField, '123456');
      await tester.pumpAndSettle();

      final visibleIcon = find.byIcon(Icons.visibility_off);
      await tester.tap(visibleIcon);
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.visibility), findsOneWidget);
      expect(find.text('123456'), findsWidgets);

      await tester.pump(Duration(milliseconds: 500));
      debugPrint("[3] Password Visible Button Check 종료");
    });

    testWidgets("SignUp 화면 전환 Check", (WidgetTester tester) async {
      debugPrint("[4] SignUp 화면 전환 Check 시작");
      tester.view.physicalSize = Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;

      final GoRouter router = GoRouter(
        initialLocation: AppRouter.login,
        routes: [
          GoRoute(
            path: AppRouter.login,
            builder: (context, state) => LoginScreen(),
          ),
          GoRoute(
            path: AppRouter.register,
            builder: (context, state) => RegisterScreen(),
          ),
        ],
      );

      await tester.pumpWidget(AppBlocProviders(
          child: MaterialApp.router(
        routerConfig: router,
      )));

      await tester.pumpAndSettle();
      final signUpButton = find.text('회원가입');
      await tester.tap(signUpButton);
      await tester.pumpAndSettle();

      debugPrint("# 화면의 모든 텍스트:");
      for (var widget in find.byType(Text).evaluate()) {
        debugPrint("- ${(widget.widget as Text).data}");
      }
      expect(find.text("회원가입"), findsNWidgets(2));

      addTearDown(tester.view.resetPhysicalSize);
      await tester.pump(Duration(milliseconds: 500));
      debugPrint("[4] SignUp 화면 전환 Check 종료");
    });

    testWidgets("Home 화면 전환 Check", (WidgetTester tester) async {
      debugPrint("[5] Home 화면 전환 Check 시작");
      final GoRouter router = GoRouter(
        initialLocation: AppRouter.login,
        routes: [
          GoRoute(
            path: AppRouter.login,
            builder: (context, state) => LoginScreen(),
          ),
          GoRoute(
            path: AppRouter.entry,
            builder: (context, state) => EntryScreen(),
          ),
        ],
      );

      await tester.pumpWidget(AppBlocProviders(
          child: MaterialApp.router(
        routerConfig: router,
      )));

      final loginButton = find.text('로그인');
      final emailField = find.byKey(Key('emailField'));
      final passwordField = find.byKey(Key('passwordField'));

      await tester.enterText(emailField, "example@gmail.com");
      await tester.enterText(passwordField, "123456");
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      debugPrint("# 화면의 모든 텍스트:");
      for (var widget in find.byType(Text).evaluate()) {
        debugPrint("- ${(widget.widget as Text).data}");
      }
      expect(find.text("발견하기"), findsOneWidget);

      await tester.pump(Duration(milliseconds: 500));
      debugPrint("[5] Home 화면 전환 Check 종료");
    });
  });

  group("회원가입 화면 테스트", () {
    testWidgets("UI Rendering Check", (WidgetTester tester) async {
      debugPrint("[1] UI Rendering Check 시작");

      await tester.pumpWidget(AppBlocProviders(
          child: MaterialApp(
        home: RegisterScreen(),
      )));

      await tester.pumpAndSettle();
      expect(find.text("회원가입"), findsNWidgets(2));
      expect(find.text("생년월일"), findsOneWidget);
      expect(find.text("성별"), findsOneWidget);
      expect(find.text("남성"), findsOneWidget);
      expect(find.text("여성"), findsOneWidget);

      expect(find.byIcon(Icons.visibility_off), findsNWidgets(2));
      expect(find.byIcon(Icons.email), findsOneWidget);
      expect(find.byIcon(Icons.cake), findsOneWidget);
      expect(find.byIcon(Icons.lock), findsOneWidget);
      expect(find.byIcon(Icons.lock_outline), findsOneWidget);
      expect(find.byIcon(Icons.male), findsOneWidget);
      expect(find.byIcon(Icons.female), findsOneWidget);

      await tester.pump(Duration(milliseconds: 500));
      debugPrint("[1] UI Rendering Check 종료");
    });

    testWidgets("Name Validator Check", (WidgetTester tester) async {
      debugPrint("[2] Name Validator Check 시작");
      tester.view.physicalSize = Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(AppBlocProviders(
          child: MaterialApp(
        home: RegisterScreen(),
      )));

      await tester.pumpAndSettle();
      final signUpButton = find.byKey(Key('signUp'));
      final scrollView = find.byKey(Key("scrollView"));
      await tester.drag(scrollView, Offset(0, -200));
      await tester.pumpAndSettle();

      await tester.tap(signUpButton);
      await tester.pumpAndSettle();

      expect(find.text("이름을 입력해주세요"), findsOneWidget);

      final nameField = find.byKey(Key('nameField'));
      await tester.enterText(nameField, "Joseph");
      await tester.tap(signUpButton);
      await tester.pumpAndSettle();

      expect(find.text("이름을 입력해주세요"), findsNothing);

      addTearDown(tester.view.resetPhysicalSize);
      await tester.pump(Duration(milliseconds: 500));
      debugPrint("[2] Name Validator Check 종료");
    });

    testWidgets("Email Validator Check", (WidgetTester tester) async {
      debugPrint("[3] Email Validator Check 시작");
      tester.view.physicalSize = Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(AppBlocProviders(
          child: MaterialApp(
        home: RegisterScreen(),
      )));

      await tester.pumpAndSettle();
      final emailField = find.byKey(Key('emailField'));
      final signUpButton = find.byKey(Key('signUp'));
      final scrollView = find.byKey(Key("scrollView"));
      await tester.drag(scrollView, Offset(0, -200));
      await tester.pumpAndSettle();

      await tester.tap(signUpButton);
      await tester.pumpAndSettle();
      expect(find.text("이메일을 입력해주세요"), findsOneWidget);

      await tester.enterText(emailField, "Joseph");
      await tester.tap(signUpButton);
      await tester.pumpAndSettle();
      expect(find.text("올바른 이메일 형식이 아닙니다"), findsOneWidget);

      await tester.enterText(emailField, "Joseph@gmail");
      await tester.tap(signUpButton);
      await tester.pumpAndSettle();
      expect(find.text("올바른 이메일 형식이 아닙니다"), findsOneWidget);

      await tester.enterText(emailField, "Joseph@gmail.com");
      await tester.tap(signUpButton);
      await tester.pumpAndSettle();
      expect(find.text("이메일을 입력해주세요"), findsNothing);
      expect(find.text("올바른 이메일 형식이 아닙니다"), findsNothing);

      addTearDown(tester.view.resetPhysicalSize);
      await tester.pump(Duration(milliseconds: 500));
      debugPrint("[3] Email Validator Check 종료");
    });

    testWidgets("Password Validator Check", (WidgetTester tester) async {
      debugPrint("[4] Password Validator Check 시작");
      tester.view.physicalSize = Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(AppBlocProviders(
          child: MaterialApp(
        home: RegisterScreen(),
      )));

      await tester.pumpAndSettle();
      final passwordField = find.byKey(Key('passwordField'));
      final signUpButton = find.byKey(Key('signUp'));
      final scrollView = find.byKey(Key("scrollView"));
      await tester.drag(scrollView, Offset(0, -200));
      await tester.pumpAndSettle();

      await tester.tap(signUpButton);
      await tester.pumpAndSettle();
      expect(find.text("비밀번호를 입력해주세요"), findsNWidgets(2));

      await tester.enterText(passwordField, "123456");
      await tester.tap(signUpButton);
      await tester.pumpAndSettle();
      expect(find.text("비밀번호는 최소 8자 이상이어야 합니다"), findsOneWidget);

      await tester.enterText(passwordField, "123456aa");
      await tester.tap(signUpButton);
      await tester.pumpAndSettle();
      expect(
          find.text("비밀번호는 영문, 숫자, 특수문자가 각각 1개 이상 포함되어야 합니다"), findsOneWidget);

      await tester.enterText(passwordField, "123456aa!");
      await tester.tap(signUpButton);
      await tester.pumpAndSettle();
      expect(find.text("비밀번호는 최소 8자 이상이어야 합니다"), findsNothing);
      expect(find.text("비밀번호는 영문, 숫자, 특수문자가 각각 1개 이상 포함되어야 합니다"), findsNothing);

      addTearDown(tester.view.resetPhysicalSize);
      await tester.pump(Duration(milliseconds: 500));
      debugPrint("[4] Password Validator Check 종료");
    });

    testWidgets("Confirm Password Validator Check",
        (WidgetTester tester) async {
      debugPrint("[5] Confirm Password Validator Check 시작");
      tester.view.physicalSize = Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(AppBlocProviders(
          child: MaterialApp(
        home: RegisterScreen(),
      )));

      await tester.pumpAndSettle();
      final confirmPasswordField = find.byKey(Key('confirmPasswordField'));
      final passwordField = find.byKey(Key('passwordField'));
      final signUpButton = find.byKey(Key('signUp'));
      final scrollView = find.byKey(Key("scrollView"));
      await tester.drag(scrollView, Offset(0, -200));
      await tester.pumpAndSettle();

      await tester.tap(signUpButton);
      await tester.pumpAndSettle();
      expect(find.text("비밀번호를 입력해주세요"), findsNWidgets(2));

      await tester.enterText(confirmPasswordField, "123456");
      await tester.tap(signUpButton);
      await tester.pumpAndSettle();
      expect(find.text("비밀번호는 최소 8자 이상이어야 합니다"), findsOneWidget);

      await tester.enterText(confirmPasswordField, "123456aa");
      await tester.tap(signUpButton);
      await tester.pumpAndSettle();
      expect(
          find.text("비밀번호는 영문, 숫자, 특수문자가 각각 1개 이상 포함되어야 합니다"), findsOneWidget);

      await tester.enterText(confirmPasswordField, "123456aa@");
      await tester.tap(signUpButton);
      await tester.pumpAndSettle();
      expect(find.text("비밀번호가 서로 다릅니다"), findsOneWidget);

      await tester.enterText(confirmPasswordField, "123456aa!");
      await tester.enterText(passwordField, "123456aa!");
      await tester.tap(signUpButton);
      await tester.pumpAndSettle();
      expect(find.text("비밀번호는 최소 8자 이상이어야 합니다"), findsNothing);
      expect(find.text("비밀번호는 영문, 숫자, 특수문자가 각각 1개 이상 포함되어야 합니다"), findsNothing);
      expect(find.text("비밀번호가 서로 다릅니다"), findsNothing);

      addTearDown(tester.view.resetPhysicalSize);
      await tester.pump(Duration(milliseconds: 500));
      debugPrint("[5] Confirm Password Validator Check 종료");
    });

    testWidgets("SignIn 화면 전환 Check", (WidgetTester tester) async {
      debugPrint("[6] SignIn 화면 전환 Check 시작");
      tester.view.physicalSize = Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;

      final GoRouter router = GoRouter(
        initialLocation: AppRouter.login,
        routes: [
          GoRoute(
            path: AppRouter.login,
            builder: (context, state) => LoginScreen(),
          ),
          GoRoute(
            path: AppRouter.register,
            builder: (context, state) => RegisterScreen(),
          ),
        ],
      );

      await tester.pumpWidget(AppBlocProviders(
          child: MaterialApp.router(
        routerConfig: router,
      )));

      await tester.pumpAndSettle();
      final signUpButton = find.text('회원가입');
      await tester.tap(signUpButton);
      await tester.pumpAndSettle();
      expect(find.text("회원가입"), findsNWidgets(2));

      final signInButton = find.byKey(Key('backButton'));
      await tester.tap(signInButton);
      await tester.pumpAndSettle();
      expect(find.text("FreakXion"), findsOneWidget);

      addTearDown(tester.view.resetPhysicalSize);
      await tester.pump(Duration(milliseconds: 500));
      debugPrint("[6] SignIn 화면 전환 Check 종료");
    });

    testWidgets("생년월일 선택 Check", (WidgetTester tester) async {
      debugPrint("[7] 생년월일 선택 Check 시작");

      await tester.pumpWidget(
          AppBlocProviders(child: MaterialApp(home: RegisterScreen())));
      await tester.pumpAndSettle();

      final birthDateButton = find.byKey(Key('birthDate'));
      await tester.tap(birthDateButton);
      await tester.pumpAndSettle();

      await tester.tap(find.text('10'));
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      expect(find.text('2000년 1월 10일'), findsOneWidget);

      await tester.pump(Duration(milliseconds: 500));
      debugPrint("[7] 생년월일 선택 Check 종료");
    });

    testWidgets("Password Visible Button Check", (WidgetTester tester) async {
      debugPrint("[8] Password Visible Button Check 시작");

      await tester.pumpWidget(AppBlocProviders(
          child: MaterialApp(
            home: LoginScreen(),
          )));

      final passwordField = find.byKey(Key('passwordField'));
      await tester.enterText(passwordField, '123456');
      await tester.pumpAndSettle();

      final visibleIcon = find.byIcon(Icons.visibility_off);
      await tester.tap(visibleIcon);
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.visibility), findsOneWidget);
      expect(find.text('123456'), findsWidgets);

      await tester.pump(Duration(milliseconds: 500));
      debugPrint("[8] Password Visible Button Check 종료");
    });

    testWidgets("Password Visible Button Check", (WidgetTester tester) async {
      debugPrint("[9] Confirm Password Visible Button Check 시작");

      await tester.pumpWidget(AppBlocProviders(
          child: MaterialApp(
            home: LoginScreen(),
          )));

      final passwordField = find.byKey(Key('passwordField'));
      await tester.enterText(passwordField, '123456');
      await tester.pumpAndSettle();

      final visibleIcon = find.byIcon(Icons.visibility_off);
      await tester.tap(visibleIcon);
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.visibility), findsOneWidget);
      expect(find.text('123456'), findsWidgets);

      await tester.pump(Duration(milliseconds: 500));
      debugPrint("[9] Confirm Password Visible Button Check 종료");
    });
  });
}

//     final Size screenSize = tester.view.physicalSize;
//     final double devicePixelRatio = tester.view.devicePixelRatio;
//     debugPrint('기기 화면 크기: $screenSize');
//     debugPrint('기기 픽셀 비율: $devicePixelRatio');
