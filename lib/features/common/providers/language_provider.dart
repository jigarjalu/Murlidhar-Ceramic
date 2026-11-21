import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_config.dart';

class LanguageNotifier extends StateNotifier<String> {
  static const String _prefLangKey = 'mc_selected_language';

  LanguageNotifier() : super(AppConfig.defaultLanguage) {
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_prefLangKey);
    if (saved != null && (saved == 'gu' || saved == 'en')) {
      state = saved;
    }
  }

  Future<void> toggleLanguage() async {
    final newLang = state == 'gu' ? 'en' : 'gu';
    state = newLang;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefLangKey, newLang);
  }

  Future<void> setLanguage(String langCode) async {
    if (langCode == 'gu' || langCode == 'en') {
      state = langCode;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefLangKey, langCode);
    }
  }

  bool get isGujarati => state == 'gu';
  bool get isEnglish => state == 'en';
}

final languageProvider = StateNotifierProvider<LanguageNotifier, String>((ref) {
  return LanguageNotifier();
});
