import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inspire_me/app/controllers/favorites_controller.dart';
import 'package:inspire_me/app/controllers/quote_controller.dart';

class HeartButton extends StatefulWidget {
  const HeartButton({super.key});

  @override
  State<HeartButton> createState() => _HeartButtonState();
}

class _HeartButtonState extends State<HeartButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _bounceAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 1.0,
          end: 1.3,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.3,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.elasticOut)),
        weight: 50,
      ),
    ]).animate(_bounceController);
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  void _onTap() {
    final QuoteController quoteCtrl = Get.find<QuoteController>();
    final FavoritesController favCtrl = Get.find<FavoritesController>();
    final quote = quoteCtrl.currentQuote.value;

    _bounceController.forward(from: 0);

    final bool wasFavorite = favCtrl.isFavorite(quote.id);
    favCtrl.toggleFavorite(quote);

    Get.showSnackbar(
      GetSnackBar(
        message:
            wasFavorite ? 'Removed from favorites' : 'Added to favorites ❤️',
        duration: const Duration(seconds: 2),
        snackStyle: SnackStyle.FLOATING,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        backgroundColor: Theme.of(
          Get.context!,
        ).colorScheme.surface.withValues(alpha: 0.95),
        messageText: Text(
          wasFavorite ? 'Removed from favorites' : 'Added to favorites ❤️',
          style: TextStyle(
            color: Theme.of(Get.context!).colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final QuoteController quoteCtrl = Get.find<QuoteController>();
    final FavoritesController favCtrl = Get.find<FavoritesController>();

    return Obx(() {
      final quote = quoteCtrl.currentQuote.value;
      favCtrl.favorites.length;
      final bool isFav = favCtrl.isFavorite(quote.id);

      return AnimatedBuilder(
        animation: _bounceAnimation,
        builder: (context, child) {
          return Transform.scale(scale: _bounceAnimation.value, child: child);
        },
        child: IconButton(
          onPressed: _onTap,
          iconSize: 32,
          icon: Icon(
            isFav ? Icons.favorite : Icons.favorite_border,
            color: isFav ? Colors.red : Colors.grey,
            size: 32,
          ),
        ),
      );
    });
  }
}
