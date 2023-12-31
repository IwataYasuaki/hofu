import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hofu/hofu.dart';
import 'package:hofu/hofu_form.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    Hofu hofu = ref.watch(hofuProvider);

    final AppBar appBar = AppBar(
      title: const Text('抱負'),
      centerTitle: true,
      elevation: 2,
    );

    // 抱負が未登録の場合、抱負フォームを開くボタンを表示する。
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
