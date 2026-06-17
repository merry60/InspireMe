import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:inspire_me/app/controllers/favorites_controller.dart';
import 'package:inspire_me/app/controllers/stats_controller.dart';
import 'package:inspire_me/app/controllers/theme_controller.dart';
import 'package:inspire_me/app/models/quote_model.dart';
import 'package:inspire_me/app/services/firebase_service.dart';
import 'package:inspire_me/app/views/login_screen.dart';
import 'package:inspire_me/app/views/home_screen.dart';
import 'package:inspire_me/app/widgets/custom_header.dart';
import 'package:share_plus/share_plus.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FavoritesController favCtrl = Get.find<FavoritesController>();
    final ThemeController themeCtrl = Get.find<ThemeController>();
    final StatsController statsCtrl = Get.find<StatsController>();

    const Color coralOrange = Color(0xFFFF8A5C);
    const Color bgColorLight = Color(0xFFFAF9F6);

    return Obx(() {
      final bool isDark = themeCtrl.isDarkMode.value;
      final Color bgColor = isDark ? const Color(0xFF121212) : bgColorLight;
      final Color textColor = isDark ? Colors.white : const Color(0xFF1A1A1A);

      return Scaffold(
        backgroundColor: bgColor,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomHeader(),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My Favorites',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Obx(
                      () => Text(
                        '${favCtrl.favorites.length} quotes saved',
                        style: TextStyle(
                          fontSize: 16,
                          color: textColor.withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color:
                        isDark
                            ? Colors.white.withValues(alpha: 0.05)
                            : const Color(0xFFF6EFEA),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Obx(
                        () => _buildStatItem(
                          Icons.favorite_border,
                          '${favCtrl.favorites.length} Saved',
                          isDark,
                        ),
                      ),
                      _buildDivider(isDark),
                      Obx(
                        () => _buildStatItem(
                          Icons.calendar_today_outlined,
                          'This week: ${statsCtrl.weeklyInspireCount.value}',
                          isDark,
                        ),
                      ),
                      _buildDivider(isDark),
                      Obx(
                        () => _buildStatItem(
                          Icons.local_fire_department_outlined,
                          'Streak: ${statsCtrl.streak.value} days',
                          isDark,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color:
                        isDark
                            ? Colors.white.withValues(alpha: 0.05)
                            : const Color(0xFFF6EFEA),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search your favorites...',
                      hintStyle: TextStyle(
                        color: textColor.withValues(alpha: 0.4),
                        fontSize: 16,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: textColor.withValues(alpha: 0.4),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    style: TextStyle(color: textColor),
                  ),
                ),
              ),

              Expanded(
                child: Obx(() {
                  final List<QuoteModel> favorites = favCtrl.favorites;

                  if (favorites.isEmpty) {
                    return _buildEmptyState(textColor);
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    itemCount: favorites.length,
                    itemBuilder: (context, index) {
                      final QuoteModel quote = favorites[index];
                      return _buildFavoriteCard(context, quote, favCtrl, isDark)
                          .animate()
                          .fadeIn(
                            duration: 400.ms,
                            delay: (index * 80).ms,
                            curve: Curves.easeOut,
                          )
                          .slideX(
                            begin: 0.1,
                            end: 0,
                            duration: 400.ms,
                            delay: (index * 80).ms,
                            curve: Curves.easeOutCubic,
                          );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
        bottomNavigationBar: _buildBottomNav(isDark, coralOrange),
        floatingActionButton: _buildSyncFAB(favCtrl, isDark, coralOrange),
      );
    });
  }

  Widget _buildStatItem(IconData icon, String text, bool isDark) {
    final color = isDark ? Colors.white70 : const Color(0xFF5A4A42);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider(bool isDark) {
    return Container(
      height: 16,
      width: 1,
      color: isDark ? Colors.white24 : Colors.black12,
    );
  }

  Widget _buildEmptyState(Color textColor) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('💭', style: TextStyle(fontSize: 72)),
          const SizedBox(height: 24),
          Text(
            'No favorites yet!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap ❤️ to save quotes',
            style: TextStyle(
              fontSize: 16,
              color: textColor.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  String _getTimeAgo(DateTime? date) {
    if (date == null) return 'SAVED RECENTLY';
    final diff = DateTime.now().difference(date);
    if (diff.inDays == 0) return 'SAVED TODAY';
    if (diff.inDays == 1) return 'SAVED YESTERDAY';
    if (diff.inDays < 7) return 'SAVED ${diff.inDays} DAYS AGO';
    if (diff.inDays < 14) return 'SAVED LAST WEEK';
    return 'SAVED ${diff.inDays ~/ 7} WEEKS AGO';
  }

  Widget _buildFavoriteCard(
    BuildContext context,
    QuoteModel quote,
    FavoritesController favCtrl,
    bool isDark,
  ) {
    final Color cardBg =
        isDark ? const Color(0xFF1E1E1E) : const Color(0xFFFFF9F7);
    final Color textColor = isDark ? Colors.white : const Color(0xFF1A1A1A);
    final Color coralOrange = const Color(0xFFFF8A5C);

    return Dismissible(
      key: ValueKey(quote.id),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        favCtrl.toggleFavorite(quote);
      },
      background: Container(
        alignment: Alignment.centerRight,
        margin: const EdgeInsets.only(bottom: 24),
        padding: const EdgeInsets.only(right: 24),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(24),
        ),
        child: const Icon(Icons.delete_rounded, color: Colors.white, size: 28),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(24),
          border:
              isDark
                  ? Border.all(color: Colors.white10)
                  : Border.all(color: Colors.black.withValues(alpha: 0.03)),
          boxShadow: [
            if (!isDark)
              BoxShadow(
                color: Colors.orange.withValues(alpha: 0.05),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              left: 10,
              bottom: -10,
              child: Text(
                '""',
                style: TextStyle(
                  fontSize: 100,
                  fontFamily: 'Georgia',
                  fontWeight: FontWeight.bold,
                  color: coralOrange.withValues(alpha: 0.15),
                  height: 1,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: coralOrange.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _getTimeAgo(quote.savedAt),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                            color:
                                isDark ? coralOrange : const Color(0xFFB82601),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Text(
                    quote.text,
                    style: TextStyle(
                      fontSize: 22,
                      fontFamily: 'Georgia',
                      color: textColor,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 32),

                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '— ${quote.author.toUpperCase()}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            color:
                                isDark
                                    ? Colors.white70
                                    : const Color(0xFFB82601),
                          ),
                        ),
                      ),

                      GestureDetector(
                        onTap: () {
                          Share.share('"${quote.text}" — ${quote.author}');
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color:
                                isDark
                                    ? Colors.white12
                                    : Colors.black.withValues(alpha: 0.05),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.share_outlined,
                            size: 20,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      GestureDetector(
                        onTap: () {
                          favCtrl.toggleFavorite(quote);
                          Get.showSnackbar(
                            const GetSnackBar(
                              message:
                                  'Quote deleted from favorites & database',
                              duration: Duration(seconds: 2),
                              snackStyle: SnackStyle.FLOATING,
                              margin: EdgeInsets.all(16),
                              borderRadius: 12,
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: Colors.redAccent,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.delete_outline,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav(bool isDark, Color coralOrange) {
    final bgColor = isDark ? const Color(0xFF1A1A1A) : const Color(0xFFF6EFEA);
    final unselectedColor = isDark ? Colors.white54 : const Color(0xFF5A4A42);

    return Container(
      color: bgColor,
      padding: const EdgeInsets.only(bottom: 24, top: 12, left: 24, right: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap:
                () => Get.off(
                  () => const HomeScreen(),
                  transition: Transition.noTransition,
                ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.home_outlined, color: unselectedColor),
                const SizedBox(height: 4),
                Text(
                  'Home',
                  style: TextStyle(
                    fontSize: 12,
                    color: unselectedColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            decoration: BoxDecoration(
              color: coralOrange,
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.bookmark_border, color: Colors.white),
                SizedBox(height: 4),
                Text(
                  'Favorites',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          GestureDetector(
            onTap: () {
              final user = FirebaseService.currentUser;
              if (user != null) {
                Get.bottomSheet(
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Theme.of(Get.context!).colorScheme.surface,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          user.displayName ?? user.email ?? 'User',
                          style:
                              Theme.of(Get.context!).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 24),
                        ListTile(
                          leading: const Icon(Icons.logout),
                          title: const Text('Sign Out'),
                          onTap: () async {
                            await FirebaseService.signOut();
                            Get.back();
                          },
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                Get.to(
                  () => const LoginScreen(),
                  transition: Transition.downToUp,
                );
              }
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.person_outline, color: unselectedColor),
                const SizedBox(height: 4),
                Text(
                  'Profile',
                  style: TextStyle(
                    fontSize: 12,
                    color: unselectedColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget? _buildSyncFAB(
    FavoritesController favCtrl,
    bool isDark,
    Color coralOrange,
  ) {
    if (FirebaseService.currentUser == null) return null;

    return FloatingActionButton(
      onPressed: () async {
        await favCtrl.syncWithCloud();
        Get.showSnackbar(
          const GetSnackBar(
            message: 'Synced with cloud ☁️',
            duration: Duration(seconds: 2),
            snackStyle: SnackStyle.FLOATING,
            margin: EdgeInsets.all(16),
            borderRadius: 12,
          ),
        );
      },
      backgroundColor: coralOrange,
      child: const Icon(Icons.cloud_sync_rounded, color: Colors.white),
    );
  }
}
