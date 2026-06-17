import 'package:hive_flutter/hive_flutter.dart';
import 'package:inspire_me/app/models/quote_model.dart';
import 'package:inspire_me/utils/app_constants.dart';

class HiveService {
  HiveService._();

  static Box<QuoteModel> get _favoritesBox =>
      Hive.box<QuoteModel>(AppConstants.favoritesBox);

  static Future<void> saveFavorite(QuoteModel quote) async {
    try {
      final QuoteModel favoriteQuote = quote.copyWith(
        isFavorite: true,
        savedAt: DateTime.now(),
      );
      await _favoritesBox.put(quote.id, favoriteQuote);
    } catch (e) {
      _logError('saveFavorite', e);
    }
  }

  static Future<void> removeFavorite(String id) async {
    try {
      await _favoritesBox.delete(id);
    } catch (e) {
      _logError('removeFavorite', e);
    }
  }

  static List<QuoteModel> getAllFavorites() {
    try {
      return _favoritesBox.values.toList();
    } catch (e) {
      _logError('getAllFavorites', e);
      return [];
    }
  }

  static bool isFavorite(String id) {
    try {
      return _favoritesBox.containsKey(id);
    } catch (e) {
      _logError('isFavorite', e);
      return false;
    }
  }

  static Future<void> clearAll() async {
    try {
      await _favoritesBox.clear();
    } catch (e) {
      _logError('clearAll', e);
    }
  }

  static Box<dynamic> get settingsBox =>
      Hive.box<dynamic>(AppConstants.settingsBox);

  static Future<void> saveSetting(String key, dynamic value) async {
    try {
      await settingsBox.put(key, value);
    } catch (e) {
      _logError('saveSetting', e);
    }
  }

  static T? getSetting<T>(String key) {
    try {
      return settingsBox.get(key) as T?;
    } catch (e) {
      _logError('getSetting', e);
      return null;
    }
  }

  static void _logError(String method, Object error) {
    assert(() {
      print('HiveService.$method error: $error');
      return true;
    }());
  }
}
