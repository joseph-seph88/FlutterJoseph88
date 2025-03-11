import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:personal_select_chat/core/app/app_bloc/app_bloc_provider.dart';
import 'package:personal_select_chat/presentation/home/screens/home_screen.dart';

void main() {
  testWidgets("Home Filter Chips Test", (WidgetTester tester) async {
    debugPrint("[1] Home Rendering Check 시작");

    await tester.pumpWidget(AppBlocProviders(
        child: MaterialApp(
      home: HomeScreen(),
    )));

    expect(find.text("발견하기"), findsOneWidget);

    final firstChipContainer = find.byKey(Key("chipContainer_0"));
    final firstContainerWidget = tester.widget(firstChipContainer) as Container;
    expect((firstContainerWidget.decoration as BoxDecoration).color,
        Color(0xFFFF4D67));

    final secondChipContainer = find.byKey(Key('chipContainer_1'));
    final secondChipContainerWidget =
        tester.widget(secondChipContainer) as Container;
    expect((secondChipContainerWidget.decoration as BoxDecoration).color,
        Colors.grey.shade100);

    final secondChips = find.byKey(Key('chips_2'));
    await tester.tap(secondChips);
    await tester.pumpAndSettle();

    final thirdChipContainer = find.byKey(Key('chipContainer_2'));
    final thirdChipContainerWidget =
        tester.widget(thirdChipContainer) as Container;

    final secondColor =
        (thirdChipContainerWidget.decoration as BoxDecoration).color;
    expect(secondColor, Color(0xFFFF4D67));

    await tester.pump(Duration(milliseconds: 500));
    debugPrint("[1] Home Rendering Check 종료");
  });

  testWidgets("Home Card Test", (WidgetTester tester) async {
    debugPrint("[2] Home Card Test 시작");

    await tester.pumpWidget(AppBlocProviders(
        child: MaterialApp(
      home: HomeScreen(),
    )));

    await tester.pumpAndSettle();

    expect(find.text("유진, 27"), findsOneWidget);
    final closeButton = find.byKey(Key("closeButton"));
    final starButton = find.byKey(Key("starButton"));
    final favoriteButton = find.byKey(Key("favoriteButton"));

    await tester.tap(closeButton);
    await tester.pumpAndSettle();
    expect(find.text("미소, 27"), findsOneWidget);

    await tester.tap(favoriteButton);
    await tester.pumpAndSettle();
    expect(find.text("사라, 27"), findsOneWidget);

    await tester.tap(starButton);
    await tester.pumpAndSettle();
    expect(find.text("매력을 평가해주세요"), findsOneWidget);

    debugPrint("# 화면의 모든 텍스트:");
    for (var widget in find.byType(Text).evaluate()) {
      debugPrint("- ${(widget.widget as Text).data}");
    }

    await tester.pump(Duration(milliseconds: 500));
    debugPrint("[2] Home Card Test 종료");
  });
}
