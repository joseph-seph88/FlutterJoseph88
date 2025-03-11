import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personal_select_chat/core/app/app_bloc/app_bloc_provider.dart';
import 'package:personal_select_chat/presentation/chat/screens/chat_screen.dart';

void main() {
  testWidgets("Chat Rendering Check", (WidgetTester tester) async {
    debugPrint("[1] Chat Rendering Check 시작");

    await tester.pumpWidget(AppBlocProviders(
        child: MaterialApp(
      home: ChatScreen(),
    )));

    await tester.pumpAndSettle();

    debugPrint("# 화면의 모든 텍스트:");
    for (var widget in find.byType(Text).evaluate()) {
      debugPrint("- ${(widget.widget as Text).data}");
    }

    expect(find.text("메시지 입력.."), findsOneWidget);

    final chatTextField = find.byKey(Key("chatTextField"));
    await tester.enterText(chatTextField, "안녕하세요");
    await tester.pump();

    final chatSendButton = find.byKey(Key("chatSendButton"));
    await tester.tap(chatSendButton);
    await tester.pump(Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    expect(find.text("안녕하세요"), findsOneWidget);

    await tester.pump(Duration(milliseconds: 500));
    debugPrint("[1] Chat Rendering Check 종료");
  });
}
