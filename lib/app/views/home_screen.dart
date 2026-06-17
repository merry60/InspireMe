import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inspire_me/app/controllers/theme_controller.dart';
import 'package:inspire_me/app/services/firebase_service.dart';
import 'package:inspire_me/app/widgets/quote_card.dart';
import 'package:inspire_me/app/widgets/inspire_button.dart';
import 'package:inspire_me/app/widgets/custom_header.dart';
import 'package:inspire_me/app/views/favorites_screen.dart';
import 'package:inspire_me/app/views/login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeCtrl = Get.find<ThemeController>();
    const Color coralOrange = Color(0xFFFF8A5C);

    return Obx(() {
      final bool isDark = themeCtrl.isDarkMode.value;

      return Scaffold(
        backgroundColor:
            isDark ? const Color(0xFF0F0F14) : const Color(0xFFF8F9FA),
        body: Container(
          width: double.infinity,
          decoration:
              isDark
                  ? const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF161621), Color(0xFF0F0F14)],
                    ),
                  )
                  : null,
          child: SafeArea(
            child: Column(
              children: [
                const CustomHeader(),

                const Spacer(flex: 1),

                const QuoteCard(),

                const Spacer(flex: 2),

                const InspireButton(),

                const SizedBox(height: 32),

                _buildBottomNav(isDark, coralOrange),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildBottomNav(bool isDark, Color coralOrange) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF21212B) : Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, 5),
            ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            decoration: BoxDecoration(
              color: coralOrange.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.home, color: Colors.white),
                SizedBox(height: 4),
                Text(
                  'Home',
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
              Get.off(
                () => const FavoritesScreen(),
                transition: Transition.noTransition,
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              color: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.bookmark_border,
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Favorites',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.white70 : Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),

          GestureDetector(
            onTap: () {
              final user = FirebaseService.currentUser;
              if (user != null) {
                CustomHeader.showProfileMenu(user.displayName ?? user.email);
              } else {
                Get.to(
                  () => const LoginScreen(),
                  transition: Transition.downToUp,
                );
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              color: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.person_outline,
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Profile',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.white70 : Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
