import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hofu/hofu.dart';
import 'package:hofu/my_home_page.dart';
import 'package:timezone/timezone.dart' as tz;

class HofuForm extends ConsumerStatefulWidget {
  const HofuForm({super.key});

  @override
  HofuFormState createState() => HofuFormState();
}

class HofuFormState extends ConsumerState<HofuForm> {
  final hofuContentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    hofuContentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    hofuContentController.text = ref.read(hofuProvider).content;
    var buttonText = hofuContentController.text.isEmpty ? '登録' : '更新';

    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ElevatedButton(
              key: const Key('createButton'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              onPressed: () {
                if(_formKey.currentState!.validate()) {
                  ref.read(hofuProvider.notifier).createHofu(hofuContentController.text);
                  _zonedScheduleNotification();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('毎月1日の20時に通知します。')),
                  );
                  Navigator.pop(context);
                }
              },
              child: Text(buttonText),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: TextFormField(
            key: const Key('hofuTextFormField'),
            controller: hofuContentController,
            keyboardType: TextInputType.multiline,
            autofocus: true,
            maxLines: 100,
            decoration: const InputDecoration(
              hintText: '(例) 本を毎月1冊以上読む📚',
            ),
            validator: (value) {
              if(value == null || value.isEmpty) {
                return '何か文章を入力してください。';
              }
              return null;
            }
          ),
        ),
      ),
    );
  }

  // 毎月1日の20時に通知する
  Future<void> _zonedScheduleNotification() async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'HOFU',
      '抱負を思い出しましょう💪',
      tz.TZDateTime.local(2100, 1, 1, 20),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'hofu',
          '毎月1日の通知',
          channelDescription: '月に一度抱負を思い出すために、毎月1日の20時にリマインドメッセージを通知します。',
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfMonthAndTime,
    );
  }
}