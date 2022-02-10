part of 'register_bloc.dart';

@immutable
abstract class RegisterEvent {}

class DoRegister extends RegisterEvent {
  final RegisterModel model;

  DoRegister({required this.model});
}
