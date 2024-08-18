part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class AuthEventRegister extends AuthEvent {
  AuthEventRegister({required this.email, required this.password});
  final String email;
  final String password;
}

class AuthEventLogin extends AuthEvent {
  AuthEventLogin({required this.email, required this.password});
  final String email;
  final String password;
}

class AuthEventLogout extends AuthEvent {}
