part of 'login_bloc.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginWaiting extends LoginState {}

class LoginError extends LoginState {
  final String errMsg;
  LoginError({this.errMsg = ''});
}

class LoginLoggedIn extends LoginState {}

class LoginLoggedOut extends LoginState {}
