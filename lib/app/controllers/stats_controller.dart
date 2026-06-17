import 'package:get/get.dart';
import 'package:inspire_me/app/services/hive_service.dart';
import 'package:inspire_me/utils/app_constants.dart';

class StatsController extends GetxController {
  final RxInt streak = 1.obs;
  final RxInt weeklyInspireCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _initStreak();
    _initWeeklyCount();
  }

  void _initStreak() {
    final now = DateTime.now();
    final String? lastLoginStr = HiveService.getSetting<String>(
      AppConstants.lastLoginDateKey,
    );
    final int savedStreak =
        HiveService.getSetting<int>(AppConstants.currentStreakKey) ?? 1;

    if (lastLoginStr != null) {
      final lastLogin = DateTime.parse(lastLoginStr);
      final today = DateTime(now.year, now.month, now.day);
      final last = DateTime(lastLogin.year, lastLogin.month, lastLogin.day);

      final int diffDays = today.difference(last).inDays;

      if (diffDays == 0) {
        streak.value = savedStreak;
      } else if (diffDays == 1) {
        streak.value = savedStreak + 1;
      } else {
        streak.value = 1;
      }
    } else {
      streak.value = 1;
    }

    HiveService.saveSetting(
      AppConstants.lastLoginDateKey,
      now.toIso8601String(),
    );
    HiveService.saveSetting(AppConstants.currentStreakKey, streak.value);
  }

  void _initWeeklyCount() {
    final now = DateTime.now();
    final int weekId = _getWeekId(now);

    final int savedWeekId =
        HiveService.getSetting<int>(AppConstants.currentWeekIdKey) ?? -1;
    final int savedCount =
        HiveService.getSetting<int>(AppConstants.weeklyInspireCountKey) ?? 0;

    if (savedWeekId == weekId) {
      weeklyInspireCount.value = savedCount;
    } else {
      weeklyInspireCount.value = 0;
      HiveService.saveSetting(AppConstants.currentWeekIdKey, weekId);
      HiveService.saveSetting(AppConstants.weeklyInspireCountKey, 0);
    }
  }

  void incrementInspireCount() {
    final now = DateTime.now();
    final int weekId = _getWeekId(now);
    final int savedWeekId =
        HiveService.getSetting<int>(AppConstants.currentWeekIdKey) ?? -1;

    if (savedWeekId != weekId) {
      weeklyInspireCount.value = 0;
      HiveService.saveSetting(AppConstants.currentWeekIdKey, weekId);
    }

    weeklyInspireCount.value++;
    HiveService.saveSetting(
      AppConstants.weeklyInspireCountKey,
      weeklyInspireCount.value,
    );
  }

  int _getWeekId(DateTime date) {
    final startOfYear = DateTime(date.year, 1, 1);
    final days = date.difference(startOfYear).inDays;
    return date.year * 100 + (days ~/ 7);
  }
}
