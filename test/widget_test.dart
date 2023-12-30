import 'package:flutter_test/flutter_test.dart';
import 'package:hofu/main.dart';

void main() {
  testWidgets('hofu is displayed', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('This is my hofu.'), findsOneWidget);
  });
}
