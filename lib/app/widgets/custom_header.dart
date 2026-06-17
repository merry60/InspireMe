import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inspire_me/app/controllers/theme_controller.dart';
import 'package:inspire_me/app/services/firebase_service.dart';
import 'package:inspire_me/app/views/login_screen.dart';
import 'package:inspire_me/app/widgets/theme_toggle.dart';

class CustomHeader extends StatelessWidget {
  const CustomHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeCtrl = Get.find<ThemeController>();
    const Color coralOrange = Color(0xFFFF8A5C);

    return Obx(() {
      final bool isDark = themeCtrl.isDarkMode.value;
      final Color textColor = isDark ? Colors.white : Colors.black87;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildProfileIcon(coralOrange),

            Row(
              children: [
                Text(
                  'InspireMe',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(Icons.auto_awesome, color: Colors.amber, size: 20),
              ],
            ),

            const ThemeToggle(),
          ],
        ),
      );
    });
  }

  Widget _buildProfileIcon(Color coralOrange) {
    return StreamBuilder(
      stream: FirebaseService.authStateChanges,
      builder: (context, snapshot) {
        final user = FirebaseService.currentUser;
        final bool isLoggedIn = user != null;

        String? firstLetter;
        if (isLoggedIn) {
          if (user.displayName != null && user.displayName!.isNotEmpty) {
            firstLetter = user.displayName![0].toUpperCase();
          } else if (user.email != null && user.email!.isNotEmpty) {
            firstLetter = user.email![0].toUpperCase();
          }
        }

        return GestureDetector(
          onTap: () {
            if (isLoggedIn) {
              showProfileMenu(user.displayName ?? user.email);
            } else {
              Get.to(
                () => const LoginScreen(),
                transition: Transition.downToUp,
              );
            }
          },
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: coralOrange, width: 1.5),
              color: const Color(0xFF2A2A3D),
            ),
            child: Center(
              child:
                  isLoggedIn && firstLetter != null
                      ? Text(
                        firstLetter,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      )
                      : const Icon(
                        Icons.person_outline,
                        color: Colors.white70,
                        size: 24,
                      ),
            ),
          ),
        );
      },
    );
  }

  static void showProfileMenu(String? displayName) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(Get.context!).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              displayName ?? 'User',
              style: Theme.of(Get.context!).textTheme.headlineMedium,
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
  }
}
