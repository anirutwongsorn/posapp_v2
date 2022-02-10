part of 'member_bloc.dart';

@immutable
abstract class MemberEvent {}

class GetMember extends MemberEvent {}

class SetChangedBranch extends MemberEvent {
  final String dbname;
  final String branch;

  SetChangedBranch({required this.dbname, required this.branch});
}

class ResetMemberState extends MemberEvent {}
