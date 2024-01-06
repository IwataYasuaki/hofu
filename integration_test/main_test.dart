import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hofu/main.dart';
import 'package:hofu/my_home_page.dart';
import 'package:hofu/share_preferences_instance.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  await SharedPreferencesInstance.initialize();
  tz.initializeTimeZones();

  const InitializationSettings initializationSettings = InitializationSettings(
    android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    iOS: DarwinInitializationSettings(),
  );

  // TODO: テスト実行中に手動で通知を許可しなくてもいいようにする
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  testWidgets('アプリ初回起動時のテスト', (WidgetTester tester) async {

    // アプリを起動する
    await tester.pumpWidget(const ProviderScope(child: MyApp()));
    var createHofuButton = find.text('抱負を登録');
    expect(createHofuButton, findsOneWidget);

    // 抱負フォームを開く
    await tester.tap(createHofuButton);
    await tester.pumpAndSettle();
    var createButton = find.text('登録');
    expect(createButton, findsOneWidget);

    // 抱負を登録する
    var hofuText = 'This is my Hofu.';
    var hofuTextFormField = find.byKey(const Key('hofuTextFormField'));
    await tester.enterText(hofuTextFormField, hofuText);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('createButton')));
    await tester.pumpAndSettle();
    expect(find.text(hofuText), findsOneWidget);
  });
}
