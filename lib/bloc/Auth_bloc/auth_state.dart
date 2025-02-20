import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object> get props => [];
}


class AuthInitial extends AuthState {}


class AuthLoading extends AuthState {}


class PhoneAuthCodeSentSuccess extends AuthState {
  final String verificationId;

  PhoneAuthCodeSentSuccess({required this.verificationId});

  @override
  List<Object> get props => [verificationId];
}


class AuthenticatedState extends AuthState {
  final String uid;

  AuthenticatedState(this.uid);

  @override
  List<Object> get props => [uid];
}


class AuthFailureState extends AuthState {
  final String error;

  AuthFailureState(this.error);

  @override
  List<Object> get props => [error];
}


class LoggedOutState extends AuthState {}