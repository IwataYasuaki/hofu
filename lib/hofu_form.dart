import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hofu/hofu.dart';

class HofuForm extends ConsumerStatefulWidget {
  const HofuForm({super.key});

  @override
  HofuFormState createState() => HofuFormState();
}

class HofuFormState extends ConsumerState<HofuForm> {
  final myController = TextEditingController();

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    myController.text = ref.read(hofuProvider).content;
    var buttonText = myController.text.isEmpty ? '登録' : '更新';

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
              child: Text(buttonText),
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