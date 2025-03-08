import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personal_select_chat/core/app/provider/app_bloc_provider.dart';
import 'package:personal_select_chat/presentation/favorite/favorite_screen.dart';

void main() {
  testWidgets("Favorite Rendering Check", (WidgetTester tester) async {
    debugPrint("[1] Favorite Rendering Check 시작");

    await tester.pumpWidget(AppBlocProviders(
        child: MaterialApp(
      home: FavoriteScreen(),
    )));

    await tester.pumpAndSettle();

    debugPrint("# 화면의 모든 텍스트:");
    for (var widget in find.byType(Text).evaluate()) {
      debugPrint("- ${(widget.widget as Text).data}");
    }

    expect(find.text("수연, 26"), findsOneWidget);
    expect(find.text("지은, 29"), findsOneWidget);
    expect(find.text("은지, 24"), findsOneWidget);

    await tester.pump(Duration(milliseconds: 500));
    debugPrint("[1] Favorite Rendering Check 종료");
  });
}
