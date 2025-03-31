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
              add(OnPhoneAuthErrorEvent(error: e.toString()));
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
          },
          timeout: Duration.zero,
        );
      } catch (e) {
        emit(AuthFailureState(e.toString()));
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
        emit(AuthFailureState(e.toString()));
      }
    });
    on<OnPhoneAuthErrorEvent>((event, emit) {
      emit(AuthFailureState(event.error.toString()));
    });

    on<OnPhoneAuthVerificationCompletedEvent>((event, emit) async {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(event.credential);

        String userId = userCredential.user!.uid;
        String? phone = userCredential.user!.phoneNumber;
        String? displayName = userCredential.user!.displayName ?? '';

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
        emit(AuthenticatedState(userId));
      } catch (e) {
        emit(AuthFailureState(e.toString()));
      }
    });
  }
}
