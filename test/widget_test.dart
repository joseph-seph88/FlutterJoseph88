import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_class_16_deploy/main.dart';

void main() {
    setUpAll(() async {
    await dotenv.load(fileName: ".env");
  });
  testWidgets("버튼 클릭 시 UI 테스트", (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    expect(find.text('no name'), findsOneWidget);
    expect(find.text('no url'), findsOneWidget);

    await tester.tap(find.text('name button'));
    await tester.pump();

    expect(find.text("${dotenv.env['MASTER_NAME']}"), findsOneWidget);

    await tester.tap(find.text('url button'));
    await tester.pump();

    expect(find.text("${dotenv.env['API_URL']}"), findsOneWidget);
  });
}
