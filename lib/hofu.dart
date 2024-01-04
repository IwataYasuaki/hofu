import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hofu/constants.dart';

@immutable
class Hofu {
  const Hofu({
    this.content = '',
  });

  final String content;

  Hofu copyWith({String? content}) {
    return Hofu(
      content: content ?? this.content,
    );
  }
}

class HofuNotifier extends StateNotifier<Hofu> {
  HofuNotifier() : super(const Hofu());
  final myController = TextEditingController();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  void createHofu(String content) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString(LocalStorageKey.hofuContent, content).then((value) {
      state = state.copyWith(content: content);
    });
  }
}

final hofuProvider =
    StateNotifierProvider<HofuNotifier, Hofu>((ref) => HofuNotifier());
