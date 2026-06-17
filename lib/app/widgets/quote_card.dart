import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:inspire_me/app/controllers/quote_controller.dart';
import 'package:inspire_me/app/controllers/favorites_controller.dart';
import 'package:inspire_me/app/services/firebase_service.dart';
import 'package:inspire_me/utils/app_constants.dart';

class QuoteCard extends StatelessWidget {
  const QuoteCard({super.key});

  @override
  Widget build(BuildContext context) {
    final QuoteController quoteCtrl = Get.find<QuoteController>();
    final FavoritesController favCtrl = Get.find<FavoritesController>();

    return Hero(
      tag: 'quote_card',
      child: Obx(() {
        final quote = quoteCtrl.currentQuote.value;
        final bool animating = quoteCtrl.isAnimating.value;

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.05),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  ),
                ),
                child: child,
              ),
            );
          },
          child:
              animating
                  ? const SizedBox(key: ValueKey('empty'), height: 200)
                  : Container(
                        key: ValueKey(quote.id),
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1B1B29),
                          borderRadius: BorderRadius.circular(32),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              blurRadius: 30,
                              offset: const Offset(0, 10),
                            ),
                            BoxShadow(
                              color: const Color(
                                0xFFFF8A5C,
                              ).withValues(alpha: 0.05),
                              blurRadius: 40,
                              spreadRadius: -10,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '\u201D\u201D',
                              style: TextStyle(
                                fontSize: 64,
                                color: Color(0xFF8B3A3A),
                                fontFamily: 'Georgia',
                                fontWeight: FontWeight.bold,
                                height: 0.5,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              '"${quote.text}"',
                              style: const TextStyle(
                                fontSize: 28,
                                fontFamily: 'Georgia',
                                fontStyle: FontStyle.italic,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                height: 1.3,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            const SizedBox(height: 48),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        quote.author.toUpperCase(),
                                        style: const TextStyle(
                                          color: Color(0xFFFF8A5C),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Visionary Leader',
                                        style: TextStyle(
                                          color: Colors.white.withValues(
                                            alpha: 0.5,
                                          ),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Obx(() {
                                  favCtrl.favorites.length;
                                  final bool isFav = favCtrl.isFavorite(
                                    quote.id,
                                  );
                                  return GestureDetector(
                                    onTap: () {
                                      favCtrl.toggleFavorite(quote);
                                      Get.showSnackbar(
                                        GetSnackBar(
                                          message:
                                              isFav
                                                  ? 'Removed from favorites'
                                                  : 'Added to favorites ❤️',
                                          duration: const Duration(seconds: 2),
                                          snackStyle: SnackStyle.FLOATING,
                                          margin: const EdgeInsets.all(16),
                                          borderRadius: 12,
                                          backgroundColor: Theme.of(
                                            Get.context!,
                                          ).colorScheme.surface.withValues(
                                            alpha: 0.95,
                                          ),
                                          messageText: Text(
                                            isFav
                                                ? 'Removed from favorites'
                                                : 'Added to favorites ❤️',
                                            style: TextStyle(
                                              color:
                                                  Theme.of(
                                                    Get.context!,
                                                  ).colorScheme.onSurface,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF252538),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.favorite,
                                        color:
                                            isFav
                                                ? Colors.red
                                                : Colors.red.withValues(
                                                  alpha: 0.5,
                                                ),
                                        size: 20,
                                      ),
                                    ),
                                  );
                                }),
                                const SizedBox(width: 12),
                                GestureDetector(
                                  onTap: () {
                                    try {
                                      final shareText =
                                          '"${quote.text}"\n\n— ${quote.author}\n\nShared via ${AppConstants.appName}';
                                      Share.share(shareText);
                                      FirebaseService.logEvent(
                                        AppConstants.eventQuoteShared,
                                        parameters: {
                                          'quote_id': quote.id,
                                          'author': quote.author,
                                        },
                                      );
                                    } catch (e) {
                                      FirebaseService.recordError(
                                        e,
                                        StackTrace.current,
                                      );
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF252538),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.share_rounded,
                                      color: Color(0xFFD4A373),
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                      .animate()
                      .fadeIn(duration: 500.ms, curve: Curves.easeOut)
                      .slideY(
                        begin: 0.03,
                        end: 0,
                        duration: 500.ms,
                        curve: Curves.easeOutCubic,
                      ),
        );
      }),
    );
  }
}
