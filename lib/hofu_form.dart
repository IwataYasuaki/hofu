import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hofu/hofu.dart';

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
              style: ElevatedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              onPressed: () {
                if(_formKey.currentState!.validate()) {
                  ref.read(hofuProvider.notifier).createHofu(hofuContentController.text);
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
            controller: hofuContentController,
            keyboardType: TextInputType.multiline,
            autofocus: true,
            maxLines: 100,
            decoration: const InputDecoration(
              hintText: '(例) 12月までに体重を60kgにする💪',
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
}