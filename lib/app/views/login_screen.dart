import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inspire_me/app/controllers/favorites_controller.dart';
import 'package:inspire_me/app/controllers/theme_controller.dart';
import 'package:inspire_me/app/services/firebase_service.dart';
import 'package:inspire_me/utils/app_theme.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeCtrl = Get.find<ThemeController>();

    return Obx(() {
      final bool isDark = themeCtrl.isDarkMode.value;
      final ThemeData theme = Theme.of(context);

      return Container(
        decoration: BoxDecoration(
          gradient: AppTheme.backgroundGradient(isDark),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),

                  Text('✨', style: const TextStyle(fontSize: 80)),

                  const SizedBox(height: 24),

                  Text(
                    'InspireMe',
                    style: theme.textTheme.displayLarge?.copyWith(
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    'Save your favorites across devices',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const Spacer(flex: 2),

                  _buildGoogleSignInButton(context, isDark),

                  const SizedBox(height: 20),

                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text(
                      'Maybe Later',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.5,
                        ),
                      ),
                    ),
                  ),

                  const Spacer(flex: 1),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildGoogleSignInButton(BuildContext context, bool isDark) {
    return GestureDetector(
      onTap: () => _handleGoogleSignIn(),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
        decoration: BoxDecoration(
          color: isDark ? Colors.white : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
              child: const Text(
                'G',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4285F4),
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Continue with Google',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF333333),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleGoogleSignIn() async {
    try {
      final result = await FirebaseService.signInWithGoogle();
      if (result != null) {
        final FavoritesController favCtrl = Get.find<FavoritesController>();
        await favCtrl.syncWithCloud();

        Get.back();

        Get.showSnackbar(
          const GetSnackBar(
            message: 'Welcome back! Syncing favorites... ☁️',
            duration: Duration(seconds: 3),
            snackStyle: SnackStyle.FLOATING,
            margin: EdgeInsets.all(16),
            borderRadius: 12,
          ),
        );
      } else {
        Get.showSnackbar(
          const GetSnackBar(
            message: 'Sign-in cancelled or failed.',
            duration: Duration(seconds: 2),
            snackStyle: SnackStyle.FLOATING,
            margin: EdgeInsets.all(16),
            borderRadius: 12,
          ),
        );
      }
    } catch (e) {
      final String error = e.toString();
      if (error.contains('popup_closed') ||
          error.contains('cancelled-popup-request')) {
        return;
      }

      FirebaseService.recordError(e, StackTrace.current);
      Get.showSnackbar(
        GetSnackBar(
          message: _googleSignInErrorMessage(error),
          duration: const Duration(seconds: 6),
          snackStyle: SnackStyle.FLOATING,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        ),
      );
    }
  }

  String _googleSignInErrorMessage(String error) {
    if (error.contains('origin_mismatch') || error.contains('redirect_uri')) {
      return 'Google Sign-In blocked: add your app URL to Google Cloud '
          'Console → Credentials → Web client → Authorized JavaScript origins '
          '(e.g. http://localhost:5000).';
    }
    return 'Sign-in failed: ${error.split('\n').first}';
  }
}
