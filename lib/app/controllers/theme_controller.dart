import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inspire_me/app/services/firebase_service.dart';
import 'package:inspire_me/app/services/hive_service.dart';
import 'package:inspire_me/utils/app_constants.dart';

class ThemeController extends GetxController {
  late RxBool isDarkMode;

  @override
  void onInit() {
    super.onInit();
    final bool? savedPref = HiveService.getSetting<bool>(
      AppConstants.isDarkModeKey,
    );
    if (savedPref != null) {
      isDarkMode = savedPref.obs;
    } else {
      final int hour = DateTime.now().hour;
      isDarkMode = (hour >= 19 || hour < 7).obs;
    }
  }

  ThemeMode get themeMode =>
      isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    HiveService.saveSetting(AppConstants.isDarkModeKey, isDarkMode.value);
    FirebaseService.logEvent(
      AppConstants.eventThemeToggled,
      parameters: {'new_theme': isDarkMode.value ? 'dark' : 'light'},
    );
  }
}
