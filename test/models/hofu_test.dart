import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/test.dart';
import 'package:hofu/models/hofu.dart';
import 'package:hofu/constants.dart';

void main() {
  group('Testing Hofu', () {
    setUpAll(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('A hofu should be created', () async {
      String content = 'This is a test.';
      final SharedPreferences pref = await SharedPreferences.getInstance();
      Hofu hofu = Hofu(pref, content);
      expect(hofu.content, content);
    });

    test('A hofu should be updated', () async {
      String beforeContent = 'before updated';
      String afterContent = 'after updated';
      final SharedPreferences pref = await SharedPreferences.getInstance();
      Hofu hofu = Hofu(pref, beforeContent);
      expect(hofu.content, beforeContent);
      hofu.updateContent(afterContent);
      expect(hofu.content, afterContent);
    });

    test('A hofu should be saved', () async {
      String content = 'This is a test.';
      final SharedPreferences pref = await SharedPreferences.getInstance();
      Hofu hofu = Hofu(pref, content);
      hofu.save();
      expect(pref.getString(LocalStorageKey.hofuContent), content);
    });
  });
}
