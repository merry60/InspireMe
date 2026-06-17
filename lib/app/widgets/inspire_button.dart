import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inspire_me/app/controllers/quote_controller.dart';
import 'package:inspire_me/app/controllers/stats_controller.dart';

class InspireButton extends StatefulWidget {
  const InspireButton({super.key});

  @override
  State<InspireButton> createState() => _InspireButtonState();
}

class _InspireButtonState extends State<InspireButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) {
    _scaleController.forward();
  }

  void _onTapUp(TapUpDetails _) {
    _scaleController.reverse();
  }

  void _onTapCancel() {
    _scaleController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final QuoteController quoteCtrl = Get.find<QuoteController>();

    return Obx(() {
      final bool loading = quoteCtrl.isLoading.value;

      return AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(scale: _scaleAnimation.value, child: child);
        },
        child: GestureDetector(
          onTapDown: _onTapDown,
          onTapUp: _onTapUp,
          onTapCancel: _onTapCancel,
          onTap:
              loading
                  ? null
                  : () {
                    quoteCtrl.fetchNewQuote(playSound: true);
                    Get.find<StatsController>().incrementInspireCount();
                  },
          child: Container(
            width: double.infinity,
            height: 56,
            margin: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF7A45), Color(0xFFD84A1B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF7A45).withValues(alpha: 0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Center(
              child:
                  loading
                      ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                      : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Inspire Me',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            Icons.auto_awesome,
                            color: Colors.white,
                            size: 20,
                          ),
                        ],
                      ),
            ),
          ),
        ),
      );
    });
  }
}
