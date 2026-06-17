import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:inspire_me/app/models/quote_model.dart';
import 'package:inspire_me/app/services/api_service.dart';
import 'package:inspire_me/app/services/firebase_service.dart';
import 'package:inspire_me/utils/app_constants.dart';
import 'package:inspire_me/utils/local_quotes.dart';

class QuoteController extends GetxController {
  late Rx<QuoteModel> currentQuote;

  final RxBool isLoading = false.obs;

  final RxBool isAnimating = false.obs;

  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void onInit() {
    super.onInit();
    currentQuote = LocalQuotes.all.first.obs;
    fetchNewQuote();
  }

  Future<void> fetchNewQuote({bool playSound = false}) async {
    try {
      if (isLoading.value) return;
      isLoading.value = true;

      isAnimating.value = true;

      final QuoteModel newQuote = await ApiService.fetchRandomQuote();

      await Future.delayed(const Duration(milliseconds: 300));

      currentQuote.value = newQuote;

      isAnimating.value = false;

      if (playSound) {
        playChimeSound();
      }

      await FirebaseService.logEvent(
        AppConstants.eventQuoteInspired,
        parameters: {
          'quote_id': newQuote.id,
          'author': newQuote.author,
          'source': newQuote.fromApi ? 'api' : 'local',
        },
      );
    } catch (e) {
      isAnimating.value = false;
      await FirebaseService.recordError(e, StackTrace.current);
    } finally {
      isLoading.value = false;
    }
  }

  void playChimeSound() {
    try {
      _audioPlayer.setVolume(AppConstants.chimeVolume);
      _audioPlayer.play(AssetSource(AppConstants.chimeAsset));
    } catch (e) {
      assert(() {
        print('Chime playback error: $e');
        return true;
      }());
    }
  }

  @override
  void onClose() {
    _audioPlayer.dispose();
    super.onClose();
  }
}
