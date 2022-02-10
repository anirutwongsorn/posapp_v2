part of 'register_bloc.dart';

@immutable
abstract class RegisterState {}

class RegisterInitial extends RegisterState {}

class RegisterWaiting extends RegisterState {}

class RegisterError extends RegisterState {
  final String errMsg;

  RegisterError({required this.errMsg});
}

class RegisterSuccess extends RegisterState {}
