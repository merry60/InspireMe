import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart'
    show debugPrint, defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart';
import 'package:inspire_me/app/models/quote_model.dart';
import 'package:inspire_me/firebase_options.dart';
import 'package:inspire_me/utils/app_constants.dart';

class FirebaseService {
  FirebaseService._();

  static FirebaseAuth? _auth;
  static FirebaseFirestore? _firestore;
  static FirebaseAnalytics? _analytics;
  static FirebaseCrashlytics? _crashlytics;
  static final GoogleSignIn _googleSignIn = _createGoogleSignIn();

  static GoogleSignIn _createGoogleSignIn() {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return GoogleSignIn(
        clientId: DefaultFirebaseOptions.ios.iosClientId,
        serverClientId: DefaultFirebaseOptions.webOAuthClientId,
      );
    }
    return GoogleSignIn(
      serverClientId: DefaultFirebaseOptions.webOAuthClientId,
    );
  }

  static void initialize() {
    try {
      _auth = FirebaseAuth.instance;
      _firestore = FirebaseFirestore.instance;
      _analytics = FirebaseAnalytics.instance;
      _crashlytics = FirebaseCrashlytics.instance;
    } catch (e) {
      _logError('initialize', e);
    }
  }

  static User? get currentUser {
    try {
      return _auth?.currentUser;
    } catch (e) {
      return null;
    }
  }

  static Stream<User?> get authStateChanges {
    try {
      return _auth?.authStateChanges() ?? const Stream.empty();
    } catch (e) {
      return const Stream.empty();
    }
  }

  static Future<UserCredential?> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        final UserCredential userCredential = await _auth!.signInWithPopup(
          GoogleAuthProvider(),
        );
        await logEvent(AppConstants.eventUserSignedIn);
        return userCredential;
      }

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth!.signInWithCredential(
        credential,
      );

      await logEvent(AppConstants.eventUserSignedIn);

      return userCredential;
    } catch (e) {
      _logError('signInWithGoogle', e);
      rethrow;
    }
  }

  static Future<void> signOut() async {
    try {
      if (!kIsWeb) {
        await _googleSignIn.signOut();
      }
      await _auth?.signOut();
      await logEvent(AppConstants.eventUserSignedOut);
    } catch (e) {
      _logError('signOut', e);
    }
  }

  static CollectionReference<Map<String, dynamic>>? _userFavoritesRef() {
    try {
      final String? uid = currentUser?.uid;
      if (uid == null) return null;
      return _firestore
          ?.collection(AppConstants.usersCollection)
          .doc(uid)
          .collection(AppConstants.favoritesCollection);
    } catch (e) {
      return null;
    }
  }

  static Future<void> syncFavoriteToCloud(QuoteModel quote) async {
    try {
      final user = currentUser;
      debugPrint(
        '[FirebaseService] syncFavoriteToCloud called. User: ${user?.uid ?? 'NULL (not logged in)'}',
      );

      final CollectionReference<Map<String, dynamic>>? ref =
          _userFavoritesRef();
      if (ref == null) {
        debugPrint(
          '[FirebaseService] ❌ Cannot sync — user is not logged in. Skipping cloud save.',
        );
        return;
      }

      await ref.doc(quote.id).set(quote.toJson());
      debugPrint(
        '[FirebaseService] ✅ Quote "${quote.id}" synced to Firestore at: users/${user!.uid}/favorites/${quote.id}',
      );
    } catch (e) {
      debugPrint('[FirebaseService] ❌ syncFavoriteToCloud FAILED: $e');
      Get.showSnackbar(
        GetSnackBar(
          message:
              'Cloud Sync Failed: ${e.toString().contains('permission-denied') ? 'Firestore rules are denying access.' : e.toString()}',
          duration: const Duration(seconds: 4),
          snackStyle: SnackStyle.FLOATING,
        ),
      );
    }
  }

  static Future<void> removeFavoriteFromCloud(String quoteId) async {
    try {
      final user = currentUser;
      debugPrint(
        '[FirebaseService] removeFavoriteFromCloud called. User: ${user?.uid ?? 'NULL (not logged in)'}',
      );

      final CollectionReference<Map<String, dynamic>>? ref =
          _userFavoritesRef();
      if (ref == null) {
        debugPrint(
          '[FirebaseService] ❌ Cannot remove — user is not logged in.',
        );
        return;
      }

      await ref.doc(quoteId).delete();
      debugPrint(
        '[FirebaseService] ✅ Quote "$quoteId" removed from Firestore.',
      );
    } catch (e) {
      debugPrint('[FirebaseService] ❌ removeFavoriteFromCloud FAILED: $e');
    }
  }

  static Future<List<QuoteModel>> fetchCloudFavorites() async {
    try {
      final CollectionReference<Map<String, dynamic>>? ref =
          _userFavoritesRef();
      if (ref == null) return [];

      final QuerySnapshot<Map<String, dynamic>> snapshot = await ref.get();
      return snapshot.docs
          .map((doc) => QuoteModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      _logError('fetchCloudFavorites', e);
      return [];
    }
  }

  static Future<void> logEvent(
    String name, {
    Map<String, Object>? parameters,
  }) async {
    try {
      await _analytics?.logEvent(name: name, parameters: parameters);
    } catch (e) {
      _logError('logEvent', e);
    }
  }

  static Future<void> recordError(Object error, StackTrace? stack) async {
    try {
      await _crashlytics?.recordError(error, stack);
    } catch (_) {}
  }

  static Future<void> log(String message) async {
    try {
      _crashlytics?.log(message);
    } catch (_) {}
  }

  static void _logError(String method, Object error) {
    assert(() {
      print('FirebaseService.$method error: $error');
      return true;
    }());
  }
}
