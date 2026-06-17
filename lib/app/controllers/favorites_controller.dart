import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:inspire_me/app/models/quote_model.dart';
import 'package:inspire_me/app/services/firebase_service.dart';
import 'package:inspire_me/app/services/hive_service.dart';
import 'package:inspire_me/utils/app_constants.dart';

class FavoritesController extends GetxController {
  final RxList<QuoteModel> favorites = <QuoteModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadFromHive();
    _syncFromCloud();
  }

  void _loadFromHive() {
    try {
      favorites.assignAll(HiveService.getAllFavorites());
    } catch (e) {
      FirebaseService.recordError(e, StackTrace.current);
    }
  }

  Future<void> _syncFromCloud() async {
    try {
      if (FirebaseService.currentUser == null) return;

      final List<QuoteModel> cloudFavorites =
          await FirebaseService.fetchCloudFavorites();

      for (final QuoteModel cloudQuote in cloudFavorites) {
        if (!HiveService.isFavorite(cloudQuote.id)) {
          await HiveService.saveFavorite(cloudQuote);
        }
      }

      _loadFromHive();
    } catch (e) {
      FirebaseService.recordError(e, StackTrace.current);
    }
  }

  void toggleFavorite(QuoteModel quote) {
    try {
      if (isFavorite(quote.id)) {
        debugPrint(
          '[FavoritesController] Removing quote "${quote.id}" from favorites...',
        );
        HiveService.removeFavorite(quote.id);
        favorites.removeWhere((q) => q.id == quote.id);

        FirebaseService.removeFavoriteFromCloud(quote.id);

        FirebaseService.logEvent(
          AppConstants.eventQuoteUnfavorited,
          parameters: {'quote_id': quote.id},
        );
      } else {
        debugPrint(
          '[FavoritesController] Adding quote "${quote.id}" to favorites...',
        );
        final QuoteModel favoriteQuote = quote.copyWith(
          isFavorite: true,
          savedAt: DateTime.now(),
        );
        HiveService.saveFavorite(favoriteQuote);
        favorites.add(favoriteQuote);

        debugPrint('[FavoritesController] Calling syncFavoriteToCloud...');
        FirebaseService.syncFavoriteToCloud(favoriteQuote);

        FirebaseService.logEvent(
          AppConstants.eventQuoteFavorited,
          parameters: {'quote_id': quote.id, 'author': quote.author},
        );
      }
    } catch (e) {
      debugPrint('[FavoritesController] toggleFavorite error: $e');
      FirebaseService.recordError(e, StackTrace.current);
    }
  }

  bool isFavorite(String id) {
    return HiveService.isFavorite(id);
  }

  Future<void> syncWithCloud() async {
    await _syncFromCloud();
  }
}
