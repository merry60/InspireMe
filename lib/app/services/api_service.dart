import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:inspire_me/app/models/quote_model.dart';
import 'package:inspire_me/utils/app_constants.dart';
import 'package:inspire_me/utils/local_quotes.dart';

class ApiService {
  ApiService._();

  static final Random _random = Random();

  static Future<QuoteModel> fetchRandomQuote() async {
    try {
      final Uri uri = Uri.parse(AppConstants.zenQuotesUrl);
      final http.Response response = await http
          .get(uri)
          .timeout(const Duration(seconds: AppConstants.apiTimeoutSeconds));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
        if (data.isNotEmpty) {
          final Map<String, dynamic> quoteData =
              data[0] as Map<String, dynamic>;
          final String quoteText = quoteData['q'] as String? ?? '';
          final String author = quoteData['a'] as String? ?? 'Unknown';

          if (quoteText.isNotEmpty &&
              !quoteText.contains('Too many requests')) {
            return QuoteModel(
              id: 'api_${DateTime.now().millisecondsSinceEpoch}',
              text: quoteText,
              author: author,
              fromApi: true,
            );
          }
        }
      }

      return _getRandomLocalQuote();
    } catch (e) {
      _logError(e);
      return _getRandomLocalQuote();
    }
  }

  static QuoteModel _getRandomLocalQuote() {
    final List<QuoteModel> quotes = LocalQuotes.all;
    return quotes[_random.nextInt(quotes.length)];
  }

  static void _logError(Object error) {
    try {
      debugPrintError('ApiService error: $error');
    } catch (_) {}
  }

  static void debugPrintError(String message) {
    assert(() {
      print(message);
      return true;
    }());
  }
}
