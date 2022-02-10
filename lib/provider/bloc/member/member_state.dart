part of 'member_bloc.dart';

@immutable
abstract class MemberState {}

class MemberInitial extends MemberState {}

class MemberWaiting extends MemberState {}

class MemberLoadError extends MemberState {
  final String errMsg;

  MemberLoadError({required this.errMsg});
}

class MemberLoadSuccess extends MemberState {
  final List<MemberModel> model;

  MemberLoadSuccess({required this.model});
}
