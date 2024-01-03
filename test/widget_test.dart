import 'package:flutter_test/flutter_test.dart';
import 'package:hofu/main.dart';

void main() {
  testWidgets('create hofu', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // expect(find.text('This is my hofu.'), findsOneWidget);
  });
}
