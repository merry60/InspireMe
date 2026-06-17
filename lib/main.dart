import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:inspire_me/app/bindings/app_bindings.dart';
import 'package:inspire_me/app/controllers/theme_controller.dart';
import 'package:inspire_me/app/models/quote_model.dart';
import 'package:inspire_me/app/services/firebase_service.dart';
import 'package:inspire_me/app/views/splash_screen.dart';
import 'package:inspire_me/firebase_options.dart';
import 'package:inspire_me/utils/app_constants.dart';
import 'package:inspire_me/utils/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool firebaseInitialized = false;
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    firebaseInitialized = true;

    FirebaseService.initialize();

    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  } catch (e) {
    debugPrint('Firebase initialization failed: $e');
    debugPrint('App will run in offline mode.');
  }

  await Hive.initFlutter();
  Hive.registerAdapter(QuoteModelAdapter());

  await Hive.openBox<QuoteModel>(AppConstants.favoritesBox);
  await Hive.openBox<dynamic>(AppConstants.settingsBox);

  if (firebaseInitialized) {
    FirebaseService.logEvent(AppConstants.eventAppOpened);
  }

  runApp(const InspireMeApp());
}

class InspireMeApp extends StatelessWidget {
  const InspireMeApp({super.key});

  @override
  Widget build(BuildContext context) {
    AppBindings().dependencies();

    final ThemeController themeCtrl = Get.find<ThemeController>();

    ever(themeCtrl.isDarkMode, (bool isDark) {
      Get.changeThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
    });

    final bool initialDark = themeCtrl.isDarkMode.value;

    return GetMaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,

      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: initialDark ? ThemeMode.dark : ThemeMode.light,

      home: const SplashScreen(),
    );
  }
}
