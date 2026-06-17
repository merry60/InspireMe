import 'package:get/get.dart';
import 'package:inspire_me/app/controllers/theme_controller.dart';
import 'package:inspire_me/app/controllers/favorites_controller.dart';
import 'package:inspire_me/app/controllers/quote_controller.dart';
import 'package:inspire_me/app/controllers/stats_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(ThemeController(), permanent: true);
    Get.put(StatsController(), permanent: true);
    Get.put(FavoritesController(), permanent: true);
    Get.put(QuoteController(), permanent: true);
  }
}
