import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:kwik/constants/FCM_token.dart';
import 'package:kwik/repositories/auth_repo.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthRepo authrepo;

  AuthBloc(this.authrepo) : super(AuthInitial()) {
    on<SendOtpToPhoneEvent>(_handleSendOtp);
    on<OnPhoneOtpSend>(_handleOtpSent);
    on<VerifySentOtp>(_handleVerifyOtp);
    on<OnPhoneAuthErrorEvent>(_handleAuthError);
    on<OnPhoneAuthVerificationCompletedEvent>(_handleVerificationComplete);
    on<LogoutEvent>(_handleLogout);
  }

  // Add state change logging
  @override
  void onTransition(Transition<AuthEvent, AuthState> transition) {
    debugPrint('''
    ============================================
    EVENT: ${transition.event}
    CURRENT STATE: ${transition.currentState}
    NEXT STATE: ${transition.nextState}
    ============================================
    ''');
    super.onTransition(transition);
  }

  Future<void> _handleSendOtp(
      SendOtpToPhoneEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    debugPrint('Initiating phone verification for: ${event.phoneNumber}');

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: event.phoneNumber,
        verificationCompleted: (credential) {
          if (!isClosed) {
            add(OnPhoneAuthVerificationCompletedEvent(credential: credential));
          }
        },
        verificationFailed: (e) {
          final error = _mapFirebaseAuthError(e);
          debugPrint('Verification failed: ${e.code} - $error');
          if (!isClosed) {
            add(OnPhoneAuthErrorEvent(error: error));
          }
        },
        codeSent: (verificationId, resendToken) {
          debugPrint('Code sent to ${event.phoneNumber}');
          if (!isClosed) {
            add(OnPhoneOtpSend(
              verificationId: verificationId,
              token: resendToken ?? 0,
            ));
          }
        },
        codeAutoRetrievalTimeout: (verificationId) {
          debugPrint('Auto-retrieval timeout: $verificationId');
        },
        // For web, you need to handle the app verifier
        // forceResendingToken: event.token != 0 ? event.token : null,
      );
    } catch (e) {
      debugPrint('Exception in _handleSendOtp: ${e.toString()}');
      emit(AuthFailureState(_mapGenericError(e)));
    }
  }

  void _handleOtpSent(OnPhoneOtpSend event, Emitter<AuthState> emit) {
    debugPrint(
        'OTP sent successfully. Verification ID: ${event.verificationId}');
    emit(PhoneAuthCodeSentSuccess(verificationId: event.verificationId));
  }

  Future<void> _handleVerifyOtp(
      VerifySentOtp event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    debugPrint('Verifying OTP: ${event.otpCode}');

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: event.verificationId,
        smsCode: event.otpCode,
      );
      if (!isClosed) {
        add(OnPhoneAuthVerificationCompletedEvent(credential: credential));
      }
    } catch (e) {
      debugPrint('OTP verification error: ${e.toString()}');
      emit(IncorrectOTP());
    }
  }

  void _handleAuthError(OnPhoneAuthErrorEvent event, Emitter<AuthState> emit) {
    debugPrint('Authentication error: ${event.error}');
    emit(AuthFailureState(event.error));
  }

  Future<void> _handleVerificationComplete(
    OnPhoneAuthVerificationCompletedEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final userCredential = await _auth.signInWithCredential(event.credential);
      final user = userCredential.user!;
      final phoneNumber = user.phoneNumber ?? '';

      // Initialize FCM and get token
      final fcmToken = await _handleFCMTokenGeneration();
      if (fcmToken == null) {
        emit(AuthFailureState('Failed to generate FCM token'));
        return;
      }

      // Handle user data in both Firestore and MongoDB
      await _handleUserDataStorage(user.uid, phoneNumber, fcmToken);

      emit(AuthenticatedState(user.uid));
    } catch (e) {
      emit(AuthFailureState('Failed to complete login: ${e.toString()}'));
    }
  }

  Future<String?> _handleFCMTokenGeneration() async {
    try {
      final fcmService = FCMService();
      await fcmService.initialize();
      return await fcmService.getToken();
    } catch (e) {
      debugPrint('FCM Token generation error: $e');
      return null;
    }
  }

  Future<void> _handleUserDataStorage(
    String uid,
    String phoneNumber,
    String fcmToken,
  ) async {
    try {
      _saveUserToFirestore(fcmToken: fcmToken, phone: phoneNumber, uid: uid);

      // MongoDB operations
      try {
        final userExists = await authrepo.addusertoMogoDB(
          phone: phoneNumber,
          uid: uid,
          fcmToen: fcmToken,
        );

        if (!userExists) {
          await authrepo.updateFcmToentoModoDB(
            firebaseId: uid,
            newFcmToken: fcmToken,
          );
        }
      } catch (error) {}
    } catch (e) {
      debugPrint('User data storage error: $e');
      // Consider whether to rethrow or handle silently
    }
  }

  Future<void> _handleUserDocument(User user) async {
    try {
      debugPrint('Checking/creating user document for ${user.uid}');

      final userDoc = await _firestore.collection('users').doc(user.uid).get();

      if (!userDoc.exists) {
        debugPrint('Creating new user document');
        await _firestore.collection('users').doc(user.uid).set({
          'phone': user.phoneNumber,
          'createdAt': DateTime.now(),
          'userId': user.uid,
          'displayName': user.displayName ?? '',
          'email': user.email ?? '',
          'lastLogin': DateTime.now(),
        });
      } else {
        debugPrint('Updating last login for existing user');
        await _firestore.collection('users').doc(user.uid).update({
          'lastLogin': DateTime.now(),
        });
      }
    } catch (e) {
      debugPrint('Error handling user document: ${e.toString()}');
      // Continue even if document handling fails
    }
  }

  Future<void> _saveUserToFirestore({
    required String uid,
    required String phone,
    required String fcmToken,
  }) async {
    try {
      final userRef = _firestore.collection('users').doc(uid);
      debugPrint('Firestore document path: users/$uid');

      await userRef.set({
        'uid': uid,
        'phone': phone,
        'fcmTokens': FieldValue.arrayUnion([fcmToken]),
        'createdAt': FieldValue.serverTimestamp(),
        'lastLogin': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      debugPrint('Firestore write successful');
    } catch (e, stack) {
      debugPrint('Firestore save failed: $e');
      debugPrint('Stack trace: $stack');
      rethrow;
    }
  }

  String _mapFirebaseAuthError(FirebaseAuthException e) {
    debugPrint('Auth Error Code: ${e.code}');
    switch (e.code) {
      case 'invalid-phone-number':
        return 'Invalid phone number format. Please enter a valid number.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'quota-exceeded':
        return 'SMS quota exceeded. Please try again later.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'operation-not-allowed':
        return 'Phone authentication is not enabled.';
      case 'session-expired':
        return 'Session expired. Please request a new verification code.';
      case 'invalid-verification-code':
        return 'Invalid verification code. Please try again.';
      case 'missing-verification-id':
        return 'Verification failed. Please restart the process.';
      case 'network-request-failed':
        return 'Network error. Please check your connection.';
      case 'internal-error':
        return 'Internal server error. Please try again.';
      case 'page-not-found':
      case 'web-context-canceled':
        return 'Authentication service unavailable. Please try again later.';
      default:
        return e.message ?? 'Authentication failed. Please try again.';
    }
  }

  String _mapFirebaseError(FirebaseException e) {
    debugPrint('Firebase Error Code: ${e.code}');
    switch (e.code) {
      case 'permission-denied':
        return 'Database permission denied.';
      case 'not-found':
        return 'Requested document not found.';
      case 'unavailable':
        return 'Service is unavailable. Please try again later.';
      default:
        return e.message ?? 'Database operation failed.';
    }
  }

  String _mapGenericError(dynamic e) {
    debugPrint('Generic Error: ${e.toString()}');
    if (e is String) return e;
    if (e.toString().contains('page not found')) {
      return 'Authentication service unavailable. Please try again later.';
    }
    return 'An unexpected error occurred. Please try again.';
  }

  Future<void> _handleLogout(
    LogoutEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading()); // Set loading state
    try {
      await _auth.signOut(); // Sign out the user
      debugPrint('User signed out');
      emit(LoggedOutState()); // Emit unauthenticated state
    } catch (e) {
      final errorMessage = _mapGenericError(e);
      debugPrint('Error during sign out: $errorMessage');
      emit(AuthFailureState(errorMessage)); // Emit failure state with error
    }
  }
}
