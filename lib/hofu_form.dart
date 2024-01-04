import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hofu/hofu.dart';

class HofuForm extends ConsumerWidget {
  const HofuForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var myController = ref.watch(hofuProvider.notifier).myController;

    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              onPressed: () {
                ref.read(hofuProvider.notifier).createHofu(myController.text);
                Navigator.pop(context);
              },
              child: const Text('登録'),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          controller: myController,
          keyboardType: TextInputType.multiline,
          autofocus: true,
          maxLines: 100,
          decoration: const InputDecoration(
            hintText: '(例) 12月までに体重を60kgにする💪',
          ),
        ),
      ),
    );
  }
}
