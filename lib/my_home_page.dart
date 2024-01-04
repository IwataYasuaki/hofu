import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hofu/hofu.dart';
import 'package:hofu/hofu_form.dart';

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Hofu hofu = ref.watch(hofuProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('抱負'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            Text(hofu.content),
            ElevatedButton(
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
            ),
          ],
        ),
      ),
    );
  }
}
