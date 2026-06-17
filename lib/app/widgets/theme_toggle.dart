import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inspire_me/app/controllers/theme_controller.dart';

class ThemeToggle extends StatefulWidget {
  const ThemeToggle({super.key});

  @override
  State<ThemeToggle> createState() => _ThemeToggleState();
}

class _ThemeToggleState extends State<ThemeToggle>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  void _onToggle() {
    final ThemeController themeCtrl = Get.find<ThemeController>();

    _rotationController.forward(from: 0);

    themeCtrl.toggleTheme();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeController themeCtrl = Get.find<ThemeController>();

    return Obx(() {
      final bool isDark = themeCtrl.isDarkMode.value;

      return RotationTransition(
        turns: Tween(begin: 0.0, end: 0.5).animate(
          CurvedAnimation(
            parent: _rotationController,
            curve: Curves.easeInOutCubic,
          ),
        ),
        child: IconButton(
          onPressed: _onToggle,
          enableFeedback: false,
          icon: Icon(
            isDark ? Icons.nightlight_round : Icons.wb_sunny,
            color: isDark ? Colors.amber : Colors.orange,
            size: 26,
          ),
          tooltip: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
        ),
      );
    });
  }
}
