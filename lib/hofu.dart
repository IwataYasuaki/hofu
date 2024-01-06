import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hofu/share_preferences_instance.dart';
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
  HofuNotifier() : super(const Hofu()) {
    state = _loadHofu() ?? const Hofu();
  }

  final _prefs = SharedPreferencesInstance().prefs;

  void createHofu(String content) async {
    await _prefs.setString(LocalStorageKey.hofuContent, content);
    state = state.copyWith(content: content);
  }
  
  Hofu? _loadHofu() {
    final content = _prefs.getString(LocalStorageKey.hofuContent);
    if (content == null) {
      return null;
    }
    return Hofu(content: content);
  }
}

final hofuProvider =
    StateNotifierProvider<HofuNotifier, Hofu>((ref) => HofuNotifier());
