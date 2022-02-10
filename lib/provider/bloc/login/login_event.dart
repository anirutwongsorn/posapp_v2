part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}

class DoLogin extends LoginEvent {
  final LoginModel model;

  DoLogin({required this.model});
}

class CheckLogin extends LoginEvent {}
