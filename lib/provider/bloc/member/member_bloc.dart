import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:posapp_v2/provider/models/model_member.dart';
import 'package:posapp_v2/provider/services/service_network.dart';

part 'member_event.dart';
part 'member_state.dart';

class MemberBloc extends Bloc<MemberEvent, MemberState> {
  String initDB = "";
  String branch = "";
  List<MemberModel> memberModel = [];

  MemberBloc() : super(MemberInitial()) {
    // on<MemberEvent>((event, emit) {
    // });

    on<GetMember>((event, emit) async {
      await _getMember(event, emit);
    });

    on<SetChangedBranch>((event, emit) async {
      await _setChangedBranch(event, emit);
    });
  }

  Future<void> _setChangedBranch(SetChangedBranch event, Emitter emit) async {
    emit(MemberWaiting());
    Future.delayed(Duration(seconds: 2));
    try {
      await NetworkService()
          .setBranch(initDB: event.dbname, branch: event.branch);
      initDB = await NetworkService().getInitDB();
      this.branch = await NetworkService().getBranch();
      emit(MemberLoadSuccess(model: memberModel));
    } catch (e) {
      emit(MemberLoadError(errMsg: e.toString()));
    }
  }

  Future<void> _getMember(GetMember event, Emitter emit) async {
    emit(MemberWaiting());
    memberModel = [];
    Future.delayed(Duration(seconds: 2));
    try {
      memberModel = await NetworkService().getMember();
      initDB = await NetworkService().getInitDB();
      branch = await NetworkService().getBranch();
      emit(MemberLoadSuccess(model: memberModel));
    } catch (e) {
      emit(MemberLoadError(errMsg: e.toString()));
    }
  }
}
