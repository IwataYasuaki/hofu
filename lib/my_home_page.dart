import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hofu/hofu.dart';
import 'package:hofu/hofu_form.dart';
import 'package:timezone/timezone.dart' as tz;

final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends ConsumerState<MyHomePage> {
  @override
  void initState() {
    super.initState();
    _requestPermissions();
    _zonedScheduleNotification();
  }

  @override
  Widget build(BuildContext context) {
    Hofu hofu = ref.watch(hofuProvider);

    final AppBar appBar = AppBar(
      title: const Text('抱負'),
      centerTitle: true,
    );

    // 抱負が未登録の場合、自動的に抱負フォームを表示する。
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (hofu.content.isEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const HofuForm(),
            fullscreenDialog: true,
          ),
        );
      }
    });

    // 抱負が未登録の場合、抱負フォームを開くボタンを表示する。
    // 初回起動時、自動的に表示された抱負フォームが閉じられた場合。
    if (hofu.content.isEmpty) {
      return Scaffold(
        appBar: appBar,
        body: const Center(
          child: CreateHofuButton(),
        ),
      );
    }

    // 通常のホーム画面を表示する。
    return Scaffold(
      appBar: appBar,
      body: Center(
        child: HofuText(hofu: hofu),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const HofuForm(),
              fullscreenDialog: true,
            ),
          );
        },
        child: const Icon(Icons.edit),
      ),
    );
  }

  Future<void> _requestPermissions() async {
    if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      await androidImplementation?.requestNotificationsPermission();
    }
  }

  // 毎月1日の20時に通知する
  Future<void> _zonedScheduleNotification() async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'HOFU',
      '抱負を思い出しましょう💪',
      tz.TZDateTime.local(2100, 1, 1, 20),
      const NotificationDetails(
          android: AndroidNotificationDetails('hofu', '毎月1日の通知',
              channelDescription: '月に一度抱負を思い出すために、毎月1日の20時にリマインドメッセージを通知します。')),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfMonthAndTime,
    );
  }
}

class CreateHofuButton extends StatelessWidget {
  const CreateHofuButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const HofuForm(),
            fullscreenDialog: true,
          ),
        );
      },
      child: const Text('抱負を登録'),
    );
  }
}

class HofuText extends StatelessWidget {
  const HofuText({
    super.key,
    required this.hofu,
  });

  final Hofu hofu;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        hofu.content,
        style: const TextStyle(fontSize: 20),
      ),
    );
  }
}
