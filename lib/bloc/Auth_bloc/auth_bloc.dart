import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<SendOtpToPhoneEvent>((event, emit) async {
      emit(AuthLoading());

      try {
        await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: event.phoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) {
            if (!isClosed) {
              add(OnPhoneAuthVerificationCompletedEvent(
                  credential: credential));
            }
          },
          verificationFailed: (FirebaseAuthException e) {
            if (!isClosed) {
              // Enhanced error handling with specific error codes
              final errorMessage = _mapFirebaseAuthError(e);
              add(OnPhoneAuthErrorEvent(error: errorMessage));
            }
          },
          codeSent: (String verificationId, int? resendToken) {
            if (!isClosed) {
              add(OnPhoneOtpSend(
                  verificationId: verificationId, token: resendToken ?? 0));
            }
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            debugPrint("Code auto-retrieval timed out for $verificationId");
            if (!isClosed) {
              add(OnPhoneAuthErrorEvent(
                  error: "Verification timeout. Please try again."));
            }
          },
          timeout: const Duration(seconds: 60),
        );
      } catch (e) {
        emit(AuthFailureState(_mapGenericError(e)));
      }
    });

    on<OnPhoneOtpSend>((event, emit) {
      emit(PhoneAuthCodeSentSuccess(verificationId: event.verificationId));
    });

    on<VerifySentOtp>((event, emit) {
      try {
        emit(AuthLoading());
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: event.verificationId,
          smsCode: event.otpCode,
        );
        if (!isClosed) {
          add(OnPhoneAuthVerificationCompletedEvent(credential: credential));
        }
      } catch (e) {
        emit(AuthFailureState(_mapGenericError(e)));
      }
    });

    on<OnPhoneAuthErrorEvent>((event, emit) {
      emit(AuthFailureState(event.error));
    });

    on<OnPhoneAuthVerificationCompletedEvent>((event, emit) async {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(event.credential);

        if (userCredential.user == null) {
          emit(AuthFailureState("Authentication failed. User not found."));
          return;
        }

        String userId = userCredential.user!.uid;
        String? phone = userCredential.user!.phoneNumber;
        String? displayName = userCredential.user!.displayName ?? '';

        // Handle user document creation
        await _handleUserDocument(userId, phone, displayName);

        emit(AuthenticatedState(userId));
      } on FirebaseException catch (e) {
        print("error");
        print(e.message);
      } catch (e) {
        emit(AuthFailureState(_mapGenericError(e)));
      }
    });
  }

  // Helper method to handle user document creation
  Future<void> _handleUserDocument(
      String userId, String? phone, String displayName) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (!userDoc.exists) {
        await FirebaseFirestore.instance.collection('users').doc(userId).set({
          'phone': phone,
          'createdAt': DateTime.now(),
          'userId': userId,
          'displayName': displayName,
        });
      }
    } catch (e) {
      debugPrint("Error creating user document: ${e.toString()}");
      // Continue even if document creation fails - auth succeeded
    }
  }

  // Maps Firebase Auth errors to user-friendly messages
  String _mapFirebaseAuthError(FirebaseAuthException e) {
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
        return 'Authentication failed. Please try again or use another method.';
      default:
        return e.message ?? 'Authentication failed. Please try again.';
    }
  }

  // Handles generic errors
  String _mapGenericError(dynamic e) {
    if (e is String) return e;
    if (e.toString().contains('page not found')) {
      return 'Authentication service unavailable. Please try again later.';
    }
    return 'An unexpected error occurred. Please try again.';
  }
}
