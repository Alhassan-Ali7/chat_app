part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;
  final context;

  LoginEvent({
    required this.email,
    required this.password,
    required this.context,
  });
}

class RegisterEvent extends AuthEvent {}
