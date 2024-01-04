import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hofu/hofu.dart';
import 'package:hofu/hofu_form.dart';

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Hofu hofu = ref.watch(hofuProvider);

    // 抱負が未登録の場合、自動的に抱負フォームを表示させる
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('抱負'),
        centerTitle: true,
      ),
      body: Center(
        child: hofu.content.isEmpty
            ? const CreateHofuButton()
            : HofuText(hofu: hofu),
      ),
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
