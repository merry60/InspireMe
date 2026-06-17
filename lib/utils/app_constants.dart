class AppConstants {
  AppConstants._();

  static const String appName = 'InspireMe ✨';
  static const String appTagline = 'Daily dose of inspiration';
  static const String splashTagline = 'Your daily dose of inspiration';

  static const String favoritesBox = 'favorites';
  static const String settingsBox = 'settings';

  static const String isDarkModeKey = 'isDarkMode';
  static const String lastLoginDateKey = 'lastLoginDate';
  static const String currentStreakKey = 'currentStreak';
  static const String weeklyInspireCountKey = 'weeklyInspireCount';
  static const String currentWeekIdKey = 'currentWeekId';

  static const String usersCollection = 'users';
  static const String favoritesCollection = 'favorites';

  static const String zenQuotesUrl = 'https://zenquotes.io/api/random';
  static const int apiTimeoutSeconds = 5;

  static const String chimeAsset = 'sounds/chime.mp3';
  static const double chimeVolume = 0.5;

  static const String eventQuoteInspired = 'quote_inspired';
  static const String eventQuoteFavorited = 'quote_favorited';
  static const String eventQuoteUnfavorited = 'quote_unfavorited';
  static const String eventQuoteShared = 'quote_shared';
  static const String eventThemeToggled = 'theme_toggled';
  static const String eventUserSignedIn = 'user_signed_in';
  static const String eventUserSignedOut = 'user_signed_out';
  static const String eventAppOpened = 'app_opened';

  static const double quoteCardRadius = 24.0;
  static const double buttonRadius = 28.0;
  static const double buttonHeight = 56.0;
  static const double quoteFontSize = 22.0;
  static const double decorativeQuoteFontSize = 48.0;
}
