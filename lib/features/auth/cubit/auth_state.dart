part of 'auth_cubit.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSignUp extends AuthState {}

class AuthLoggedIn extends AuthState {
  final String email;
  AuthLoggedIn(this.email);
}

class AuthError extends AuthState {
  final String error;
  AuthError(this.error);
}
